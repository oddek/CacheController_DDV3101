PROG = report
CC = pdflatex
LIB = bibtex

all: build

build:
	$(CC) $(PROG).tex && $(LIB) $(PROG).aux && $(CC) $(PROG).tex && $(CC) $(PROG).tex
