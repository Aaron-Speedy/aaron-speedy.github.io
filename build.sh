#!/bin/sh

# set -xe

gen() {
  echo "Building $1"
  # line=$(head -n 1 docs/$1.md)
  # sed -e "s~PAGE_TITLE~$line~" -e "s~#~~" recs/$2.html > docs/$1.html
  cat recs/$2.html > docs/$1.html
  smu src/$1.md >> docs/$1.html
  cat recs/footer.html >> docs/$1.html
}

rm -r docs
mkdir docs
cp recs/style.css docs
cp CNAME docs

mkdir docs/articles
# gen "articles/tiny-site-generator" header

gen "index" index-header
gen "webhosting" index-header
