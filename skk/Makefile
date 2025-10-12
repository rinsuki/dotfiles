.PHONY: clean

all: dest/SKK-JISYO.annict.utf8 dest/SKK-JISYO.L.github

clean:
	rm -f dest/*
	touch dest/.gitkeep

dest/SKK-JISYO.annict.utf8:
	curl https://rinsuki.github.io/skk-annict-dic/latest/SKK-JISYO.annict.utf8 > $@

dest/SKK-JISYO.L.github:
	curl https://skk-dev.github.io/dict/SKK-JISYO.L.gz | gzip -d > $@