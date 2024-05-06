/*******************************************************************************
 * UIMECInventory generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class UIMECInventory extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);

enum EUIWidgetIndices_MapList
{
    eWidgetIndex_BuildNewMec,
    eWidgetIndex_MecList,
    eWidgetIndex_MAX
};

var const localized string m_strMECInventoryTitle;
var const localized string m_strMECInventorySubTitle;
var const localized string m_strButtonUpgrade;
var const localized string m_strButtonRepair;
var const localized string m_strButtonBuild;
var const localized string m_strDescBuildNewMec;
var const localized string m_strMECEquipped;
var const localized string m_strMECUnequipped;
var const localized string m_sKeysToMecDeploymentTitle;
var const localized string m_sKeysToMecDeploymentDescription;
var XGCyberneticsUI m_kLocalMgr;
var string m_strCameraTag;
var name DisplayTag;
var private int m_iCurrentSelection;
var private UIWidgetHelper m_hWidgetHelper;
var protected int m_iView;

defaultproperties
{
    m_strCameraTag="CyberneticsLab_UIDisplayCam"
    DisplayTag=UIDisplay_CyberneticsLab
    s_package="/ package/gfxMECInventory/MECInventory"
    s_screenId="gfxMECInventory"
    e_InputState=eInputState_Evaluate
    s_name=theScreen
}