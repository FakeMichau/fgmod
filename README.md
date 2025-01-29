## Credit
This mod is an installation script for Artur's [DLSS Enabler](https://github.com/artur-graniszewski/DLSS-Enabler) which itself is a combination of multiple other projects.

## Installation
Run this command in the terminal
```sh
curl https://raw.githubusercontent.com/FakeMichau/fgmod/main/prepare.sh | bash --
```
This will create a folder called ``fgmod`` in your home directory with a wrapper ``fgmod`` inside of it.

Before running it, at least take a look at prepare.sh and fgmod.sh, piping stuff blindly into sh is not wise.

## Usage
After running the script, you will be given the exact command. In case you missed it, look below.

For Steam, add this to the launch options: ``$HOME/fgmod/fgmod %COMMAND%``  
For Lutris, add this to the Command Prefix in the System Options tab: ``$HOME/fgmod/fgmod``  
For Heroic, add this as a new wrapper: ``$HOME/fgmod/fgmod``  
For Bottles, add this this as pre-run script in the launch options: ``$HOME/fgmod/fgmod``  

### AUR package
There is PKGBUILD, download that and fgmod.sh, you know what to do with it - ``makepkg``. Usage is simpler, just add ``fgmod`` as a wrapper.

## Uninstallation
### 1. For a single game
- Remove ``$HOME/fgmod/fgmod`` from the launch options
- Run ``fgmod-uninstaller.sh`` found in the game folder, it will not always be the main folder


### 2. The whole fgmod
- Remove the ``$HOME/fgmod`` folder
- Do the steps for a single game for every game you've used fgmod with 
