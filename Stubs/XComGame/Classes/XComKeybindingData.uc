class XComKeybindingData extends Object
    native(UI);
//complete stub

enum KeybindCategories
{
    eKC_General,
    eKC_Tactical,
    eKC_MAX
};

enum GeneralBindableCommands
{
    eGBC_Confirm,
    eGBC_Cancel,
    eGBC_NavigateUp,
    eGBC_NavigateDown,
    eGBC_NavigateLeft,
    eGBC_NavigateRight,
    eGBC_MAX
};

enum TacticalBindableCommands
{
    eTBC_EnterShotHUD_Confirm,
    eTBC_Pause,
    eTBC_Path,
    eTBC_Interact,
    eTBC_SwapWeapon,
    eTBC_EndTurn,
    eTBC_Chat,
    eTBC_MoreInfo,
    eTBC_CamCenterOnActiveUnit,
    eTBC_CamMoveUp,
    eTBC_CamMoveDown,
    eTBC_CamMoveLeft,
    eTBC_CamMoveRight,
    eTBC_CamRotateLeft,
    eTBC_CamRotateRight,
    eTBC_CamZoomIn,
    eTBC_CamZoomOut,
    eTBC_CamFreeZoom,
    eTBC_CamToggleZoomLevel,
    eTBC_CursorUp,
    eTBC_CursorDown,
    eTBC_NextUnit,
    eTBC_PrevUnit,
    eTBC_AbilityOverwatch,
    eTBC_AbilityReload,
    eTBC_Ability1,
    eTBC_Ability2,
    eTBC_Ability3,
    eTBC_Ability4,
    eTBC_Ability5,
    eTBC_Ability6,
    eTBC_Ability7,
    eTBC_Ability8,
    eTBC_Ability9,
    eTBC_Ability0,
    eTBC_Target1,
    eTBC_Target2,
    eTBC_Target3,
    eTBC_Target4,
    eTBC_Target5,
    eTBC_Target6,
    eTBC_Target7,
    eTBC_Target8,
    eTBC_QuickSave,
    eTBC_ToggleOverheadCam,
    eTBC_AbilityHunkerDown,
    eTBC_MAX
};

enum LocalizedKeyNames
{
    eLKN_Tab,
    eLKN_Home,
    eLKN_CapsLock,
    eLKN_Enter,
    eLKN_Escape,
    eLKN_End,
    eLKN_Delete,
    eLKN_BackSpace,
    eLKN_Insert,
    eLKN_NumLock,
    eLKN_Spacebar,
    eLKN_LeftShift,
    eLKN_RightShift,
    eLKN_LeftControl,
    eLKN_RightControl,
    eLKN_LeftAlt,
    eLKN_RightAlt,
    eLKN_RightMouseButton,
    eLKN_LeftMouseButton,
    eLKN_MiddleMouseButton,
    eLKN_MouseScrollUp,
    eLKN_MouseScrollDown,
    eLKN_ThumbMouseButton,
    eLKN_ThumbMouseButton2,
    eLKN_Up,
    eLKN_Down,
    eLKN_Left,
    eLKN_Right,
    eLKN_ScrollLock,
    eLKN_LeftAccent,
    eLKN_LeftBracket,
    eLKN_RightBracket,
    eLKN_PageUp,
    eLKN_PageDown,
    eLKN_Divide,
    eLKN_Multiply,
    eLKN_Subtract,
    eLKN_Semicolon,
    eLKN_Underscore,
    eLKN_Equals,
    eLKN_Add,
    eLKN_Tilde,
    eLKN_Quote,
    eLKN_Slash,
    eLKN_Backslash,
    eLKN_Comma,
    eLKN_Period,
    eLKN_Decimal,
    eLKN_Pause,
    eLKN_MAX
};

var native Map_Mirror m_GeneralBindableCommandsMap;
var native Map_Mirror m_TacticalBindableCommandsMap;
var native Map_Mirror m_KeyToLocalizedKeyMap;
var const localized string m_arrGeneralBindableLabels[GeneralBindableCommands];
var const localized string m_arrTacticalBindableLabels[TacticalBindableCommands];
var const localized string m_arrLocalizedKeyNames[LocalizedKeyNames];
var const localized string m_strShiftKeyPreprocessor;
var const localized string m_strControlKeyPreprocessor;
var const localized string m_strAltKeyPreprocessor;
var const localized string m_strNumpadKeyPreprocessor;

// Export UXComKeybindingData::execInitializeBindableCommandsMap(FFrame&, void* const)
native simulated function InitializeBindableCommandsMap();

// Export UXComKeybindingData::execGetBoundKeyForAction(FFrame&, void* const)
native simulated function KeyBind GetBoundKeyForAction(out PlayerInput kPlayerInput, int actionEnum, optional bool SecondaryBind, optional XComKeybindingData.KeybindCategories Category=1);

// Export UXComKeybindingData::execGetEnumValueForGeneralBindingsFromCommand(FFrame&, void* const)
native simulated function int GetEnumValueForGeneralBindingsFromCommand(string Command);

// Export UXComKeybindingData::execGetEnumValueForTacticalBindingsFromCommand(FFrame&, void* const)
native simulated function int GetEnumValueForTacticalBindingsFromCommand(string Command);

// Export UXComKeybindingData::execGetGeneralBindableActionLabel(FFrame&, void* const)
native simulated function string GetGeneralBindableActionLabel(XComKeybindingData.GeneralBindableCommands Action);

// Export UXComKeybindingData::execGetTacticalBindableActionLabel(FFrame&, void* const)
native simulated function string GetTacticalBindableActionLabel(XComKeybindingData.TacticalBindableCommands Action);

// Export UXComKeybindingData::execGetCommandStringForGeneralAction(FFrame&, void* const)
native simulated function string GetCommandStringForGeneralAction(XComKeybindingData.GeneralBindableCommands Action);

// Export UXComKeybindingData::execGetCommandStringForTacticalAction(FFrame&, void* const)
native simulated function string GetCommandStringForTacticalAction(XComKeybindingData.TacticalBindableCommands Action);

// Export UXComKeybindingData::execIsBindableKey(FFrame&, void* const)
native simulated function bool IsBindableKey(out KeyBind kKeyBinding);

// Export UXComKeybindingData::execGetLocalizedStringName(FFrame&, void* const)
native simulated function string GetLocalizedStringName(string KeyName);

simulated function string GetKeyStringForAction(out PlayerInput kPlayerInput, int actionEnum, optional bool SecondaryBind, optional XComKeybindingData.KeybindCategories Category=1){}
simulated function string GetPrimaryOrSecondaryKeyStringForAction(out PlayerInput kPlayerInput, int actionEnum, optional XComKeybindingData.KeybindCategories Category=1){}
simulated function string GetKeyString(out KeyBind kKey){}
