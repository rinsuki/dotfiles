#!/usr/bin/python3
# バニラPython縛り
from dataclasses import dataclass
from enum import Enum
import urllib.request
import urllib.parse
import http.client
import os
import json
import plistlib

class DictionaryType(Enum):
    LocalEUCJP = 0
    LocalUTF8 = 5

@dataclass
class DictionaryEntry:
    active = True
    type: DictionaryType
    location: str

    def asdict(self): # type: ignore
        return {
            "active": self.active,
            "type": self.type.value,
            "location": self.location
        } # type: ignore

AQUASKK_DIR = os.environ["HOME"] + "/Library/Application Support/AquaSKK"
SKK_DEST = os.environ["HOME"] + "/dotfiles/skk/dest"

def download(url: str):
    print("Downloading", url)
    res: http.client.HTTPResponse = urllib.request.urlopen(url)
    if res.status >= 300 or res.status < 200:
        raise Exception(f"Failed to download {url}: HTTP {res.status}")
    r = res.read()
    res.close()
    return r

def write_to_file(path: str, content: bytes):
    with open(path, "wb") as f:
        f.write(content)

# im@sparql

IMASPARQL_QUERY = """
PREFIX schema: <http://schema.org/>
PREFIX imas: <https://sparql.crssnky.xyz/imasrdf/URIs/imas-schema.ttl#>

SELECT ?id ?name ?yomi ?brand
WHERE {
  ?id schema:name ?name;
      imas:nameKana ?yomi;
      imas:Brand ?brand.
  FILTER (lang(?name) = "ja" || lang(?name) = "")
}
""".strip()

sparql_response = download("https://sparql.crssnky.xyz/spql/imas/query?output=json&query=" + urllib.parse.quote(IMASPARQL_QUERY))
sparql_response = json.loads(sparql_response.decode())
sparql_response = sparql_response["results"]["bindings"]
sparql_jisyo: dict[str, str] = {}
for r in sparql_response:
    key = r["yomi"]["value"]
    value = r["name"]["value"]
    value += ";[im@sparql] " + r["brand"]["value"]
    if key not in sparql_jisyo:
        sparql_jisyo[key] = "/"
    sparql_jisyo[key] += value + "/"
# sort by keys char code
sparql_jisyo = dict(sorted(sparql_jisyo.items(), key=lambda x: x[0]))
sparql_jisyo_list = [f"{k} {v}" for k, v in sparql_jisyo.items()]
sparql_jisyo_list.insert(0, ";; okuri-ari entries.")
sparql_jisyo_list.insert(1, ";; okuri-nasi entries.")
sparql_jisyo_list.append("")
sparql_jisyo_str = "\n".join(sparql_jisyo_list)
write_to_file(AQUASKK_DIR + "/SKK-JISYO.imasparql", sparql_jisyo_str.encode())

plist = [
    DictionaryEntry(type=DictionaryType.LocalEUCJP, location=SKK_DEST + "/SKK-JISYO.L.github"),
    DictionaryEntry(type=DictionaryType.LocalUTF8, location=AQUASKK_DIR + "/SKK-JISYO.imasparql"),
    DictionaryEntry(type=DictionaryType.LocalUTF8, location=SKK_DEST + "/SKK-JISYO.annict.utf8")
]

write_to_file(AQUASKK_DIR + "/DictionarySet.plist", plistlib.dumps([e.asdict() for e in plist]))
