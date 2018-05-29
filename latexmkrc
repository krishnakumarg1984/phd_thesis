push @generated_exts, "acn";
push @generated_exts, "acr";
push @generated_exts, "alg";
push @generated_exts, "auxlock";
push @generated_exts, "brf";
push @generated_exts, "cb";
push @generated_exts, "cb2";
push @generated_exts, "glg-abr";
push @generated_exts, "glo-abr";
push @generated_exts, "gls-abr";
push @generated_exts, "ist";
push @generated_exts, "nav";
push @generated_exts, "nlg";
push @generated_exts, "nlo";
push @generated_exts, "nls";
push @generated_exts, "nmo";
push @generated_exts, "run.xml";
push @generated_exts, "slg";
push @generated_exts, "snm";
push @generated_exts, "spl";
push @generated_exts, "syg";
push @generated_exts, "syi";
push @generated_exts, "synctex.gz";
push @generated_exts, "tar.gz";
push @generated_exts, "tdo";
push @generated_exts, "thm";


$pdflatex = 'lualatex %O %S --interaction=batchmode --shell-escape --bibtex';
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
