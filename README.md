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

> :warning: Long War: Community Edition is a work in progress. Any release not marked as Stable is likely to be full of bugs, and you will probably not be able to play an entire campaign.

If you're planning to work on LWCE, or write mods for LWCE, see [building locally](#building-lwce-locally). If you just want to install LWCE to check it out, head over to [Releases](https://github.com/chrishayesmu/XCOM-LW-CommunityEdition/releases), download the latest, and run the installer.

# Uninstalling LWCE

As LWCE modifies game binaries directly, there is no easy way to revert back to Long War 1.0. You can use Steam to validate game files and restore those binaries, then reinstall Long War 1.0 on top of that.

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

While many quality-of-life changes are still pending, we do have a few in place already:

* When customizing a soldier in HQ, you can now change their gender.
* The game can detect saves made without LWCE, and warn you before loading them.
* Additional keybinds have been added to the settings menu, including Long War's "Overwatch All" command, and a new input in LWCE that shows the movement grid without having to hold right click.

There's much more to come! If you're the author of a QoL mod that you think should be integrated in LWCE, feel free to reach out.

## Exposing configuration

Long War has sophisticated logic throughout its various systems, but due to the limited modding techniques available at the time it was written, the authors were unable to add new ini files and variables. This meant they could only make functionality configurable by hijacking a configuration variable that existed in Enemy Within. Thanks to newer modding techniques, we can now get around this and offer additional ini files to make the Long War experience far more personalizable.

For an example of the types of configuration now possible, take a look at [DefaultLWCEStrategyAI.ini](Config/DefaultLWCEStrategyAI.ini).

## Modding hooks

Documentation for mod hooks not yet completed. For now, see [LWCETacticalListener](Src/XComLongWarCommunityEdition/Classes/LWCETacticalListener.uc) and [LWCEStrategyListener](Src/XComLongWarCommunityEdition/Classes/LWCEStrategyListener.uc).

Mutator-based mods are still supported, as in Long War 1.0; however if these mods conflict with LWCE (e.g. by overriding the same class as LWCE does) their interaction may be unpredictable. Authors of mutator-based mods are encouraged to migrate to LWCE, especially if any conflicts occur.

### **Adding items, perks, and technologies**

(Note that not all of these are supported fully yet. Currently you can freely add new research and Foundry techs, perks, soldier classes, and limited aspects of new items.)

In the base game, there are a number of systems that use enums for unique identifiers. Since UnrealScript enums are a single byte, this limits these identifiers to 256 different values, greatly limiting modding potential. In LWCE, we've rewritten these systems to replace their identifiers with 32-bit signed integers, vastly increasing the value space to 2,147,483,647 distinct values (negative values are not allowed).

Aside from obviously increasing the total amount of content the game can support, this also makes it much simpler to have multiple mods that add content without them conflicting with each other.

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

1. Create a symlink in `UDK_PATH/Development/Src` which points to the LWCE source code (`LWCE_DIR/LWCE_Core/Src`).
2. Modify `UDK_PATH/UDKGame/Config/DefaultEngine.ini` and add the line `+EditPackages=XComLongWarCommunityEdition` to the end of the `EditPackages` block from before. (It must be at the end!)
3. Repeat these steps for each mod folder located in `LWCE_DIR/LWCE_BundledMods`.
4. Build using `UDK_PATH/Binaries/Win32/UDK.exe make` and verify that the build succeeds.

If the build succeeds then you should be good to go as far as building LWCE locally.

### Running the LWCE code in game

