#!/usr/bin/env bash

#  Must be run from a bash shell. Moreover latexdiff must be found by the shell. Does not work with windows cmd or powershell
if [ ! -d ../nonflat_submitted ]; then
    cd ..
    cp -R phd_thesis/ nonflat_submitted/
    cd nonflat_submitted/
    git checkout -f 383e7c8 # with gitinfo2 footer. The -f flag helps to force checkout to facilitate local uncommitted changes to the repo (like testing this script)
    # git checkout -f 0f26b11 # without footer.  The -f flag helps to force checkout to facilitate local uncommitted changes to the repo (like testing this script)
    cd ../phd_thesis/
fi

if [ ! -d ../diff_head_submitted ]; then
    mkdir ../diff_head_submitted
    cp latexmkrc ../diff_head_submitted/
    sed -i 's/main/diff/g' ../diff_head_submitted/latexmkrc
    # echo "\$max_repeat = 10;" >> ../diff_head_submitted/latexmkrc
fi

cp --parents `find -name \*.PNG` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message
cp --parents `find -name \*.png` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message
cp --parents `find -name \*.jpg` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message
cp --parents `find -name \*.pdf` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message
cp --parents `find -name \*.bib` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message
cp --parents `find -name \*.icc` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message
cp --parents `find -name \*.otf` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message
cp --parents `find -name \*.m` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message
rm -rf ../diff_head_submitted/notes*
rm -rf ../diff_head_submitted/main*

cp frontmatter/project_outputs.pdf ../diff_head_submitted/
cp frontmatter/coverpage.pdf ../diff_head_submitted/
cp frontmatter/figures/black_ink_sign_from_jpg.pdf ../diff_head_submitted/
cp frontmatter/figures/narayam_sanskrit.pdf ../diff_head_submitted/
cp run_diff_latexmk.bat ../diff_head_submitted/

latexdiff -c ld.cfg --driver=pdftex --floattype=IDENTICAL --packages=amsmath,hyperref,siunitx,cleveref,glossaries,chemformula --exclude-textcmd="section,subsection,subsubsection" --verbose --flatten --math-markup=3 --graphics-markup=0 --enable-citation-markup -L submitted_version -L latest_version -p Preamble/ltxdiff_defaultstyle_preamble.tex ../nonflat_submitted/main.tex main.tex > ../diff_head_submitted/diff.tex


cd ../diff_head_submitted

if [ -f diff_changedpages.tex ]; then
    latexmk -C diff_changedpages.tex
    latexmk -f --shell-escape -halt-on-error diff_changedpages.tex
    if [ ! -f diff_changedpages.pdf]; then
        latexmk -f --shell-escape diff_changedpages.tex
    fi
fi
if  [ -f diff.tex ]; then
    latexmk -C diff.tex
    latexmk -f --shell-escape -halt-on-error diff.tex
    if [ ! -f diff.pdf ]; then
        latexmk -f --shell-escape diff.tex
    fi
fi

cd ../phd_thesis

