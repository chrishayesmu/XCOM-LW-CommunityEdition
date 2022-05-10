const { app, BrowserWindow, dialog, ipcMain, shell } = require("electron");
const fs = require("fs");
const fsPromises = require("fs/promises");
const os = require("os");
const path = require("path");
const util = require('util')

const exec = util.promisify(require("child_process").exec);

// These are the bytestrings in the game executable that need to be modified as part of installation.
const bytestrings = [
    {
        "original":    Buffer.from([ 0xA9, 0xCE, 0x07, 0x00, 0x00, 0x0F, 0x84, 0xCC, 0x01, 0x00, 0x00 ]),
        "replacement": Buffer.from([ 0xA9, 0xCE, 0x07, 0x00, 0x00, 0x0F, 0x89, 0xCC, 0x01, 0x00, 0x00 ])
    },
    {
        "original":    Buffer.from([ 0x39, 0x7E, 0xFC, 0x75, 0x43, 0x8B, 0x0D, 0xEC, 0x7D ]),
        "replacement": Buffer.from([ 0x39, 0x7E, 0xFC, 0xEB, 0x43, 0x8B, 0x0D, 0xEC, 0x7D ])
    },
    {
        "original":    Buffer.from([ 0x7C, 0xAD, 0x84, 0xDB, 0x0F, 0x85, 0x86, 0x00, 0x00, 0x00 ]),
        "replacement": Buffer.from([ 0x7C, 0xAD, 0x84, 0xDB, 0x0F, 0x89, 0x86, 0x00, 0x00, 0x00 ])
    },
    {
        "original":    Buffer.from([ 0x8D, 0x44, 0x24, 0x38, 0x8B, 0xCF, 0x50, 0x74, 0x7A ]),
        "replacement": Buffer.from([ 0x8D, 0x44, 0x24, 0x38, 0x8B, 0xCF, 0x50, 0xEB, 0x7A ])
    }
];

const resourcePaths = {
    Config: path.resolve(__dirname, "Resources/Config"),
    CookedPCConsole: path.resolve(__dirname, "Resources/CookedPCConsole"),
    Localization: path.resolve(__dirname, "Resources/Localization"),
    Mods: path.resolve(__dirname, "Resources/Mods"),
    UpkPatches: path.resolve(__dirname, "Resources/UPK patches")
};

let debug = false; // TODO connect to argv
let logFileHandle = null;
let mainWindow = null;

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 600,
        height: 600,
        resizable: false,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    });

    mainWindow.loadFile("index.html");

    if (!debug) {
        mainWindow.setMenu(null);
    }

    mainWindow.webContents.on('new-window', function(e, url) {
        e.preventDefault();
        shell.openExternal(url);
    });
}

/**
 * Applies all bytecode patch files to the game UPKs.
 *
 * @param {string} cookedPcConsolePath The full path to the CookedPCConsole folder in the game installation.
 * @param {string} patchUpkPath The full path to the PatchUPK executable file.
 */
async function applyBytecodePatches(cookedPcConsolePath, patchUpkPath) {
    // Read files in directory and translate to absolute paths we can hand off to PatchUPK
    const patchFiles = (await fsPromises.readdir(resourcePaths.UpkPatches))
                                        .filter(f => !f.includes(".gitkeep") && !f.includes("uninstall"))
                                        .map(file => path.resolve(resourcePaths.UpkPatches, file));

    if (patchFiles.length === 0) {
        log("No UPK patches were found to apply!");
        return;
    }

    const tmpDir = os.tmpdir();
    const tmpPatchFilePath = path.resolve(tmpDir, "lwce-patch.txt");

    // Combine all patch files into one temporary file. There are a few reasons for this:
    //   1. It's faster to only run PatchUPK once.
    //   2. Executing one UPK patch generates just one uninstall file, if the user wants it.
    //   3. PatchUPK cannot be prevented from generating an uninstall file, and fails if it can't
    //      write said file. When the installer is packaged, it will try to write the uninstall file
    //      into the installer's executable, which will obviously fail and thus prevent patches
    //      from being applied at all.

    let combinedPatchFile = "";

    for (let i = 0; i < patchFiles.length; i++) {
        const fileContents = await fsPromises.readFile(patchFiles[i], { encoding: "utf8" });
        combinedPatchFile += fileContents + os.EOL;
    }

    await fsPromises.writeFile(tmpPatchFilePath, combinedPatchFile);
    log("Wrote patch file at " + tmpPatchFilePath);

    const sysCmd = `"${patchUpkPath}" "${tmpPatchFilePath}" "${cookedPcConsolePath}"`;

    log("Executing system command: " + sysCmd);

    try {
        await exec(sysCmd);
    }
    catch (e) {
        log("Error while applying bytecode patch: " + e.message);
        return; // TODO: fail install
    }
}

