# LV3-airframe
simulation/design stuff for the LV3 airframe (2016 capstone)

``ORK/`` holds all the OpenRocket models.  
Most of the other stuff is related to comparing the results from lots of OR models at once. You can refresh that by running ``analyze_everything.sh``.  
``flutterAnalysis.md`` provides a nice summary of where we stand with fin flutter, and is generated from ``flutter Analysis.Rmd`` using ``../Rmd2github``.  
``DATCOM/`` holds the DATCOM simulation of the rocket (not completed)  
``OpenFoam/`` contains the OF simulation of the nose cone (still need to do mesh convergence).  
``plots/`` and ``reductions/`` both contain the useful information from comparing different flight configurations.   

## Comparing lots of flight configurations
Put the CSV files from OpenRocket into the simData directory.
Then in bash, do 

    ./analysis.R simData/YOURSIM.csv
or simply

    ./analyze_everything.sh
(This will rerun the analysis for all the sim files in your simData/ directory.) Eventually, I will make a short script that will compare the reductions.

The appropriate plots will go in plots/ and the important info will go in reductions/ .
If you can't do it that way, open up R and do:

    setwd("YOURPATH/LV3-airframe")
    csvName <- "simData/YOURSIM.csv"
    source("analysis.R")

If you have issuses, ask Joe: <shields6@pdx.edu>.