> :warning: Before following these steps, make sure you have XCOM: Enemy Within installed, with [Long War 1.0](https://www.nexusmods.com/xcom/mods/88/) installed on top. We're using bytecode modification to inject LWCE, so any differences in your environment could cause it to fail. Leaving other small mods installed might be fine, but if you have another Long War version, or you have a similarly large mod installed, things are likely to break.

Now that you've built LWCE, connecting it to the game is straightforward. We're going to start by using the same installation process that players use. This will apply binary patches to `XComEW.exe` that are annoying to apply by hand, as well as a few other changes. Head over to [Releases](https://github.com/chrishayesmu/XCOM-LW-CommunityEdition/releases) and grab the most recent release, then install it.

Now you're running LWCE, but it's the same version as everyone else - it isn't your locally built version. Let's change that. You will need to know the directory that XCOM is installed in, such as `C:\Program Files (x86)\Steam\steamapps\common\XCom-Enemy-Unknown`. This will be referred to as `XCOM_PATH`.

The steps below will instruct you to create symbolic links for many files. Those files will already exist under `XCOM_PATH` due to running the installer. Any time you're making a symlink, make sure to go delete the existing file in `XCOM_PATH` first. By using a symlink, each time you build LWCE, the latest version will be picked up by the game automatically. If you're only changing `.ini` files, you won't even need to build.

### Setting up LWCE Core

1. Navigate to `UDK_PATH/UDKGame/Script`. If you built LWCE successfully, you should see the file `XComLongWarCommunityEdition.u` there.
2. Also navigate to `XCOM_PATH/XEW/XComGame/CookedPCConsole`. This is where `.upk` and `.u` files are stored for XCOM: Enemy Within. Make sure your path includes `XEW`, otherwise it is for XCOM: Enemy Unknown.
3. Create a symbolic link within `CookedPCConsole` that points at the `XComLongWarCommunityEdition.u` file.
4. Repeat this process, creating a symbolic link in `XCOM_PATH/XEW/XComGame/Config` for each of the `.ini` files under `LWCE_DIR/Config`.
5. Create one more symlink in `XCOM_PATH/XEW/XComGame/Localization/INT`, which points to `LWCE_DIR/Localization/XComLongWarCommunityEdition.int`.

### Setting up LWCE Bundled Mods

These steps are similar to LWCE Core, but the paths are different.

1. Look in `LWCE_DIR/LWCE_BundledMods`. You will need to repeat these steps for each mod you find there.
2. Navigate to `XCOM_PATH/XEW/XComGame/Mods`. There is likely already a folder for each mod within `LWCE_BundledMods`, but create any missing ones.
3. In each folder, you will need to create certain directories. Which ones are necessary depends on the contents of the mod.
   * If the mod source contains `Config`, `Content`, or `Localization` folders, so should the mod in `XCOM_PATH`. You can symlink the entire folder from the source directory, or each file individually.
   * If the mod source contains any code, the mod in `XCOM_PATH` should have a folder called `Script`. Inside of that, make a symlink to the mod's `.u` file from `UDK_PATH/UDKGame/Script`. (For example, `Mods/LWCEGraphicsPack/Script` contains a symlink pointing to `UDK_PATH/UDKGame/Script/LWCEGraphicsPack.u`.)

At this point, if you launch XCOM, you should be running LWCE. The easiest way to confirm this is that the main menu will have a (non-functional) button called "Mod Settings". The next step is to enable the log window while playing, to make debugging much easier.

### Viewing XCOM logs

These steps assume you're playing through Steam. If not, they should still be applicable; you just need to apply the launch options to your own launcher method.

1. Find XCOM: Enemy Unknown in Steam. Right click it and select Properties.
2. At the bottom of the General section, you should see a "Launch Options" field. Enter the following: `--noRedScreens -noStartUpMovies -log -allowConsole`
3. Close the launch options and boot the game.

After the game starts, a separate window should open which contains log output. These logs are also written to a file which is overwritten every time the game launches. For me, the file is at `Documents/my games/XCOM - Enemy Within/XComGame/Logs/Launch.log`. Note that the log window is unbuffered, while the file is buffered, so you may not see the latest output in the file unless you close the game.

LWCE begins logging even at the main menu, without loading a game. To verify that LWCE is running properly, open the log file and search for `XComLongWarCommunityEdition`, which all LWCE log lines begin with. If you find it, congratulations - you're all set up to build and run Long War: Community Edition!