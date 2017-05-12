lv3.0-airframe/cad/
=====================

# Solid Works CAD for the LV3 launch vehicle

## Dependencies:  
psas/sw-cad-airframe-nsr	
psas/reaction-control	

See:   https://github.com/psas/sw-cad-common#psas-solidworks-setup-and-use-procedures for procedures on using github for Solidworks files

### Heads up:  
SolidWorks still doesn't support building assemblies with relative file paths for some reason. If you are working on an assembly after someone else, you will have to show SW where the referenced parts are. 

## TODO: 
* Create tip-to-tip shells
	* Add TTT shells to the assembly
* Incorporate eNSR guts into main assembly
* Incorporate flight computer cradle assembly into main assembly
* Incorporate recovery system assembly into main assembly
* Incorporate RCS guts into main assembly
* Figure out how to keep SW from always modifying the parts in an assembly! (makes it hard to tell what's really changed)

## Technical Drawings
To rebuild this list, take the output of `find -iname '*.pdf'` and format it to `[LINE](LINE)  ` where `LINE` is a line of the output. (It may need two spaces on the end to display the links on separate lines.)

[./railSled/sledJig.pdf](./railSled/sledJig.pdf)  
[./finCan/motorMount.pdf](./finCan/motorMount.pdf)  
[./finCan/fin_jig_mid_TechDrawing.pdf](./finCan/fin_jig_mid_TechDrawing.pdf)  
[./finCan/fin_jig_top_bottom2_TechDrawing.pdf](./finCan/fin_jig_top_bottom2_TechDrawing.pdf)  
[./finCan/spider.pdf](./finCan/spider.pdf)  
[./finCan/finLayup_jig_baseplate.pdf](./finCan/finLayup_jig_baseplate.pdf)  
[./couplingExample.pdf](./couplingExample.pdf)  
[./nose/noseplug.pdf](./nose/noseplug.pdf)  
[./nose/von_karmon_nose_tip2.pdf](./nose/von_karmon_nose_tip2.pdf)  
[./module/maleRing.pdf](./module/maleRing.pdf)  
[./module/femaleRing.pdf](./module/femaleRing.pdf)  
[./CubeSatAirframeMount/CradleInterface_TechDrawing.pdf](./CubeSatAirframeMount/CradleInterface_TechDrawing.pdf)  
[./finCan/LongFinFiles/LongFins_ALedge.PDF](./finCan/LongFinFiles/LongFins_ALedge.PDF)
