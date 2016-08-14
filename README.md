[//]: # " vim: set nonumber tabstop=4: "

# PSAS Launch Vehicle 3 "LV3" CAD Files

This is the repo for the LV3 airframe. This holds everything you need to know about making a rocket out of carbon fiber.

## Todo:
[This to-do list is probably more informative.](https://drive.google.com/open?id=1f-Etqf3f5pUfQ_Xc_3bBB01bxaG66x3LiqV5aW0Z5N8)

- Fin can
		- [ ] Practice the tip-to-tip on the existing fin can.
		- [ ] Finalize new fin frames.
		- [ ] Find out if we can water-jet the frames, and if it can be done sooner than the laser cutter is repaired.
- Nose
		- [ ] Make templates for CF sections
				- [ ] Someone needs to figure out how to unfold the molding surface to make the template. (use math or Solidworks)
		- Machining
				- [ ] Get threaded rods to Alex
				- [ ] Get ball endmill to Alex
				- [ ] Set up go-pro(s) to document machining
		- [X] Attempt a layup
				- [ ] redo the tip CAD for the redesigned mold (Alex F.)
				- [ ] machine the new tip
- MFG procedures
	- [ ] Add pictures to the MFG procedures.
	- [ ] Review procedures (not Joe)
- Radome
	- [X] Make a FG layup. 
	- [ ] Perform EM testing
	- [X] Crush the FG layup
	    - [ ] Order strain gauges (not strictly necessary)
- Surface roughness
    - [ ] Read AIAA paper (not gonna post it. You can email Joe if you want it.)
    - [ ] [Read NASA paper](http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19660028009.pdf)
    - [ ] Make decision
	- Convert black modules? Abandon blue modules?
- [ ] AIAA paper
	- [ ] Write first draft of AIAA paper. (in progress)
		- Figures
				- [X] add diagram/picture of the sandwich design
				- [ ] add pictures of crushed FG module
				- [ ] add pictures of the puncture failure
				- [ ] add plot of the surface features
				- [ ] add picture of layers, put alongside diagram
				- [ ] add picture/CAD render of the cylindrical modules and/or whole rocket
		- Sections
				- [X] write more detailed description of the modules
				- [X] write section on the materials
				- [ ] write section on destructive testing
				- [ ] write section on the fins
				- [ ] write section on the nose cone
- Miscellaneous
		- [X] Write up suggestions for future ME PSAS groups to consider during thier project. 
		- [ ] Move all deliverable-related things from the Google Drive into this repo. 
		- [X] Order more heat-shrink tape (non-perforated) (Dunstone hi-shrink tape)
		- [ ] Schedule tensile test with Chinh

## Relavant Deadlines

* AIAA paper: August. 18 8pm EST (hard deadline; submit before this)
* Rocket launch: October ~15

## Team Members
LV3 team members, please add your name to this list, so we know who is able to push to this repository:

Person		|	Role
----------------|-----------
Joe Shields		|	project coordination; MFG; paper
Leslie Elwood	|	nose; materials; paper
Alex Farias		|	MFG; design
Ian Zabel		|	design; modelling
Calvin Young	|	Oven controller
David Edwards	|	MFG
Alex Kollen		|	???
Jorden Rolland	|	???
Katia 			|	machining
Marie House		|	

If you aren't allowed to push, send Andrew your Github username and ask him to give you access. (This is different from getting added to the PSAS "organization".)

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
