Check out the `blocks/table/table.tex` to see an example of something that will port into Inkscape well. 
Note that it must be complied with `lualatex table.tex` and then imported into Inkscape as a PDF.

You can use `dvisvgm table.dvi table.svg` to convert DVI files to SVG and then import them (good with the `latex` command). 
However, that doesn't seem to work with the `fontspec` package. 
Importing PDFs *does* work with the `fontspec` package, so you can have the LaTeX stuff match up with the Inkscape stuff. 
