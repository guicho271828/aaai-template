
make.log: en

sty.subm: $(name).log submission.mk
	grep -o "\(-\|[0-9a-zA-Z/\._]\)\+\.sty" $(name).log | xargs readlink -ef | sort | uniq | sed -e "s~$$(pwd)/~~g" | grep -v "texlive\\|amsgen" > $@
png.subm: $(name).log submission.mk
	grep -o "\(-\|[0-9a-zA-Z/\._]\)\+\.png" $(name).log | xargs readlink -ef | sort | uniq | sed -e "s~$$(pwd)/~~g" > $@
pdf.subm: $(name).log submission.mk
	grep -o "\(-\|[0-9a-zA-Z/\._]\)\+\.pdf" $(name).log | xargs readlink -ef | sort | uniq | sed -e "s~$$(pwd)/~~g" | grep -v $(name).pdf > $@
tex.subm: $(name).log submission.mk
	grep -o "\(-\|[0-9a-zA-Z/\._]\)\+\.tex" $(name).log | xargs readlink -ef | sort | uniq | sed -e "s~$$(pwd)/~~g" > $@

bbl.subm: $(name).log submission.mk
	grep -o "\(-\|[0-9a-zA-Z/\._]\)\+\.bbl" $(name).log | xargs readlink -ef | sort | uniq | sed -e "s~$$(pwd)/~~g" > $@

bb.subm:  png.subm submission.mk
	sed -e 's/png/bb/g' $< > $@

# subm: en
# -rm -r sources
# ./aaai_script.sh $(name).tex

submission: en sty.subm png.subm pdf.subm bb.subm tex.subm bbl.subm
	mkdir -p submission
	cat *.subm | while read file ; \
	 do if [ -e ./$$file ] ; \
	 then mkdir -p submission/$$(dirname $$file) ; \
	      cp --remove-destination $$file submission/$$file ; \
	 else cp --remove-destination $$file submission ; \
	 fi ; \
	 done
	cd submission ; ../inline-tex $(name).tex
	find submission -name "*\.log" -delete
	find submission -name "*\.bbl" -delete
	find submission -name "*\.tex" | grep -v $(name).tex | xargs rm
	find submission -type d -empty -exec rmdir {} \;
	ls submission
	cd submission ; pdflatex $(name).tex
	cd submission ; pdflatex $(name).tex
	cd submission ; pdflatex $(name).tex
	find submission -name "*\.log" -delete
	find submission -name "*\.bbl" -delete
	find submission -name "*\.aux" -delete


clean-submission:
	-rm -rf *.subm submission

archive: submission
	cd submission ; tar cvzf $(name).tar.gz * ; mv $(name).tar.gz ../
