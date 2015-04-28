
BB=$(shell ls *.svg | sed -e "s/svg/bb/g")
SBB=$(shell ls *.svg | sed -e "s/svg/sbb/g")
MBB=$(shell ls *.svg | sed -e "s/svg/mbb/g")
XBB=$(shell ls *.svg | sed -e "s/svg/xbb/g")
PNG=$(shell ls *.svg | sed -e "s/svg/png/g")

.PHONY:	clean all

all: $(PNG) $(SBB)

%.colorpng : %.svg
	inkscape -z -f $< -e $*.colorpng -d 300

%.png : %.colorpng
	convert $< -colorspace gray $@
%.mbb : %.png
	ebb -O -m $< > $*.bb
	cp -f $*.bb $@

%.sbb : %.png
	ebb -O $< > $*.bb
	cp -f $*.bb $@

%.xbb : %.png
	ebb -O -x $< > $*.bb
	cp -f $*.bb $@

clean:
	rm -f *.png *bb

