# XCOM Long War: Community Edition

**Long War: Community Edition**, or **LWCE**, is a community effort with four main goals:

* Provide a version of Long War 1.0 with as many bugs fixed as possible.
* Roll some Quality of Life (QOL) changes into the game without requiring additional mods.
* Open up Long War's gameplay to configuration via ini files.
* Expose modding hooks for modders to use when ini changes aren't sufficient.

Each of these is explored individually in more depth [below](#project-goals).

Due to this mod's extensive overriding of base game classes, it is unlikely to be compatible with other mods that perform significant modifications. This limitation is why part of the goal of LWCE is to expose modding APIs, allowing fully-featured mods to be built on top of LWCE without conflicting.

Want to know more? Check out [the project wiki](https://github.com/chrishayesmu/XCOM-LW-CommunityEdition/wiki/) for developers, or [some screenshots](https://github.com/chrishayesmu/XCOM-LW-CommunityEdition/wiki/Screenshots) to get a glimpse of what we're all about.

# Installation

This section is TBD, as there are no releases yet. For personal use while in development, see [building locally](#building-lwce-locally).

# Project goals

## Bug fixes

There are a number of bugs in Long War 1.0, which were either introduced by Long War, or existed in vanilla Enemy Within. They can be broadly classed into two categories:

1. Bugs that impact the QOL, but not difficulty.
2. Bugs which have an impact on game balance.

An example of the first category is that when purchasing Interceptors in XCOM HQ, after submitting the order, the amount of money you have doesn't visibly update right away. It does update behind the scenes, so this doesn't cause any problems, but it is a small bug that can be annoying.

In the second category, we have bugs such as the smoke defense bonus not applying to overwatch shots. Fixing this does impact the game balance, because now you can make it significantly safer for your units to run overwatch.

When there are bug fixes in the second category, LWCE does not enable those fixes right away. Instead, the bug fix can be enabled using an ini variable, and the normal Long War 1.0 behavior is used otherwise. This allows LWCE to be used by anyone who wants its quality of life improvements, while not differing from the Long War 1.0 experience.

For a list of Long War bugs tracked and/or fixed by LWCE, [see here](https://github.com/chrishayesmu/XCOM-LW-CommunityEdition/issues?q=is%3Aopen+is%3Aissue+label%3Abase-game-bug).

## Quality of life changes

This section is TBD.

## Exposing configuration

Long War has sophisticated logic throughout its various systems, but due to the limited modding techniques available at the time it was written, the authors were unable to add new ini files and variables. This meant they could only make functionality configurable by hijacking a configuration variable that existed in Enemy Within. Thanks to newer modding techniques, we can now get around this and offer additional ini files to make the Long War experience far more personalizable.

For an example of the types of configuration now possible, take a look at [DefaultLWCEStrategyAI.ini](Config/DefaultLWCEStrategyAI.ini).

## Modding hooks

Documentation for mod hooks not yet completed. For now, see [LWCETacticalListener](Src/XComLongWarCommunityEdition/Classes/LWCETacticalListener.uc) and [LWCEStrategyListener](Src/XComLongWarCommunityEdition/Classes/LWCEStrategyListener.uc).

Mutator-based mods are still supported, as in Long War 1.0; however if these mods conflict with LWCE (e.g. by overriding the same class as LWCE does) their interaction may be unpredictable. Authors of mutator-based mods are encouraged to migrate to LWCE, especially if any conflicts occur.

### **Adding items, perks, and technologies**

(Note that not all of these are supported fully yet. Currently you can freely add new research and Foundry techs, and limited aspects of new items.)

In the base game, there are a number of systems that use enums for unique identifiers. Since UnrealScript enums are a single byte, this limits these identifiers to 256 different values, greatly limiting modding potential. In LWCE, we've rewritten these systems to replace their identifiers with 32-bit signed integers, vastly increasing the value space to 2,147,483,647 distinct values (negative values are not allowed).

#### **Choosing IDs without conflicts**

Even with such a large space to work in, conflicts are possible if there's no system for partitioning the space. Mods are therefore responsible for choosing an ID space according to the following:

1. IDs are assigned in blocks of 10,000 elements.
2. Negative ID values are disallowed.
3. All IDs from 0 to 99999, inclusive, are reserved for LWCE.
4. All IDs from 2,147,000,000 to 2,147,483,647, inclusive, are reserved for LWCE.
5. Of the remaining 214k ID blocks, modders should choose a block for themselves using a random number generator, rolling from 10 to 214,599. This number is your **block prefix**. Multiply it by 10000 to get the first ID in your block.
6. If for some reason a single block isn't large enough for a mod, mods should extend into the next contiguous block. (Ex: if your block is 1000000 to 1009999, you would extend into 1010000 to 1019999.)

As an example, suppose a random number generator gives you the block prefix **146339**. Then your block extends from 14,633,900,000 to 14,633,909,999.

Once you have your ID block, you need to update your `LWCEModBase` child class with this info, using the `ModIDRange` field. If you don't set this value to a valid block range, LWCE will not load your mod. (For forward compatibility's sake, this applies even to mods that don't intend to add any content that needs an ID.)

# Building LWCE locally

> :warning: These steps are only tested on Windows systems. For other OS's you may need to modify these extensively.

These steps will get you able to build and run LWCE on your own machine. We make extensive use of [symbolic links](https://en.wikipedia.org/wiki/Symbolic_link), or **symlinks**, so make sure you know how to create them on your system.

## First time setup for XCOM modding

>If you have written and built mods for XCOM: Enemy Within before, you may be able to skip most of this section. However, some steps are unique to LWCE's environment, so still read through to see if you need to make any changes!

### Installing the UDK

XCOM: Enemy Within was built using the 2011-09 version of the UDK, so we use the same one. You can download it [from the Nexus](https://www.nexusmods.com/xcom/mods/485). Make sure to note the installation path, as you will refer back to it frequently. Throughout this README we will refer to the installation path as `UDK_PATH`.

> :warning: The UDK installer doesn't create a subfolder at the given path. For example, if you install at `D:\`, it will happily extract the UDK's contents directly into `D:\` and make things difficult to navigate. Make sure you create a subfolder yourself and install it there.

After installing the UDK, navigate to `UDK_PATH` and check that you have the folders `Binaries`, `Development`, `Engine`, and `UDKGame`. To check that you are set up properly, execute `UDK_PATH/Binaries/Win32/UDK.exe make` to build the sample game that comes with the installer.

### Adding XCOM stubs to the UDK

To build against XCOM's APIs, we need to know its classes and their functions. We do this using **stubs**, which contain only the classes and function signatures, without including the body of any functions (which would be very difficult to get to build successfully). Note that the stubs are ***incomplete***, and periodically we have to add functions or even entire classes to them. For this reason, we use symlinks rather than just copying them into the UDK directory.

If you open `UDK_PATH/Development/Src`, you will see a number of folders such as `Core`, `Engine`, etc. You will see the same folders in your LWCE installation directory under `Stubs`, plus a few more. We will mostly be adding packages to the UDK, but XCOM does make modifications to the `Core` and `Engine` classes, so you'll need to delete the folders `UDK_PATH/Development/Src/Core` and `UDK_PATH/Development/Src/Engine`.

Once you've located both the stubs and the UDK folders, simply create symlinks within `UDK_PATH/Development/Src` pointing to the equivalent folder in `Stubs/`. You need to do this for the folders `Core`, `Engine`, `GFxUI`, `XComGame`, `XComUIShell`, `XComStrategyGame`, `XComMutator`, and `XComLZMutator`.

After creating the symlinks, you still need to tell the UDK about the XCOM packages. Open the file at `UDK_PATH/UDKGame/Config/DefaultEngine.ini` in any text editor, and locate this block:

```
[UnrealEd.EditorEngine]
+EditPackages=UTGame
+EditPackages=UTGameContent
```

We're going to append the XCOM packages like this:

```
[UnrealEd.EditorEngine]
+EditPackages=UTGame
+EditPackages=UTGameContent
+EditPackages=XComGame
+EditPackages=XComUIShell
+EditPackages=XComStrategyGame
+EditPackages=XComMutator
+EditPackages=XComLZMutator
```

**Make sure your packages are in this order!** This is the order they will build in, and they must be in this order due to the dependencies between packages.

Once you've saved the file, execute `UDK_PATH/Binaries/Win32/UDK.exe make` again. You will likely see a bunch of warnings, since we're only building stubs and not real functions, but you should not receive any errors. If the build succeeds for all packages, your stubs are set up correctly.

### Installing an IDE

You can edit UnrealScript files any way you like, including a basic notepad editor if you want. One setup which works well is using [Visual Studio Code](https://code.visualstudio.com/), which is free and relatively lightweight. You can install the [UnrealScript](https://marketplace.visualstudio.com/items?itemName=EliotVU.uc) extension to get language support, though many of the features may only work sporadically. It still provides syntax highlighting at minimum, which is well worth having.

If you're using VS Code, you can also create [a custom build task](https://code.visualstudio.com/docs/editor/tasks#_custom-tasks) which executes `UDK_PATH/Binaries/Win32/UDK.exe make`, so that you can build by simply pressing <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd>.

## First time setup for LWCE

### Building through the UDK

The steps for building LWCE are quite similar to the setup for the stub files.

1. Create a symlink in `UDK_PATH/Development/Src` which points to the LWCE source code (`LWCE_DIR/Src`).
2. Modify `UDK_PATH/UDKGame/Config/DefaultEngine.ini` and add the line `+EditPackages=XComLongWarCommunityEdition` to the end of the `EditPackages` block from before. (It must be at the end!)
3. Build using `UDK_PATH/Binaries/Win32/UDK.exe make` and verify that the build succeeds.

If the build succeeds then you should be good to go as far as building LWCE locally.

### Running the LWCE code in game

> :warning: Before following these steps, make sure you have XCOM: Enemy Within installed, with [Long War 1.0](https://www.nexusmods.com/xcom/mods/88/) installed on top. We're using bytecode modification to inject LWCE, so any differences in your environment could cause it to fail. Leaving other small mods installed should be fine, but if you have another Long War version, or a similarly large mod installed, things are likely to break.

Now that you've built LWCE, connecting it to the game is straightforward. You will need to have PatcherGUI available, which is part of [UPKUtils](https://www.nexusmods.com/xcom/mods/448). You will also need to know the directory that XCOM is installed in, such as `D:\SteamLibrary\steamapps\common\XCom-Enemy-Unknown`. This will be referred to as `XCOM_PATH`.

1. Navigate to `UDK_PATH/UDKGame/Script`. If you built LWCE successfully, you should see the file `XComLongWarCommunityEdition.u` there.
2. Also navigate to `XCOM_PATH/XEW/XComGame/CookedPCConsole`. This is where `.upk` and `.u` files are stored for XCOM: Enemy Within. Make sure your path includes `XEW`, otherwise it is for XCOM: Enemy Unknown.
3. Create a symbolic link within `CookedPCConsole` that points at the `XComLongWarCommunityEdition.u` file.
4. Repeat this process, creating a symbolic link in `XCOM_PATH/XEW/XComGame/Config` for each of the `.ini` files under `LWCE_DIR/Config`.
5. Create one more symlink in `XCOM_PATH/XEW/XComGame/Localization/INT`, which points to `LWCE_DIR/Localization/XComLongWarCommunityEdition.int`.

By using a symlink, each time you build LWCE, the latest version will be picked up by the game automatically. If you're only changing `.ini` files, you don't even need to build.

There's one more step: the LWCE code is located alongside the game, but the game doesn't know to load it. There are several ways to make that happen, but we use **bytecode modification** to inject a few high-level classes into the game flow. Installing these is easy:

1. Open up PatcherGUI, from UPKUtils. This is an application that can apply bytecode patches in a safe and reversible way.
2. At the top of PatcherGUI's window, there should be a path pointing to the `XEW` folder in your XCOM installation. Verify that it has detected the right path, as sometimes it can get confused depending on your installation directory.
3. Click the Browse button next to the line that just says "Mod file". Browse to `LWCE_DIR/Patches` and select `XComGame_Overrides.upatch`. (You'll need to change the filetype filter to see `.upatch` files.)
4. After you select the file, you will see its contents appear in PatcherGUI. Click Apply on the right side to modify the game files. You should receive a pop-up stating that the mod installed successfully.
5. Make note of (or back up) the uninstall file generated by PatcherGUI. It will allow you to return to Long War 1.0 without having to reinstall everything from scratch.

At this point, if you launch XCOM, you should be running LWCE. But since the point of LWCE is to fix bugs and look as much like Long War 1.0 as possible, it may be tough to verify this. The simplest way - and a good idea regardless if you're going to be modding XCOM - is to enable the log window while playing.

### Viewing XCOM logs

These steps assume you're playing through Steam. If not, they should still be applicable; you just need to apply the launch options to your own launcher method.

1. Find XCOM: Enemy Unknown in Steam. Right click it and select Properties.
2. At the bottom of the General section, you should see a "Launch Options" field. Enter the following: `--noRedScreens -noStartUpMovies -log -allowConsole`
3. Close the launch options and boot the game.

After the game starts, a separate window should open which contains log output. These logs are also written to a file which is overwritten every time the game launches. For me, the file is at `Documents/my games/XCOM - Enemy Within/XComGame/Logs/Launch.log`. Note that the log window is unbuffered, while the file is buffered, so you may not see the latest output in the file unless you close the game.

LWCE begins logging even at the main menu, without loading a game. To verify that LWCE is running properly, open the log file and search for `XComLongWarCommunityEdition`, which all LWCE log lines begin with. If you find it, congratulations - you're all set up to build and run Long War: Community Edition!