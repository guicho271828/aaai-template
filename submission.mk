
%.subm: $(name).fls submission.mk
	awk '/INPUT .*\.$*/{print $$2}' $< | xargs readlink -ef | sort | uniq | grep -v "texlive" | sed -e "s~$$(pwd)/~~g" > $@

xbb.subm:  png.subm submission.mk
	sed -e 's/png/xbb/g' $< > $@

# Now AAAI press requires all image files to be stored under the root directory.
# Putting the images in a nested directory is no longer allowed in the camera ready.
# Thus we implemented a method that automatically flattens the directory structure.
# Directory separaters "/" are replaced with "^".

all.subm_from: sty.subm png.subm pdf.subm bb.subm tex.subm bbl.subm pygstyle.subm pygtex.subm
	cat $^ > $@

all.subm_to: all.subm_from
	tr "/" "^" < $< > $@

all.subm_fromto: all.subm_from all.subm_to
	paste all.subm_from all.subm_to > $@

submission: en all.subm_fromto

	mkdir -p submission
	while read from to ; do cp -v $$from submission/$$to ; done < all.subm_fromto

# replace the image pathnames in the text
	while read from to ; do echo "$$from -> $$to" ; sed -i "s@$$from@$$to@g" submission/*.tex ; done < all.subm_fromto
	cd submission ; ../inline-tex $(name).tex

# removing comments
	sed -i '/^[ ]*%.*/d' submission/$(name).tex
# "Your .tex source must be as simple as possible. Do not include unused style
# files, and do not include large areas of commented out text, or conditional
# statements for various versions. (You may be required to resubmit and pay the
# resubmission fee if your source is cluttered with extraneous text or
# scripted)." https://www.aaai.org/Publications/Author/icaps-submit.php

	-find submission -name "*\.log" -delete
	-find submission -name "*\.bbl" -delete
	-find submission -type d -empty -exec rmdir {} \; # remove the empty directories
	ls submission
	cd submission ; pdflatex $(name).tex
	cd submission ; pdflatex $(name).tex
	cd submission ; pdflatex $(name).tex
	-find submission -name "*\.log" -delete
	-find submission -name "*\.bbl" -delete
	-find submission -name "*\.aux" -delete
	-find submission -name "*\.out" -delete

# To ensure that the operations done above did not affect the paper.
	latexmk/pdfdiff.py $(name).pdf submission/$(name).pdf

	@echo "Make sure every \\input commands are in the beginning of line but space"

clean-submission:
	-rm -rf *.subm submission *.tar.gz *.zip

archive: submission
	-rm submission/*.sty submission/*.bst
	-rm $(name).tar.gz
	cd submission ; tar cvzf ../$(name).tar.gz *
	-rm $(name).zip
	cd submission ; zip -r ../$(name).zip *
