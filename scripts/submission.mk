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

.INTERMEDIATE: $(wildcard *.subm_from *.subm_to *.subm_fromto)

# AAAI press also requires all image files to be stored under the root directory.
# Putting the images in a nested directory is no longer allowed in the camera ready.
# Thus we implemented a method that automatically flattens the directory structure.
# Directory separaters "/" are replaced with "___".

%.subm_from: %.fls
	@echo "submission.mk: collecting all included files"
	awk '/INPUT .*\.(cls|sty|png|pdf|bb|tex|bbl|pygstyle|pygtex)/{print $$2}' $< | xargs --no-run-if-empty readlink -ef | sort | uniq | grep -v "texlive" | sed -e "s~$$(pwd)/~~g" > $@
	awk '/INPUT .*\.png/{print $$2}' $< | sed -e 's/png/xbb/g' | xargs --no-run-if-empty readlink -ef | sort | uniq | grep -v "texlive" | sed -e "s~$$(pwd)/~~g" >> $@

%.subm_to: %.subm_from
	cp $< $@
	@echo "submission.mk: Emitting a new location at the root for each file (official sty/bst/cls files)"
	sed -i "s@styles/official/@@g" $@
	@echo "submission.mk: Emitting a new location at the root for each file (images, other style files)"
	sed -i "s@/@___@g" $@

%.subm_fromto: %.subm_from %.subm_to
	paste $*.subm_from $*.subm_to > $@


%.submission: en %.subm_fromto

	@echo "submission.mk: preparing the main article"
	mkdir -p $@

	@echo "submission.mk: copying necessary files"
	while read from to ; do cp -v $$from $@/$$to ; done < $*.subm_fromto

	@echo "submission.mk: replacing pathnames, inline \\input, \\bibliography, remove comments"
	bash scripts/inline.sh $@/$*.tex $*.subm_fromto

	@echo "submission.mk: typesetting the pdf"
	cd $@ ; pdflatex $*.tex
	cd $@ ; pdflatex $*.tex
	cd $@ ; pdflatex $*.tex

	@echo "submission.mk: cleaning up unnecessary log files"
	-find $@ -name "*\.tex" -not -name $*.tex -delete # remove other tex files included through xr package
	-find $@ -name "*\.log" -delete
	-find $@ -name "*\.aux" -delete
	-find $@ -name "*\.out" -delete
	-find $@ -type d -empty -exec rmdir {} \; # remove empty directories


clean-submission:
	-rm -rf *.submission *.tar.gz *.zip


archive: $(name).submission supplemental.submission
	@echo "submission.mk: creating a camera-ready submission archive (tar.gz, zip) WITHOUT style files (use 'make arxiv' instead to include them)"
	-rm *.submission/*.sty *.submission/*.bst
	-rm $(name).tar.gz
	cd $(name).submission ; tar cvf ../$(name).tar *
	cd supplemental.submission ; tar rvf ../$(name).tar *
	gzip $(name).tar
	-rm $(name).zip
	cd $(name).submission ; zip -r ../$(name).zip *
	cd supplemental.submission ; zip -r ../$(name).zip *


arxiv: $(name).submission supplemental.submission
	@echo "submission.mk: creating an Arxiv submission (tar.gz, zip) WITH style files (use 'make archive' instead to exclude them)"
	-rm $(name).tar.gz
	cd $(name).submission ; tar cvf ../$(name).tar *
	cd supplemental.submission ; tar rvf ../$(name).tar *
	gzip $(name).tar
	-rm $(name).zip
	cd $(name).submission ; zip -r ../$(name).zip *
	cd supplemental.submission ; zip -r ../$(name).zip *

