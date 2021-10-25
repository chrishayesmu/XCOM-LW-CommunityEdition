# XCOM Long War Highlander

The **XCOM Long War Highlander**, named in the spirit of the [XCOM 2 WOTC Community Highlander](https://github.com/X2CommunityCore/X2WOTCCommunityHighlander) (but otherwise unassociated with that project), is a community effort with four main goals:

* Provide a version of Long War 1.0 with as many bugs fixed as possible.
* Roll some Quality of Life (QOL) changes into the game without requiring additional mods.
* Open up Long War's gameplay to configuration via ini files.
* Expose modding hooks for modders to use when ini changes aren't sufficient.

Each of these is explored individually in more depth [below](#project-goals).

Like XCOM 2's Highlander, the name is inspired by [the movie's](https://en.wikipedia.org/wiki/Highlander_(film)) line "there can be only one". Specifically, due to this mod's extensive overriding of base game classes, it is unlikely to be compatible with other mods that perform significant modifications. This limitation is why part of the goal of the Highlander is to expose modding APIs, allowing fully-featured mods to be built on top of the Highlander without conflicting.

# Installation

This section is TBD.

# Project goals

## Bug fixes

There are a number of bugs in Long War 1.0, which were either introduced by Long War, or existed in vanilla Enemy Within. They can be broadly classed into two categories:

1. Bugs that impact the QOL, but not difficulty.
2. Bugs which have an impact on game balance.

An example of the first category is that when purchasing Interceptors in XCOM HQ, after submitting the order, the amount of money you have doesn't visibly update right away. It does update behind the scenes, so this doesn't cause any problems, but it is a small bug that can be annoying.

In the second category, we have bugs such as the smoke defense bonus not applying to overwatch shots. Fixing this does impact the game balance, because now you can make it significantly safer for your units to run overwatch.

When there are bug fixes in the second category, the Highlander does not enable those fixes right away. Instead, the bug fix can be enabled using an ini variable, and the normal Long War 1.0 behavior is used otherwise. This allows the Highlander to be used by anyone who wants its quality of life improvements, while not differing from the Long War 1.0 experience.

For a list of Long War bugs tracked and/or fixed by the Highlander, [see here](https://github.com/chrishayesmu/XCOM-LW-Highlander/issues?q=is%3Aopen+is%3Aissue+label%3Abase-game-bug).

## Quality of life changes

This section is TBD.

## Exposing configuration

Long War has sophisticated logic throughout its various systems, but due to the limited modding techniques available at the time it was written, the authors were unable to add new ini files and variables. This meant they could only make functionality configurable by hijacking a configuration variable that existed in Enemy Within. Thanks to newer modding techniques, we can now get around this and offer additional ini files to make the Long War experience far more personalizable.

For an example of the types of configuration now possible, take a look at [DefaultHighlanderStrategyAI.ini](Config/DefaultHighlanderStrategyAI.ini).

## Modding hooks

A system for new mod hooks has not been determined yet.

Mutator-based mods are still supported, as in Long War 1.0; however if these mods conflict with the Highlander (e.g. by overriding the same class as the Highlander does) their interaction may be unpredictable.

# Building the Highlander locally

This project uses macros defined in the file `SrcOrig/XComGame/Globals.uci`. To build the Highlander locally, you will need this file present in your UDK environment, at `<UDK root>/Development/Src/XComGame/Globals.uci`. The simplest way to accomplish this is to create a symbolic link pointing at the file in your local Highlander repo, so that your build environment remains in sync with the latest changes.