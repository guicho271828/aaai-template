
all: journal-rebuttal.pdf

auto:
	bash ../make-periodically.sh

%.pdf: %.tex
	pdflatex -halt-on-error -shell-escape $<
	bibtex $*
	pdflatex -halt-on-error -shell-escape $<
	pdflatex -halt-on-error -shell-escape $<

clean:
	-rm *.pdf
