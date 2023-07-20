#!/usr/bin/env bash

for n in 00 01 02 03 04 05 06 07 08 09 10
do
        md2html lesson$n
        mv lesson$n.html ../html
done
md2html index
mv index.html ../
