#!/bin/bash

if [ ! -d ../nonflat_submitted ]; then
    cd ..
    cp -R phd_thesis/ nonflat_submitted/
    cd nonflat_submitted/
    git checkout 383e7c8 # with gitinfo2 footer
    # git checkout 0f26b11 # without footer
    cd ../phd_thesis/
fi

if [ ! -d ../diff_head_submitted ]; then
    mkdir ../diff_head_submitted
    cp latexmkrc ../diff_head_submitted/
    sed -i 's/main/diff/g' ../diff_head_submitted/latexmkrc
fi

latexdiff -c ld.cfg  --driver=pdftex --subtype=ONLYCHANGEDPAGE --floattype=IDENTICAL --verbose --flatten --math-markup=3 --graphics-markup=0 --enable-citation-markup -L submitted_version -L latest_version ../nonflat_submitted/main.tex main.tex > ../diff_head_submitted/diff_changes.tex

latexdiff -c ld.cfg --driver=pdftex --floattype=IDENTICAL --verbose --flatten --math-markup=3 --graphics-markup=0 --enable-citation-markup -L submitted_version -L latest_version ../nonflat_submitted/main.tex main.tex > ../diff_head_submitted/diff.tex

cp --parents `find -name \*.xdy` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message: https://serverfault.com/questions/153875/how-to-let-cp-command-dont-fire-an-error-when-source-file-does-not-exist

cp --parents `find -name \*.PNG` ../diff_head_submitted/
cp --parents `find -name \*.png` ../diff_head_submitted/
cp --parents `find -name \*.jpg` ../diff_head_submitted/
cp --parents `find -name \*.pdf` ../diff_head_submitted/
cp --parents `find -name \*.bib` ../diff_head_submitted/
cp --parents `find -name \*.icc` ../diff_head_submitted/
cp --parents `find -name \*.otf` ../diff_head_submitted/
cp --parents `find -name \*.m` ../diff_head_submitted//
rm -rf ../diff_head_submitted/notes*

cp frontmatter/project_outputs.pdf ../diff_head_submitted/
cp frontmatter/coverpage.pdf ../diff_head_submitted/
cp frontmatter/figures/black_ink_sign_from_jpg.pdf ../diff_head_submitted/
cp frontmatter/figures/narayam_sanskrit.pdf ../diff_head_submitted/
cp frontmatter/figures/doclicense-CC-by-nc-nd.pdf ../diff_head_submitted/chapters/backmatter/

cd ../diff_head_submitted
latexmk -f --shell-escape -halt-on-error diff.tex
latexmk -f --shell-escape diff.tex
latexmk -f --shell-escape -halt-on-error diff_changes.tex
latexmk -f --shell-escape diff_changes.tex
cd ../phd_thesis

