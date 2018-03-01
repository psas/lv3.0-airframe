# PSAS Launch Vehicle 3 (LV3) 🚀

This is the repo for the LV3 airframe. This holds everything you need to know about making a rocket out of carbon fiber. This includes CAD files, design and prototyping logs, simulation and testing data, most of all the manufacturing procedures for the carbon fiber airframe modules.  

If you aren't allowed to push, send Joe or Andrew your Github username and ask for access. (This is different from getting added to the PSAS "organization".)

If you're looking to copy or build on this work check out the [doc directory](/doc/), especially the [layup procedure](/doc/mfg/moduleProcedure.md) and please message the people who have committed frequently/recently with any questions (or better yet, [make an issue with your question](https://github.com/psas/lv3.0-airframe/issues)).

If you want some quick physical specifications on the airframe, checkout the [quick facts.](doc/quickFacts.md)
For more detailed info, we have a [model](sim/ORK/LV3_L13.ork) for [OpenRocket](http://openrocket.info/) and a [model](cad/LV3.SLDASM) for [SolidWorks](http://www.solidworks.com/).

![](https://github.com/psas/lv3.0-airframe/blob/master/cad/LV3.png)

## Relevant Repositories
If you want to work on the CAD model, you'll need to have the dependencies cloned to the same directory as this repo. So, something like 

```
PSAS
├── lv3.0-airframe
├── lv3.0-recovery
├── lv3.0-camera-ring
├── lv3.0-umbilical-ring
├── sw-cad-airframe-nsr
└── reaction-control
```

You should also read the [Intro to Git workshop slides](https://drive.google.com/open?id=1pykfwvAw5q1oXGM8aLyhXPHOKDCI61YhK5w33QwzuFw) if you're new to Git
Also, read the [OreSat contributions guide](https://github.com/oresat/oresat-structure/blob/master/.github/CONTRIBUTING.md) if you're new to using SolidWorks with Git.

### Dependencies
* [psas/lv3.0-recovery](https://github.com/psas/lv3.0-recovery) -- CAD and analysis for the eNSR-based recovery system
* [psas/lv3.0-camera-ring](https://github.com/psas/lv3.0-camera-ring) -- 360 degree camera module based on the RunCam Split 2
* [psas/lv3.0-umbilical-ring](https://github.com/psas/lv3.0-umbilical-ring) -- passthrough module for the umbilical and arming switches (uses same format as camera ring)
* [psas/sw-cad-airframe-nsr](https://github.com/psas/sw-cad-airframe-nsr) -- Mechanical separation system for the nosecone/parachute
* [psas/reaction-control](https://github.com/psas/reaction-control) -- Cold gas reaction control system

### Historical
* [psas/LV3-design](https://github.com/psas/LV3-design) -- Early conceptual design of LV3
* [~~psas/mme-capstone~~](https://github.com/psas/mme-capstone) (**DEPRECATED**) -- One of the repositories created durring the 2014 capstone. This contains code for some of the tools they used. 
* [~~psas/sw-cad-carbon-fiber-process~~](https://github.com/psas/sw-cad-carbon-fiber-process) (**DEPRECATED**) -- Yet another repo from the 2014 team. This contains CAD for some of the tools they made.

## TODO:
[Check out the issues list if you're looking for something to do.](https://github.com/psas/lv3.0-airframe/issues) 
Keeping a TODO in the README never works out.

## Project Members
If you're working on the project in any way, please add yourself to this list.

IRL Name                       | Github username        | Current Role
------------------------------ | ---------------------- | ------------
Joe "Rocket Czar" Shields      | @Joedang               | project coordination; MFG; design
Leslie Elwood                  | @lelwood               | MFG; design; logistics
Alex "the Pretty Good" Farias  | @alexkazam             | MFG
Ian Zabel                      | @IanZabel              | cradle design; modelling
Kyle Blakeman                  | @kablakeman            | module sanding
Peter McCloud                  | @petermccloud          | CNC machining
Jorden Rolland                 | @JSRoland              | 
Katia                          | @kp07                  | 
Marie "Marie House" House      | @hmarie2               | anti-lithobreaking precautions
Adam Harris                    | @SaturnVF1             | MFG; manual machining
Josh Carlson                   | @paperman5             | CNC machining; design
Jacob Tiller                   | @JacobTiller           | machining; design
Erin Schmidt                   | @7deeptide             | system integration; design
Nathan Bergey                  | @natronics             | patron saint
Andrew Greenberg               | @andrewgreenberg       | benevolent dictator; pixie wrangler

## What and where
```
|-- cad						holds the Solidworks files for all the machined parts
│   ├── COTS					models for Commercial Off-The-Shelf parts
│   ├── CubeSatAirframeMount			"Cradle" that holds the flight computer (OreSat) inside LV3
|   |-- finCan
|	|-- LongFinFiles			current fin design (flyable and manufacturable)
|   |-- module					files for 18 and 24 inch modules
│   │   ├── jigs				jig for drilling side holes in module rings (and other radial parts)
│   │   └── layup
|   |-- nose					nosecone and mold subassemblies
|   |-- radome					radio-transparent fiberglass module
|   `-- railSled				part for interfacing with the launch rail
│       ├── CAM					G code for the rail sled (obsolete)
│       │   ├── Base
│       │   ├── Neck
│       │   └── Trunk
│       └── Old rail sled designs
|-- doc						all pure documentation
|   |-- aiaa-3.6.1				LaTeX template for AIAA
|   |-- extAbstract				extened abstract for the AIAA paper
|   |-- img					image resources for documentation
|   |-- mfg					step-by-step instructions for manufacturing
|   |-- paper					the conference paper we're submitting to AIAA Space
│   ├── FlightComputerMount			stuff about the Cradle
│   ├── textbook				summary of composite techniques in general
|   `-- updates					bi-monthlyish status updates on the project
|-- sim						simulations and calculations
|   |-- DATCOM					DATCOM cases for cross-validating the design (abandoned)
|   |   |-- case
|   |   |   |-- LV3				case for the LV3 airframe (not complete)
|   |   |   `-- exMiG
|   |   |-- doc					DATCOM documentation
|   |   `-- exlinux				example DATCOM cases
|   |-- ORK					open rocket models
|   |   `-- prev
|   |-- OpenFOAM				CFD models
|   |   `-- LV3\_LD-Haack			model of the 1:5 nose cone
|   |       `-- rcf_100				100-node-long mesh
|   |           |-- 0				initial conditions
|   |           |-- constant			fluid properites
|   |           `-- system			simulation parameters
|   |-- plots					plots of the open rocket data
|   |-- reductions				reductions of the openrocket simulations
|   `-- simData					output of the openrocket simulations
|-- test					data from physical tests on modules
|   `-- profilometer				surface roughness data
│   └── tinyMold				
└── tools					sources/CAD/docs for physical tools used to make LV3
    ├── Composite_Table				the table we do all the layups on
    ├── crusher-control				controller software for one of the crush testers at PSU	
    ├── oven-controller				the temperature controller for the oven
    │   ├── Oven_Controller			the temperature controller for... wait
    │   │   ├── Box				enclosure for the oven controller
    │   │   ├── OvenControl			the temperature contr-- again?!
    │   │   └── oven-controller-master		"A Deja Vu is usually a glitch in the Matrix."
    │   └── src					source code for the controller
    ├── Sheet_Cutting_Templates			templates used to cut sheets of CF, adhesive, et cetera
    └── strain-gauge-amplifier			instrument used to take strain measurements in a crush/tensile test
```
