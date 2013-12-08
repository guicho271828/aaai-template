
SBB=$(shell ls *.svg | sed -e "s/svg/sbb/g")
MBB=$(shell ls *.svg | sed -e "s/svg/mbb/g")
XBB=$(shell ls *.svg | sed -e "s/svg/xbb/g")
PNG=$(shell ls *.svg | sed -e "s/svg/png/g")

.SUFFIXES: .svg .png
.PHONY:	clean all

all: $(PNG) $(SBB)
	$(shell ./overwritebb.sh $(SBB))

dvipdfm: $(PNG) $(MBB) always
	$(shell ./overwritebb.sh $(MBB))

dvipdfmx: $(PNG) $(XBB) always
	$(shell ./overwritebb.sh $(XBB))

%.png : %.svg
	inkscape -f $< -e $*.png -d 600

%.mbb : %.png
	ebb -O -m $< > $@

%.sbb : %.png
	ebb -O $< > $@		# standard bb

%.xbb : %.png
	ebb -O -x $< > $@

clean:
	rm -f *.png *bb

