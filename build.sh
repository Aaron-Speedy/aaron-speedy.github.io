#!/bin/sh

gen() {
  mkdir dest/$1
  for file in src/$1/*
  do
    if test -f "$file"
    then
      basefile="$(basename "$file" .${file##*.})"
      echo "Building $file"
      cat recs/header.html > "dest/$1/$basefile.html"
      smu "$file" >> "dest/$1/$basefile.html"
      cat recs/footer.html >> "dest/$1/$basefile.html"
    fi
  done
}

rm -r dest
mkdir dest

cp recs/style.css dest

gen "articles"

echo "Building src/index.md"
cat recs/index-header.html > "dest/index.html"
smu src/index.md >> "dest/index.html"
cat recs/footer.html >> "dest/index.html"