/**
 * Recursively copies all contents of sourceDir into destDir. In the event of any conflicts,
 * the copies from sourceDir will overwrite the destination entries.
 *
 * @param {string} sourceDir
 * @param {string} destDir
 */
async function copyResourceFiles(sourceDir, destDir) {
    log("Copying from " + sourceDir + " to " + destDir);

    await fsPromises.cp(sourceDir, destDir, {
        preserveTimestamps: true,
        recursive: true,
        filter: f => !f.includes(".gitkeep")
    });
}

/**
 * Checks several popular locations on the disk for XComEW.exe.
 *
 * @returns {string} The absolute path of XComEW.exe if located, or the empty string if not.
 */
function getBestGuessGameExePath() {
    let possiblePaths = [];

    if (process.platform == "win32") {
        possiblePaths = [
            "C:\\Program Files (x86)\\Steam\\SteamApps\\common\\XCom-Enemy-Unknown\\XEW\\Binaries\\Win32\\XComEW.exe",
            "D:\\Program Files (x86)\\Steam\\SteamApps\\common\\XCom-Enemy-Unknown\\XEW\\Binaries\\Win32\\XComEW.exe",
            "D:\\SteamLibrary\\steamapps\\common\\XCom-Enemy-Unknown\\XEW\\Binaries\\Win32\\XComEW.exe"
        ];
    }

    for (let i = 0; i < possiblePaths.length; i++) {
        if (fs.existsSync(possiblePaths[i])) {
            log("Determined XComEW executable exists at " + possiblePaths[i]);
            return possiblePaths[i];
        }
    }

    return "";
}

async function log(msg) {
    if (logFileHandle == null) {
        logFileHandle = await fsPromises.open(path.resolve(os.tmpdir(), "lwce-installer.log"), "w");
    }

    const d = new Date();
    const timestamp = "[" + d.toLocaleDateString() + " " + d.toLocaleTimeString() + "] ";
    logFileHandle.write(timestamp + msg + os.EOL);

    if (debug) {
        console.log(timestamp + msg);
    }
}

/**
 * Modifies the XComEW executable file by making replacements to specific strings of bytes.
 *
 * @param {string} exeFilePath The absolute path to XComEW.exe
 */
function modifyBinary(exeFilePath) {
    let i = 0;
    let filePos = 0;
    let replacementsDone = 0;

    log("Opening exe file for modification at path " + exeFilePath);

    // TODO: make method async
    const fileBuffer = Buffer.alloc(1024);
    const fd = fs.openSync(exeFilePath, "r+");

    // Read through the file, searching for our target bytestrings along the way and replacing them as needed
    while (replacementsDone < bytestrings.length && fs.readSync(fd, fileBuffer, { length: fileBuffer.byteLength, position: filePos }) > 0) {
        for (i = 0; i < bytestrings.length; i++) {
            const matchIndex = fileBuffer.indexOf(bytestrings[i].original);

            if (matchIndex >= 0) {
                const writePos = filePos + matchIndex;
                log("Found match for bytestring " + i + " at position " + writePos);

                const replacement = bytestrings[i].replacement;
                fs.writeSync(fd, replacement, /* offset */ 0, /* length */ replacement.byteLength, writePos);

                replacementsDone++;
            }
        }

        // Advance position by less than the buffer size, thus guaranteeing that if
        // a bytestring spans across two reads, we'll catch it completely in one or the other.
        // (This won't work if a bytestring is more than 24 bytes, but none are currently.)
        filePos += fileBuffer.byteLength - 24;
    }

    fs.closeSync(fd);
    log(`Binary modification of exe file complete. ${replacementsDone} bytestring instances were found and replaced.`);
}

/**
 * Modifies ini files in the base game, for places that can't be changed otherwise.
 *
 * @param {string} configPath The absolute path to the game's Config folder
 */
