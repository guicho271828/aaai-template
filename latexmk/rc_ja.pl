# -*- cperl -*-
# latexmkrc

$latex         = 'platex';
$bibtex        = 'pbibtex';
$dvipdf = "dvipdfm %O -f latexmk/ipa.map -o %D %S";
