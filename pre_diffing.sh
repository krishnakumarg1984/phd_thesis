#!/bin/bash

latexpand -o ..\head_flattened_phd_thesis\flattened_head.tex --show-graphics --makeatletter main.tex
cp --parents `find -name \*.PNG` ../head_flattened_phd_thesis/
cp --parents `find -name \*.png` ../head_flattened_phd_thesis/
cp --parents `find -name \*.jpg` ../head_flattened_phd_thesis/
cp --parents `find -name \*.pdf` ../head_flattened_phd_thesis/
cp --parents `find -name \*.m` ../head_flattened_phd_thesis/
cp --parents `find -name \*.bib` ../head_flattened_phd_thesis/
cp --parents `find -name \*.xdy` ../head_flattened_phd_thesis/
cp --parents `find -name \*.icc` ../head_flattened_phd_thesis/
cp --parents `find -name \*.otf` ../head_flattened_phd_thesis/