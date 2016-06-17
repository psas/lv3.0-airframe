# Get DATCOM
To get the DATCOM source and example files, [go here](http://www.pdas.com/packages/datcom.zip). 
There are three volumes of documentation ([1](https://docs.google.com/file/d/0B2UKsBO-ZMVgRk91aXJyYnd0OXc/edit?usp=sharing), [2](https://docs.google.com/file/d/0B2UKsBO-ZMVgb2hTanF2SzZNclE/edit?usp=sharing), [3](https://docs.google.com/file/d/0B2UKsBO-ZMVgMmZEbDVYMmVlSzQ/edit?usp=sharing))
The first one is the most useful. [This tutorial](http://wpage.unina.it/agodemar/DSV-DQV/DATCOM_Tutorial_I.pdf) is also a really great way to get introduced to the input formats.

To install DATCOM, extract that ZIP file and run 

    gfortran  datcom.f -o datcom

in the directory where you extracted it. You will get a crapton of warnings, but it should compile successfully. Make sure the 

    datcom

file is executable. Optional: move it to /usr/local/bin/ or put a link there to it.

# Test DATCOM
To test that it's working, copy one of the example files into a clean directory and run it.

    mkdir testCase
    cp exlinux/ex1.inp testCase/
    cd testCase/
    datcom

DATCOM will ask you for the name of the input file you want. Enter

    ex1.inp

DATCOM will run the case and create a few output files. The one you usually care about is 

    datcom.out

Compare this output to the example output. 

    diff datcom.out ../exlinux/ex1.out 

They should only differ by some minus signs on zero-valued outputs and perhaps some array sizing errors.

# Write Inputs
DATCOM really cares about what characters come first on a line ("card"). Pieces of the aircraft and their parameters are preceeded by a space, no newlines or tabs! controls like CASEID, DIM, and airfoil designators don't get a space. DATCOM also doesn't like comments on certain lines. See the exMiG.inp file for an example of where you are allowed to put comments.
