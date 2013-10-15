#@+leo-ver=5-thin
#@+node:ville.20101127205006.2026: * @thin export.py

# this utility script only works on my computer, fix as appropriate


import sloppycode.shortcuts as sc
import os

#@+<< meat >>
#@+node:ville.20101127205006.2027: ** << meat >>
sc.ns.VER = "1.0"
sc.ns.PACKAGE = 'com.substanceofcode.kasvopus'
sc.ns.OBSPRJ = sc.fpath('~/obs/home:vivainio/kasvopus')
sc.ns.TARB = sc.fpath("${OBSPRJ}/${PACKAGE}-${VER}.tar")


sh = sc.shrun
sc.verbose = 1
with sc.chdir('..'):
    sh("git archive -o ${TARB} --prefix ${PACKAGE}-$VER/ HEAD" )
    sh("gzip ${TARB}")
    sh('tar tf ${TARB}.gz')
    sh('cp ${PACKAGE}.yaml ${PACKAGE}.spec ${OBSPRJ}')
    with sc.chdir('${OBSPRJ}'):
        sh('specify ${PACKAGE}.yaml')

#@-<< meat >>
#@-leo
