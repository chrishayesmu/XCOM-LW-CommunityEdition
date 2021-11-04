class XComPlayerController_PendingLevel extends XComPlayerController
    native(Core)
    config(Game)
    hidecategories(Navigation);

// Export UXComPlayerController_PendingLevel::execEngineLevelDisconnect(FFrame&, void* const)
native function EngineLevelDisconnect();

simulated function OnDestroyedOnlineGame(name SessionName, bool bWasSuccessful){}

//function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful){}

DefaultProperties
{
}
