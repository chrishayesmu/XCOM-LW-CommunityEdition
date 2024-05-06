class XComOnlineProfileSettings extends OnlineProfileSettings
    native(Core)
    dependson(XComOnlineProfileSettingsDataBlob)
    config(Content);

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

defaultproperties
{
    // ProfileSettingIds=/* Array type was not detected. */
    // DefaultSettings=/* Array type was not detected. */
    VersionNumber=36
}