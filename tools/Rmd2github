#!/bin/bash
for var in "$@"
do
	Rscript -e "rmarkdown::render(input= '$var', output_format= rmarkdown::md_document(variant = 'markdown_github'))"
done
