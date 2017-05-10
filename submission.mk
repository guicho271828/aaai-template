
%.subm: $(name).fls submission.mk
	awk '/INPUT .*\.$*/{print $$2}' $< | xargs readlink -ef | sort | uniq | grep -v "texlive" | sed -e "s~$$(pwd)/~~g" > $@

xbb.subm:  png.subm submission.mk
	sed -e 's/png/xbb/g' $< > $@

submission: en sty.subm png.subm pdf.subm bb.subm tex.subm bbl.subm
	bash -c "rsync --files-from=<(cat *.subm) . submission/"
	cd submission ; ../inline-tex $(name).tex
	find submission -name "*\.log" -delete
	find submission -name "*\.bbl" -delete
	find submission -type d -empty -exec rmdir {} \;
	ls submission
	cd submission ; pdflatex $(name).tex
	cd submission ; pdflatex $(name).tex
	cd submission ; pdflatex $(name).tex
	find submission -name "*\.log" -delete
	find submission -name "*\.bbl" -delete
	find submission -name "*\.aux" -delete
	find submission -name "*\.out" -delete
	@echo "Make sure every \\input commands are in the beginning of line but space"

clean-submission:
	-rm -rf *.subm submission *.tar.gz *.zip

archive: submission
	cd submission ; tar cvzf ../$(name).tar.gz *
	cd submission ; zip -r ../$(name) *
