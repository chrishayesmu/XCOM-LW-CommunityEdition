class UIKeybindingsPCScreen extends UI_FxsScreen
    native(UI)
    notplaceable
    hidecategories(Navigation)
    dependson(XComKeybindingData);

struct native UIKeyBind
{
    var init string UserLabel;
    var KeyBind PrimaryBind;
    var KeyBind SecondaryBind;
    var bool BlockUnbindingPrimaryKey;
};

var const localized string m_strTitle;
var const localized string m_strGeneralBindingsCategoryLabel;
var const localized string m_strTacticalBindingsCategoryLabel;
var const localized string m_strResetBindingsButtonLabel;
var const localized string m_strSaveAndExitButtonLabel;
var const localized string m_strCancelButtonLabel;
var const localized string m_strPrimaryBindingsColumnHeader;
var const localized string m_strSecondaryBindingsColumnHeader;
var const localized string m_strPressKeyLabel;
var const localized string m_strConfirmResetBindingsDialogTitle;
var const localized string m_strConfirmResetBindingsDialogText;
var const localized string m_strConfirmDiscardChangesTitle;
var const localized string m_strConfirmDiscardChangesText;
var const localized string m_strConfirmDiscardChangesAcceptButton;
var const localized string m_strConfirmDiscardChangesCancelButton;
var const localized string m_strConfirmConflictingBindDialogTitle;
var const localized string m_strConfirmConflictingBindDialogText;
var const localized string m_strConfirmConflictingBindDialogAcceptButton;
var const localized string m_strConfirmConflictingBindDialogCancelButton;

var init array<init UIKeyBind> m_arrBindings;
var KeybindCategories m_eBindingCategory;
var PlayerController m_kBaseInputController;
var XComTacticalController m_kTacticalInputController;
var XComKeybindingData m_kKeybindingData;
var array<PlayerInput> m_arrDirtyPlayerInputs;
var bool m_bAwaitingInputForBind;
var bool m_bAlreadyProcessingRawInput;
var bool m_bSecondaryKeyBeingBound;
var bool m_bSecondaryKeyConflicting;
var bool m_bKeybindindsChanged;
var int m_iKeySlotBeingBound;
var int m_iKeySlotConflicting;
var KeyBind m_kCachedKeyBeingBound;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function InitInputClasses(){}
simulated function OnInit(){}
simulated function UpdateBindingsList(){}
simulated function DisplayBindings(){}
simulated function bool OnUnrealCommand(int Cmd, int Actionmask){}
simulated function bool IsBindable(name Key){}
simulated function bool RawInputHandler(name Key, int Actionmask, bool bCtrl, bool bAlt, bool bShift){}
final function string GetCommandForKeyBeingBound(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function DisplayConfirmResetBindingsDialog(){}
function OnDisplayConfirmResetBindingsDialogAction(EUIAction eAction){}
function DisplayConfirmCancelDialog(){}
function OnDisplayConfirmCancelDialog(EUIAction eAction){}
function DisplayConflictingKeyDialog(){}
function OnDisplayConflictingKeyDialog(EUIAction eAction){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function bool OnAccept(optional string Arg = ""){}
simulated function bool OnCancel(optional string Arg = ""){}

native simulated function ReadBindings();
native simulated function ReloadPlayerInputBindings();
native simulated function ResetPlayerInputBindings();
native simulated function int IsKeyAlreadyBound(name Key, bool bCtrl, bool bAlt, bool bShift);
native simulated function bool BlockUnbindingOfPrimaryKey(int enumIndex);

simulated function AS_SetTitle(string txt){}
simulated function AS_SetTabLabels(string tab1, string TAB2, optional string TAB3){}
simulated function AS_SetColumnLabels(string primaryColumn, string secondaryColumn){}
simulated function AS_SetButtonLabels(string resetToDefaultsButtonLabel, string backButtonLabel, string acceptButtonLabel){}
simulated function AS_SetPressKeyText(string txt){}
simulated function AS_AddKeyBindingSlot(string Label, string PrimaryKey, string SecondaryKey, bool BlockUnbindingPrimaryKey){}
simulated function AS_ClearBindingsList(){}
simulated function AS_ActivateSlot(int Index, bool secondarySlot){}
simulated function AS_DeactivateSlot(int Index, bool secondarySlot){}
simulated function AS_SetNewKey(int Index, bool secondarySlot, string newKey){}
simulated function AS_ClearSlot(int Index, bool secondarySlot){}
simulated function AS_ActivateTab1(){}
simulated function AS_ActivateTab2(){}

simulated function Deactivate(){}
event DestroyInputClasses(){}