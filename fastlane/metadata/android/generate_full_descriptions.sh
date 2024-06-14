#!/usr/bin/env bash

for d in */; do
    cd "$d"
    language=$(basename "$d")
    printf "\nGenerating full_description.txt for language $language\n"
    perl full_description.pl
    cd ".."
done
