# Launchpad Step Sequencer

This will be a step sequencer for Renoise using the Launchpad.

## Lauchpad.lua

Here I define basic functionality the Launchpad delivers.

    pad = Launchpad()
    
    example_colors(pad)

should show almost all the functions that are possible.
You should have a look at that function to find out what is possible by the Launchpad class. 


## Convention

* functions starting with an underscore are meant to be used in public
* functions without an underscore meant to be private

### why?

Almost all functions are private. 
I don't want to write my functions in a way they are bad readable.
In the main file there are a lot of underscore functions (because all the configuration takes place here).
In that file an underscore kind a improves the readability (because there is moar space betweent them lettors).

# Changelog

Version names by Estonian Marathon Champions

## 0.1 Aare Kuum

* Basic usability works
    * Pattern Editor
    * Keyboard
    * Instrument chooser/muter
    * Pagination and Zooming works too
* You can use an osc server to hear the keyboard preview sounds
    
