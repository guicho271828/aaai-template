
name       = asai
reference  = asai-reference.bib
emacs 	   = emacs
styles     = abbrev.sty aaai_my.sty
sources    = abstract.tex introduction.tex main.org.tex

.SUFFIXES: .tex .org
.PHONY: all en ja open imgs clean allclean

all: en


en: $(name).tex imgs $(sources) $(styles) $(reference)
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<
	bibtex $(name)
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<

ja: $(name).tex imgs $(sources) $(styles) $(reference)
	platex -halt-on-error $<
	platex -halt-on-error $<
	jbibtex $(name)
	platex -halt-on-error $<
	platex -halt-on-error $<
	dvipdfm $(name)

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
	rm -f *~ *.aux *.dvi *.log *.toc *.bbl *.blg *.utf8 *.org.tex *.elc *.pdf
	rm -f -r sources
	rm -f __*

allclean: clean
	make -C img clean
