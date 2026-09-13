SHELL := /bin/bash
DIR   := $(shell pwd)
OUT   := $(DIR)/output

.PHONY: all pdf epub md clean

all: pdf epub md

pdf: $(OUT)/book.pdf

epub: $(OUT)/book.epub

md: $(OUT)/book.md

$(OUT):
	mkdir -p $(OUT)

$(OUT)/book.pdf: main.tex chapters/*.tex references.bib img_playing_cards.jpg | $(OUT)
	xelatex -output-directory=$(OUT) -jobname=book main.tex
	biber $(OUT)/book
	xelatex -output-directory=$(OUT) -jobname=book main.tex
	xelatex -output-directory=$(OUT) -jobname=book main.tex
	@echo "PDF built: $(OUT)/book.pdf"

$(OUT)/book.epub: main.tex chapters/*.tex metadata.yaml img_playing_cards.jpg | $(OUT)
	pandoc main.tex \
		--from latex \
		--to epub3 \
		--metadata-file=metadata.yaml \
        --epub-cover-image=img_playing_cards.jpg \
		--toc \
		--toc-depth=2 \
		--resource-path=. \
		--css=epub.css \
		--split-level=1 \
		-o $(OUT)/book.epub
	@echo "EPUB built: $(OUT)/book.epub"

$(OUT)/book.md: main.tex chapters/*.tex | $(OUT)
	pandoc main.tex \
		--from latex \
		--to gfm \
		--wrap=none \
		--resource-path=. \
		--css=epub.css \
		--split-level=1 \
		-o $(OUT)/book.md
	@echo "Markdown built: $(OUT)/book.md"

clean:
	rm -rf $(OUT)
