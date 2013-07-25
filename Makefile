
PAGES := index.html about.html documentation.html download.html
PAGES += $(addsuffix .html,$(basename $(wildcard cmd_*.in)))

web: $(PAGES)

index.html:
	ln -s about.html index.html

%.html: %.in templates/*
	perl -pe 'if (/^@(\S+)\s*(.*)@\s*$$/) { open(F, "<templates/$$1.in") or die $$!; # \
		$$y=$$2; $$x=""; $$x.=$$_ while <F>; close F; $$_=$$x; s/\@\@/$$y/g; s/\@$(basename $@)\@/1/g; s/\@[0-9a-zA-Z_]*\@/0/g; }' $< > $@.new
	mv $@.new $@

update_cmd:
	rm -f cmd_*.html
	git rm --ignore-unmatch -f cmd_*.in templates/cmd_index.in
	yosys -qp 'help -write-web-command-reference-manual'
	git add cmd_*.in templates/cmd_index.in

push: web
	rsync -e ssh -av --delete --exclude .git . clifford@clifford.at:htdocs/clifford/yosys/.

clean:
	rm -f $(PAGES)

.PHONY: web push clean

