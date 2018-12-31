% ls -F backmatter/*.bib | tr '\n' '\0' | xargs -0 -n 1 basename | sed 's/.\{4\}$//'
