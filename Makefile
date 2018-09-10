
name       = asai
reference  = confs.bib journals.bib
emacs 	   = emacs
latexmk    = latexmk/latexmk.pl
styles     = abbrev.sty aaai_my.sty common-header.sty
tables     = $(addsuffix .tex,$(basename $(wildcard tables/*.org)))
sources    = main.tex $(wildcard [0-9]-*.tex) $(tables)
$(info $(sources))

max_pages   = 8

upload     = ~/Dropbox/FukunagaLabShare/OngoingWorks/Asai/

ncpu       = $(shell grep "processor" /proc/cpuinfo | wc -l)

get-archive = wget -O- $(1) | tar xz ; mv $(2) $(3)

.SUFFIXES: .tex .org .el .elc .svg
.SECONDARY: compile-csv-org.elc compile-main-org.elc __tmp1 __tmp2
.PHONY: all en ja open imgs clean allclean check_pages check_overflow en_pdf ja_pdf automake submission archive clean-submission

all: check_pages check_overflow en

$(name).log $(name).fls: $(name).pdf

check_pages: $(name).pdf
	-./check_pages.sh $(max_pages) $(name)

check_overflow: $(name).log
	-./check_overflow.sh $(name).log

en: $(name).pdf supplemental.pdf

$(name).pdf: supplemental.pdf

%.pdf: %.tex $(name).tex supplemental.tex imgs $(sources) $(styles) $(reference)
	-$(latexmk) -pdf \
		   -latexoption="-halt-on-error -shell-escape" \
		   -bibtex \
		   $<
	mkdir -p $(upload)/$(notdir $(PWD))/
	cp $@ $(upload)/$(notdir $(PWD))/$(shell hostname)-$(shell git rev-parse --abbrev-ref HEAD)-$*.pdf

%.ja.pdf: %.tex imgs $(sources) $(styles) $(reference)
	$(latexmk) -r latexmk/rc_ja.pl \
		   -latexoption="-halt-on-error -shell-escape" \
		   -pdfdvi \
		   -bibtex \
		   $<

# %.bib:
# 	-ln -s $$(kpsewhich $@)

open: $(name).pdf
	nohup evince $< &>/dev/null &

auto:
	+./make-periodically.sh

ci:
	while : ; do git pull && make ; sleep 60 ; done

imgs:
	$(MAKE) -C img
# $(MAKE) -C staticimg

clean: clean-submission
	-rm *~ *.aux *.dvi *.log *.toc *.bbl \
		*.blg *.utf8 *.elc $(name).pdf \
		*.fdb_latexmk __* *.fls
	-rm -r sources

allclean: clean
	$(MAKE) -C img clean

include submission.mk
