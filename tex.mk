TEXS=$(wildcard *.tex)
PDFS=$(TEXS:.tex=.pdf)

SCANS=$(wildcard *-scan.pdf)
FULLS=$(SCANS:-scan.pdf=-full.pdf)

all:: $(PDFS) $(FULLS)

clean::
	rm $(PDFS) $(FULLS)

%-full.pdf: %.pdf %-scan.pdf
	pdftk $^ cat output $@

%.pdf:: %.tex
	pdflatex $<
