const { ipcRenderer } = require('electron');

const stepContainer = document.getElementById("setup-contents");
const nextButton = document.getElementById("nav-bar-next");
const previousButton = document.getElementById("nav-bar-previous");
const cancelButton = document.getElementById("nav-bar-cancel");

const installSettings = {};

const installStep = 2;
let currentStep = 0;

let isInstallationComplete = false;

function copyInstallSettings() {
    installSettings.exePath = document.getElementById("xew-file-selector-display").value;
    installSettings.patchUpkPath = document.getElementById("patchupk-file-selector-display").value;
}

function validateInstallSettings() {
    let isValid = true;

    if (!installSettings.exePath) {
        isValid = false;
        document.getElementById("xew-file-selector-display").classList.add("invalid");
    }

    if (!installSettings.patchUpkPath) {
        isValid = false;
        document.getElementById("patchupk-file-selector-display").classList.add("invalid");
    }

    // TODO make sure files exist and are correct as much as possible

    return isValid;
}

async function goToStep(stepNum) {
    // Before unloading the settings page, copy the settings
    if (currentStep === installStep - 1) {
        copyInstallSettings();

        // TODO show error to user
        if (!validateInstallSettings()) {
            return;
        }
    }

    currentStep = stepNum;

    const stepHtml = await fetch("html/step_" + stepNum + ".html").then(response => response.text());
    stepContainer.innerHTML = stepHtml;

    const versionPlaceholders = [...document.querySelectorAll(".replace-with-version")];
    versionPlaceholders.forEach(e => e.replaceWith("PLACEHOLDER STRING"));

    if (stepNum === 0 || stepNum == installStep) {
        previousButton.classList.add("hidden");
    }
    else {
        previousButton.classList.remove("hidden");
    }

    if (stepNum === installStep) {
        nextButton.setAttribute("disabled", "");
    }
    else {
        nextButton.removeAttribute("disabled");
    }

    if (stepNum === installStep - 1) {
        nextButton.innerText = "Install";
    }
    else {
        nextButton.innerText = "Next";
    }

    if (stepNum === 1) {
        // TODO: adjust paths and wording based on platform
        const possibleGameExePath = await ipcRenderer.invoke("get-ew-exe-best-guess");
        document.getElementById("xew-file-selector-display").value = possibleGameExePath;

        document.getElementById("xew-file-selector-btn").addEventListener("click", async () => {
            const selectedPath = await ipcRenderer.invoke("open-file-picker-dialog", {
                title: "Select XComEW.exe",
                defaultPath: possibleGameExePath
            });

            if (selectedPath) {
                document.getElementById("xew-file-selector-display").classList.remove("invalid");
                document.getElementById("xew-file-selector-display").value = selectedPath;
            }
        });

        document.getElementById("patchupk-file-selector-btn").addEventListener("click", async () => {
            const selectedPath = await ipcRenderer.invoke("open-file-picker-dialog", {
                title: "Select PatchUPK.exe",
                defaultPath: document.getElementById("patchupk-file-selector-display").value
            });

            if (selectedPath) {
                document.getElementById("patchupk-file-selector-display").classList.remove("invalid");
                document.getElementById("patchupk-file-selector-display").value = selectedPath;
            }
        });
    }
}

nextButton.addEventListener("click", async () => {
    if (isInstallationComplete) {
        ipcRenderer.send("close-installer");
        return;
    }

    goToStep(currentStep + 1);

    if (currentStep === installStep) {
        cancelButton.classList.add("hidden");
        nextButton.classList.add("hidden");
        previousButton.classList.add("hidden");

        ipcRenderer.send("begin-installation", installSettings);
    }
});

previousButton.addEventListener("click", async () => {
    if (currentStep === 0) {
        return;
    }

    goToStep(currentStep - 1);
});

ipcRenderer.on("installation-progress", (_event, params) => {
    // Need a short delay because our DOM element is added at the same time as this fires
    setTimeout(() => {
        const progressContainer = document.getElementById("installer-output");

        progressContainer.innerHTML += params.title + "<br/>";
    }, 250);
});

ipcRenderer.on("installation-complete", () => {
    setTimeout(() => {
        const progressContainer = document.getElementById("installer-output");
        progressContainer.innerHTML += "<br/><span style='font-weight: bold; color: green'>Installation successful!</span>";

        isInstallationComplete = true;

        nextButton.innerText = "Finish";
        nextButton.removeAttribute("disabled");
        nextButton.classList.remove("hidden");
    }, 250);
});

goToStep(0);