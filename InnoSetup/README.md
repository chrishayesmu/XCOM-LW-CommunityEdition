# Inno Setup 6.2.x Installer

This folder contains the Inno Setup Script (`.iss`) file for creating LWCE's Windows installer. To generate a new installer:

1. Download Inno Setup from [jrsoftware.org](https://jrsoftware.org/isdl.php). The most recent version which is known to work for LWCE is 6.2.2.
2. Set the `LWCE_UDKGAME_PATH` environment variable so that it points to the `UDKGame` folder of your UDK installation. The path should be such that `$LWCE_UDKGAME_PATH/Script/XComLongWarCommunityEdition.u` is a valid path.
3. Build LWCE's script files from whichever commit you're creating a release for.
4. Open `create-installer.iss` in Inno Setup Compiler, then select Build > Compile in the toolbar. Alternatively, you can run the compiler from the command line using [the iscc command](https://jrsoftware.org/ishelp/index.php?topic=compilercmdline).

This will generate an `Output` folder containing the installer executable.