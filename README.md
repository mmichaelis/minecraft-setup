# Minecraft-Setup

> Setup scripts for Minecraft Server Setup

This repository contains a script to set up Minecraft Server on Microsoft Windows as service. It has been tested with
Windows 8 but should also work for other Windows versions.

The script has been tested for intranet set up, thus to provide a server which can be used by everyone of our family.
For guides to make your server available in the internet please consult other documentation which for example describes
how to make your changing IP available in the internet.

The following [Help Section][#help] starts with an description for the advanced user already knowing basics about servers,
Java set up etc. For a more detailed description follow [Step-by-Step][#stepbystep] below which hopefully describes all steps
so anyone could install the Minecraft Server

<a name="help"/>
# Help

The script is actually rather self-explaining providing the following description once you call `minecraft help`.

## Synopsis

```
minecraft [help|install|remove|edit|start|stop|status|run]
```

## Description

> Tool to set up Minecraft Server and install it as a service.

Mind that you first should run Minecraft Server in order to set up
the configuration data like server.properties. Then accept the EULA
(in eula.txt) and start again just to ensure that the server runs
without problems. Install it as a service as soon as the server runs
just fine.

Recommended order of steps (run as admin or with UAC turned off):

1. **`> minecraft run`**

   Configuration files will be created in: `C:\ProgramData\Mojang\Minecraft`
    
2. Adapt `server.properties`, etc. and especially edit `eula.txt` to
   accept the End User License Agreement.

3. **`> minecraft run`**

    Start Minecraft Server again just to see that all your configuration
    works. You can already log in. End server with Ctrl+C or `/stop` at
    Minecraft Console if everything is fine.

    You might also want to run some commands (see `/help` at Minecraft
    Console) e. g. to set default gamemode or define operators.
    
4. **`> minecraft install`**

    Install Minecraft Server as Windows service. Service will be installed
    to start automatically on reboot. You can call this any time again to
    update the Service configuration (for example if you updated Java).
    
5. **`> minecraft edit`**

    *(Optional)* Edit/review Minecraft Server settings.

6. **`> minecraft start`**

    Start Minecraft Server Service.

### Other options:

* **`> minecraft stop`**

  Stop Minecraft Server Service

* **`> minecraft status`**

  See if Minecraft Server Service is up and running.

* **`> minecraft remove`**

  Remove Minecraft Server Service

### URLs:

* Non-Sucking Service Manager: https://nssm.cc/
* Java Download: https://java.com/download/
* Minecraft Download: https://minecraft.net/download

<a name="stepbystep"/>
## Step by Step

This description is targeted to the beginner to intermediate Windows user. If you feel that the description is not
sufficient feel free to drop me a note.

During the installation process you might be asked to provide administrative permissions. As alternative run applications
like command line or explorer as administrator.

### Preparation

#### Non-Sucking Service Manager

This service manager is used to configure and run Minecraft as Windows Service. A Windows Service is capable of starting
right at system startup so the obvious advantage is, that you do not have to log in to Windows to make the server available
to your intranet.

1. Download the Non-Sucking Service Manager from https://nssm.cc/download
2. Unzip and place the `nssm-<version>` folder into `C:\Program Files`

#### Java

1. Download the Java Runtime Environment (JRE) from https://java.com/download/
2. Execute the installer and remember the installation path, for example `C:\Program Files\Java\jre1.8.0_40`

#### Minecraft Server

1. Download the Minecraft Multiplayer Server JAR (Java Archive) from https://minecraft.net/download

    Remember not to download the executable EXE file but the JAR mentioned later in the download section.
    
2. Place the JAR into `C:\Program Files\Mojang\Minecraft`

#### Installation Script

1. Download the installation script [](minecraft.bat)
2. For example place it into the Minecraft folder as used above. Any other folder will do so as well.
3. Edit [](minecraft.bat) and adjust the following settings:

    * `MINECRAFT_HOME=C:\Program Files\Mojang\Minecraft`
    
        Set this to the path where you placed the Minecraft Server JAR.
    
    * `MINECRAFT_VERSION=1.8.3`
    
        Set this to the version as given by the JAR filename.
        
    * `MINECRAFT_DATA=C:\ProgramData\Mojang\Minecraft`
    
        This is where the minecraft data (world data, configuration, etc.) will be written to.

    * `NSSM_HOME=C:\Program Files\nssm-2.24\win64`
    
        Where to find the nssm.exe matching your operating system, here: 64bit.

    * `JAVA_HOME=C:\Program Files\Java\jre1.8.0_40`

        Where to find the bin\java.exe matching your operating system
        .
### Installation

*TBC*
