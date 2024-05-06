/*******************************************************************************
 * XGManufacturingUI generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGManufacturingUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EManufacturingView
{
    eManView_Item,
    eManView_Facility,
    eManView_Foundry,
    eManView_MAX
};

enum EManButton
{
    eManButt_None,
    eManButt_SubmitOrder,
    eManButt_CancelOrder,
    eManButt_ToTop,
    eManButt_MAX
};

enum EManButtonStates
{
    eManButtState_NotVisible,
    eManButtState_Disabled,
    eManButtState_Unselected,
    eManButtState_Highlighted,
    eManButtState_MAX
};

struct TManWidget
{
    var TText txtTitle;
    var TButtonText txtItemInfoButton;
    var TImage imgItem;
    var TText txtQuantity;
    var TText txtQuantityLabel;
    var TButtonText txtQuantityHelp;
    var bool bCanAdjustQuantity;
    var TText txtEngineers;
    var TText txtEngineersLabel;
    var TButtonText txtEngHelp;
    var TLabeledText txtProjDuration;
    var TText txtResourcesLabel;
    var TCostSummary kCost;
    var TText txtNotesLabel;
    var TText txtNotes;
    var TText txtProblem;
    var TButtonText txtRushButton;
    var TButtonText txtNotifyButton;
    var array<TButtonText> arrButtons;

    structdefaultproperties
    {
        txtTitle=(StrValue="",iState=0)
        txtItemInfoButton=(StrValue="",iState=0,iButton=0)
        imgItem=(iImage=0,strLabel="",iState=0,strPath="")
        txtQuantity=(StrValue="",iState=0)
        txtQuantityLabel=(StrValue="",iState=0)
        txtQuantityHelp=(StrValue="",iState=0,iButton=0)
        bCanAdjustQuantity=false
        txtEngineers=(StrValue="",iState=0)
        txtEngineersLabel=(StrValue="",iState=0)
        txtEngHelp=(StrValue="",iState=0,iButton=0)
        txtProjDuration=(StrValue="",strLabel="",iState=0,bNumber=false)
        txtResourcesLabel=(StrValue="",iState=0)
        kCost=(arrRequirements=none,strHelp="")
        txtNotesLabel=(StrValue="",iState=0)
        txtNotes=(StrValue="",iState=0)
        txtProblem=(StrValue="",iState=0)
        txtRushButton=(StrValue="",iState=0,iButton=0)
        txtNotifyButton=(StrValue="",iState=0,iButton=0)
        arrButtons=none
    }
};

var TButtonBar m_kButtonBar;
var TManWidget m_kWidget;
var TImage m_imgBG;
var TItemProject m_kIProject;
var TFacilityProject m_kFProject;
var TFoundryProject m_kFoundProject;
var bool m_bCanRush;
var bool m_bCanAfford;
var bool m_bCanCancel;
var bool m_bSatCapacity;
var bool m_bAllowDeleteOrder;
var array<int> m_arrButtons;
var int m_iHighlightedButton;
var int m_iAddedEngineers;
var const localized string m_strLabelItemInfo;
var const localized string m_strLabelQuantity;
var const localized string m_strLabelProjectDuration;
var const localized string m_strLabelEngineersAssigned;
var const localized string m_strLabelProjectCost;
var const localized string m_strLabelNotes;
var const localized string m_strLabelRushBuild;
var const localized string m_strLabelYES;
var const localized string m_strLabelNO;
var const localized string m_strLabelSubmitOrder;
var const localized string m_strLabelModifyOrder;
var const localized string m_strLabelModifyBeginBuild;
var const localized string m_strLabelContinueBuild;
var const localized string m_strLabelBeginProject;
var const localized string m_strLabelContinueProject;
var const localized string m_strLabelCancelBuild;
var const localized string m_strLabelDeleteProject;
var const localized string m_strLabelFacilityInfo;
var const localized string m_strLabelTimeToBuild;
var const localized string m_strLabelDeleteOrder;
var const localized string m_strLabelProjectInfo;
var const localized string m_strLabelTimeToComplete;
var const localized string m_strBackLabel;
var const localized string m_strETADays;
var const localized string m_strNoteWeaponRifle;
var const localized string m_strNoteWeaponAllSoldiers;
var const localized string m_strNoteWeaponSpecific;
var const localized string m_strNoteInsufficientBays;
var const localized string m_strNoteBuildStalled;
var const localized string m_strNoteMaintenanceCost;
var const localized string m_strNoteFoundryStalled;
var const localized string m_strHelpAdjust;
var const localized string m_strErrEngineers;
var const localized string m_strLabelImmediate;
var const localized string m_strHelp;
var const localized string m_strSatCapacity;