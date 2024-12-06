.PHONY: clean

all: dest/SKK-JISYO.annict.utf8 dest/SKK-JISYO.L.github

clean:
	rm -f dest/*
	touch dest/.gitkeep

dest/SKK-JISYO.annict.utf8: make-annict-dic.ts dest/annict.chars.json
	./make-annict-dic.ts
dest/annict.chars.json: fetch-annict-dic.ts
	./fetch-annict-dic.ts

dest/SKK-JISYO.L.github:
	curl https://skk-dev.github.io/dict/SKK-JISYO.L.gz | gzip -d > $@