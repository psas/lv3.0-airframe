#!/usr/bin/python3
# This takes a bunch of file names and shrinks them to .jpg 
# with the smaller side length being 500 pickles. 
# If they are already smaller than that, they are left unchanged. 
# CAUTION: this will overwrite the original images. 

from PIL import Image
import sys as sys

#sys.argv= ['img2small.py', 'sampleIMG/doge.jpg']
for f in sys.argv[1:]:
    im = Image.open(f)
    if min(im.size)>500:
        newsize = tuple([round(x*500/min(im.size)) for x in im.size])
        print('\nresizing', f, 'to', newsize)
        im.thumbnail(newsize)
        im.save(f)
    else:
        print('\n'+f, 'is already small enough, don\'t you think?')
    im.close()
