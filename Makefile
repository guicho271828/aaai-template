
name       = asai
reference  = asai-references.bib
emacs 	   = emacs
styles     = abbrev.sty aaai_my.sty
sources    = abstract.tex introduction.tex main.org.tex
max_pages   = 7

.SUFFIXES: .tex .org
.PHONY: all en ja open imgs clean allclean check_pages en_pdf ja_pdf

all: en

check_pages:
	./check_pages.sh $(max_pages) $(name)

en:	en_pdf check_pages
ja:	ja_pdf check_pages

en_pdf: $(name).tex imgs $(sources) $(styles) $(reference)
	latexmk -pdf \
		-latexoption="-halt-on-error" \
		-bibtex \
		$<

ja_pdf: $(name).tex imgs $(sources) $(styles) $(reference)
	latexmk -r rc_ja.pl \
		-latexoption="-halt-on-error" \
		-pdfdvi \
		-bibtex \
		$<

open: $(name).pdf
	nohup evince $< &

imgs:
	make -C img

%.csv: %.csvorg compile-csv-org.elc
	$(emacs) --batch --quick --script compile-csv-org.elc --eval "(progn (load-file \"compile-csv-org.el\")(compile-org \"$<\" \"$@\"))"

img/%.tex: %.gnuplot %.csv
	gnuplot $<

img/%.svg: %.gnuplot %.csv
	gnuplot $<

%.org.tex: %.org compile-main-org.elc
	$(emacs) --batch --quick --script compile-main-org.elc --eval "(progn (load-file \"compile-main-org.el\")(compile-org \"$<\" \"$@\"))"

%.elc : %.el
	$(emacs) -Q --batch -f batch-byte-compile $<

clean:
	-rm *~ *.aux *.dvi *.log *.toc *.bbl \
		*.blg *.utf8 *.org.tex *.elc $(name).pdf \
		fdb_latexmk __*
	-rm -r sources

allclean: clean
	make -C img clean
