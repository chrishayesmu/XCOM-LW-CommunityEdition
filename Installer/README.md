These directories include the source code for the Long War Community Edition installer. None of the actual game logic is found here.

## Overview

The installer is written for [Electron](https://www.electronjs.org/), a cross-platform application library for writing apps in HTML, JS and CSS. We use an extremely simplistic architecture, because the installer itself is very simple.

You must have [NodeJS](https://nodejs.org/) installed to run the installer from source code. That is not necessary for running the packaged executable. To run from source, open a CLI to the `Installer` folder, and run `npm start` (npm is included with NodeJS).

## Packaging the installer for distribution

You must manually populate the contents of the `Resources` folder before packaging. At this time, there is no automation of that process. The folder structure largely matches that of the game itself, except that the `Mods` folder is not in a different location from the others, and `UPK patches` is not an actual game folder.

Once the `Resources` subfolders are populated, you can use [electron-builder](https://www.electron.build/) to package the app. If you've never used electron-builder before, then run:

```
npm install -g electron-builder
```

Once installed, run (this example builds for Windows):

```
npx electron-builder build --win portable
```

It will create the output file in the `dist/` directory within `Installer`.