# LV3-airframe
design of the LV3 airframe (2016 capstone)

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
