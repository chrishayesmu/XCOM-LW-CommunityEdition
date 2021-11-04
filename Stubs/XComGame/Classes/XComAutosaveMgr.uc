class XComAutosaveMgr extends Actor
	dependson(XComOnlineEventMgr);
//complete stub

const MAX_TACTICAL_AUTOSAVES = 3;

var bool m_bWasIronman;

delegate WriteSaveGameComplete(bool bWasSuccessful);
function Init();
function bool WasIronman(){}
function DoAutosave(bool bIsIronman, optional delegate<WriteSaveGameComplete> AutoSaveCompleteCallback){}
function DoQuicksave(bool bIsIronman, optional delegate<WriteSaveGameComplete> QuicksaveCompleteCallback){}
function int GetNextSaveID(){}
function bool AutosaveEnabled(bool bIsIronman){}
function bool SavingEnabled(){}
