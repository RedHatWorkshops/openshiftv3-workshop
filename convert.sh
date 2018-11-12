#!/bin/bash

for file in *.md; do nfile=`echo $file|sed 's/.md/.adoc/'`;pandoc -f markdown -t asciidoc -o $nfile $file; done
