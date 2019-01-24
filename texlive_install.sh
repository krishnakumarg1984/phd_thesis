#!/usr/bin/env sh

# Originally from https://github.com/latex3/latex3

# This script is used for testing using Travis
# It is intended to work on their VM set up: Ubuntu 12.04 LTS
# A minimal current TL is installed adding only the packages that are
# required


# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
    # Obtain TeX Live
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    tar -xzf install-tl-unx.tar.gz
    cd install-tl-20*

    # Install a minimal system
    ./install-tl --profile=../texlive.profile

    cd ..
fi

# Just including texlua so the cache check above works
# Needed for any use of texlua even if not testing LuaTeX
tlmgr install luatex

# Other contrib packages: done as a block to avoid multiple calls to tlmgr
# texlive-latex-base is needed to run pdflatex
tlmgr install   \
    addlines \
    aleph \
    algorithmicx \
    algorithms \
    anyfontsize \
    appendix \
    arydshln \
    bezos \
    bib2gls \
    biber \
    biblatex \
    bigints \
    booktabs \
    cancel \
    caption \
    ccicons \
    changepage \
    chemformula \
    chkfloat \
    cleveref \
    csquotes \
    ctablestack \
    datatool \
    datetime \
    datetime2 \
    dehyph-exptl \
    diffcoeff \
    doclicense \
    enumitem \
    environ \
    eso-pic \
    etextools \
    etoolbox \
    fancyvrb \
    filehook \
    fixme \
    float \
    fmtcount \
    fontspec \
    footmisc \
    fp \
    framed \
    fvextra \
    gitinfo2 \
    glossaries \
    glossaries-english \
    glossaries-extra \
    hyphen-german \
    hyperxmp \
    ifetex \
    iffont \
    ifmtarg \
    ifoddpage \
    ifplatform \
    ifsym \
    iftex \
    ifthenx \
    impnattypo \
    koma-script \
    l3kernel \
    l3packages \
    labelschanged \
    latexdiff \
    latexmk \
    lineno \
    listings \
    listofitems \
    lm \
    lm-math \
    logreq \
    luacode \
    lualatex-math \
    lualibs \
    luaotfload \
    luatex85 \
    luatexbase \
    makecell \
    mathfixs \
    mathtools \
    metalogo \
    metalogox \
    mfirstuc \
    microtype \
    minted \
    ms \
    multirow \
    nag \
    nowidow \
    pdfpages \
    pdfx \
    pgf \
    pgfopts \
    pgfornament \
    pgfplots \
    placeins \
    selnolig \
    setspace \
    shapepar \
    silence \
    siunitx \
    stackengine \
    subfig \
    substr \
    supertabular \
    tabstackengine \
    tcolorbox \
    texcount \
    textcase \
    threeparttable \
    titlesec \
    tocbibind \
    todonotes \
    tracklang \
    trimspaces \
    ulem \
    unicode-math \
    units \
    upquote \
    varwidth \
    witharrows \
    xcolor \
    xfor \
    xifthen \
    xindy \
    xkeyval \
    xmpincl \
    xpatch \
    xstring \
    tabulary \
    ltabptch \
    xunicode

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
