/*******************************************************************************
 * UIObjectivesScreen generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class UIObjectivesScreen extends UI_FxsScreen
    hidecategories(Navigation);

var const localized string m_strBack;
var const localized string m_strMoreInfo;
var const localized string m_strObjectives;
var bool m_isLarge;
var private UISituationRoom m_kSitRoom;
var private string m_strBriefText;
var private string m_strLargeText;

defaultproperties
{
    s_package="/ package/gfxObjectivesScreen/ObjectivesScreen"
    s_screenId="gfxObjectivesScreen"
    e_InputState=eInputState_Evaluate
    s_name=theScreen
}