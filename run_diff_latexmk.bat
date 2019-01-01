latexmk -C diff.tex
lualatex --shell-escape diff.tex
latexmk -f --shell-escape -halt-on-error diff.tex
latexmk -f --shell-escape diff.tex
REM sumatrapdf.exe -reuse-instance diff.pdf

