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


# list files loaded by latex that are not part of texlive
%.subm: $(name).fls scripts/submission.mk
	awk '/INPUT .*\.$*/{print $$2}' $< | xargs readlink -ef | sort | uniq | grep -v "texlive" | sed -e "s~$$(pwd)/~~g" > $@

# list bounding box files
xbb.subm:  png.subm scripts/submission.mk
	sed -e 's/png/xbb/g' $< > $@

# Now AAAI press requires all image files to be stored under the root directory.
# Putting the images in a nested directory is no longer allowed in the camera ready.
# Thus we implemented a method that automatically flattens the directory structure.
# Directory separaters "/" are replaced with "___".

all.subm_from: sty.subm png.subm pdf.subm bb.subm tex.subm bbl.subm pygstyle.subm pygtex.subm
	cat $^ > $@

all.subm_to: all.subm_from
	sed "s@/@___@g" < $< > $@

all.subm_fromto: all.subm_from all.subm_to
	paste all.subm_from all.subm_to > $@

submission: en all.subm_fromto

	mkdir -p submission
	while read from to ; do cp -v $$from submission/$$to ; done < all.subm_fromto

# replace pathnames, inline \input, \bibliography, remove comments
	bash scripts/inline.sh submission/$(name).tex all.subm_fromto

	ls submission
	cd submission ; pdflatex $(name).tex
	cd submission ; pdflatex $(name).tex
	cd submission ; pdflatex $(name).tex
	-find submission -name "*\.log" -delete
	-find submission -name "*\.aux" -delete
	-find submission -name "*\.out" -delete
	-find submission -type d -empty -exec rmdir {} \; # remove the empty directories

	@echo "Make sure every \\input commands are in the beginning of line but space"

clean-submission:
	-rm -rf *.subm submission *.tar.gz *.zip


# camera-ready submission requires removing style files from the archive
archive: submission
	-rm submission/*.sty submission/*.bst
	-rm $(name).tar.gz
	cd submission ; tar cvzf ../$(name).tar.gz *
	-rm $(name).zip
	cd submission ; zip -r ../$(name).zip *


# unlike archive, include the style files
arxiv: submission
	-rm $(name).tar.gz $(name).zip
	cd submission ; tar cvzf ../$(name).tar.gz *
	cd submission ; zip -r ../$(name).zip *
