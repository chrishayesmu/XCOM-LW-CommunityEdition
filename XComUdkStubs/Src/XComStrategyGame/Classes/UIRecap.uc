/*******************************************************************************
 * UIRecap generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class UIRecap extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);

var const localized string m_strNext;
var const localized string m_strPrevious;
var const localized string m_strStat;
var const localized string m_strYou;
var const localized string m_strWorld;
var private int m_iPage;
var private XGRecapUI m_kMgr;

defaultproperties
{
    s_package="/ package/gfxRecap/Recap"
    s_screenId="gfxRecap"
    e_InputState=eInputState_Evaluate
    s_name=theRecap
}