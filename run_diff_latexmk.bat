latexmk -C diff.tex
latexmk -f --shell-escape -halt-on-error diff.tex
latexmk -f --shell-escape diff.tex
sumatrapdf.exe -reuse-instance diff.pdf

