#!/usr/bin/env deno run --allow-net=api.annict.com --allow-write=dest/annict.chars.json --allow-read=dest/annict.chars.json --allow-env
import { promptSecret } from "jsr:@std/cli";
import { z } from "npm:zod";

const token = await promptSecret("Annict Personal Access Token: ");
if (token == null) throw new Error("Token is required");

const query = `
query($after: String) {
  searchWorks(first: 100, after: $after, orderBy: { field: CREATED_AT, direction: ASC }) {
    nodes {
      title
      seasonYear
      seasonName
      media
      casts {
        nodes {
          character {
            name
            nameKana
          }
        }
      }
    }
    pageInfo {
      endCursor
      hasNextPage
    }
  }
}
`;

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

const zResponse = z.object({
  data: z.object({
    searchWorks: z.object({
      nodes: z.array(z.object({
        title: z.string(),
        seasonYear: z.nullable(z.number()),
        seasonName: z.nullable(z.enum(seasonNames)),
        media: z.string(),
        casts: z.object({
          nodes: z.array(z.object({
            character: z.object({
              name: z.string(),
              nameKana: z.string(),
            }),
          })),
        }),
      })),
      pageInfo: z.object({
        endCursor: z.string().optional(),
        hasNextPage: z.boolean(),
      }),
    }),
  }),
});

type Variables = {
  after?: string;
};

let after: string | undefined = undefined;
// {kana: {name: [title, ...]}}
const entries = new Map<string, Map<string, {
  title: string,
  season?: Season,
  year?: number,
}[]>>();

while (true) {
  const res = await fetch("https://api.annict.com/graphql", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query,
      variables: { after } satisfies Variables,
    }),
  });

  const { data } = zResponse.parse(await res.json());
  after = data.searchWorks.pageInfo.endCursor;
  console.log(after);
  for (const work of data.searchWorks.nodes) {
    let title = work.title
    title = work.media + " " + title;
    if (work.seasonYear != null) {
      title += " (" + work.seasonYear;
      if (work.seasonName != null) {
        title += seasonToReadableName[work.seasonName];
      }
      title += ")";
    }

    for (const cast of work.casts.nodes) {
      const name = cast.character.name;
      const nameKana = cast.character.nameKana;
      if (nameKana === "") continue;

      let yomis = entries.get(nameKana);
      if (yomis == null) entries.set(nameKana, yomis = new Map());

      let titles = yomis.get(name);
      if (titles == null) yomis.set(name, titles = []);

      titles.push({
        title,
        year: work.seasonYear ?? undefined,
        season: work.seasonName ?? undefined,
      });
    }
  }
  console.log(entries.size);

  // break
  if (!data.searchWorks.pageInfo.hasNextPage) break;
}

await Deno.writeFile(
  "./dest/annict.chars.json",
  new TextEncoder().encode(JSON.stringify(Array.from(
    entries.entries().map(a => ({
      yomi: a[0],
      names: Array.from(a[1].entries().map(b => ({
        name: b[0],
        titles: b[1],
      })))
    }))
  ), null, 2)),
);
