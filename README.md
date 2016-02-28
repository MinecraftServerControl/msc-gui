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
[Minecraft Server Control Script]
(https://github.com/MinecraftServerControl/mscs) that has been controlling
many Linux and UNIX powered Minecraft servers since it was first released in
2011.

## Prerequisites for installation

The Minecraft Server Control GUI uses Perl to present a web-based interface to
the [Minecraft Server Control Script]
(https://github.com/MinecraftServerControl/mscs).  As such, the `mscs` script
must be [installed](https://github.com/MinecraftServerControl/mscs/blob/master/README.md#installation)
and working for the GUI to function. Since the GUI is web based, you will need
to have a web server installed and working.  These directions assume you are
using [Apache](https://httpd.apache.org), but any web server solution should
function.  To install Apache:

    sudo apt-get install apache2

## Installation

### Download

If you followed the easiest way of [downloading the script](https://github.com/MinecraftServerControl/mscs/blob/master/README.md#downloading-the-script) when installing MSCS, then you will want to do the same here.  With `git` already installed:

    git clone https://github.com/MinecraftServerControl/msc-gui.git

##### Other ways to download

* Get the development version as a [zip file]
(https://github.com/MinecraftServerControl/msc-gui/archive/master.zip):

    wget https://github.com/MinecraftServerControl/msc-gui/archive/master.zip

### Configuration

Navigate to the `msc-gui` directory that you just downloaded.  Configuration
can be done with the included Makefile in Debian and Ubuntu like environments
by running:

    sudo make install


#### Apache

Here is an example of a file that can be placed in the
`/etc/apache2/sites-enabled/` directory to enable Apache to run a webserver
on port `80` on the host `minecraft.server.com` from the directory
`/var/www`. Change these values to suit your the needs of your website. This
configuration makes the GUI available at `http:\\minecraft.server.com\gui`.

```
<VirtualHost *:80>
    ServerName minecraft.server.com
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www

    Alias /gui /var/www/gui
    <Directory "/var/www/gui">
        Order Allow,Deny
        Allow from all
        AllowOverride None
        AddHandler cgi-script .pl
        Options +ExecCGI -MultiViews -Indexes -Includes +FollowSymLinks
    </Directory>
</VirtualHost>

```

Make sure to create a symbolic link so that Apache can actually find the GUI:

    sudo ln -s /opt/mscs/gui /var/www/gui

You will also need to enable the Apache CGI module and restart Apache for the
GUI to work:

    a2enmod cgi
    service apache2 restart

#### Permissions

To allow Apache and the MSC-GUI access to MSCS, use your favorite editor to
create a new file in the `/etc/sudoers.d` folder:

    sudo editor /etc/sudoers.d/mscs

and add this text :

    # Allow www-data to execute the msctl command as the minecraft user.
    www-data ALL=(minecraft:minecraft) NOPASSWD: /usr/local/bin/msctl

## Getting started guide


## License

See [LICENSE](LICENSE)

## Disclaimer

Minecraft is a trademark of Mojang Synergies AB, a subsidiary of Microsoft
Studios.  MSCS and MSC-GUI are designed to ease the use of the Mojang produced
Minecraft server software on Linux and UNIX servers.  MSCS and MSC-GUI are
independently developed by open software enthusiasts with no support or
implied warranty provided by either Mojang or Microsoft.
