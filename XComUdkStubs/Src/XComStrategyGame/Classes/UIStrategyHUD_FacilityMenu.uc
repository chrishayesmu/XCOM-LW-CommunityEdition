/*******************************************************************************
 * UIStrategyHUD_FacilityMenu generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class UIStrategyHUD_FacilityMenu extends UI_FxsPanel
    hidecategories(Navigation);

struct UIFacilityMenuOption
{
    var int iIndex;
    var int iState;
    var string strLabel;
    var bool bNeedsAttention;
    var XGFacility kFacility;

    structdefaultproperties
    {
        iIndex=-1
        strLabel="Default Label"
    }
};

var private bool bItemsLoaded;
var private bool bPumpDataPostItemLoad;
var private int m_iCurrentSelection;
var private array<UIFacilityMenuOption> m_arrUIFacilities;
var UIStrategyHUD_FacilitySubMenu m_kSubMenu;
var private XGFacility m_kInitFacility;

defaultproperties
{
    m_iCurrentSelection=-1
    s_name=theMenu.facilityMenu
}