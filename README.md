# Bar
A status bar made in quickshell for niri.

- `bars/` contains the code that makes the actual bars work
- `sides/` contains the different modules that are positioned along each bar
- `modules/` contains each module that is used in the bars


## Requirements
- `brightnessctl` for brightness stuff
- To be running `niri`
    - If you are not don't worry, just almost none of the bottom bar's stuff will work.
    - Feel free to make your own copy of this repo to change the buttons as you need.
## Extra stuff
These are extra things you can get for more features
- `acpi` for battery time estimates
- Set the environment var `TermSpawn` to get stuff to open on click of some elements
    - TermSpawn must be set to the command to spawn a new terminal running code (e.g. with alacritty it's `alacritty -e`)
    - It just needs to be avaliable when running the quickshell instance, so set it wherever.
- Set the environment `EXECUTE` to do something when the button is pressed (same as before)

## How to use
To use, clone it into `~/.config/quickshell`:
```bash
cd ~/.config/quickshell
git clone https://github.com/Tsunami014/bar
```

You can put this line in some config.kdl file in niri's config to make it run on startup:
```bash
spawn-at-startup "quickshell" "-c" "bar" "-n"
```
