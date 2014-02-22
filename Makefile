
name       = asai
reference  = asai-references.bib
emacs 	   = emacs
latexmk    = latexmk/latexmk.pl
styles     = abbrev.sty aaai_my.sty
sources    = abstract.tex main.org.tex
max_pages   = 8

.SUFFIXES: .tex .org .el .elc .svg
.SECONDARY: compile-csv-org.elc compile-main-org.elc __tmp1 __tmp2
.PHONY: all en ja open imgs clean allclean check_pages check_overflow en_pdf ja_pdf automake submission

all: en

check_pages:
	./check_pages.sh $(max_pages) $(name)

check_overflow: $(name).log
	./check_overflow.sh $(name).log

en:	en_pdf check_pages check_overflow
ja:	ja_pdf check_pages check_overflow

en_pdf: $(name).tex imgs $(sources) $(styles) $(reference)
	$(latexmk) -pdf \
		   -latexoption="-halt-on-error" \
		   -bibtex \
		   $<

ja_pdf: $(name).tex imgs $(sources) $(styles) $(reference)
	$(latexmk) -r rc_ja.pl \
		   -latexoption="-halt-on-error" \
		   -pdfdvi \
		   -bibtex \
		   $<

open: $(name).pdf
	nohup evince $< &>/dev/null &

automake: all
	nohup ./make-periodically.sh &

imgs:
	$(MAKE) -C img

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

clean:
	-rm *~ *.aux *.dvi *.log *.toc *.bbl \
		*.blg *.utf8 *.elc $(name).pdf \
		*.fdb_latexmk __* *.fls
	-rm -r sources

allclean: clean
	$(MAKE) -C img clean

submission: en
	./aaai_script.sh $(name).tex
