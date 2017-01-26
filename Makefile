all: dist/site/posts/first.html

dist/site/posts:
	mkdir -p "$@"

dist/meta/posts:
	mkdir -p "$@"

dist/site/posts/first.html: templates/post posts/first.md dist/meta/posts/first.meta dist/meta/posts/first.body | dist/site/posts
	slurping body dist/meta/posts/first.body \
          cat dist/meta/posts/first.meta "|" \
          exporting template templates/post \
          > dist/site/posts/first.html

dist/meta/posts/first.meta: posts/first.md dist/meta/posts/first.body | dist/meta/posts
	metadata posts/first.md > "$@"
	wordcount < posts/first.md >> "$@"

dist/meta/posts/first.body: posts/first.md | dist/meta/posts
	content posts/first.md | pandoc > "$@"

.PHONY: clean
clean:
	rm -rf dist
