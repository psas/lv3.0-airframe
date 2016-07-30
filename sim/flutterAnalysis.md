

The following is a shot at estimating the factor of safety against flutter for the LV3 fins, using different materials and fin thicknesses. The data for air pressure, speed of sound, and airspeed come from OpenRocket (OR) simulations of the corresponding fin thicknesses. We could use a better model (see assumptions section), so I wrote this to be pretty much agnostic of the formula used to calculate the critical flutter velocity defined at the top of the script.

[Here is the source](http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19930085030.pdf) for this equation. (page 14, equation 18)

$$
V\_{f}=a \\sqrt{\\frac{G\_{E}}{K\_{1}\*K\_{2}\*K\_{3}}}\\\\
K\_{1}=\\frac{39.3(AR^3)}{(\\frac{t}{c})^3 (AR+2)}\\\\
K\_{2}=\\frac{\\lambda+1}{2}\\\\
K\_{3}=\\frac{p}{p\_{o}}\\\\
$$

| Symbol            | Meaning                               | Variable      |
|-------------------|---------------------------------------|---------------|
| *V*<sub>*f*</sub> | Flutter Velocity (m/s)                | vel.flutter() |
| *a*               | Speed of Sound (m/s)                  | vel.sonic     |
| *G*<sub>*E*</sub> | Effective Shear Modulus (Pa)          | mod.shear     |
| *A**R*            | Aspect Ratio                          | asp           |
| *t*               | Fin Thickness (m)                     | thick         |
| *c*               | Fin Chord (m)                         | chord         |
| *λ*               | Taper Ratio (Tip Chord to Root Chord) | taper         |
| *p*               | Air Pressure (Pa)                     | press         |
| *p*<sub>*o*</sub> | Air Pressure, Sea Level (Pa)          | press0        |

Assumptions of this model
-------------------------

-   high aspect ratio fins (2:3) **\[violated\]**
-   low ratio of bending frequency to torsional frequency (can get from SW) **\[???\]**
-   heavy fins **\[???\]**
-   constant airfoil geometry along the fin (the airfoil is a *very* thin rupee at the root and a thin rupee at the tip) **\[violated\]**
-   the center of mass is around the center of the fin (can get from SW) **\[probably violated\]**
-   the fluid is air **\[OK\]**
-   solid airfoil **\[violated\]**
-   thin airfoil (slenderness is 1:20 at the tip) **\[OK\]**
-   no struts in the frame (conservative) **\[OK\]**
-   stationwise frame profiles are square (conservative) **\[OK\]**
-   stationwise cross sections of the frame beams are small compared to the chord length (1:20 at the tip) **\[OK\]**

Since there are a few violated assumptions for equation 18, we should probably switch to one of the earlier equations in the paper, before these assumptions are brought in.

