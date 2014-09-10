---
layout: page
title: Documentation
permalink: /documentation/
---

## Introduction

*Stepp0r* can be used as an easy to use interface for the tracking interface of 
[**Renoise**](http://www.renoise.com/).
It gives you basic usage to 
[**Renoise**](http://www.renoise.com/)
which already exists. 
So you don't _have_ to use it.

> There is only one restriction : 
> InstrumentX will always be on TrackX

## Parts

Here are the parts of the Stepp0r.

<img class="img-responsive center-block" src="/assets/Launchpad.svg" alt="Launchpad Parts" />


### Keyboard

For Playing Tones.

> You have to start an OSC Server on port 8008 to hear the tones.

The last key you've pressed is blinking and will be used to edit the *Stepper-Area*.

On the top left and right you can change the octave, which is displayed as an yellow button in the 
second row.

### Instruments / Tracks

You can choose the different Instruments here. 
Choosing a new Instrument will update the *Stepper-Area*.

The *Instrument-Row* is paged. 

On the right you can toggle between *choose* and *mute*.

> Changing an instrument/track will also change the focus in on the *Pattern Editor*.

> Changing the track in *Renoise* will also change the selection in *Stepp0r*.

### Stepper

The core view of **Stepp0r*. 
When you hit play and you select the actual pattern in the *Pattern Matrix*, you will see a green light running 
from left to right, which represents the current play position.

You have **Pagination** and **Zooming** for the Stepper.

Pressing keys will place or remove a note (using the *Keyboard* and *Effects*) at this specific place.

You can choose use up to 4 different *Note Columns* per track.

### Effects 

To change the *Delay/Volume/Panning*.
You can toggle through the different Effect on the right side.

#### Delay 

* On the first key you will put in the full step.
* On the 5th key in the row, you will delay the tone by half the time of the step.
* On the 7th key in the row, you will delay the tone by 3/4 the time of the step.
etc.

#### Panning

Is centered in the middle.
If you want to center the panning again, just press the panning again.

#### Volume

very obvious.


