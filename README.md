# PSAS Launch Vehicle 3 (LV3) 🚀

This is the repo for the LV3 airframe. This holds everything you need to know about making a rocket out of carbon fiber. This includes CAD files, design and prototyping logs, simulation and testing data, most of all the manufacturing procedures for the carbon fiber airframe modules.  

If you aren't allowed to push, send Andrew your Github username and ask him to give you access. (This is different from getting added to the PSAS "organization".)

If you're looking to copy or build on this work check out the [doc directory](/doc/), especially the [layup procedure](/doc/mfg/moduleProcedure.md) and please message the people who have committed frequently/recently with any questions (or better yet, [make an issue with your question](https://github.com/psas/lv3.0-airframe/issues)).

![](https://github.com/psas/lv3.0-airframe/blob/master/cad/LV3.JPG)

## Todo:
[Check out the issues list if you're looking for something to do.](https://github.com/psas/lv3.0-airframe/issues) This to-do is usually out of date and is meant to give an idea of what needs to happen for the project to progress. If you see something that needs to be added, modified, or checked off, please do so. 

- Fin can
    - [ ] Practice the tip-to-tip on the existing fin can.
	- [X] Cut out the frames (Peter)
	   - [ ] Cut the leading/trailing edges on the frames
	- [ ] Cut out the fin jigs
		- [X] figure out how/where we can manufacture such a large plate (would probably work on @petermccloud's machine!)
	- [ ] Cut out the baseplate.
	- [ ] Try cutting the leading/trailing edges on the weeny fin using the mill in the LID.
	- [ ] Test the fin layup process.
		- [ ] Make a couple CF brackets.
		- [ ] 3D print two tiny ABS fillets.
		- [ ] Do bracket layup with high-temp epoxy.
		- [ ] Do T2T layup with high-temp epoxy.
		- [ ] Do high-temp cure.
	- [ ] MFG first fin can
		- [ ] re-test the fin brackets from the 2014 capstone for feasibility 
	    - [ ] layup test fins (one at a time, until it's good)
		- [ ] layup fins onto fin can
- Nose
	- [ ] Design templates for CF sections
	- [X] do a small-scale test of MFG a composite mold
		- [X] test porosity of a many-layered section
		- [X] test feasability of laying up on sharp corners
		- [X] try making a mold with a layer of gel coat
		- [ ] try another layup in the tiny mold with more release agent
	- [ ] Try a tiny layup with the room-temp materials.
	- [ ] Machine the tip.
	- [ ] Revise the design for the plug.
- MFG procedures
	- [X] Add pictures to the MFG procedures.
	- [X] Review procedures (not Joe)
	- [ ] document problems/decisions relating to the nose mold
- Radome
	- [X] Make a FG layup. 
	- [ ] Perform EM testing
	- [ ] Integration test with cradle
- Modules
    - [ ] sand modules
    	- [ ] Figure out what the best method for sanding is (hand, dremel, orbital, etc.).
    - Surface roughness
        - [ ] Read AIAA paper (not gonna post it. You can email @Joedang if you want it.)
        - [ ] [Read NASA paper](http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19660028009.pdf)
    - [ ] Make decision (convert black modules? ~~Abandon blue modules?~~)
- [X] AIAA paper
- Miscellaneous
	- [X] Move all deliverable-related things from the Google Drive into this repo. 
	- [ ] Schedule tensile test with Chinh

## Project Members

If you're working on the project in any way, please add yourself to this list.

IRL Name			|	Github username	|	Current Role
----------------|--------------------|-----------
Joe Shields		|	@Joedang			|	project coordination; MFG; design
Leslie Elwood	|	@lelwood			|	
Alex Farias		|	@alexkazam		|	MFG
Ian Zabel		|	@IanZabel		|	cradle design; modelling
Kyle Blakeman	|					|   
Peter McCloud	|	@petermccloud	|   CNC machining
Jorden Rolland	|					|	
Katia			|					|	
Marie "Marie House" House	|					|	
Adam Harris		|					|   MFG; manual machining
Josh Carlson		|	@paperman5		|   CNC machining; design
Jacob Tiller		|	@JacobTiller		|   Machining; design
Erin Schmidt		|	@7deeptide		|	System integration; design
Nathan Bergey	|	@natronics		|	

## What and where
```
|-- cad							holds the Solidworks files for all the machined parts
│   ├── CubeSatAirframeMount			"Cradle" that holds the flight computer (OreSat) inside LV3
|   |-- finCan
|	|	`- LongFinFiles			current fin design (flyable and manufacturable)
|   |-- module
|   |-- nose
|   |-- radome
|   `-- railSled
|       `-- CAM					G code for the rail sled (obsolete)
|           |-- Base
|           |-- Neck
|           `-- Trunk
|-- doc							all pure documentation
|   |-- aiaa-3.6.1				LaTeX template for AIAA
|   |-- extAbstract				extened abstract for the AIAA paper
|   |-- img						image resources for documentation
|   |-- mfg						step-by-step instructions for manufacturing
|   |-- paper					the conference paper we're submitting to AIAA Space
│   ├── FlightComputerMount			stuff about the Cradle
│   ├── textbook				summary of composite techniques in general
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
|-- test						data from physical tests on modules
|   `-- profilometer			surface roughness data
└── tools				sources/CAD/docs for physical tools used to make LV3
    ├── Composite_Table			the table we do all the layups on
    ├── crusher-control			controller software for one of the crush testers at PSU	
    ├── oven-controller			the temperature controller for the oven
    │   ├── Oven_Controller		the temperature controller for... wait
    │   │   ├── Box			enclosure for the oven controller
    │   │   ├── OvenControl		the temperature contr-- again?!
    │   │   └── oven-controller-master	"A Deja Vu is usually a glitch in the Matrix."
    │   └── src				source code for the controller
    ├── Sheet_Cutting_Templates		templates used to cut sheets of CF, adhesive, et cetera
    └── strain-gauge-amplifier		instrument used to take strain measurements in a crush/tensile test
```
    
## Relevant Repositories
* [~~psas/mme-capstone~~](https://github.com/psas/mme-capstone) (**DEPRECATED**) -- One of the repositories created durring the 2014 capstone. This contains code for some of the tools they used. 
* [~~psas/sw-cad-carbon-fiber-process~~](https://github.com/psas/sw-cad-carbon-fiber-process) (**DEPRECATED**) -- Yet another repo from the 2014 team. This contains CAD for some of the tools they made.
* [psas/LV3-design](https://github.com/psas/LV3-design) -- Early conceptual design of LV3
