
name       = default
latexmk    = perl latexmk/latexmk.pl
sources    = $(wildcard *.tex) $(wildcard *.sty) $(wildcard *.bib)
max_pages  = 8

$(info sources: $(sources))

.PHONY: all en ja open imgs clean allclean auto \
	submission archive clean-submission

all: en

en: combined.pdf

ja: $(name).ja.pdf supplemental.pdf

combined.pdf: $(name).pdf supplemental.pdf
	pdfunite $(name).pdf supplemental.pdf combined.pdf

$(name).tex:
	echo "\input{main.tex}" > $@

$(name).log $(name).fls: $(name).pdf

$(name).pdf: supplemental.pdf

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

ifeq ($(UNAME), Darwin)
open: $(name).pdf
	open $< &>/dev/null
endif
ifeq ($(UNAME), Linux)
open: $(name).pdf
	nohup xdg-open $< &>/dev/null &
endif

auto:
	+bash scripts/make-periodically.sh

imgs:
	$(MAKE) -C img

clean: clean-submission
	-rm -r *~ *.aux *.dvi *.log *.toc *.bbl *.*pyg* \
		*.blg *.utf8 *.elc $(name).pdf supplemental.pdf \
		*.fdb_latexmk __* *.fls *.subm* \
		_minted*

allclean: clean
	$(MAKE) -C img clean

include scripts/submission.mk
