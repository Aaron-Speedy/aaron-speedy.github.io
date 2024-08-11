#!/bin/sh

gen() {
  echo "Building $1"
  line=$(head -n 1 docs/$1.md)
  sed -e "s~PAGE_TITLE~$line~" -e "s~#~~" recs/header.html > dest/$1.html
  smu docs/$1.md >> dest/$1.html
  cat recs/footer.html >> dest/$1.html
}

rm -r dest
mkdir dest
cp recs/style.css dest

mkdir dest/articles
gen "articles/tiny-site-generator"
