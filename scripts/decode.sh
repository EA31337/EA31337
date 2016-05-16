#!/usr/bin/env bash

name=${2:-EA31337 Lite}
author="kenorb"
link="https://github.com/EA31337"
copyright="Copyright 2016, kenorb"
version="1.068"
email=${1:-$name$version$copyright"@example.com"}
echo $email

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}


len=$(( ${#name} + ${#author} + ${#link} ))
out=''
for ((i=${#email}-1; i>=0; i--)) {
  ords=$(ord ${email:$i:1})
  convert=$(printf '%*.*s%s' 0 $(( 3 - ${#cv} )) '-' $ords)
  out="$out$convert"
}
r1=${out/9/1}
r2=${r1/8/7}
r3=${r2/--/-3}
echo ${r3:0:$len-1}
