#!/bin/bash

[ -d ../diff_head_submitted ] || mkdir ../diff_head_submitted

latexdiff -c ld.cfg --type=CULINECHBAR --driver=pdftex --subtype=ONLYCHANGEDPAGE --floattype=IDENTICAL --verbose --flatten --math-markup=3 --graphics-markup=0 --enable-citation-markup -L submitted_version -L latest_version nonflat_submitted\main.tex phd_thesis\main.tex > diff_head_submitted\diff.tex

cp latexmkrc ../diff_head_submitted/
sed -i 's/main/diff/g' ../diff_head_submitted/latexmkrc

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

# find . -name \*.pdf -exec cp {} ../diff_head_submitted \;
# find . -name \*.PNG -exec cp {} ../diff_head_submitted \;
# find . -name \*.png -exec cp {} ../diff_head_submitted \;
# find . -name \*.jpg -exec cp {} ../diff_head_submitted \;
# find . -name \*.bib -exec cp {} ../diff_head_submitted \;

# [ -d ../head_flattened_phd_thesis ] || mkdir ../head_flattened_phd_thesis
# latexpand -o ../head_flattened_phd_thesis/flattened_head.tex --show-graphics --makeatletter main.tex

# cp latexmkrc ../head_flattened_phd_thesis/

# cp --parents `find -name \*.xdy` ../head_flattened_phd_thesis/ 2>/dev/null || : # If you want to suppress the exit code and the error message: https://serverfault.com/questions/153875/how-to-let-cp-command-dont-fire-an-error-when-source-file-does-not-exist
# cp --parents `find -name \*.PNG` ../head_flattened_phd_thesis/
# cp --parents `find -name \*.png` ../head_flattened_phd_thesis/
# cp --parents `find -name \*.jpg` ../head_flattened_phd_thesis/
# cp --parents `find -name \*.pdf` ../head_flattened_phd_thesis/
# cp --parents `find -name \*.bib` ../head_flattened_phd_thesis/
# cp --parents `find -name \*.icc` ../head_flattened_phd_thesis/
# cp --parents `find -name \*.otf` ../head_flattened_phd_thesis/
# cp --parents `find -name \*.m` ../head_flattened_phd_thesis/
# rm -rf ../head_flattened_phd_thesis/notes*

