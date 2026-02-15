#!/usr/bin/env -S deno run
import { compress, decompress } from "jsr:@denosaurs/lz4@0.1.4"
import { readAll } from "jsr:@std/io@0.225.3/read-all"

const ENGINES = {
    "@googleudm": {
        name: "Google udm=14",
        url: {
            icon: {
                "32": "https://www.gstatic.com/images/branding/searchlogo/ico/favicon.ico",
            },
            href: "https://www.google.com/search?client=firefox-b-d&udm=14&q={searchTerms}",
        }
    },
    "@ytm": {
        name: "YouTube Music",
        url: {
            icon: {
                "32": "https://music.youtube.com/img/favicon_32.png",
            },
            href: "https://music.youtube.com/search?q={searchTerms}",
        }
    },
    "@features": {
        name: "Cargo Crate Features",
        url: {
            icon: {
                "32": "https://docs.rs/-/static/favicon.ico",
            },
            href: "https://docs.rs/crate/{searchTerms}/latest/features"
        }
    },
    "@crates": {
        name: "Cargo Crates",
        url: {
            icon: {
                "16": "https://crates.io/assets/cargo.png",
            },
            href: "https://crates.io/search?q={searchTerms}"
        }
    },
    "@ototoy": {
        name: "OTOTOY",
        url: {
            icon: {
                "16": "https://ototoy.jp/favicon.svg",
            },
            href: "https://ototoy.jp/find/?q={searchTerms}"
        }
    },
    "@amjp": {
        name: "ISRCeam (Apple JP)",
        url: {
            icon: {
                "32": "https://music.apple.com/assets/favicon/favicon-32.png",
            },
            href: "https://isrceam.rinsuki.net/apple/jp/search?q={searchTerms}"
        }
    },
    "@mbrel": {
        name: "MusicBrainz: Releases",
        url: {
            icon: {
                "32": "https://musicbrainz.org/static/images/entity/release.png",
            },
            href: "https://musicbrainz.org/search?type=release&method=indexed&query={searchTerms}"
        }
    },
    "@mbartist": {
        name: "MusicBrainz: Artists",
        url: {
            icon: {
                "32": "https://musicbrainz.org/static/images/entity/artist.png",
            },
            href: "https://musicbrainz.org/search?type=artist&method=indexed&query={searchTerms}"
        }
    },
    "@mbrec": {
        name: "MusicBrainz: Recordings",
        url: {
            icon: {
                "32": "https://musicbrainz.org/static/images/entity/recording.png",
            },
            href: "https://musicbrainz.org/search?type=recording&method=indexed&query={searchTerms}"
        }
    },
    "@spoalbum": {
        name: "Spotify: Albums",
        url: {
            icon: {
                "32": "https://open.spotifycdn.com/cdn/images/favicon32.b64ecc03.png",
            },
            href: "https://open.spotify.com/search/{searchTerms}/albums"
        },
    }
}

const DISABLED_IDS = ["yahoo-jp", "rakuten"]

const PROFILE_DIR = Deno.args[0]
if (PROFILE_DIR == null) {
    throw new Error("Please specify the Firefox profile directory as the first argument.")
}
const SEARCHLZ4_FILE = `${PROFILE_DIR}/search.json.mozlz4`
await Deno.stat(SEARCHLZ4_FILE)

const MOZLZ4_MAGIC = new TextEncoder().encode("mozLz40\0");

const file = await Deno.open(SEARCHLZ4_FILE, { read: true, write: true, append: true })
await file.lock(true)

const header = new Uint8Array(MOZLZ4_MAGIC.length + 4 /* decompressed size */)
await file.read(header)
if (!MOZLZ4_MAGIC.every((byte, i) => byte === header[i])) {
    throw new Error("Invalid magic header in search.json.mozlz4")
}
const decompressedSize = new DataView(header.buffer, MOZLZ4_MAGIC.length).getUint32(0, true)
console.log(decompressedSize)
const compressed = await readAll(file)
const decompressed = decompress(compressed)
if (decompressed.length !== decompressedSize) {
    throw new Error(`Decompressed size mismatch: expected ${decompressedSize}, got ${decompressed.length}`)
}
const text = new TextDecoder().decode(decompressed)
const json = JSON.parse(text)
if (json.version !== 13) {
    throw new Error(`Unsupported search.json version: ${json.version}`)
}
console.log(json)

let order = json.engines.length

for (const engine of json.engines) {
    order = Math.max(order, engine._metaData?.order ?? 0)
    if (DISABLED_IDS.includes(engine.id)) {
        engine._metaData = {
            ...engine._metaData,
            hidden: true,
            alias: "",
        }
    }
    if (engine._metaData?.alias in ENGINES) {
        const newData: typeof ENGINES[keyof typeof ENGINES] = ENGINES[engine._metaData.alias]
        engine._name = newData.name
        engine._urls = [
            {
                params: [],
                rels: [],
                template: newData.url.href,
            }
        ]
        delete ENGINES[engine._metaData.alias]
    }
}

for (const [alias, data] of Object.entries(ENGINES)) {
    json.engines.push({
        id: crypto.randomUUID(),
        _name: data.name,
        _loadPath: "[user]",
        _metaData: {
            alias,
            order: ++order,
        },
        _iconMapObj: Object.fromEntries(await Promise.all(Object.entries(data.url.icon).map(async e => {
            return [
                e[0],
                await fetch(e[1]).then(async r => {
                    if (!r.ok) {
                        throw new Error(`Failed to fetch icon from ${e[1]}: ${r.status} ${r.statusText}`)
                    }
                    const buffer = await r.arrayBuffer()
                    return `data:${r.headers.get("Content-Type")};base64,${new Uint8Array(buffer).toBase64()}`
                })
            ]
        }))),
        _urls: [
            {
                params: [],
                rels: [],
                template: data.url.href,
            }
        ],
        _definedAliases: [],
    })
}

console.log(json)

const beforeCompressed = new TextEncoder().encode(JSON.stringify(json))
const newCompressed = compress(beforeCompressed)
const newHeader = new Uint8Array(MOZLZ4_MAGIC.length + 4)
newHeader.set(MOZLZ4_MAGIC)
new DataView(newHeader.buffer, MOZLZ4_MAGIC.length).setUint32(0, beforeCompressed.length, true)
await file.truncate()
await file.seek(0, Deno.SeekMode.Start)
await file.write(newHeader)
await file.write(newCompressed)
file.close()