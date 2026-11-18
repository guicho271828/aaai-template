
# all: journal-rebuttal.pdf
all: \
	$(shell echo Screenshot_from_2026-11-06_13-43-22-anon.{png,webp,avif,jpg}.base64) \
	$(shell echo Screenshot_from_2026-11-06_13-59-43.{png,webp,avif,jpg}.base64) \
	$(shell echo Screenshot_from_2026-11-06_13-59-43-small.{png,webp,avif,jpg}.base64) \

%.png.base64: %.png Makefile
	@base64 -w 0 $< | sed 's|^|<img src="data:image/png;base64,|' | sed 's|$$|" alt="$<">|' > $@

%.webp.base64: %.png Makefile
	@magick $< -quality 25 $*.webp
	@base64 -w 0 $*.webp | sed 's|^|<img src="data:image/webp;base64,|' | sed 's|$$|" alt="$<">|' > $@

%.webp-lossless.base64: %.png Makefile
	@magick $< -define webp:lossless=true $*.webp
	@base64 -w 0 $*.webp | sed 's|^|<img src="data:image/webp;base64,|' | sed 's|$$|" alt="$<">|' > $@

%.avif.base64: %.png Makefile
	@magick $< -quality 25 $*.avif
	@base64 -w 0 $*.avif | sed 's|^|<img src="data:image/avif;base64,|' | sed 's|$$|" alt="$<">|' > $@

%.jpg.base64: %.png Makefile
	@magick $< -quality 25 $*.jpg
	@base64 -w 0 $*.jpg | sed 's|^|<img src="data:image/jpeg;base64,|' | sed 's|$$|" alt="$<">|' > $@

auto:
	bash ../make-periodically.sh

%.pdf: %.tex
	pdflatex -halt-on-error -shell-escape $<
	bibtex $*
	pdflatex -halt-on-error -shell-escape $<
	pdflatex -halt-on-error -shell-escape $<

clean:
	-rm *.pdf *.base64
