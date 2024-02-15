# Tiny Site Generator

Lots of large static site generators are in fashion
now. Here's a tiny one you can make yourself using shell
scripting.

## Approach
The main idea is to take in a bunch of files written in
markdown, convert them to HTML and add headers/footers.

To start, we can have a `src` directory to store all
our markdown files. To convert them to HTML, we can use
[`smu`](https://github.com/karlb/smu). Finally, we can
store our generated files in a `dest` directory.

```sh
mkdir dest/articles
for file in src/articles/*
do
  if test -f "$file"
  then
    basefile="$(basename "$file" .${file##*.})"
    echo "Building $file"
    smu "$file" >> "dest/articles/$basefile.html"
  fi
done
```

Next, we can store header and footer html files in a
`recs` directory and then concatenate them to every
generated file.

```sh
# ...
cat recs/header.html > "dest/articles/$basefile.html"
smu "$file" >> "dest/articles/$basefile.html"
cat recs/footer.html >> "dest/$1/$basefile.html"
# ...
```

And of course every time the site is made, we need to
clear the `dest` directory.

```sh
rm -r dest
mkdir dest
```

From here adding support for something like CSS is easy.

## Why?
Sure this might be simple, but why bother rolling your own
static site generator when you could just use one of the
myriad of static site generators available on the internet?
After all, many of them have lots of themes available for
immediate use, and often they even have support for fancy
tagging systems or the like. Does this approach offer any
of that?

Yes it does, and it offers more!

What this approach is all about is gluing distinct
tools together, using the common interface of text,
to ultimately generate a few HTML files laid out in a
directory structure. These tools are not limited to the
tools we used. We could also use, say, `sed` to find
and replace text, `git` to manage history, or even
custom-built tools to do more complicated things. The
sky(your computer, or perhaps your mind) is the limit!

## Conclusion

Maybe one day I will revise this article to include
examples of such extensions, however, right now I am
becoming tired, so I will end it at this.

Although I realize that I didn't address the issue of there
being more themes available on other static site generators
than there are on this approach. Again, there are a few
things I could say about this, but right now I will just
say CSS, yes more hacky, and aesthetic of static sites
or something.

Finally, for a full demonstration,
[here](https://github.com/Aaron-Speedy/personal-website)
is the code for the website this article is posted on,
which uses this approach.

Anyway, I hope this article was helpful!
