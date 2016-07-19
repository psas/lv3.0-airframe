# Narrative of the LV3 airframe 2016 capstone

## Introduction

The following is essentially a description of the LV3 airframe project sorted by subject.
It also includes thoughts about what worked well, what didn't, how it could have been better, and how we would do it differently.
For a chronological description, see the [project updates](/updates/).

The LV3 team set out to build an airframe according to the following requirements, in fulfillment of a mechanical engineering capstone.

1. Design and manufacture airframe to work up to Mach 3. (We later determined that it would realistically only ever see Mach 2.)
	1. Reproduce the results from the 2014 capstone in making cylindrical modules.
	1. Design and manufacture a nose cone with a metal tip.
	1. Design and manufacture a fin can with metal leading edges.
1. Destructively test at least one copy of every part.
1. Create one full airframe and one backup airframe.
1. Create clear how-to documentation for future builds.

If you don't read anything else in this document:

* __Put all desicions and tasks in writing.__ Email is OK. Weekly logs are better. Both is preferred. When in doubt, CC some more people.
* __Confirm everything with someone__, even if you know what you're doing, *especially* if you don't. 
* __Read/learn what people tell you to.__ If a rocket without a turboencabulator explodes, *you'd better know what one is!*
* __Do the calculation.__ Your intuition is wrong. You have time to not ruin everything.
* __Go to every meeting.__ The people at PSAS know things you don't. Talk to them. 

If you didn't read anything else though... you'd be such a scrub.

## Materials

Perhaps the biggest stumbling block in the project was the materials. 
Essentially the whole first half of the project was spent dealing with materials. 

In addition the problems acquiring materials, we had problems with the materials themselves. "Reproduce the results from the 2014 capstone in making cylindrical modules," isn't as simple as it sounds. 
The techniques developed by the 2014 team were for their specific materials. So, we ended up needing to reformulate a few key pieces. In the end, we got a procedure and design that was *similar* to the 2014 version.
One very troublesome part of this was that we always thought that we were one issue away from reproducing their results. 
The takeaway from this is that unless you have a finished part sitting in front of you, there are no guarantees that you will get that part soon.

We acquired donations of carbon fiber (CF) and fiberglass (FG) from Pacific Coast Composites (PCC) (contact: ??). They also gave us adhesive, but it wasn't a full roll, and it wasn't a kind of adhesive that was useful in our design.
Similar things will undoubtedly happen to future groups working with CF. The necessary materials are prohibitively expensive, so you have to rely on donations. 
This means that you don't necessarily get what you want or need. 

At the end of the winter term, we were all but convinced that the other carbon fiber team (LV4 aka NGCF) would need to massively reduce the scope of their project, due to a lack of adhesive.
Luckily, we got a huge donation from Boeing (contact: [Loren Coleman](mailto:loren.m.coleman@boeing.com) and [Sandie Hallman](mailto:sandie.h.hallman@boeing.com)) which included the proper Meltbond 1515 adhesive. They also gave us huge amounts of vacuum bagging supplies, prepreg FG, and prepreg CF (plain weave and unidirectional).
Boeing, being a *huge* company, often gets rid of stock that is expired or in excess. It's sporadic and you have to periodically ask them what they've got, but you can get huge amounts of new (for our purposes) material this way.

In fact, we ended up creating a different problem for ourselves. We then had so much material that we didn't have space for it. 
At that time, we only had the Viking Motor Sports (VMS) freezer to store material in. Note that it's not even long enough to store some rolls.
We had to scramble to get a freezer to store all our material in (MME was not super enthusiastic about buying it).
The biology department was gracious enough to let us store a lot of it in their cold room temporarily (contact: Dr. Lindgren). 
Eventually, we got a freezer to keep in the 480 lab. Between the VMS and 480 freezers though, we still only had space to store about half of what we got. 
This extra material was given away to the CTRL-H maker space, the OSU robotics lab, and the WSU rocket team. 
The vacuum bagging material found a semi-permanent home in the capstone lab, but even that isn't "supposed" to be there. (This situation is still developing.)

The lesson here is that you should only accept donations that you can use. It may feel like you're being rude to refuse a donation, but you can end up causing lots of problems for yourself. 

### Machine Sciences

In this same vein, we got a lot of aluminum and machine time donated by Machine Sciences (contact: [Dani Yeager](dani.yeager@machinesciences.com) and [Brian McCabe](brian.mccabe@machinesciences.com)). They provided the coupling rings and fin frames for the project. 

Their willingness to donate is essentially based on Brian's excitement about the project. Keep this in mind if you plan on asking for donations from them. You'll want to emphasize the novelty and spaciness of the project.

The other really important thing about Machine Sciences is the lead times. They are a high-end commercial job shop. Their customer's orders come first. If they're machining parts for you, get your order in as soon as you can, _**while still doing a good job on the design and double-checking things with your team mates and PSAS**_.
You don't want to find yourself waiting for a solid two months of other jobs to finish, like we did.

## Parts

This was a weird project for design. That is to say, there was disturbingly little "real" engineering design.
There were a lot of "OMG, this needs to be done yesterday" type tasks. So, even when it would have been appropriate to spend a month or more on the design of a part, we ended up going with a "it's probably fine" method of design.

