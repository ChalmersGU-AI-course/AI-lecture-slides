
.DELETE_ON_ERROR:

.PHONY: help img

IMAGEDIR = img

PDFFILES = $(wildcard $(IMAGEDIR)/*.pdf)

help:
	@echo "make img"

# img: $(PDFFILES:%.pdf=%.png)

%.png: %.pdf
	sips -s format png $< --out $@

