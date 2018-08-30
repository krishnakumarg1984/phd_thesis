push @generated_exts, "acn";
push @generated_exts, "acr";
push @generated_exts, "alg";
push @generated_exts, "auxlock";
push @generated_exts, "bbl";
push @generated_exts, "blg";
push @generated_exts, "brf";
push @generated_exts, "cb";
push @generated_exts, "cb2";
push @generated_exts, "fdb_latexmk";
push @generated_exts, "fof";
push @generated_exts, "glg-abr";
push @generated_exts, "glo-abr";
push @generated_exts, "gls-abr";
push @generated_exts, "ist";
push @generated_exts, "loa";
push @generated_exts, "log";
push @generated_exts, "lot";
push @generated_exts, "mtc*";
push @generated_exts, "mypyg";
push @generated_exts, "nav";
push @generated_exts, "nlg";
push @generated_exts, "nlo";
push @generated_exts, "nls";
push @generated_exts, "nmo";
push @generated_exts, "out.ps";
push @generated_exts, "ptc";
push @generated_exts, "run.xml";
push @generated_exts, "slg";
push @generated_exts, "snm";
push @generated_exts, "spl";
push @generated_exts, "syg";
push @generated_exts, "syi";
push @generated_exts, "synctex*";
push @generated_exts, "synctex.gz";
push @generated_exts, "tar.gz";
push @generated_exts, "tdo";
push @generated_exts, "thm";
push @generated_exts, "xdy";
push @generated_exts, "xmpi";
push @generated_exts, "xmpdata";
push @generated_exts, 'acn', 'acr', 'alg';
push @generated_exts, 'glo', 'gls', 'glg';


$pdflatex = 'lualatex %O %S --interaction=batchmode -halt-on-error --shell-escape --bibtex --recorder';
$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;
$clean_ext .= ' %R.ist %R.xdy';
$ENV{'TZ'}='Europe/London';
@default_files = ('main.tex');


@cus_dep_list = (@cus_dep_list, "glo-abr gls-abr 0 makenomenclature");
sub makenomenclature {
   system("makeindex $_[0].glo-abr -s nomencl.ist -o $_[0].gls-abr"); }

@cus_dep_list = (@cus_dep_list, "syi syg 0 makegls");
sub makegls {
   system("makeindex $_[0].syg -s nomencl.ist -o $_[0].syi"); }

add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
  if ( $silent ) {
    system "makeglossaries -q '$_[0]'";
  }
  else {
    system "makeglossaries '$_[0]'";
  };
}

sub asy {return system("asy -o \"$_[0]\" \"$_[0]\"");}
add_cus_dep("asy","eps",0,"asy");
add_cus_dep("asy","pdf",0,"asy");
add_cus_dep("asy","tex",0,"asy");

push @file_not_found, '^Package .* No file `([^\\\']*)\\\'';

$bibtex_use=2
