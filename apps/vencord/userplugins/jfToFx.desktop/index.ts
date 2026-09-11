/*
 * Vencord, a Discord client mod
 * Copyright (c) 2026 rinsuki and Vendicated and contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import definePlugin from "@utils/types";
import { Embed, EmbedMedia, Message } from "@vencord/discord-types";
import { MessageCache, MessageStore } from "@webpack/common";

const RE_TWITTER_MEDIA_PREVIEW = /^https:\/\/jf\.x\.com\/images\/media-preview\/([0-9]+)$/;

type FxTweet = {
    id: string,
    media: {
        all: FxMedia[];
    };
    author: {
        avatar_url: string,
    };
};

type FxMedia = {
    type: "photo",
    width: number,
    height: number,
    url: string,
} | {
    type: "video",
    format: string,
    width: number,
    height: number,
    url: string,
    thumbnail_url: string,
};

function fxMediaToDiscordEmbed(fxMedia: FxMedia, baseMedia: EmbedMedia): Partial<Embed> {
    const overwrittenBase: Partial<Embed> = { image: undefined, images: undefined, video: undefined, thumbnail: undefined };
    const base = {
        ...baseMedia,
        contentType: "format" in fxMedia ? fxMedia.format : baseMedia.contentType, // todo: guess from extension
        url: fxMedia.url,
        proxyURL: fxMedia.url,
        width: fxMedia.width,
        height: fxMedia.height,
        placeholder: "",
        srcIsAnimated: false,
        description: undefined, // TODO: alt text
    };
    if (fxMedia.type === "photo") {
        return {
            ...overwrittenBase,
            images: [base],
        };
    } else if (fxMedia.type === "video") {
        return {
            ...overwrittenBase,
            video: base,
            thumbnail: {
                ...base,
                url: fxMedia.thumbnail_url,
                proxyURL: fxMedia.thumbnail_url,
            }
        };
    } else {
        return {};
    }
}

function fxTweetToDiscordEmbeds(fx: FxTweet, embed: Embed): Embed[] {
    if (embed.image == null) return [embed];
    const embedBaseImage = embed.image;
    const author = embed.author && { ...embed.author, iconURL: fx.author.avatar_url, iconProxyURL: fx.author.avatar_url };
    const footer = embed.footer && { ...embed.footer, text: embed.footer.text + " (JfToFxed)" };
    return fx.media.all.map(f => fxMediaToDiscordEmbed(f, embedBaseImage)).reduce((p, c) => {
        const lastPrevious = p.at(-1);
        if (lastPrevious == null) return [c];
        if (lastPrevious.images == null || c.images == null) {
            p.push(c);
        } else {
            lastPrevious.images.push(...c.images);
        }
        return p;
    }, [] as Partial<Embed>[]).map((e, i) => {
        if (i === 0) {
            return {
                ...embed,
                ...e,
                author,
                footer,
            };
        } else {
            return {
                color: "",
                contentScanVersion: 0,
                fields: [],
                flags: embed.flags,
                id: embed.id + "_" + i,
                rawDescription: "",
                rawTitle: "",
                type: "rich",
                url: embed.url,
                referenceId: undefined,
                ...e,
                footer,
            } satisfies Embed;
        }
    });
}

async function fetchAndUpdateTweetsEmbed(message: Message) {
    let shouldUpdate = false;
    const promises: Promise<[tweet_id: string, tweet: FxTweet]>[] = [];
    for (const embed of message.embeds) {
        if (embed.image == null) continue;
        const match = RE_TWITTER_MEDIA_PREVIEW.exec(embed.image.url);
        if (match == null) continue;
        const tweetId = match[1];
        promises.push((async () => {
            const res = await fetch(`https://api.fxtwitter.com/i/status/${tweetId}`, {
                cache: "force-cache"
            }).then(r => r.json() as Promise<{
                tweet: FxTweet;
            }>);
            return [
                res.tweet.id,
                res.tweet,
            ];
        })());
        shouldUpdate = true;
    }
    if (!shouldUpdate) return;
    const tweets = new Map(await Promise.all(promises));

    const channelMessageCache = MessageCache.getOrCreate(message.channel_id);
    if (!channelMessageCache.has(message.id)) return;
    const newChannelMessageCache = channelMessageCache.update(message.id, (oldMessage: Message) => {
        let shouldChange = false;
        const newEmbeds: Embed[] = oldMessage.embeds.flatMap(embed => {
            if (embed.image == null) return [embed];
            const match = RE_TWITTER_MEDIA_PREVIEW.exec(embed.image.url);
            if (match == null) return [embed];
            const info = tweets.get(match[1]);
            if (info == null) return [embed];

            shouldChange = true;

            return fxTweetToDiscordEmbeds(info, embed);
        });

        if (!shouldChange) return oldMessage;
        return oldMessage.merge({
            embeds: newEmbeds,
        });
    });

    MessageCache.commit(newChannelMessageCache);
    MessageStore.emitChange();
}

export default definePlugin({
    name: "JfToFx",
    description: "jf.x.com merges multiple media to one (low-res) image, We will un-merge them (by using FxTwitter API)",
    tags: ["Chat", "Media"],
    dependencies: ["MessageUpdaterAPI"],
    authors: [],

    patches: [
        {
            find: "renderEmbeds(",
            replacement: {
                match: /renderEmbeds\((\i)\){/,
                replace: "$&$self.checkEmbeds($1);"
            }
        },
        {
            // disable &format=webp&width=…… since pbs.twimg.com will not work with format= query
            find: "ImageLoaderUtils.getSrcWithWidthAndHeight",
            replacement: {
                match: /(\((\i)\){)(let\{src)/,
                replace: "$1if($2.src.startsWith('https://pbs.twimg.com/'))return $2.src;$3"
            }
        },
        {
            // disable author ?format=png since pbs.twimg.com will not work with format= query
            find: "renderAuthor",
            replacement: {
                match: /src:(\i&&!\i)(?=\?(\i\.iconProxyURL))/,
                replace: "src:($2.startsWith('https://pbs.twimg.com/')||($1))"
            }
        }
    ],


    checkEmbeds(message: Message) {
        for (const embed of message.embeds) {
            // console.log(embed);
            if (embed.image != null && embed.image.url.startsWith("https://jf.x.com/images/media-preview/")) {
                fetchAndUpdateTweetsEmbed(message).catch(e => {
                    console.error("Failed to update tweets embed:", e);
                });
            }
        }
    }
});
