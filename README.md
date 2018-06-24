# Minecraft Server Control GUI

# Index
* [Overview](#overview)
* [Prerequisites for installation](#prerequisites-for-installation)
* [Installation](#installation)
  * [Download](#download)
  * [Configuration](#configuration)
* [Getting started guide](#getting-started-guide)
* [License](LICENSE)
* [Disclaimer](#disclaimer)

## Overview
Minecraft Server Control GUI (MSC-GUI) is a new web-based interface to the
[Minecraft Server Control Script](https://github.com/MinecraftServerControl/mscs)
that has been controlling many Linux and UNIX powered Minecraft servers since
it was first released in 2011.

MSC-GUI is currently under heavy development and will be in various stages
of usability for the immediate future.  As of this writing, the only code
available is at the proof-of-concept stage.  This proof-of-concept code will
evolve or be replaced as the concept matures.  When the MSC-GUI is in a more
usable state, this message will be removed.

## Prerequisites for installation

The Minecraft Server Control GUI uses Perl and
[Mojolicious](https://mojolicious.org/), a Perl-based web framework, to
present a web-based interface to the
[Minecraft Server Control Script](https://github.com/MinecraftServerControl/mscs).
As such, the `mscs` script must be
[installed](https://github.com/MinecraftServerControl/mscs/blob/master/README.md#installation)
and working for the GUI to function. Likewise, Mojolicious must be installed
for MSC-GUI to function. If you are running Debian or Ubuntu, you can make
sure that Mojolicious is installed by running:

    sudo apt install libmojolicious-perl

## Installation

### Download

If you followed the easiest way of [downloading the script](https://github.com/MinecraftServerControl/mscs/blob/master/README.md#downloading-the-script) when installing MSCS, then you will want to do the same here.  With `git` already installed:

    git clone https://github.com/MinecraftServerControl/msc-gui.git

##### Other ways to download

* Get the development version as a [zip file](https://github.com/MinecraftServerControl/msc-gui/archive/master.zip):

    wget https://github.com/MinecraftServerControl/msc-gui/archive/master.zip

### Configuration

Navigate to the `msc-gui` directory that you just downloaded.  Configuration
can be done with the included Makefile in Debian and Ubuntu like environments
by running:

    sudo make install

## License

See [LICENSE](LICENSE)

## Disclaimer

Minecraft is a trademark of Mojang Synergies AB, a subsidiary of Microsoft
Studios.  MSCS and MSC-GUI are designed to ease the use of the Mojang produced
Minecraft server software on Linux and UNIX servers.  MSCS and MSC-GUI are
independently developed by open software enthusiasts with no support or
implied warranty provided by either Mojang or Microsoft.