I recommend we switch either to equation 1, since we can estimate *ω*<sub>*α*</sub> and *x*<sub>*α*</sub> using Solidworks, or try to find a relation that is valid for low aspect ratio fins (*c*<sub>0.5</sub>/*L* = 1.8).

Code-y stuff
------------

#### define the function for critical flutter velocity

Fortunately, if we decide we want to use some other estimate of the critical flutter velocity, we can just change this function, and not muck around with the rest of the script.

``` r
vel.flutter <- function(vel.sonic, mod.shear, asp, thick, chord, taper, press, press0)
{
    K1 <- 39.3*asp^3/((thick/chord)^3*(asp+2))
    K2 <- (taper+1)/2
    K3 <- press/press0
    return(vel.sonic*sqrt(mod.shear/(K1*K2*K3)))
}
```

#### define the parameters

The information on the planform is just copied from OR. The sealevel pressure is from basically any reference. The thicknesses are plausible thicknesses we could buy. The modulus of rigidity for aluminum comes from [here](http://www.engineeringtoolbox.com/modulus-rigidity-d_946.html). The modulus for fiberglass is based off of [a PCB listed on MatWeb](http://www.matweb.com/search/DataSheet.aspx?MatGUID=952559b637a940658f6ab71767504fdc) and is low for many of the glass-based composites listed.

``` r
chord.root <- 18*25.4/1e3 # m, converted from inches
chord.tip <- 5*25.4/1e3 # m, converted from inches
semispan <- 6.4*25.4/1e3 # m, converted from inches
# mod.shear <- 24e9 # Pa, shear modulus for aluminum
press0 <- 101e3 # Pa, atmospheric pressure at sealevel
CSVs <- c("simData/L-13a_ideal_0.25fins.csv", "simData/L-13a_ideal_0.125fins.csv", "simData/L-13a_ideal_0.09375fins.csv", "simData/L-13a_ideal_0.0625fins.csv") # names of the OR outputs
thicknesses.inch <- c(1/4, 1/8, 3/32, 1/16) # inches (gets converted to meters later)
materials <- c("aluminum", "fiberglass") # material names
mod.shears <- c(24e9, 2e9) # Pa, moduli of rigidity for the materials
```

#### secondary parameters

``` r
chord.mean <- (chord.root+chord.tip)/2 # m, mean chord length
asp <- semispan/chord.mean # m, planform aspect ratio
taper <- chord.tip/chord.root # dimensionless taper ratio
```

#### create a function to read the OR output and add in the flutter information

To simplify the problem, I assumed there were no struts in the frame. I also assumed that the stationwise profile of the frame was two squares (one for the leading edge, and another for the trailing edge) with the given thickness. These are both conservative approximations, since the actual fin will have beefier geometry and therefore be more rigid.

I also approximate the polar moment of inertia as being determined by the two "point areas" of the squares (you'll hopefully see what I mean in the calculation), rather than integrating out those two dinky little squares. Essentially, I'm assuming that the squares are small compared to the chord, which they are. (1:20 at the tip)

``` r
analyze.flutter <- function(csv, thick, mod.shear)
{
    #read in the data
    dat <- read.csv(csv, comment.char = "#")
    
    #fix the variable names
    lines <- readLines("simData/L-13a_ideal_0.25fins.csv")
    varNames <- unlist(strsplit(lines[7], ","))
    varNames <- gsub(pattern = "# ", replacement = "", x = varNames)
    varNames <- gsub(pattern = " ", replacement = "_", x = varNames)
    varNames <- gsub(pattern = "\\(", replacement = "", x = varNames)
    varNames <- gsub(pattern = "\\)", replacement = "", x = varNames)
    names(dat) <- varNames
    
    # find the secondary parameters
    polar.moment <- chord.mean^2*thick^2/2 # approximation, assuming a frame with no struts and a square cross section, using "point areas"
    polar.moment.rect <- chord.mean*thick*(chord.mean^2+thick^2)/12
    mod.shear.eff <- polar.moment*mod.shear/polar.moment.rect
    
    # find the critical flutter velocity at every point in time
    for (i in 1:length(dat$Time))
    { 
        # assign the flutter velocity to a new variable in the data frame
        dat$vel.flutter[i] <- vel.flutter(
                vel.sonic = dat$`Speed_of_sound_m/s`[i],
                mod.shear = mod.shear.eff,
                asp = asp,
                thick = thick, 
                chord = chord.mean, 
                taper = taper, 
                press = dat$Air_pressure_Pa[i], 
                press0 = press0
            )
        #assign the factor of safety to a new variable in the data frame
        dat$FS.flutter[i] <- dat$vel.flutter[i]/dat$Vertical_velocity[i]
        # get rid of things that aren't actual numbers
        if (is.infinite(dat$FS[i])) 
            dat$FS.flutter[i] <- NA
    }
    return(dat)
}
```

I also wrote a function to plot the data and find the factor of safety, but that's just a bunch of book-keeping. You can check the `.Rmd` source if you want to see it.

The current design (aluminum, 1/4" thick)
-----------------------------------------

So, let's check out the flutter factor of safety for the current fins (with no struts and a simplified frame). ![](flutterAnalysis_files/figure-markdown_github/unnamed-chunk-6-1.png)

    ## [1] 83.51251

Okay, it's clear that this design is *way* overbuilt for flutter. The FS is on the same scale as the velocity... This means we can start to play around with thinner fins and lighter materials.

Different thicknesses of aluminum and fiberglass
------------------------------------------------

The following factors of safety are for 1/4", 1/8", 3/32", and 1/16" frames of aluminum and fiberglass.

    ## 
    ## ----- aluminum -----
    ## factor of safety for 0.25 inch thick aluminum = 83.51251factor of safety for 0.125 inch thick aluminum = 20.88183factor of safety for 0.09375 inch thick aluminum = 11.45416factor of safety for 0.0625 inch thick aluminum = 5.09083
    ## ----- fiberglass -----
    ## factor of safety for 0.25 inch thick fiberglass = 24.10799factor of safety for 0.125 inch thick fiberglass = 6.028064factor of safety for 0.09375 inch thick fiberglass = 3.30653factor of safety for 0.0625 inch thick fiberglass = 1.469596

Thoughts/conclusions
--------------------

If we're to believe the above analysis, we're pretty much free to make the fins as thin as we want, especially since the carbon and struts will make the fin more rigid.

However, The FS for the 1/16" FG frame makes me question the results. Remember that a 1/16" fiberglass plate is a PCB. This is essentially the consideration of a fin frame made of 1/16" diameter fiberglass rods. Of course, I'm intuitively imagining the frame "crumpling" under a torsional load, which a plate -- which the model is based on -- would not do. There's also a video (can't seem to re-find it) of a guy's rocket surviving flutter, where he later shows that he can bend the fins by hand. That result would indicate to me that if you can bend the fins, there's a good chance they'll flutter.

I also still don't understand how the density of the fins falls out of the the analysis in the NASA paper. It seems like you could always stave off flutter by making heavier fins, thereby raising their natural frequency (maybe that's the reason for the "heavy fin" assumption). I'm sure it would help if I read through the paper more carefully.
