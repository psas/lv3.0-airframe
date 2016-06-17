XYhist <- function(X, Y){
	#This makes a weighted histogram of the mach number (the weight is the energy loss due to drag).
	Nbins <- 10#number of bins
	bins <-   seq(from= min(X), to=max(X), length.out= Nbins+1)#the partitions of the bins
	binval <- seq(0,0, length.out= Nbins)#the height assigned to each bin
	
	for (i in 1:length(X)){ #for each measurement
		for (j in 1:length(binval)){ #go from low bins to high
			if (X[i]>=bins[j] & X[i]<=bins[j+1]){ #When you're in the current bin
				binval[j]= binval[j]+Y[i] #add the current density
				break #go to the next measurement
			}
		}
	}
	return(data.frame(height= c(binval,0), labels=bins))
}
portableLoadHelper <- function(x, repos){
	#Try to load package x. If you can't, install it and then load it.
	if (!require(x, character.only = T)){
		install.packages(x, repos= repos)
		library(x, character.only = T)
	}
}
portableLoad <- function(x, repos="http://cran.rstudio.com/")
	#load a whole vector of package names, as above. 
	invisible(sapply(x, function(x) portableLoadHelper(x, repos)))