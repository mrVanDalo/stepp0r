# Launchpad Step Sequencer

This will be a step sequencer for Renoise using the Launchpad.

## Structure

### Module

A module is something that is used by other Modules. 
Moste of the time that is something that writes something to the Launchpad.

#### parts of a module

#### init

The init part is the part that holds the constructor and everything that should be used from outside.
Most of the time these are callbacks, setter (starte withe `wire` because it sound cooler) and 
un/register callback functions.

#### boot

The boot part is kinda fuzzy, in here are the `_activate` and `_deactivate` functions.
And most of the time all the functions that are called in those 2 functions.

#### lib / _functionality_

This part/s hold logic function that derive from the init and boot parts.

### Data

Modules have them too, and the convention is `<Modulename>Data`. 
It holds the Constant values for the modul or this artifact (Color or Note for example).
Its a dictionary (table).
For more complex objects it has a access key (containing the indecies to access parts of the complex object)

# Changelog

Version names by Estonian Marathon Champions

## 0.1 Aare Kuum

* Basic usability works
    * Pattern Editor
    * Keyboard
    * Instrument chooser/muter
    * Pagination and Zooming works too
* You can use an osc server to hear the keyboard preview sounds
    