async function modifyGameConfig(configPath) {
    // Since this ini file is pretty small, we just read the whole thing at once, change it, and write it back
    const engineCfgPath = path.resolve(configPath, "DefaultEngine.ini");
    const gameEngineString = "GameEngine=XComLongWarCommunityEdition.LWCE_XComEngine";
    const consoleClassString = "ConsoleClassName=XComLongWarCommunityEdition.LWCE_Console";

    let fileContents = await fsPromises.readFile(engineCfgPath, { encoding: "utf8" });

    // A few weird patterns to match here. Ideally we could just modify Engine/XComEngine.ini, but if anyone has
    // the same entry in Config/DefaultEngine.ini, that one would take priority, and that breaks LWCE completely.
    if (fileContents.includes("GameEngine=")) {
        if (fileContents.includes("ConsoleClassName=")) {
            log("Found (and replacing) both target keys for [Engine.Engine]");
            // If both keys are present, replace them individually
            fileContents = fileContents.replace("GameEngine=Engine.GameEngine", gameEngineString)
                                       .replace("ConsoleClassName=Engine.Console", consoleClassString);
        }
        else {
            // If only the GameEngine key is present, append the ConsoleClassName key right after it
            log("Found only the GameEngine target key for [Engine.Engine]; replacing and appending");
            fileContents = fileContents.replace("GameEngine=Engine.GameEngine", gameEngineString + os.EOL + consoleClassString);
        }
    }
    else if (fileContents.includes("[Engine.Engine]")) {
        // In case the Engine config is present but somehow lacking both keys
        log("Did not find target keys in [Engine.Engine], appending them");
        fileContents = fileContents.replace("[Engine.Engine]", "[Engine.Engine]" + os.EOL + gameEngineString + os.EOL + consoleClassString);
    }
    else {
        // If someone somehow doesn't even have [Engine.Engine] in their config file
        log("[Engine.Engine] config missing entirely, adding new section");
        fileContents += os.EOL + "[Engine.Engine]" + os.EOL + gameEngineString + os.EOL + consoleClassString;
    }

    await fsPromises.writeFile(engineCfgPath, fileContents);
}

function updateInstallationProgress(text) {
    log(text);
    mainWindow.webContents.send("installation-progress", { title: text });
}

app.whenReady().then(() => {
    createWindow();

    if (debug) {
        mainWindow.webContents.openDevTools();
    }

    app.on("activate", () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow();
        }
    });
});

app.on("window-all-closed", () => {
    if (process.platform !== "darwin") {
        app.quit();
    }
});

ipcMain.handle("get-ew-exe-best-guess", () => {
    return getBestGuessGameExePath();
});

ipcMain.handle("open-file-picker-dialog", (_event, params) => {
    return dialog.showOpenDialogSync(mainWindow, {
        title: params.title,
        properties: ["openFile"],
        defaultPath: params.defaultPath,
        filters: [{
            name: "Executable", extensions: ["exe"]
        }]
    });
});

ipcMain.on("begin-installation", async (_event, params) => {
    const ewExePath = params.exePath;
    const xcomGameDirPath = path.resolve(ewExePath, "../../../XComGame/");
    const patchUpkPath = params.patchUpkPath;

    const pathsObj = {
        Config: path.resolve(xcomGameDirPath, "./Config"),
        CookedPCConsole: path.resolve(xcomGameDirPath, "./CookedPCConsole"),
        ExeFile: ewExePath,
        Localization: path.resolve(xcomGameDirPath, "./Localization"),
        Mods: path.resolve(xcomGameDirPath, "./Mods"),
        PatchUPK: patchUpkPath
    };

    log("Beginning installation process");

    updateInstallationProgress("Modifying game executable..");
    modifyBinary(pathsObj.ExeFile);

    updateInstallationProgress("Patching base game UPKs..");
    await applyBytecodePatches(pathsObj.CookedPCConsole, pathsObj.PatchUPK);

    updateInstallationProgress("Updating base game INIs..");
    await modifyGameConfig(pathsObj.Config);

    updateInstallationProgress("Copying config files..");
    await copyResourceFiles(resourcePaths.Config, pathsObj.Config);

    updateInstallationProgress("Copying localization files..");
    await copyResourceFiles(resourcePaths.Localization, pathsObj.Localization);

    updateInstallationProgress("Copying UPK files..");
    await copyResourceFiles(resourcePaths.CookedPCConsole, pathsObj.CookedPCConsole);

    updateInstallationProgress("Copying LWCE-included mods..");
    await copyResourceFiles(resourcePaths.Mods, pathsObj.Mods);

    log("Installation process complete");
    mainWindow.webContents.send("installation-complete");
});

ipcMain.on("close-installer", () => {
    log("Closing installer app..");
    app.exit(0);
});