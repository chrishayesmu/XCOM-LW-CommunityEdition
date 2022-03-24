class LWCE_UIKeybindingsPCScreen extends UIKeybindingsPCScreen
    config(LWCEInput);

struct LWCE_UIKeybind
{
    var UIKeyBind kBinding;
    var KeybindCategories eBindingCategory;
    var bool bIsGlobal; // Keybinding should be applied in all input contexts
    var string strIdentifier; // Unique identifier in order to tell if a keybind is missing completely
};

var config array<LWCE_UIKeyBind> m_arrCEKeybinds;

var const localized string m_strDevConsoleFullLabel;
var const localized string m_strDevConsoleMiniLabel;
var const localized string m_strOverwatchAllLabel;
var const localized string m_strToggleGridLabel;

static function ApplyCustomKeybinds(PlayerInput kInput)
{
    local KeybindCategories eBindingCategory;
    local LWCE_UIKeybind kLWCEBinding;

    if (kInput.IsA('XComTacticalInput'))
    {
        eBindingCategory = eKC_Tactical;

        RemoveLegacyOverwatchAllBinding(kInput);
    }
    else
    {
        eBindingCategory = eKC_General;
    }

    PopulateCustomKeybinds(default.m_arrCEKeybinds);

    foreach default.m_arrCEKeybinds(kLWCEBinding)
    {
        if (kLWCEBinding.eBindingCategory != eBindingCategory && !kLWCEBinding.bIsGlobal)
        {
            continue;
        }

        // Remove any existing bindings, in case the ini file has been edited outside of the game
        if (kLWCEBinding.kBinding.PrimaryBind.Name != 'None')
        {
            kInput.RemoveBind(kLWCEBinding.kBinding.PrimaryBind.Name, kLWCEBinding.kBinding.PrimaryBind.Command, /* bSecondaryBind */ true);
            kInput.RemoveBind(kLWCEBinding.kBinding.PrimaryBind.Name, kLWCEBinding.kBinding.PrimaryBind.Command, /* bSecondaryBind */ false);
            kInput.AddBind(kLWCEBinding.kBinding.PrimaryBind);
        }

        if (kLWCEBinding.kBinding.SecondaryBind.Name != 'None')
        {
            kInput.RemoveBind(kLWCEBinding.kBinding.SecondaryBind.Name, kLWCEBinding.kBinding.SecondaryBind.Command, /* bSecondaryBind */ true);
            kInput.RemoveBind(kLWCEBinding.kBinding.SecondaryBind.Name, kLWCEBinding.kBinding.SecondaryBind.Command, /* bSecondaryBind */ false);
            kInput.AddBind(kLWCEBinding.kBinding.SecondaryBind);
        }
    }
}

