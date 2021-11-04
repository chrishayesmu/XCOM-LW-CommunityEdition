class XComMultiplayerTacticalUI extends XComMultiplayerUI
    notplaceable
    hidecategories(Navigation);
//complete stub

simulated function Init(XComPlayerController Controller){}
simulated function XComMPTacticalGRI GetTacticalGRI(){}
simulated function string GetGameType(){}
simulated function string GetMapName(){}
simulated function string GetPoints(){}
simulated function int GetSeconds(){}
simulated function string GetTurns(){}
simulated function string GetTopName(){}
simulated function string GetBottomName(){}
simulated function UniqueNetId GetTopUID(){}
simulated function UniqueNetId GetBottomUID(){}
simulated function SetCurrentPlayerTop(){}
simulated function SetCurrentPlayerBottom(){}
final simulated function XComMPTacticalPRI GetTopPlayer(){}
final simulated function XComMPTacticalPRI GetBottomPlayer(){}
simulated function bool IsLocalPlayerTheWinner(){}
simulated function bool DidLosingPlayerDisconnect(){}
