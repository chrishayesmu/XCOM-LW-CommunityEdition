interface XComMCPEventListener extends Interface;
//complete stub

simulated event OnMCPInitialized(EMCPInitStatus eInitStatus);

simulated event OnGetINIFromServerCompleted(bool bSuccess, string INIFilename, string strINIContents);