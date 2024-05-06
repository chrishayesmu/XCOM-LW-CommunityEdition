/*******************************************************************************
 * UISquadSelect_SquadList generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class UISquadSelect_SquadList extends UI_FxsPanel
    hidecategories(Navigation);

struct UISquadList_UnitBox
{
    var int iIndex;
    var string strName;
    var string strNickName;
    var string classDesc;
    var string classLabel;
    var string item1;
    var string item2;
    var int iStatus;
    var bool bPromote;
    var bool bEmpty;
    var bool bUnavailable;
    var bool bHint;

    structdefaultproperties
    {
        iIndex=-1
        bEmpty=true
    }
};

var const localized string m_strPromote;
var const localized string m_strAddUnit;
var const localized string m_strEditUnit;
var const localized string m_strClearUnit;
var const localized string m_strBackpackLabel;
var protected int m_iCurrentSelection;
var protected array<UISquadList_UnitBox> m_arrUIOptions;
var protected array<int> m_arrFillOrderIndex;
var protected bool bCanNavigate;
var protected bool m_bInSoldierView;
var protected int m_iMaxSlots;

defaultproperties
{
    m_iMaxSlots=6
    s_name=theSquadList
}