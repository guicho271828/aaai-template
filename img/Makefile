
.SECONDEXPANSION:

.PRECIOUS: %.png %.pdf

.PHONY:	clean all

all: $(shell find -name "*.svg" -o -name "*.png" -o -name "*.jpg" | sed -e "s/\(png\|jpg\|svg\)/xbb/g")

%.xbb : %.jpg Makefile
	ebb -x $<

%.xbb : %.png Makefile
	ebb -x $<

%.xbb : %.pdf
	ebb -x $<

%.pdf : %.svg
	inkscape -f $< -A $*.pdf -d 150
# %.png : %.svg
# 	inkscape -f $< -e $*.png -d 150
#	convert $< $*.png
#	if you want to use imagemagick, comment out 'inkscape...' and use 'convert...'

clean:
	-find -name "*.xbb" -delete
	-rm *.png *.pdf
