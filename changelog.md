---
layout: page
title: Changelog
permalink: /changelog/
---

Version names by Estonian Marathon Champions

## 0.71 Launchpad / Launchpad PRO

* created Launchpad flavor
* created Launchpad PRO flavor

## 0.70 Rein Valdmaa

* Reorganize the Buttons on the Top `enhancement`
* Deleting a Track will clear the launchpad view. `BUG`
* mixxx section will be add, as new pattern `BUG`, `wontfix`
* Make the effect row green `enhancement`
* improve plugin ui `enhancement`
* Change color of the off now (red is to hard!) `enhancement`
* play button on the pattern mix view `enhancement`
* HotFix for the automation following problem `BUG`
* Copy paste mode to copy multiple or single track colums `enhancement`
* insert and delete pattern row `enhancement`
* remove old color codes and stuff from adjuster and editor module `tech-enhancement`
* Creating a Track, and starting a new track (Stepp0r still on) will crash `BUG`
* hide start button in UI if there is no launchpad available. `enhancement`
* put instrument number in front of track name `enhancement`


## 0.64 Renoise Workshop (Berlin) release

* Selecting a track where there is no instrument yet for, it results in an `exception` `bug`
* Groups mess up the instrument row and pattern matrix sync `bug`
* Instrument Row is not updated quick enough `enhancement`
* remove print-lines `bug`
* fix play and record button `bug`
* Pattern Matrix and track groups `enhancement`
* Pattern mix add Instrument in later stage bug `enhancement` `tech-enhancement`
* dodgy usb cable generates lockup `bug`
* Some kind of Pattern Matrix control `enhancement`


## 0.60 Meelis Veilberg

* pagination of instruments should be configurable in the ui `enhancement`
* Clean up some functions to the renoise object `tech-enhancement`
* Edit Pattern Matrix `enhancement`
* Improve pattern editor view `enhancement`
* record button `enhancement`
* Launchpad 1 does not react instantly `bug`

## 0.50 Kalev Urbanik

* fix master branch  bug
* optimize bank_max and bank_min arithmetics  `tech-enhancement`
* extract duplicated logic from Adjuster and Stepper  `bug` `enhancement` `tech-enhancement`
* All wiring, listener registration and so on should be done in the setup class  `tech-enhancement`
* enforce private and public naming convention  enhancement `tech-enhancement`
* select instrument in renoise when select instrument on launchpad  `enhancement` `question`
* select instrument when muting it  `enhancement`
* update stepper matrix when changing pattern link on active pattern  `enhancement`

## 0.4.1 Santa Clause

* fixed copy-paste bug (insertion of empty instruments)
* add rotation of the pad (just left and right for now)

## 0.4 Villy Sudemäe

* fixed various bugs, like the pollution of green dots, using a high LPB rate.
* add adjust (aka copy paste) mode. You can copy paste patterns now.
* add a nicer logo. Copyright by [stylefusion.de](http://www.stylefusion.de/)
* group tracks will be no longer selected by the instrument chooser (bug)
* add about Page into Help -> About Stepp0r 
* notification should be more stable now.


## 0.3 Vladimir Heerik

* nice UI
    * change osc port.
    * more robust.
    * closing the window does not restart the UI.
* recognize midi instruments.
* improved playback position observer.
* instrument update is properly working now (add an instrument will update launchpad now).
* Licensed under GPL v3 now.
* send release note over osc when releasing the note on the launchpad

## 0.2 Rene Meimer

* cleaned up code
* add columns to chooser
* proper activate and deactivate behavior

## 0.1 Aare Kuum

* Basic usability works
    * Pattern Editor
    * Keyboard
    * Instrument chooser/muter
    * Pagination and Zooming works too
* You can use an osc server to hear the keyboard preview sounds
    
