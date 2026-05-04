#!/bin/bash


grep '^INPUT .*\.pdf' default.fls | sed 's@INPUT \.\?/\?@@g'  | sort | uniq | parallel -v -j 1 git add -f
grep '^INPUT .*\.png' default.fls | sed 's@INPUT \.\?/\?@@g'  | sort | uniq | parallel -v -j 1 git add -f
grep '^INPUT .*\.jpg' default.fls | sed 's@INPUT \.\?/\?@@g'  | sort | uniq | parallel -v -j 1 git add -f
