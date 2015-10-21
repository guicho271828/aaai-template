
BB=$(shell find . -name "*.svg" | sed -e "s/svg/bb/g")
SBB=$(shell find . -name "*.svg" | sed -e "s/svg/sbb/g")
MBB=$(shell find . -name "*.svg" | sed -e "s/svg/mbb/g")
XBB=$(shell find . -name "*.svg" | sed -e "s/svg/xbb/g")
PNG=$(shell find . -name "*.svg" | sed -e "s/svg/png/g")
CPNG=$(shell find . -name "*.svg" | sed -e "s/\.svg/-color.png/g")

.PHONY:	clean all

all: $(PNG) $(SBB)
# all: $(PNG) $(CPNG) $(SBB)

%.png : %.svg Makefile
	inkscape -z -f $< -e $@ -d 300

# %-color.png : %.svg
# 	inkscape -z -f $< -e $@ -d 300
# 
# %.png : %-color.png
# 	convert $< -colorspace gray $@
%.mbb : %.png  Makefile
	ebb -O -m $< > $*.bb
	cp -f $*.bb $@

%.sbb : %.png  Makefile
	ebb -O $< > $*.bb
	cp -f $*.bb $@

%.xbb : %.png Makefile
	ebb -O -x $< > $*.bb
	cp -f $*.bb $@

clean:
	rm -f *.png *bb