/// <summary>
/// Returns true if there is an open keybindings screen and the player is currently pressing keys
/// with the intent of using them as keybindings.
/// </summary>
static function bool IsKeybindingInProgress()
{
    local UIKeybindingsPCScreen kScreen;

    foreach `WORLDINFO.AllActors(class'UIKeybindingsPCScreen', kScreen)
    {
        if (kScreen.m_iKeySlotBeingBound >= 0)
        {
            return true;
        }
    }

    return false;
}

/**
 * Adds new keybindings to arrKeybinds only if they're not already present. Do not modify anything
 * if a keybinding is already in the array, or you may overwrite user settings.
 *
 * TODO: make it easy to always update the UserLabel, in case the user has changed languages or text
 */
static function PopulateCustomKeybinds(out array<LWCE_UIKeybind> arrKeybinds)
{
    local int Index;
    local LWCE_UIKeybind kBlankBinding, kCEBinding;

    if (arrKeybinds.Find('strIdentifier', "LWCE_OpenDevConsole_Full") == INDEX_NONE)
    {
        kCEBinding.strIdentifier = "LWCE_OpenDevConsole_Full";
        kCEBinding.eBindingCategory = eKC_General;
        kCEBinding.bIsGlobal = true;

        kCEBinding.kBinding.UserLabel = default.m_strDevConsoleFullLabel;
        kCEBinding.kBinding.PrimaryBind.Command = "OpenDevConsole_Full";
        kCEBinding.kBinding.PrimaryBind.Name = 'Tilde';

        arrKeybinds.AddItem(kCEBinding);

        kCEBinding = kBlankBinding;
    }

    if (arrKeybinds.Find('strIdentifier', "LWCE_OpenDevConsole_Small") == INDEX_NONE)
    {
        kCEBinding.strIdentifier = "LWCE_OpenDevConsole_Small";
        kCEBinding.eBindingCategory = eKC_General;
        kCEBinding.bIsGlobal = true;

        kCEBinding.kBinding.UserLabel = default.m_strDevConsoleMiniLabel;
        kCEBinding.kBinding.PrimaryBind.Command = "OpenDevConsole_Small";
        kCEBinding.kBinding.PrimaryBind.Name = 'Backslash';

        arrKeybinds.AddItem(kCEBinding);

        kCEBinding = kBlankBinding;
    }

    if (arrKeybinds.Find('strIdentifier', "LWCE_OverwatchAll") == INDEX_NONE)
    {
        kCEBinding.strIdentifier = "LWCE_OverwatchAll";
        kCEBinding.eBindingCategory = eKC_Tactical;

        kCEBinding.kBinding.UserLabel = default.m_strOverwatchAllLabel;
        kCEBinding.kBinding.PrimaryBind.Command = "ForceOverwatch TRUE";
        kCEBinding.kBinding.PrimaryBind.Name = 'O';
        kCEBinding.kBinding.PrimaryBind.Alt = true;

        arrKeybinds.AddItem(kCEBinding);

        kCEBinding = kBlankBinding;
    }

    if (arrKeybinds.Find('strIdentifier', "LWCE_ToggleDisplayOfMovementGrid") == INDEX_NONE)
    {
        kCEBinding.strIdentifier = "LWCE_ToggleDisplayOfMovementGrid";
        kCEBinding.eBindingCategory = eKC_Tactical;

        kCEBinding.kBinding.UserLabel = default.m_strToggleGridLabel;
        kCEBinding.kBinding.PrimaryBind.Command = "ToggleDisplayOfMovementGrid";
        kCEBinding.kBinding.PrimaryBind.Name = 'T';
        kCEBinding.kBinding.PrimaryBind.Alt = true;

        arrKeybinds.AddItem(kCEBinding);

        kCEBinding = kBlankBinding;
    }

    for (Index = 0; Index < arrKeybinds.Length; Index++)
    {
        // Make sure the command is set the same for primary and secondary binds
        arrKeybinds[Index].kBinding.SecondaryBind.Command = arrKeybinds[Index].kBinding.PrimaryBind.Command;

        // Mark all primary binds as primary
        arrKeybinds[Index].kBinding.PrimaryBind.bPrimaryBinding = true;
        arrKeybinds[Index].kBinding.PrimaryBind.bSecondaryBinding = false;

        // Mark all secondary binds as secondary
        arrKeybinds[Index].kBinding.SecondaryBind.bPrimaryBinding = false;
        arrKeybinds[Index].kBinding.SecondaryBind.bSecondaryBinding = true;
    }
}

/**
 * Deletes the "Overwatch All" keybinding provided by Long War 1.0. Unfortunately that keybinding is not
 * configured correctly to work with the UI, so if we don't manually delete it, it will always be present
 * (in addition to any custom keybind). We delete theirs and immediately insert our own, which defaults to the
 * same input, so that it can be remapped freely.
 */
static function RemoveLegacyOverwatchAllBinding(PlayerInput kInput)
{
    local int Index;

    for (Index = 0; Index < kInput.Bindings.Length; Index++)
    {
        if (kInput.Bindings[Index].Name == 'O' &&
            kInput.Bindings[Index].Command == "ForceOverWatch TRUE" &&
            kInput.Bindings[Index].Alt &&
           !kInput.Bindings[Index].bPrimaryBinding &&
           !kInput.Bindings[Index].bSecondaryBinding)
        {
            // Normally we would use RemoveBind, but that expects either bPrimaryBinding or bSecondaryBinding
            // to be true, which is exactly how the Overwatch All binding is misconfigured
            kInput.Bindings.Remove(Index, 1);
            kInput.SaveConfig();
            break;
        }
    }
}

simulated function bool OnAccept(optional string Arg = "")
{
    local int iBindingIndex, Index;

    // We need to sync back keybinding info from m_arrBindings for any custom bindings,
    // since all the structs we're using are being copied
    if (m_eBindingCategory == eKC_General)
    {
        iBindingIndex = eGBC_MAX;
    }
    else
    {
        iBindingIndex = eTBC_MAX;
    }

    // Since m_arrBindings only contains bindings appropriate to the keybinding category,
    // we need to track progress in it separately from progress in m_arrCEKeybinds
    for (Index = 0; Index < m_arrCEKeybinds.Length; Index++)
    {
        if (m_arrCEKeybinds[Index].eBindingCategory != m_eBindingCategory)
        {
            continue;
        }

        m_arrCEKeybinds[Index].kBinding = m_arrBindings[iBindingIndex];
        iBindingIndex++;
    }

    SaveConfig();

    // Make sure all of our keybinds, including global ones, are up-to-date before we reload the input config
    ApplyCustomKeybinds(m_kBaseInputController.PlayerInput);
    m_kBaseInputController.PlayerInput.SaveConfig();

    ApplyCustomKeybinds(m_kTacticalInputController.PlayerInput);
    m_kTacticalInputController.PlayerInput.SaveConfig();

    super.OnAccept(arg);

    return true;
}

function OnDisplayConfirmResetBindingsDialogAction(EUIAction eAction)
{
    local LWCE_UIKeybind kLWCEBinding;

    if (eAction == eUIAction_Accept)
    {
        ResetPlayerInputBindings();

        // Remove all LWCE keybindings or else they'll persist instead of resetting to default
        // TODO: this would be slightly better if we didn't rely on actually knowing the keybinding but instead iterated
        // what's in the Input objects, because this won't clear out keybinds that were manually put in the ini file, but
        // those keybinds won't be visible in the UI either
        foreach m_arrCEKeybinds(kLWCEBinding)
        {
            if (kLWCEBinding.kBinding.PrimaryBind.Name != 'None')
            {
                m_kBaseInputController.PlayerInput.RemoveBind(kLWCEBinding.kBinding.PrimaryBind.Name, kLWCEBinding.kBinding.PrimaryBind.Command, /* bSecondaryBind */ false);
                m_kTacticalInputController.PlayerInput.RemoveBind(kLWCEBinding.kBinding.PrimaryBind.Name, kLWCEBinding.kBinding.PrimaryBind.Command, /* bSecondaryBind */ false);
            }

            if (kLWCEBinding.kBinding.SecondaryBind.Name != 'None')
            {
                m_kBaseInputController.PlayerInput.RemoveBind(kLWCEBinding.kBinding.SecondaryBind.Name, kLWCEBinding.kBinding.SecondaryBind.Command, /* bSecondaryBind */ true);
                m_kTacticalInputController.PlayerInput.RemoveBind(kLWCEBinding.kBinding.SecondaryBind.Name, kLWCEBinding.kBinding.SecondaryBind.Command, /* bSecondaryBind */ true);
            }
        }

        // Repopulate everything from scratch and save it
        m_arrCEKeybinds.Length = 0;
        PopulateCustomKeybinds(m_arrCEKeybinds);
        default.m_arrCEKeybinds = m_arrCEKeybinds;
        SaveConfig();

        // Need to get our default keybinds into the base input before we reload it
        ApplyCustomKeybinds(m_kBaseInputController.PlayerInput);
        m_kBaseInputController.PlayerInput.SaveConfig();

        ApplyCustomKeybinds(m_kTacticalInputController.PlayerInput);
        m_kTacticalInputController.PlayerInput.SaveConfig();

        // Reload the inputs and update the UI
        ReloadPlayerInputBindings();
        UpdateBindingsList();
    }
}

simulated function InitInputClasses()
{
    // These classes are used to apply input changes to them, then when the changes are accepted, we save config with
    // these instances and reload config on the instances that actually matter
    m_kBaseInputController = Spawn(class'PlayerController');
    m_kBaseInputController.InitInputSystem();

    m_kTacticalInputController = Spawn(class'LWCE_XComTacticalController');
    m_kTacticalInputController.InitInputSystem();
}

simulated function UpdateBindingsList()
{
    local LWCE_UIKeybind kCEBinding;

    ReadBindings();
    PopulateCustomKeybinds(m_arrCEKeybinds);

    foreach m_arrCEKeybinds(kCEBinding)
    {
        if (kCEBinding.eBindingCategory == m_eBindingCategory)
        {
            m_arrBindings.AddItem(kCEBinding.kBinding);
        }
    }

    DisplayBindings();
}

simulated function bool RawInputHandler(name Key, int Actionmask, bool bCtrl, bool bAlt, bool bShift)
{
    local PlayerInput kPlayerInput;
    local KeyBind kBind;

    if (m_bAlreadyProcessingRawInput || !m_bAwaitingInputForBind || Actionmask != class'UI_FxsInput'.const.FXS_ACTION_RELEASE || !IsBindable(Key))
    {
        return false;
    }

    m_bAlreadyProcessingRawInput = true;
    FlushPressedKeys();

    m_bAlreadyProcessingRawInput = false;
    m_bAwaitingInputForBind = false;
    m_iKeySlotConflicting = IsKeyAlreadyBound(Key, bCtrl, bAlt, bShift);

    if (m_iKeySlotConflicting != -1)
    {
        if (m_iKeySlotBeingBound == m_iKeySlotConflicting)
        {
            AS_DeactivateSlot(m_iKeySlotBeingBound, m_bSecondaryKeyBeingBound);
            return true;
        }

        m_kCachedKeyBeingBound.Name = Key;
        m_kCachedKeyBeingBound.bPrimaryBinding = !m_bSecondaryKeyBeingBound;
        m_kCachedKeyBeingBound.bSecondaryBinding = m_bSecondaryKeyBeingBound;
        m_kCachedKeyBeingBound.Control = bCtrl;
        m_kCachedKeyBeingBound.Shift = bShift;
        m_kCachedKeyBeingBound.Alt = bAlt;

        if (IsBaseGameKeybindBeingBound())
        {
            m_kCachedKeyBeingBound.Command = GetCommandForKeyBeingBound();
        }

        DisplayConflictingKeyDialog();
        return true;
    }

    switch (m_eBindingCategory)
    {
        case eKC_General:
            kPlayerInput = m_kBaseInputController.PlayerInput;
            break;
        case eKC_Tactical:
            kPlayerInput = m_kTacticalInputController.PlayerInput;
            break;
    }

    if (m_arrDirtyPlayerInputs.Find(kPlayerInput) == INDEX_NONE)
    {
        m_arrDirtyPlayerInputs.AddItem(kPlayerInput);
    }

    if (m_bSecondaryKeyBeingBound)
    {
        kBind = m_arrBindings[m_iKeySlotBeingBound].SecondaryBind;
    }
    else
    {
        kBind = m_arrBindings[m_iKeySlotBeingBound].PrimaryBind;
    }

    if (kBind.Name != 'None')
    {
        kPlayerInput.RemoveBind(kBind.Name, kBind.Command, m_bSecondaryKeyBeingBound);
    }

    kBind.Name = Key;
    kBind.bPrimaryBinding = !m_bSecondaryKeyBeingBound;
    kBind.bSecondaryBinding = m_bSecondaryKeyBeingBound;
    kBind.Control = bCtrl;
    kBind.Shift = bShift;
    kBind.Alt = bAlt;

    if (IsBaseGameKeybindBeingBound())
    {
        // Only call this function for keybindings in the base game, or else it will result in a crash
        // in native code. Custom keybinds should already have their command field set anyway.
        kBind.Command = GetCommandForKeyBeingBound();
    }

    if (m_bSecondaryKeyBeingBound)
    {
        m_arrBindings[m_iKeySlotBeingBound].SecondaryBind = kBind;
    }
    else
    {
        m_arrBindings[m_iKeySlotBeingBound].PrimaryBind = kBind;
    }

    kPlayerInput.AddBind(kBind);
    AS_DeactivateSlot(m_iKeySlotBeingBound, m_bSecondaryKeyBeingBound);
    AS_SetNewKey(m_iKeySlotBeingBound, m_bSecondaryKeyBeingBound, m_kKeybindingData.GetKeyString(kBind));

    m_iKeySlotBeingBound = -1;

    return true;
}

protected static function string BindToString(KeyBind kBind)
{
    local string strResult, strRole;
    local array<string> arrKeys;

    if (kBind.Name == 'None')
    {
        return "None";
    }

    if (kBind.Control)
    {
        arrKeys.AddItem("Ctrl");
    }

    if (kBind.Shift)
    {
        arrKeys.AddItem("Shift");
    }

    if (kBind.Alt)
    {
        arrKeys.AddItem("Alt");
    }

    arrKeys.AddItem(string(kBind.Name));

    JoinArray(arrKeys, strResult, "+");

    if (kBind.bPrimaryBinding && kBind.bSecondaryBinding)
    {
        strRole = "ERR: PrimAndSec";
    }
    else if (kBind.bPrimaryBinding)
    {
        strRole = "Primary";
    }
    else if (kBind.bSecondaryBinding)
    {
        strRole = "Secondary";
    }
    else
    {
        strRole = "ERR: NoRole";
    }

    return "<" $ strResult $ ": " $ kBind.Command $ " | " $ strRole $ ">";
}

protected function bool IsBaseGameKeybindBeingBound()
{
    return (m_eBindingCategory == eKC_General && m_iKeySlotBeingBound < eGBC_MAX) || (m_eBindingCategory == eKC_Tactical && m_iKeySlotBeingBound < eTBC_MAX);
}