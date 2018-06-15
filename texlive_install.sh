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
    aleph \
    algorithmicx \
    algorithms \
    antt \
    anyfontsize \
    apalike2 \
    appendix \
    arev \
    arydshln \
    auto-pst-pdf \
    auto-pst-pdf-lua \
    babel-german \
    belleek \
    bezos \
    biber \
    biblatex \
    bigints \
    booktabs \
    cancel \
    caption \
    ccfonts \
    ccicons \
    changepage \
    chapterfolder \
    chemformula \
    chkfloat \
    cleveref \
    cmbright \
    colortbl \
    csquotes \
    ctablestack \
    datatool \
    dehyph-exptl \
    diffcoeff \
    doclicense \
    enumitem \
    environ \
    epstopdf \
    eso-pic \
    esstix \
    etextools \
    etoolbox \
    eulervm \
    excludeonly \
    fancyhdr \
    fancyvrb \
    filehook \
    fixme \
    float \
    fontloader-luaotfload \
    fontspec \
    footmisc \
    fourier \
    fouriernc \
    fp \
    framed \
    fvextra \
    geometry \
    gitinfo2 \
    glossaries \
    glossaries-english \
    glossaries-extra \
    glossaries-german \
    graphics \
    hyphen-german \
    ifetex \
    iffont \
    ifmtarg \
    ifoddpage \
    ifplatform \
    ifsym \
    iftex \
    ifthenx \
    import \
    impnattypo \
    isodate \
    iwona \
    kerkis \
    koma-script \
    kurier \
    l3kernel \
    l3packages \
    labelschanged \
    latexmk \
    libertine \
    libertinus \
    libertinus-otf \
    libertinust1math \
    lineno \
    listings \
    listofitems \
    lm \
    lm-math \
    logreq \
    ltxnew \
    luacode \
    lualatex-math \
    luaotfload \
    luatex \
    luatex85 \
    luatexbase \
    luatodonotes \
    marginnote \
    marvosym \
    mathdesign \
    mathfixs \
    mathpazo \
    mathtools \
    metalogo \
    mfirstuc \
    microtype \
    minted \
    moreverb \
    ms \
    mtgreek \
    multirow \
    nag \
    needspace \
    newtx \
    newtxsf \
    nowidow \
    ntheorem \
    omega \
    onlyamsmath \
    paracol \
    pdfx \
    pgf \
    pgfplots \
    placeins \
    plex \
    plex-otf \
    psnfss \
    pstricks \
    pxfonts \
    realscripts \
    relsize \
    selnolig \
    setspace \
    silence \
    siunitx \
    stackengine \
    stix \
    stix2-otf \
    subfig \
    subfloat \
    substr \
    supertabular \
    svg \
    tabstackengine \
    tcolorbox \
    tex-gyre \
    tex-gyre-math \
    textcase \
    tikzscale \
    titlesec \
    tocbibind \
    todonotes \
    tracklang \
    translator \
    trimspaces \
    threeparttable \
    txfonts \
    ucharcat \
    unicode-math \
    units \
    upquote \
    url \
    varwidth \
    was \
    wrapfig \
    xcolor \
    xetex \
    xfor \
    xifthen \
    xkeyval \
    xltxtra \
    xmpincl \
    xstring \
    xunicode



# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
