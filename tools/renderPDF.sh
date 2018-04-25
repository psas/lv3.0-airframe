#!/bin/bash 
#take all the file paths, 
		#separate out the markdown files, 
			#read them one at a time tineo the $line variable
find `pwd` | grep .md$ | while read -r line
do
	#printf "${line%/*}\n"
	printf "rendering $line \n" # call out which file you're rendering
	cd ${line%/*} # change to the working directory of that file
	# add a timestamp to the begining of the stuff to be rendered
	cat <(echo rendered on) <(date) <(printf "\n") <(cat $line) | 
	# convert that giant string into a pdf... I guess pandoc just knows it's .md ?
       	pandoc - -o ${line%.*}.pdf --latex-engine=xelatex
done	
