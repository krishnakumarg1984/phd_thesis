#!/usr/bin/env bash

#  Must be run from git-bash or cmder bash or some other bash shell. Does not work with windows cmd or powershell
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

cp --parents `find -name \*.xdy` ../diff_head_submitted/ 2>/dev/null || : # If you want to suppress the exit code and the error message: https://serverfault.com/questions/153875/how-to-let-cp-command-dont-fire-an-error-when-source-file-does-not-exist


cp frontmatter/project_outputs.pdf ../diff_head_submitted/
cp frontmatter/coverpage.pdf ../diff_head_submitted/
cp frontmatter/figures/black_ink_sign_from_jpg.pdf ../diff_head_submitted/
cp frontmatter/figures/narayam_sanskrit.pdf ../diff_head_submitted/
cp run_diff_latexmk.bat ../diff_head_submitted/

latexdiff -c ld.cfg --driver=pdftex --floattype=IDENTICAL --verbose --flatten --math-markup=3 --graphics-markup=0 --enable-citation-markup -L submitted_version -L latest_version ../nonflat_submitted/main.tex main.tex > ../diff_head_submitted/diff.tex

cd ../diff_head_submitted

if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ] || [ "$(expr substr $(uname -s) 1 7)" == "MSYS_NT" ]; then
    # start cmd /c ""latexmk -f --shell-escape -halt-on-error diff.tex"" & ""latexmk -f --shell-escape diff.tex""
    # :
    # ../phd_thesis/run_diff_latexmk.bat  # https://stackoverflow.com/questions/11865085/out-of-a-git-console-how-do-i-execute-a-batch-file-and-then-return-to-git-conso
    start cmd "/C run_diff_latexmk.bat"
else
    latexmk -C diff.tex
    latexmk -f --shell-escape -halt-on-error diff.tex
    latexmk -f --shell-escape diff.tex
fi

cd ../phd_thesis

