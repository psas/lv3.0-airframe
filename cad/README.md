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
All of these `PDF`s should correspond to a `SLDDRW` in the same directory.  
_To rebuild this list, run the `listpdf.sh` script in this directory._

[./couplingExample.pdf](./couplingExample.pdf)  
[./railSled/sledJig.pdf](./railSled/sledJig.pdf)  
[./nose/jenkyNoseTip.pdf](./nose/jenkyNoseTip.pdf)  
[./nose/noseplug.pdf](./nose/noseplug.pdf)  
[./nose/dummyNoseTip.pdf](./nose/dummyNoseTip.pdf)  
[./nose/nosePlug2.pdf](./nose/nosePlug2.pdf)  
[./nose/von_karmon_nose_tip2.pdf](./nose/von_karmon_nose_tip2.pdf)  
[./module/maleRing.pdf](./module/maleRing.pdf)  
[./module/layup/mandrel24.pdf](./module/layup/mandrel24.pdf)  
[./module/layup/dummies.pdf](./module/layup/dummies.pdf)  
[./module/femaleRing.pdf](./module/femaleRing.pdf)  
[./finCan/fin_jig_top_bottom2_TechDrawing.pdf](./finCan/fin_jig_top_bottom2_TechDrawing.pdf)  
[./finCan/fin_jig_mid_TechDrawing.pdf](./finCan/fin_jig_mid_TechDrawing.pdf)  
[./finCan/LongFinFiles/LongFins_ALedge.PDF](./finCan/LongFinFiles/LongFins_ALedge.PDF)  
[./finCan/motorMount.pdf](./finCan/motorMount.pdf)  
[./finCan/finLayup_jig_baseplate.pdf](./finCan/finLayup_jig_baseplate.pdf)  
[./finCan/spider.pdf](./finCan/spider.pdf)  
