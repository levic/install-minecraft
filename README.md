# install-minecraft
* Downloads and installs Minecraft Bedrock Edition (ie Minecraft Pocket Edition) and sets it up as a systemd user service (called `minecraft@default`)

## Requirements
* Uses [`crudini`](https://manpages.ubuntu.com/manpages/trusty/man1/crudini.1.html) to modify settings
    * On ubuntu/debian run `sudo apt install crudini`

## Installation
* Check settings in `settings.inc`
* Run `./install-minecraft.sh`
