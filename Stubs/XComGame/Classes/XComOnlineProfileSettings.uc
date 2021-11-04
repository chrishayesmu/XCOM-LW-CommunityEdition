class XComOnlineProfileSettings extends OnlineProfileSettings
    native(Core)
    config(Content)
	dependson(XComOnlineProfileSettingsDataBlob);
//complete  stub
const NumLoadoutSlots = 8;

struct native TSSMPLoadoutData
{
    var array<TTransferSoldier> m_aTransferSoldiers;
    var ETeam m_eTeam;
};

var globalconfig array<config UISPLoadout_Unit> LoadoutSlots;
var globalconfig array<config UIMPLoadout_Unit> MultiplayerLoadoutSlots;
var globalconfig array<config UIMPLoadout_Squad> MultiplayerLoadoutSquads;
var XComOnlineProfileSettingsDataBlob Data;
var array<TTransferSoldier> m_aSoldiers;
var TSSMPLoadoutData m_aSSMPLoadoutData[2];

function ExtendedLaunch_InitToDefaults(){}
event ExtendedLaunch_BuildSoldiers(array<UISPLoadout_Unit> aUISoldiers){}
static function ExtendedLaunch_BuildSoldiersFromParts(out array<TTransferSoldier> aSoldiers, array<UISPLoadout_Unit> aUISoldiers, XGCharacterGenerator CharGen){}
event SetToDefaults(){}
simulated function ApplyOptionsSettings(){}
simulated function ApplyAudioOptions(){}
function Options_ResetToDefaults(bool bInShell){}
simulated function ApplyUIOptions(){}
// Export UXComOnlineProfileSettings::execGetGammaNative(FFrame&, void* const)
native simulated function float GetGammaNative();

// Export UXComOnlineProfileSettings::execSetGammaNative(FFrame&, void* const)
native simulated function SetGammaNative(float NewGamma);

simulated function ApplyVideoOptions(){}
native function SetGlobalAudioVolume(float fVolume);

simulated function MPLoadoutSquads_InitToDefaults(){}
simulated function int GetLoadoutUnitCount(){}
simulated function UIMPLoadout_Unit GetLoadoutUnit(int iIndex){}
simulated function int GetLoadoutCount(){}
simulated function UIMPLoadout_Squad GetLoadout(int iIndex){}
simulated function int GetLoadoutId(int iIndex){}
simulated function int GetCurrentLoadoutId(){}
simulated function SetCurrentLoadout(int iIndex){}
simulated function SetCurrentLoadoutId(int iLoadoutId){}
simulated function int GetDefaultLoadoutId(){}
simulated function string GetCurrentLoadoutName(){}
simulated function SetLoadoutName(int iLoadoutId, string strNewName){}
simulated function string GetLoadoutName(int iLoadoutId){}
simulated function string GetLoadoutLanguage(int iLoadoutId){}
simulated function int GetNextLoadoutId(){}
simulated function int CreateNewLoadout(string strNewLoadoutName){}
simulated function int CloneLoadout(int iOldLoadoutId, string strNewLoadoutName){}
simulated function DeleteLoadoutData(int iLoadoutId, optional bool bRemoveLoadoutId){}
