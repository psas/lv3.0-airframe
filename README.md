[//]: # " vim: set nonumber tabstop=4: "

# PSAS Launch Vehicle 3 "LV3" CAD Files

This is the repo for the LV3 airframe. This holds everything you need to know about making a rocket out of carbon fiber.  
If you aren't allowed to push, send Andrew your Github username and ask him to give you access. (This is different from getting added to the PSAS "organization".)

## Todo:
[Check out the issues list if you're looking for something to do.](https://github.com/psas/lv3.0-airframe/issues) This to-do is usually out of date. 

- Fin can
    - [ ] Practice the tip-to-tip on the existing fin can.
	- [ ] Cut out the frames (Peter)
	- [ ] MFG first fin can
	    - [ ] layup test fins (one at a time, until it's good)
		- [ ] layup fins onto fin can
- Nose
	- [ ] Design templates for CF sections
	- [ ] do a small-scale test of MFG a composite mold
		- [ ] test porosity of a many-layered section
		- [ ] test feasability of laying up on sharp corners
- MFG procedures
	- [ ] Add pictures to the MFG procedures.
	- [ ] Review procedures (not Joe)
	- [ ] document problems/decisions relating to the nose mold
- Radome
	- [X] Make a FG layup. 
	- [ ] Perform EM testing
	- [ ] Integration test with cradle
- Modules
    - [ ] sand modules
    - Surface roughness
        - [ ] Read AIAA paper (not gonna post it. You can email Joe if you want it.)
        - [ ] [Read NASA paper](http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19660028009.pdf)
    - [ ] Make decision (convert black modules? Abandon blue modules?)
- [X] AIAA paper
- Miscellaneous
	- [ ] Move all deliverable-related things from the Google Drive into this repo. 
	- [ ] Schedule tensile test with Chinh

Person		|	Role
----------------|-----------
Joe Shields		|	project coordination; MFG
Leslie Elwood	|	nose; materials
Alex Farias		|	MFG; design
Ian Zabel		|	cradle design; modelling
Kyle Blakeman   |   module sanding 
Peter McCloud   |   fin frames
Jorden Rolland	|	???
Katia 			|	machining
Marie House		|	

## What and where

	|-- cad							holds the Solidworks files for all the machined parts
	|   |-- finCan
	|   |-- module
	|   |-- nose
	|   |-- radome
	|   `-- railSled
	|       `-- CAM					G code for the rail sled
	|           |-- Base
	|           |-- Neck
	|           `-- Trunk
	|-- doc							all pure documentation
	|   |-- aiaa-3.6.1				LaTeX template for AIAA
	|   |-- extAbstract				extened abstract for the AIAA paper
	|   |-- img						image resources for documentation
	|   |-- mfg						step-by-step instructions for manufacturing
	|   |-- paper					the conference paper we're submitting to AIAA Space
	|   `-- updates					bi-monthlyish status updates on the project
	|-- sim							simulations and calculations
	|   |-- DATCOM
	|   |   |-- case
	|   |   |   |-- LV3				case for the LV3 airframe (not complete)
	|   |   |   `-- exMiG
	|   |   |-- doc					DATCOM documentation
	|   |   `-- exlinux				example DATCOM cases
	|   |-- ORK						open rocket models
	|   |   `-- prev
	|   |-- OpenFOAM				CFD models
	|   |   `-- LV3\_LD-Haack		model of the 1:5 nose cone
	|   |       `-- rcf_100			100-node-long mesh
	|   |           |-- 0			initial conditions
	|   |           |-- constant	fluid properites
	|   |           `-- system		simulation parameters
	|   |-- plots					plots of the open rocket data
	|   |-- reductions				reductions of the openrocket simulations
	|   `-- simData					output of the openrocket simulations
	`-- test						data from physical tests on modules
	    `-- profilometer			surface roughness data
