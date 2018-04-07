$pdflatex = 'lualatex %O %S --shell-escape';
$pdf_mode = 1;
$postscript_mode = $dvi_mode = 0;

@cus_dep_list = (@cus_dep_list, "glo-abr gls-abr 0 makenomenclature");
sub makenomenclature {
   system("makeindex $_[0].glo-abr -s nomencl.ist -o $_[0].gls-abr"); }

@cus_dep_list = (@cus_dep_list, "syi syg 0 makegls");
sub makegls {
   system("makeindex $_[0].syg -s nomencl.ist -o $_[0].syi"); }

add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
  if ( $silent ) {
    system "makeglossaries -q '$_[0]'";
  }
  else {
    system "makeglossaries '$_[0]'";
  };
}
 
push @file_not_found, '^Package .* No file `([^\\\']*)\\\'';

$bibtex_use=2




