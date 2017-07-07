CC=$(GOPATH)/bin/hugo
COMMAND=
FLAGS=-s blog
OUTDIR?=.

default: build_site

build_site:
	$(CC) $(COMMAND) $(FLAGS)
	cp -r blog/public $(OUTDIR)
