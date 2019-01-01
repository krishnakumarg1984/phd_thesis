IF EXIST "diff_changedpages.tex" (
    latexmk -C diff_changedpages.tex
    latexmk -f --shell-escape -halt-on-error diff_changedpages.tex
    latexmk -f --shell-escape diff_changedpages.tex
) ELSE (
    REM nothing to do
)


IF EXIST "diff.tex" (
    latexmk -C diff.tex
    latexmk -f --shell-escape -halt-on-error diff.tex
    latexmk -f --shell-escape diff.tex
) ELSE (
    REM nothing to do
)

REM sumatrapdf.exe -reuse-instance diff.pdf

