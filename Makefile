SITE=dist/site
META=dist/meta
TEMPLATES=$(wildcard templates/*)
POSTS_MD=$(wildcard posts/*.md)
POSTS_MD_META=$(patsubst posts/%.md, $(META)/posts/%.meta, $(POSTS_MD))
POSTS_MD_HTML=$(patsubst posts/%.md, $(SITE)/posts/%.html, $(POSTS_MD))

all: $(SITE)/index.html $(POSTS_MD_HTML)

$(SITE)/index.html: $(META)/posts/index $(POSTS_MD_META)
	@mkdir -p $(@D)
	echo "Hello, world!" > $@
	(cut -d' ' -f2 | xargs -I{} sh -c "cat {} | exporting template templates/index-entry") < $< >> $@

$(META)/posts/index: $(POSTS_MD_META) $(TEMPLATES)
	@mkdir -p $(@D)
	index $(POSTS_MD_META) | sort -nr > $(META)/posts/index

$(SITE)/posts/%.html: $(META)/posts/%.meta $(META)/posts/%.body $(TEMPLATES)
	@mkdir -p $(@D)
	slurping body $(word 2,$^) exporting template templates/post < $(word 1,$^) > $@

$(META)/posts/%.meta: posts/%.md $(META)/posts/%.body
	@mkdir -p $(@D)
	metadata $< > $@
	(plain | wordcount) < $< >> $@
	echo 'url="$(patsubst %.md,%.html,$(word 1,$^))"' >> $@

$(META)/posts/%.body: posts/%.md
	@mkdir -p $(@D)
	content $< | markdown > $@

.PHONY: clean
clean:
	rm -rf dist
