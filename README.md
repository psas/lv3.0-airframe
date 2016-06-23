# sw-cad-airframe-lv3.0
This is the repo for the 2016 LV3 capstone. This [will eventually hold] everything you need to know about making a rocket out of carbon fiber.

##To do 
- [ ] Move all deliverable-related things from the Google Drive into this repo. 
 	- [ ] Find out which SW models are the final versions.
	- [X] Clean up existing CAD files.
- [ ] Bring the procedures for all the manufacturing up to date. 
	- [X] Write all the necessary steps
	- [ ] Add pictures to the MFG procedures.
- [ ] Prepare machinable foam for CNC milling at ESCO
	- [X] Cut block into thirds 
	- [X] Re-apply resin with **vacuum bagging** & **room temp for 24 hr**
	- [X] Run through whole cure cycle with **vacuum bagging**
	- [ ] Deliver foam blocks to Esco.
- [ ] Make a radome
	- [X] Make a FG layup. 
	- [ ] Perform EM testing
	- [ ] Crush the FG layup
- [ ] Figure out how much surface roughness matters.
- [ ] AIAA paper
	- [ ] Write first draft of AIAA paper.
- [ ] Finish the fin cans.
	- [ ] Do the tip-to-tip on the existing fin can.
	- [ ] Layup 3 more fins.
	- [ ] Attach new fins to the remaining 24" module.
	- [ ] Do tip-to-tip on the new fin can.
- [ ] Write up suggestions for future ME PSAS groups to consider during thier project. 

## Relavant Deadlines
* AIAA paper: August. 18 8pm EST (hard deadline; submit before this)
* Rocket launch: August 19 ([with OROC](http://www.oregonrocketry.com/?page_id=54))

## Capstone Members
LV3 team members, please add your name to this list, so we know who is able to push to this repository:

* Joe Shields
* Leslie Elwood:dog:
* 
* 
* \*crickets chirping\*

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
