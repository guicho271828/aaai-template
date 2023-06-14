#
# Makefile for preparing a conference/arxiv/journal submission.
# See README for explanations.

# Example of camera-ready requirements (these requirements change time to time,
# so I follow the safest strategy):
#
# https://www.aaai.org/Publications/Author/icaps-submit.php
# "your .tex source must be as simple as possible. Do not include unused style
# files, and do not include large areas of commented out text, or conditional
# statements for various versions. (You may be required to resubmit and pay the
# resubmission fee if your source is cluttered with extraneous text or
# scripted)."
#
#
# https://aaai.org/wp-content/uploads/AuthorKit23.zip
# Your \LaTeX{} source file submitted as a \textbf{single} .tex file (do not use
# the ``input'' command to include sections of your paper --- every section must
# be in the single source file). (The only allowable exception is .bib file, which
# should be included separately).
#
# Your \LaTeX{} source will be reviewed and recompiled on our system (if
# it does not compile, your paper will be returned to you. \textbf{Do not
# submit your source in multiple text files.} Your single \LaTeX{} source
# file must include all your text, your bibliography (formatted using
# aaai23.bst), and any custom macros.
#
# \textbf{Do not send files that are not actually used in the paper.}
# Avoid including any files not needed for compiling your paper,
# including, for example, this instructions file, unused graphics files,
# style files, additional material sent for the purpose of the paper
# review, intermediate build files and so forth.  \textbf{Obsolete style
# files.} The commands for some common packages (such as some used for
# algorithms), may have changed. Please be certain that you are not
# compiling your paper using old or obsolete style files.
#
# \textbf{Final Archive.} Place your source files in a single archive which should be compressed using .zip. The final file size may not exceed 10 MB.
# Name your source file with the last (family) name of the first author, even if that is not you.


#
# Additional note: All bash scripts are explicitly invoked by `bash`, rather than with an executable flag.
# This is because stupid Overleaf always resets the executable flag.
#

.INTERMEDIATE: $(name).subm_from $(name).subm_to $(name).subm_fromto cls.subm sty.subm png.subm pdf.subm bb.subm tex.subm bbl.subm pygstyle.subm pygtex.subm

%.subm: $(name).fls
	@echo "submission.mk: listing $* files loaded by latex that are not part of texlive"
	awk '/INPUT .*\.$*/{print $$2}' $< | xargs --no-run-if-empty readlink -ef | sort | uniq | grep -v "texlive" | sed -e "s~$$(pwd)/~~g" > $@

xbb.subm:  png.subm
	@echo "submission.mk: listing bounding box files"
	sed -e 's/png/xbb/g' $< > $@


# AAAI press also requires all image files to be stored under the root directory.
# Putting the images in a nested directory is no longer allowed in the camera ready.
# Thus we implemented a method that automatically flattens the directory structure.
# Directory separaters "/" are replaced with "___".

$(name).subm_from: cls.subm sty.subm png.subm pdf.subm bb.subm tex.subm bbl.subm pygstyle.subm pygtex.subm
	@echo "submission.mk: collecting all included files"
	cat $^ > $@

$(name).subm_to: $(name).subm_from
	cp $< $@
	@echo "submission.mk: Emitting a new location at the root for each file (official sty/bst/cls files)"
	sed -i "s@styles/official/@@g" $@
	@echo "submission.mk: Emitting a new location at the root for each file (images, other style files)"
	sed -i "s@/@___@g" $@

$(name).subm_fromto: $(name).subm_from $(name).subm_to
	paste $(name).subm_from $(name).subm_to > $@


$(name).submission: en $(name).subm_fromto

	@echo "submission.mk: preparing the main article"
	mkdir -p $@

	@echo "submission.mk: copying necessary files"
	while read from to ; do cp -v $$from $@/$$to ; done < $(name).subm_fromto

	@echo "submission.mk: replacing pathnames, inline \\input, \\bibliography, remove comments"
	bash scripts/inline.sh $@/$(name).tex $(name).subm_fromto

	@echo "submission.mk: typesetting the pdf"
	cd $@ ; pdflatex $(name).tex
	cd $@ ; pdflatex $(name).tex
	cd $@ ; pdflatex $(name).tex

	@echo "submission.mk: cleaning up unnecessary log files"
	-find $@ -name "*\.tex" -not -name $(name).tex -delete # remove other tex files included through xr package
	-find $@ -name "*\.log" -delete
	-find $@ -name "*\.aux" -delete
	-find $@ -name "*\.out" -delete
	-find $@ -type d -empty -exec rmdir {} \; # remove empty directories


clean-submission:
	-rm -rf *.subm *.submission *.tar.gz *.zip


archive: $(name).submission
	@echo "submission.mk: creating a camera-ready submission archive (tar.gz, zip) WITHOUT style files (use 'make arxiv' instead to include them)"
	-rm $</*.sty $</*.bst
	-rm $(name).tar.gz
	cd $< ; tar cvzf ../$(name).tar.gz *
	-rm $(name).zip
	cd $< ; zip -r ../$(name).zip *


arxiv: $(name).submission
	@echo "submission.mk: creating an Arxiv submission (tar.gz, zip) WITH style files (use 'make archive' instead to exclude them)"
	-rm $(name).tar.gz $(name).zip
	cd $< ; tar cvzf ../$(name).tar.gz *
	cd $< ; zip -r ../$(name).zip *
