#!/usr/bin/env deno run --allow-read=dest/annict.chars.json --allow-write=dest/SKK-JISYO.annict.utf8
import { z } from "npm:zod";
import { platform } from "node:os";

const seasonToReadableName = {
    WINTER: "冬",
    SPRING: "春",
    SUMMER: "夏",
    AUTUMN: "秋",
} as const;

const seasonNames = [
    "WINTER",
    "SPRING",
    "SUMMER",
    "AUTUMN",
] as const satisfies (keyof typeof seasonToReadableName)[];
type Season = typeof seasonNames[number];

const skkType = platform() === "darwin" ? "aquaskk" : "skk"

// 参考: https://mzp.hatenablog.com/entry/2016/05/02/101923
function escapeForSKK(str: string): string {
    if (skkType === "aquaskk") {
        return str
            .replaceAll("/", "[2f]")
            .replaceAll("[", "[5b]")
            .replaceAll(";", "[3b]")
    } else {
        throw new Error("TODO: support concat way")
    }
}

function escapeForAnnotation(str: string): string {
    if (skkType === "aquaskk") {
        return str
            .replaceAll(";", "；")
            .replaceAll("/", "／")
    } else {
        throw new Error("TODO: research about annotation escape for other skks")
    }
}

const dic = z.array(z.object({
    yomi: z.string(),
    names: z.array(z.object({
        name: z.string(),
        titles: z.array(z.object({
            title: z.string(),
            year: z.number().optional(),
            season: z.enum(seasonNames).optional(),
        })),
    })),
})).parse(JSON.parse(await Deno.readTextFile("./dest/annict.chars.json")));

const lines = dic.map(e => {
    let line = e.yomi + " /";
    for (const name of e.names) {
        line += escapeForSKK(name.name) + ";"
        // old to new
        name.titles.sort((a, b) => {
            if (a.year !== b.year) {
                if (a.year == null) return 1;
                if (b.year == null) return -1;
                return a.year - b.year
            }
            if (a.season !== b.season) {
                if (a.season == null) return 1;
                if (b.season == null) return -1;
                return seasonNames.indexOf(a.season) - seasonNames.indexOf(b.season);
            }
            return a.title.localeCompare(b.title);
        })
        const titles = Array.from(new Set(
            name.titles
                .map(title => title.title)
        ))
            .join("、")
        line += `[Annict] ${titles}/`
    }
    return line
})

lines.sort()
lines.unshift(
    ";; okuri-ari entries.",
    ";; okuri-nasi entries.",
)
lines.push("")

await Deno.writeTextFile("./dest/SKK-JISYO.annict.utf8", lines.join("\n"))
