PATH:=$(pwd)/bin:${PATH}
SHELL=env -i PATH="$(PATH)" /bin/sh
.SHELLFLAGS= -euc

SITE=dist/site
META=dist/meta
TEMPLATES=$(wildcard templates/*)
STATIC=$(patsubst static/%,$(SITE)/static/%,$(wildcard static/*.css))

POSTS_MD=$(wildcard posts/*.md)
POSTS_MD_META=$(patsubst posts/%.md, $(META)/posts/%.meta, $(POSTS_MD))
POSTS_MD_HTML=$(patsubst posts/%.md, $(SITE)/posts/%.html, $(POSTS_MD))

HTML=$(SITE)/index.html $(POSTS_MD_HTML)

all: $(HTML) $(STATIC)

$(SITE)/index.html: $(META)/posts/index $(POSTS_MD_META)
	@mkdir -p $(@D)
	render-index $< > $@

$(SITE)/static/%: static/%
	@mkdir -p $(@D)
	cp -rf "$<" "$@"

$(META)/posts/index: $(POSTS_MD_META) $(TEMPLATES)
	@mkdir -p $(@D)
	index $(POSTS_MD_META) | sort -nr > $(META)/posts/index

$(SITE)/posts/%.html: $(META)/posts/%.meta $(META)/posts/%.body $(TEMPLATES)
	@mkdir -p $(@D)
	render-post $(word 1,$^) $(word 2,$^) > $@

$(META)/posts/%.meta: posts/%.md $(META)/posts/%.body
	@mkdir -p $(@D)
	metadata $< > $@
	(plain | wordcount) < $(word 2,$^) >> $@
	echo 'url="$(patsubst %.md,%.html,$(word 1,$^))"' >> $@
	echo 'root=".."' >> $@

$(META)/posts/%.body: posts/%.md
	@mkdir -p $(@D)
	content $< | markdown > $@

.PHONY: clean
clean:
	rm -rf dist
