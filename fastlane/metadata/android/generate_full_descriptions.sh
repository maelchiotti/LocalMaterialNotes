#!/usr/bin/env bash

for d in */
do
  (
    cd "$d" || exit
    language=$(basename "$d")
    printf "\nGenerating full_description.txt for language %s\n" "$language"
    perl full_description.pl
  )
done
