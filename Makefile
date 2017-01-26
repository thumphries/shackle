TEMPLATES=$(wildcard templates/*)
POSTS_MD=$(wildcard posts/*.md)
POSTS_MD_HTML=$(patsubst posts/%.md, dist/site/posts/%.html, $(POSTS_MD))

all: dist/site/index.html

dist/site/index.html: $(POSTS_MD_HTML)
	echo "Hello, world!" > $@

dist/site/posts:
	mkdir -p "$@"

dist/meta/posts:
	mkdir -p "$@"

dist/site/posts/%.html: dist/meta/posts/%.meta dist/meta/posts/%.body $(TEMPLATES) | dist/site/posts
	slurping body $(word 2,$^) \
	  cat $(word 1,$^) "|" exporting template templates/post > $@

dist/meta/posts/%.meta: posts/%.md dist/meta/posts/%.body $(TEMPLATES)
	metadata $< > $@
	wordcount < $< >> $@

dist/meta/posts/%.body: posts/%.md | dist/meta/posts
	content $< | markdown > $@

.PHONY: clean
clean:
	rm -rf dist
