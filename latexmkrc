$pdflatex = 'lualatex %O %S --shell-escape';
$pdf_mode = 1;
$postscript_mode = $dvi_mode = 0;

@cus_dep_list = (@cus_dep_list, "glo-abr gls-abr 0 makenomenclature");
sub makenomenclature {
   system("makeindex $_[0].glo-abr -s nomencl.ist -o $_[0].gls-abr"); }

@cus_dep_list = (@cus_dep_list, "syi syg 0 makegls");
sub makegls {
   system("makeindex $_[0].syg -s nomencl.ist -o $_[0].syi"); }

push @file_not_found, '^Package .* No file `([^\\\']*)\\\'';

$bibtex_use=2




