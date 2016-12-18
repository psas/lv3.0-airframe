lv3.0-airframe/cad/
=====================

Solid Works CAD for the LV3 launch vehicle

Dependencies:  
psas/sw-cad-airframe-nsr	
psas/reaction-control	

See:   https://github.com/psas/sw-cad-common#psas-solidworks-setup-and-use-procedures for procedures on using github for Solidworks files

Heads up:  
SolidWorks still doesn't support building assemblies with relative file paths for some reason. If you are working on an assembly after someone else, you will have to show SW where the referenced parts are. 

TODO:  
* Incorporate eNSR guts into main assembly
* Incorporate flight computer cradle assembly into main assembly
* Incorporate recovery system assembly into main assembly
* Incorporate RCS guts into main assembly
* Figure out how to keep SW from always modifying the parts in an assembly!