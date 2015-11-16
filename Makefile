# cheers tj
# https://github.com/visionmedia/masteringnode/

MD = toc.md \
	 chapters/01.md \
	 chapters/02.md \
	 chapters/03.md \
	 chapters/04.md \
	 chapters/05.md \
	 chapters/06.md

HTML = $(MD:.md=.html)

all: book.html book.pdf book.mobi book.epub

regenerate: clean all
	git commit -a -m 'Regenerated book' && echo done

book.pdf: $(HTML)
	@echo "\n... generating $@"
	htmldoc $(HTML) $(PDF_FLAGS) --outfile $@

book.html: $(HTML)
	@echo "\n... generating $@"
	cat $(HTML) > book.html

%.html: %.md
	ronn --pipe --fragment $< \
		| sed -E 's/<h1>([^ ]+) - /<h1>/' \
		> $@

book.mobi:
	@echo "\n... generating $@"
	ebook-convert book.html book.mobi --output-profile kindle

book.epub:
	@echo "\n... generating $@"
	ebook-convert book.html book.epub \
		--title "A Bit of Git" \
		--no-default-epub-cover \
		--authors "Kristian Freeman" \
		--language en \
		--cover abitofgit.jpg

view: book.pdf
	open book.pdf

clean:
	rm -f book.*
	rm -f chapters/*.html

.PHONY: view clean regenerate
