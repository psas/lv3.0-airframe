# PSAS Launch Vehicle 3 "LV3" CAD Files

This is the repo for the 2016 LV3 capstone. This [will eventually hold] everything you need to know about making a rocket out of carbon fiber.

## Todo:

- Fin can
	- [ ] Do the tip-to-tip on the existing fin can.
	- [ ] Finalize new fin frames
	- [ ] Ask MSI to make new fin frames
	- Alternate fin MFG?
- Nose
	- [ ] Seal the new mold
		- remember to pour some epoxy in the delaminated section and clamp it
		- remember to let it rest upright to avoid pooling of the epoxy on the molding surface
	- [ ] Make templates for CF sections
	- [ ] Attempt a layup
	    - [ ] redo the tip CAD for the redesigned mold
	    - [ ] machine the new tip
- MFG procedures
	- [ ] Add pictures to the MFG procedures.
	- [ ] Review procedures (not Joe)
- Radome
	- [X] Make a FG layup. 
	- [ ] Perform EM testing
	- [ ] Crush the FG layup
	    - [ ] Order strain gauges
- Surface roughness
    - [ ] Read AIAA paper
    - [ ] [Read NASA paper](http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19660028009.pdf)
    - [ ] Make decision
	- Convert black modules? Abandon blue modules?
- [ ] AIAA paper
	- [ ] Write first draft of AIAA paper.
- Miscellaneous
- [X] Write up suggestions for future ME PSAS groups to consider during thier project. 
- [ ] Move all deliverable-related things from the Google Drive into this repo. 
    - [ ] Order more heat-shrink tape (non-perforated) (Dunstone hi-shrink tape)

## Relavant Deadlines

* AIAA paper: August. 18 8pm EST (hard deadline; submit before this)
* Rocket launch: August 19 ([with OROC](http://www.oregonrocketry.com/?page_id=54))

## Team Members
LV3 team members, please add your name to this list, so we know who is able to push to this repository:

Person		|	Role
----------------|-----------
Joe Shields	|	everything?
Leslie Elwood	|	everything?
Alex Farias	|	manufacturing
Ian Zabel	|	Fins
Calvin Young	|	Oven
David Edwards	|	
Alex Kollen	|	
Jorden Rolland	|	
Katia 		|	
Marie House	|	thermal sensing

If you aren't allowed to push, send Andrew your Github username and ask him to give you access. (This is different from getting added to the PSAS "organization".)

## What and where

	|-- cad				holds the Solidworks files for all the machined parts
	|   |-- finCan
	|   |-- module
	|   |-- nose
	|   |-- radome
	|   `-- railSled
	|       `-- CAM			G code for the rail sled
	|           |-- Base
	|           |-- Neck
	|           `-- Trunk
	|-- doc				all pure documentation
	|   |-- aiaa-3.6.1		LaTeX template for AIAA
	|   |-- extAbstract		extened abstract for the AIAA paper
	|   |-- img			image resources for documentation
	|   |-- mfg			step-by-step instructions for manufacturing
	|   |-- paper			the conference paper we're submitting to AIAA Space
	|   `-- updates			bi-monthlyish status updates on the project
	|-- sim				simulations and calculations
	|   |-- DATCOM
	|   |   |-- case
	|   |   |   |-- LV3		case for the LV3 airframe (not complete)
	|   |   |   `-- exMiG
	|   |   |-- doc			DATCOM documentation
	|   |   `-- exlinux		example DATCOM cases
	|   |-- ORK			open rocket models
	|   |   `-- prev
	|   |-- OpenFOAM		CFD models
	|   |   `-- LV3\_LD-Haack	model of the 1:5 nose cone
	|   |       `-- rcf_100		100-node-long mesh
	|   |           |-- 0		initial conditions
	|   |           |-- constant	fluid properites
	|   |           `-- system	simulation parameters
	|   |-- plots			plots of the open rocket data
	|   |-- reductions		reductions of the openrocket simulations
	|   `-- simData			output of the openrocket simulations
	`-- test			data from physical tests on modules
	    `-- profilometer		surface roughness data
