#Git cheat sheet
To bring down a new repository:

    git clone <COPY THE REPO NAME HERE>

**First thing you do** when you sit down to work (while in the repository directory):

    git pull

Anytime you're confused:

    git status
This command is how you see what's going on. This will show you any changes you've made, any new files, files you've added, files set to commit, if you're ready to commit. 

##After making changes and you want to push them to the repo
Add the files you want to commit:

    git status
    git add MYFILE.txt FAVCOLORS.jpg FANCYMATH.tex 

Commit your changes:

    git status
    git commit -a

The -a option just says to commit all the files you've added. Git will now ask you to comment on the commit. You *must* make a comment. Please make it something descriptive and less than 10 words. (Don't write "stuff") If you want to give a more extensive description, skip a line and then give your extended descrition.

**Remember:** 

Push your changes to Github:

    git push

Git will then ask 
