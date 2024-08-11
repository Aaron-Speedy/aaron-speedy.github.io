# Tiny Site Generator

Lots of large static site generators are in fashion
now. Here's a tiny one you can make yourself using shell
scripting.

## Basics
The main idea is to take in a bunch of files
written in markdown, convert them to HTML, and attach
headers and footers.

We can start with just a single article: cool-article.md.

```sh
file="cool-article"
```

To start, we can use [smu](https://github.com/karlb/smu)
to convert our markdown to HTML:
```sh
smu $file.md > $file.html
```

This does not generate any headers or footers. We can
do that ourselves by creating two files: header.html
and footer.html. You might also want a style.css.

header.html:
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Extremely Cool Article</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
```

footer.html:
```html
</body>
</html>
```

To attach them to the article, we can simply do:
```sh
cat header.html > $file.html
smu $file.md >> $file.html
cat footer.html >> $file.html
```

And we're done! Now we can simply wrap it in a function
and put it in a build.sh file.

```sh
gen() {
  cat header.html > $1.html
  smu $1.md >> $1.html
  cat footer.html >> $1.html
}
gen("cool-article")
```

## Other stuff

One problem with what we have right now is that articl
