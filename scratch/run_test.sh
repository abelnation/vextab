#!/bin/sh

name=$1

rm $name/$name.js
jison $name/$name.y $name/$name.l -o $name/$name.js

for input_file in $name/$name.input.*; do
  echo "Input: $input_file"
  node $name/$name.js $input_file
  echo

done

