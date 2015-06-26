
name       = asai
reference  = asai-references.bib
emacs 	   = emacs
latexmk    = latexmk/latexmk.pl
styles     = abbrev.sty aaai_my.sty
sources    = main.tex
max_pages   = 8

ncpu       = $(shell grep "processor" /proc/cpuinfo | wc -l)

.SUFFIXES: .tex .org .el .elc .svg
.SECONDARY: compile-csv-org.elc compile-main-org.elc __tmp1 __tmp2
.PHONY: all en ja open imgs clean allclean check_pages check_overflow en_pdf ja_pdf automake submission archive clean-submission

all: en GTAGS

GTAGS: $(name).tex imgs $(sources) $(styles) $(reference)
	gtags

check_pages:
	./check_pages.sh $(max_pages) $(name)

check_overflow: $(name).log
	./check_overflow.sh $(name).log

en:	en_pdf check_pages check_overflow

en_pdf: $(name).pdf

%.pdf: %.tex imgs $(sources) $(styles) $(reference)
	$(latexmk) -pdf \
		   -latexoption="-halt-on-error" \
		   -bibtex \
		   $<

%.ja.pdf: %.tex imgs $(sources) $(styles) $(reference)
	$(latexmk) -r latexmk/rc_ja.pl \
		   -latexoption="-halt-on-error" \
		   -pdfdvi \
		   -bibtex \
		   $<

%.bib:
	-cp $$(kpsewhich $@) .

open: $(name).pdf
	nohup evince $< &>/dev/null &

auto:
	./make-periodically.sh

imgs:
	$(MAKE) -C img
# $(MAKE) -C staticimg

%.csv: %.csvorg compile-csv-org.elc
	$(emacs) --batch --quick --script compile-csv-org.elc --eval "(progn (load-file \"compile-csv-org.el\")(compile-org \"$<\" \"$@\"))"

img/%.tex: %.gnuplot %.csv
	gnuplot $<

img/%.svg: %.gnuplot %.csv
	gnuplot $<

%.org.tex: %.org compile-main-org.elc
	$(emacs) --batch --quick \
		 --script compile-main-org.elc \
		 --eval "(compile-org \"$<\" \"$@\")"

%.elc : %.el
	$(emacs) -Q --batch -f batch-byte-compile $<

clean: clean-submission
	-rm *~ *.aux *.dvi *.log *.toc *.bbl \
		*.blg *.utf8 *.elc $(name).pdf \
		*.fdb_latexmk __* *.fls
	-rm -r sources

allclean: clean
	$(MAKE) -C img clean

include submission.mk
