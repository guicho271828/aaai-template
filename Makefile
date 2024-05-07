
name       = default
latexmk    = perl latexmk/latexmk.pl
sources    = $(wildcard *.tex) $(wildcard *.sty) $(wildcard *.bib)
max_pages  = 8

.PHONY: all imgs clean allclean auto \
	submission archive arxiv clean-submission

all: $(name).pdf standalone-supplement.pdf

$(name).tex: Makefile
	( echo "% This file is autogenerated. See Makefile and README " ; echo "\input{main.tex}") > $@
	echo $(name).tex >> .gitignore

$(name).log $(name).fls: $(name).pdf

# build a pygstyle file through finalizecache option of minted package
%.pygstyle: $(sources)
	touch $*.needpyg
	rm $*.pdf
	$(MAKE) $*.pdf
	rm $*.needpyg

%.pdf: %.tex imgs $(sources)
	-$(latexmk) -pdf \
		   -latexoption="-halt-on-error -shell-escape" \
		   -bibtex \
		   $<

%.ja.pdf: %.tex imgs $(sources)
	$(latexmk) -r latexmk/rc_ja.pl \
		   -latexoption="-halt-on-error -shell-escape" \
		   -pdfdvi \
		   -bibtex \
		   $<

auto:
	+bash scripts/make-periodically.sh

imgs:
	$(MAKE) -C img

clean: clean-submission
	-rm -r *~ *.aux *.dvi *.log *.toc *.bbl *.*pyg* *.out \
		*.blg *.utf8 *.elc $(name).pdf supplemental.pdf combined.pdf \
		*.fdb_latexmk __* *.fls *.subm* \
		_minted*

allclean: clean
	$(MAKE) -C img clean

include scripts/submission.mk
