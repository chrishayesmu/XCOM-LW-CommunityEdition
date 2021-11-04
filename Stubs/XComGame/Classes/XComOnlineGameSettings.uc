class XComOnlineGameSettings extends OnlineGameSettings
    abstract
    config(MPGame);
//complete stub


var config bool DEBUG_bChangeRankedGameOptions;

function SetMPDataINIVersion(int iINIVersion){}
function int GetMPDataINIVersion(){}
function SetNetworkType(EMPNetworkType eNetworkType){}
function EMPNetworkType GetNetworkType(){}
function SetGameType(EMPGameType eGameType){}
function EMPGameType GetGameType(){}
function SetTurnTimeSeconds(int iTurnTime){}
function int GetTurnTimeSeconds(){}
function SetMaxSquadCost(int iSquadCost){}
function int GetMaxSquadCost(){}
function SetIsRanked(bool bIsRanked){}
function bool GetIsRanked(){}
function SetRankedNetworkType(EMPNetworkType eNetworkType, bool bIsRanked){}
function SetMapIndex(int iMapindex){}
function int GetMapIndex(){}
function string GetMapDisplayName(){}
function string GetMapFileName(){}
function int GetHostRankedRating(){}
function SetByteCodeHash(string sByteCodeHash){}
function string GetByteCodeHash(){}
function string ToString(){}
