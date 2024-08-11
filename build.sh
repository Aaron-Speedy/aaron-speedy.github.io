#!/bin/sh

gen() {
  echo "Building $1"
  line=$(head -n 1 docs/$1.md)
  sed -e "s~PAGE_TITLE~$line~" -e "s~#~~" recs/header.html > docs/$1.html
  smu docs/$1.md >> docs/$1.html
  cat recs/footer.html >> docs/$1.html
}

rm -r docs
mkdir docs
cp recs/style.css docs

mkdir docs/articles
gen "articles/tiny-site-generator"
