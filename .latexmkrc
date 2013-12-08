# -*- mode: perl -*-
# vim:syntax=perl
#
# This (latexmkrc) is a configuration file to be used with latexmk

$latex             = 'pdflatex -output-format=dvi -src-specials -file-line-error'; # -shell-escape
$pdflatex          = 'pdflatex -output-format=pdf -src-specials -file-line-error'; # -shell-escape
$makeindex         = 'makeindex -cL';
$bibtex            = 'bibtex -min-crossrefs=1';
$clean_ext         = "brf ind lol lox nav out sbb snm thm xmpi tmp tui tuo log fdb_latexmk run.xml";
$clean_full_ext    = "hyph";
$pdf_previewer     = "start evince %O %S";
$pdf_update_method = 0;
@generated_exts = (@generated_exts, 'brf', 'lol', 'lox', 'nav', 'sbb', 'snm', 'thm', 'xmpi');
