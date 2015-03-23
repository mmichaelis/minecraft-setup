# Minecraft-Setup

> Setup scripts for Minecraft Server Setup

This repository contains a script to set up Minecraft Server on Microsoft Windows. It has been tested with Windows 8 but
should also work for other Windows versions.

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
