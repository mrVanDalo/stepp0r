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

> There is only one restriction : 
> InstrumentX will always be on TrackX


## Pattern Edit mode

The first mode you see, to *edit* the **Pattern** selected in **Renoise**.

<img class="img-responsive center-block" src="{{ site.baseurl }}/assets/Launchpad-PatternEditorMode.svg" alt="Launchpad Parts" />


### Keyboard

For Playing Tones.

> You have to start an OSC Server on the port you configured to hear the tones.

The last key you've pressed is blinking and will be used to edit the **Pattern Edit Area**.

On the top left and right you can change the octave, which is displayed as an yellow button in the 
second row.

### Instruments / Tracks

You can choose the different Instruments here. 
Choosing a new Instrument will update the **Pattern Edit Area**.

The **Instrument-Row** is paged. 

On the right you can toggle between **choose** and **mute**.

> Changing an instrument/track will also change the focus in on the **Pattern Editor**.

> Changing the track in **Renoise** will also change the selection in **Stepp0r**.

### Pattern Edit Area

When you hit play and you select the actual pattern in the **Pattern Matrix**, you will see a green light running 
from left to right, which represents the current play position.

You have **Pagination** and **Zooming** for this Area.

Pressing keys will place or remove a note (using the **Keyboard** and **Effects**) at this specific place.

You can choose use up to 4 different **Note Columns** per track.

### Effects 

To change the **Delay/Volume/Panning**.
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



## Adjustment Mode (aka Copy Paste mode)

This mode lets you copy paste sections of you Pattern. 

<img class="img-responsive center-block" src="{{ site.baseurl }}/assets/Launchpad-AdjustMode.svg" alt="Launchpad Adjust Mode Parts" />

### Bank

You have 8 Banks, where you can store selections.
You can clear every Bank by using the red button below the selected bank.
By pressing the flashing button in the bank (your selected bank) you can switch between copy and paste mode.
The pattern you copy can be used across all other instruments.


### Adjust Mode Area

Here you can insert and select your patterns, according to the mode you've selected.

### Effects

Don't do anything right now.

## Pattern Matrix Mode

This mode is for arranging patterns. 
It is influenced by [Ableton Live](https://www.ableton.com/),
[Live Dive](http://www.renoise.com/tools/live-dive) and the 
[Grid Pie](http://www.renoise.com/tools/grid-pie) plugin, but optimized for producing. 
To use this mode you have to set the **Pattern Mix** parameter to 2 or 1. 

<img class="img-responsive center-block" src="{{ site.baseurl }}/assets/Launchpad-PatternMatrix.svg" alt="Launchpad Pattern Matrix Parts" />


### Copy, Delete

You have a copy and a delete button.
Holding the button will change the color of the scene buttons. 

Holding the copy button will copy the actual played pattern to the new selected one.
The delete button will delete the new selected pattern.

The Scene buttons will also take the copy and delete buttons into account.

## Scene buttons

The scene buttons will select the complete row.