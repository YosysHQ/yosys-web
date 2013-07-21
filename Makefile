
PAGES := index.html about.html documentation.html download.html

web: $(PAGES)

index.html:
	ln -s about.html index.html

%.html: %.in templates/*
	perl -pe 'if (/^@(\S+)\s*(.*)@\s*$$/) { open(F, "<templates/$$1.in") or die $!; $$y=$$2; $$x=""; $$x.=$$_ while <F>; close F; $$_=$$x; s/@@/$$y/g; }' $< > $@.new
	mv $@.new $@

push: web
	rsync -e ssh -av --delete --exclude .git . clifford@clifford.at:htdocs/clifford/yosys/.

clean:
	rm -f $(PAGES)

.PHONY: web push clean

