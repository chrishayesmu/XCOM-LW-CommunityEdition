class UITerrorInfo extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var XGAIPlayer_Animal m_civilians;
var string m_sTotalImage;
var string m_sSavedImage;
var string m_sLostImage;
var const localized string m_sCivsRemaining;
var const localized string m_sCivsSaved;
var const localized string m_sCivsLost;

defaultproperties
{
    m_sTotalImage="<img src='img:///gfxTerrorInfo.CiviliansTOTAL'  align='baseline' vspace='-5'>"
    m_sSavedImage="<img src='img:///gfxTerrorInfo.CiviliansSAVED' align='baseline' vspace='-5'>"
    m_sLostImage="<img src='img:///gfxTerrorInfo.CiviliansLOST' align='baseline' vspace='-5'>"
    s_package="/ package/gfxTerrorInfo/TerrorInfo"
    s_screenId="gfxTerrorInfo"
    s_name="theTerrorInfo"
}