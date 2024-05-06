/*******************************************************************************
 * XGPsiLabsUI generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGPsiLabsUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EBaseView
{
    ePsiLabsView_Main,
    ePsiLabsView_Add,
    ePsiLabsView_Results,
    ePsiLabsView_MAX
};

struct TSoldierTable
{
    var TTableMenu mnuSoldiers;

    structdefaultproperties
    {
        mnuSoldiers=(arrCategories=none,kHeader=(arrStrings=none,arrStates=none),arrOptions=none,bTakesNoInput=false)
    }
};

struct TPsiTraineeList
{
    var TText txtTitle;
    var TTableMenu mnuSlots;
    var TButtonText btxtChoose;

    structdefaultproperties
    {
        txtTitle=(StrValue="",iState=0)
        mnuSlots=(arrCategories=none,kHeader=(arrStrings=none,arrStates=none),arrOptions=none,bTakesNoInput=false)
        btxtChoose=(StrValue="",iState=0,iButton=0)
    }
};

struct TPsiResultsList
{
    var TText txtTitle;
    var TTableMenu mnuResults;

    structdefaultproperties
    {
        txtTitle=(StrValue="",iState=0)
        mnuResults=(arrCategories=none,kHeader=(arrStrings=none,arrStates=none),arrOptions=none,bTakesNoInput=false)
    }
};

var TPsiTraineeList m_kTraineeList;
var TPsiResultsList m_kResults;
var TSoldierTable m_kSoldierTable;
var int m_iHighlightedSlot;
var int m_iTraineeToBeRemoved;
var bool m_bGift;
var const localized string m_strLabelCurrentTestSubjects;
var const localized string m_strLabelRemoveSoldier;
var const localized string m_strLabelAddSoldier;
var const localized string m_strLabelHours;
var const localized string m_strLabelDays;
var const localized string m_strLabelTestResults;
var const localized string m_strItemEmpty;
var const localized string m_strItemGifted;
var const localized string m_strItemNoGift;
var private const localized string m_strConfirmRemovalDialogTitle;
var private const localized string m_strConfirmRemovalDialogText;
var private const localized string m_strConfirmRemovalDialogAcceptText;
var const localized string m_strPsiLabsPostHelpTitle;
var const localized string m_strPsiLabsPostHelpBody;
var const localized string m_strPsiLabsPostHelpOK;