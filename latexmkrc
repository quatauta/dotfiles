# -*- mode: perl -*-
# vim:syntax=perl
#
# This (latexmkrc) is a configuration file to be used with latexmk

$bibtex                   = 'bibtex -min-crossrefs=1';
$clean_ext                = "bbl brf ind lol lox nav out sbb snm thm xmpi tmp tui tuo log fdb_latexmk run.xml";
$clean_full_ext           = "hyph";
$latex                    = 'pdflatex -output-format=dvi -src-specials -file-line-error'; # -shell-escape
$makeindex                = 'makeindex -cL';
$pdf_mode                 = 1;
$pdf_previewer            = "xdg-open %O %S";
$pdf_update_method        = 0;
$pdflatex                 = 'pdflatex -output-format=pdf -src-specials -file-line-error'; # -shell-escape
$recorder                 = 1;
$silence_logfile_warnings = 1;
$silent                   = 1;
@generated_exts           = (@generated_exts, 'brf', 'lol', 'lox', 'nav', 'sbb', 'snm', 'thm', 'xmpi');
