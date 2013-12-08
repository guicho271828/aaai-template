
EMACS = emacs
EMACSFLAGS =

styles=abbrev.sty aaai_my.sty
sources_common=abstract.tex introduction.tex \
	msss.org.tex \
	results2.org.tex \
	img/msss-2a.tex \
	violate-third-condition.org.tex

# comp-direct-app.org.tex \
# comp-lower-bounds.org.tex \
# comp-trivial.org.tex \

# table-compare-seq.org.tex \
# table-compare-par.org.tex \
# table-compare-lower-bound.org.tex

sources_en=main.tex
sources_ja=main.ja.tex

.SUFFIXES: .tex .org
.PHONY: all ja open openja imgs clean allclean

all: asai.pdf compile-main-org.elc

ja: asai.ja.pdf compile-main-org.elc

open: all
	nohup evince asai.pdf &

openja: ja
	nohup evince asai.ja.pdf &

# 本番環境
# asai.pdf: imgs abstract.tex introduction.tex main.tex asai-references.bib
# 	pdflatex
# 	bibtex
# 	pdflatex
# 	pdflatex


asai.ja.pdf: asai.ja.tex imgs $(sources_common) $(sources_ja) $(styles) asai-references.bib
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<
	bibtex asai.ja
	pdflatex -halt-on-error $<
	pdflatex -halt-on-error $<

asai.dvi: asai.tex imgs $(sources_common) $(sources_en) $(styles) asai-references.bib
	platex -halt-on-error $<
	platex -halt-on-error $<
	bibtex $*
	platex -halt-on-error $<
	platex -halt-on-error $<

imgs:
	make -C img

%.csv: %.csvorg compile-csv-org.elc
	emacs --batch --quick --script compile-csv-org.elc --eval "(progn (load-file \"compile-csv-org.el\")(compile-org \"$<\" \"$@\"))"

img/%.tex: %.gnuplot %.csv
	gnuplot $<

img/%.svg: %.gnuplot %.csv
	gnuplot $<

%.org.tex: %.org compile-main-org.elc
	emacs --batch --quick --script compile-main-org.elc --eval "(progn (load-file \"compile-main-org.el\")(compile-org \"$<\" \"$@\"))"

# %.pdf : %.dvi
# 	dvipdfm -f ipa.map -o $@ $*

%.elc : %.el
	$(EMACS) -Q --batch $(EMACSFLAGS) -f batch-byte-compile $<

clean:
	rm -f *~ *.aux *.dvi *.log *.toc *.bbl *.blg *.utf8 *.org.tex *.elc *.pdf
	rm -f -r sources
	rm -f __*

allclean: clean
	make -C img clean
