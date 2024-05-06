class UIKeybindingsPCScreen extends UI_FxsScreen
    native(UI)
    dependson(XComKeybindingData)
    notplaceable
    hidecategories(Navigation);

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

defaultproperties
{
    s_package="/ package/gfxPCKeybindingsScreen/PCKeybindingsScreen"
    s_screenId="gfxPCKeybindingsScreen"
    e_InputState=eInputState_Consume
    s_name="theScreen"
}