The vast majority of the design was done using OpenRocket (OR). It's strictly an amateur tool, but still gives pretty accurate results. 
Our other main tools were OpenFOAM, Abaqus, and first-principles calculations.

For many of our first-order approximations, we simply used the OR model of Launch 12 (L12), since it was known to be very accurate. Once we had a reasonable guess as to what L13 would look like (including the nose and fin planform), we did calculations based on that, refining the model as we went.

### Nose

Initially, we were very worried about the design of the nose. The drag on the rocket dissipates kilowatts of power. 
Assuming the vast majority of it got dissipated as wave drag on the tip, we might expect the tip to reach hundreds of degrees C, depending on the size of the aluminum tip. We were worried that the tip might go beyond the operating range of the epoxy in the CF.

We got to this by taking the output of the OR simulation of L12, and summing the work done by the drag at each time step. Assuming all of that work went into the nose tip and that it was evenly distributed throughout the aluminum tip, we could calculate the temperature of a tip of a given size. 
Of course, these assumptions were totally heinous, but they gave an upper bound for how hot the tip might get.

After that, we tried to get a more accurate estimate of the tip temperature by using analytical expressions for the wave drag and skin drag, and relating them to the ratio of how much energy is dissipated by each. 
Unfortunately, the derivation of those was a bit beyond the scope of the project. The ones we found were either wrong or we weren't using them properly, because they disagreed wildly with the OR model. 

Next, we tried CFD. (It was probably silly jumping to this, but meh.) The OpenFOAM model predicted a maximum air temperature of only 175 degrees F. To back this up, [Peter](peter@mccloudaero.com), from NASA, got a similar result.
This meant that the tip size didn't matter much, as far as temperature. It just needed to be practical.

So, having the major dimensions (Based on the literature we found a 1:5 aspect von Karman nose was a very reasonable choice.) of the nose cone, we went about making CAD and talking to Machine Sciences about getting a mandrel machined. 
We decided to use a similar design as the modules, using a male mandrel to layup a CF-nomex-CF sandwich. 
Our reasoning behind this was that the sandwich was sort of a known technology that we already had practice with.

This presented a few challenges. 
First, Machine Sciences had trouble just machining it. (In fact, they eventually concluded that they couldn't machine it without buying some really expensive add-on to one of their machines.) Second, it was a *huge* part. Unless Machine Sciences could hog out the core of it -- they could only do about half -- it would take 3 people just to lift. 

Ultimately, they couldn't make the part. Even if they could, it would have been done after the launch date. Unfortunately, this became apparent after we had done all the CAD for the associated parts and been going under the assumption that we would have that tooling.

So, we had to figure out a new strategy for making the nose. 

We decided on a much more common method for forming noses: molding. This had the very attractive quality that many other amateur rocketeers built their nose cones by forming sections of the nose with a female mold and then joining them together. 
The main difference between our design and most others was that we were using high temperature prepreg CF, while most other groups used room-temperature cure epoxy painted onto raw CF.

We went back and forth between making a positive plug in the shape of the nose versus just making a female mold directly.
With the plug, we would machine the shape of one side of the nose, then mold FG on that and use the resulting FG mold to make the half-section of the nose. 
With the direct female mold, we would machine the negative shape of the half-section and then layup the CF on that directly.

Both strategies had problems. 
With the female mold, we would need to get a material that would withstand the cure cycle of the CF. This basically limited our options to either aluminum or machinable foam. 
Using a female mold would also mean that if we break the mold, it's very difficult to make a new one. 
Obviously, aluminum would have all the same problems as the mandrel. 
With the plug, we have the added step of forming a mold on the plug -- more things to get wrong. We would also need to get an epoxy that would cure at a low enough temperature to avoid damaging the plug, but still withstand the cure cycle of the CF.

We considered removing the FG from the plug and adding a layer of plaster onto the back of the FG. Ultimately, we decided that the simpler female mold was a better bet.

As of now, we are layering together the block of machinable foam that the mold will be machined out of. 

### Fin Can

All of the design for the fins was done in OpenRocket. The main thing we needed to determine was the the planform (the shape of the flat part of the fin). 
There's a lot of nice theory and experiment to back up designs of different airfoils, but practicality drove the design stronger than anything else.

For example, the preferred supersoic airfoil is a diamond. (In fact, such an airfoil is reasonable to construct using molding or a machine foam core.)
However, because we placed so much weight on reusing the work of the 2014 capstone, we decided to persue a fin design that mirrored it as closely as possible. 
To get smooth, durable leading edges, we used an aluminum frame surrounding the fin. 
To fill the gaps of the frame, we used honeycomb.
This was then covered in CF to form the aeroshell. 
In order to ensure strength against flutter, we added a flange at the root of the frame.
With this, stresses from flutter would be transmitted through a thick section of aluminum with a large moment arm, compared to a simple CF tip-to-tip (TTT) layup. 
To make the frame even stronger, we decided to mahine the frame out of a solid block.
(You can check out the pictures in the updates and the cad files for more description of the old fins.)

A lot of these design decisions were only feasible because we already knew we would be receiving machine time donations from Machine Sciences. 
In other words, we knew that if we overbuilt something in a way that required very tricky machining, we wouldn't really have to make it ourselves. 
Frankly, this encouraged a lot of bad design decisions. We wound up making parts that coulnd't ever be made at PSU or any other university, most likely. 
