class LWCE_XGCustomizeUI extends XGCustomizeUI
    dependson(LWCETypes);

`include(sort.uci)

var const localized string m_strGenderLabel;
var const localized string m_strGenderMale;
var const localized string m_strGenderFemale;
var const localized string m_strNoContent;

var array< delegate<LWCETypes.OnSpinnerChanged> > m_arrSpinnerHandlers;

var privatewrite LWCE_XComHumanPawn m_kCEPawn;
var privatewrite LWCE_XGStrategySoldier m_kCESoldier;

var private LWCEContentTemplateManager m_kContentTemplateMgr;

function Init(int iView)
{
    super.Init(iView);

    m_kContentTemplateMgr = `LWCE_CONTENT_TEMPLATE_MGR;
}

function AdvanceArmorDeco(int Dir)
{
    local int CurIdx, NewIdx, NumPresets;
    local name NewDeco;

    NumPresets = m_kCEPawn.m_arrCEArmorKits.Length;
    CurIdx = GetArmorDecoIndex();
    NewIdx = CurIdx + Dir;

    if (NewIdx < -1)
    {
        NewIdx = NumPresets - 1;
    }

    if (NewIdx >= NumPresets)
    {
        NewIdx = -1;
    }

    NewDeco = (NewIdx > -1 && m_kCEPawn.m_arrCEArmorKits.Length > 0) ? m_kCEPawn.m_arrCEArmorKits[NewIdx].GetContentTemplateName() : '';
    m_kCEPawn.LWCE_SetArmorDeco(NewDeco);
    m_kCESoldier.m_kCESoldier.kAppearance.nmArmorKit = NewDeco;
}

function AdvanceArmorTint(int Dir)
{
    local int CurIdx, NewIdx, NumPresets;
    local name NewColor;

    NumPresets = m_kCEPawn.m_arrCEArmorColors.Length;
    CurIdx = GetArmorTintIndex();
    NewIdx = CurIdx + Dir;

    if (NewIdx < 0)
    {
        NewIdx = NumPresets - 1;
    }

    if (NewIdx >= NumPresets)
    {
        NewIdx = 0;
    }

    NewColor = m_kCEPawn.m_arrCEArmorColors[NewIdx].GetContentTemplateName();
    m_kCEPawn.LWCE_SetArmorTint(NewColor);
    m_kCESoldier.m_kCESoldier.kAppearance.nmArmorColor = NewColor;
}

function AdvanceFacialHair(int Dir)
{
    local int CurIdx, NewIdx, NumPresets;
    local name NewFacialHair;

    NumPresets = m_kCEPawn.m_arrCEFacialHairs.Length;
    CurIdx = GetFacialHairIndex();
    NewIdx = CurIdx + Dir;

    if (NewIdx < -1)
    {
        NewIdx = NumPresets - 1;
    }

    if (NewIdx >= NumPresets)
    {
        NewIdx = -1;
    }

    NewFacialHair = NewIdx >= 0 ? m_kCEPawn.m_arrCEFacialHairs[NewIdx].GetContentTemplateName() : '';
    m_kCEPawn.LWCE_SetFacialHair(NewFacialHair);
    m_kCESoldier.m_kCESoldier.kAppearance.nmFacialHair = NewFacialHair;
}

function bool AdvanceFeature(int Feature, int Dir)
{
    local delegate<LWCETypes.OnSpinnerChanged> kSpinnerDelegate;

    if (Feature >= 0 && Feature < m_arrSpinnerHandlers.Length)
    {
        kSpinnerDelegate = m_arrSpinnerHandlers[Feature];

        if (kSpinnerDelegate != none)
        {
            kSpinnerDelegate(Dir);
            return true;
        }
    }

    return false;
}

function AdvanceGender(int Dir)
{
    local int iGender;

    iGender = m_kCEPawn.m_kCEAppearance.iGender == eGender_Female ? eGender_Male : eGender_Female;

    // XComHumanPawn doesn't have a function to change gender, so we need to set the underlying
    // variables directly. We then call SetRace because that triggers enough of the processing
    // to update the face mesh to the new gender.
    m_kCEPawn.m_kCEAppearance.iGender = iGender;
    m_kCEPawn.bIsFemale = iGender == eGender_Female;
    m_kCEPawn.LWCE_SetGender(m_kCEPawn.m_kCEAppearance.iGender);

    // Finally, we need to trigger a reload of the character's skeleton and armor mesh, because female
    // soldiers are scaled down relative to male soldiers. If we don't do this, the soldier's head has
    // the scale of the new gender, but the rest of the model doesn't. SetInventory reloads that content
    // for us.
    //m_kCEPawn.LWCE_SetInventory(m_kCEPawn.m_kCEChar, m_kCESoldier.m_kCEChar.kInventory, m_kCEPawn.m_kCEAppearance);

    // Sync back our changes to the soldier data
    m_kCESoldier.m_kCESoldier.kAppearance.iGender = m_kCEPawn.m_kCEAppearance.iGender;
    m_kCESoldier.m_kCESoldier.kAppearance.nmHead = m_kCEPawn.m_kCEAppearance.nmHead;
    m_kCESoldier.m_kCESoldier.kAppearance.nmHaircut = m_kCEPawn.m_kCEAppearance.nmHaircut;
    m_kCESoldier.m_kCESoldier.kAppearance.nmVoice = m_kCEPawn.m_kCEAppearance.nmVoice;
}

function AdvanceHair(int Dir)
{
    local name nmNewHair;
    local int CurIdx, NewIdx, NumHairs;

    NumHairs = m_kCEPawn.m_arrCEHairs.Length;
    CurIdx = GetHairIndex();
    NewIdx = CurIdx + Dir;

    if (NewIdx < -1)
    {
        NewIdx = NumHairs - 1;
    }

    if (NewIdx >= NumHairs)
    {
        NewIdx = -1;
    }

    nmNewHair = NewIdx > -1 ? m_kCEPawn.m_arrCEHairs[NewIdx].GetContentTemplateName() : '';

    m_kCEPawn.LWCE_SetHair(nmNewHair);
    m_kCESoldier.m_kCESoldier.kAppearance.nmHaircut = nmNewHair;
    m_kCESoldier.m_kCESoldier.kAppearance.nmHairColor = m_kCEPawn.m_kCEAppearance.nmHairColor;

    UpdateView();
}

function AdvanceHairColor(int Dir)
{
    local name nmHairColor;
    local int CurIdx, NewIdx, NumHairColors;

    NumHairColors = m_kCEPawn.m_arrCEHairColors.Length;
    CurIdx = GetHairColorIndex();
    NewIdx = CurIdx + Dir;

    if (NewIdx < 0)
    {
        NewIdx = NumHairColors - 1;
    }

    if (NewIdx >= NumHairColors)
    {
        NewIdx = 0;
    }

    nmHairColor = m_kCEPawn.m_arrCEHairColors[NewIdx].GetContentTemplateName();

    m_kCEPawn.LWCE_SetHairColor(nmHairColor);
    m_kCESoldier.m_kCESoldier.kAppearance.nmHairColor = nmHairColor;

    UpdateView();
}

function AdvanceHead(int Dir)
{
    local name nmNewHead;
    local int CurIdx, NewIdx, NumHeads;

    NumHeads = m_kCEPawn.m_arrCEHeads.Length;
    CurIdx = GetHeadIndex();
    NewIdx = CurIdx + Dir;

    if (NewIdx < 0)
    {
        NewIdx = NumHeads - 1;
    }

    if (NewIdx >= NumHeads)
    {
        NewIdx = 0;
    }

    nmNewHead = m_kCEPawn.m_arrCEHeads[NewIdx].GetContentTemplateName();

    m_kCEPawn.LWCE_SetHead(nmNewHead);
    m_kCESoldier.m_kCESoldier.kAppearance.nmHead = nmNewHead;

    UpdateView();
}

function AdvanceRace(int Dir)
{
    local int CurIdx, NewIdx, NumRaces;
    local name nmNewRace;

    CurIdx = GetRaceIndex();
    NewIdx = CurIdx + Dir;
    NumRaces = m_kCEPawn.m_arrCERaces.Length;

    if (NewIdx >= NumRaces)
    {
        NewIdx = 0;
    }

    if (NewIdx < 0)
    {
        NewIdx = NumRaces - 1;
    }

    nmNewRace = m_kCEPawn.m_arrCERaces[NewIdx].GetContentTemplateName();

    m_kCEPawn.LWCE_SetRace(nmNewRace);
    m_kCESoldier.m_kCESoldier.kAppearance.nmRace = nmNewRace;
    m_kCESoldier.m_kCESoldier.kAppearance.nmSkinColor = m_kCEPawn.m_kCEAppearance.nmSkinColor;
    m_kCESoldier.m_kCESoldier.kAppearance.nmHead = m_kCEPawn.m_kCEAppearance.nmHead;
}

function AdvanceSkinColor(int Dir)
{
    local int CurIdx, NewIdx, NumColors;
    local name nmSkinColor;

    NumColors = m_kCEPawn.m_arrCESkinColors.Length;
    CurIdx = GetSkinColorIndex();
    NewIdx = CurIdx + Dir;

    if (NewIdx < 0)
    {
        NewIdx = NumColors - 1;
    }

    if (NewIdx >= NumColors)
    {
        NewIdx = 0;
    }

    nmSkinColor = m_kCEPawn.m_arrCESkinColors[NewIdx].GetContentTemplateName();
    m_kCEPawn.LWCE_SetSkinColor(nmSkinColor);
    m_kCESoldier.m_kCESoldier.kAppearance.nmSkinColor = nmSkinColor;
}

function AdvanceVoice(int Dir)
{
    local int CurIdx, NewIdx, MinChoice, MaxChoice;
    local name nmNewVoice;

    MinChoice = 0;
    MaxChoice = m_kCEPawn.m_arrCEVoices.Length - 1;
    CurIdx = GetVoiceIndex();
    NewIdx = CurIdx + Dir;

    if (NewIdx < MinChoice)
    {
        NewIdx = MaxChoice;
    }

    if (NewIdx > MaxChoice)
    {
        NewIdx = MinChoice;
    }

    nmNewVoice = m_kCEPawn.m_arrCEVoices[NewIdx].GetContentTemplateName();
    m_kCEPawn.LWCE_SetVoice(nmNewVoice);
    m_kCESoldier.m_kCESoldier.kAppearance.nmVoice = nmNewVoice;
}

function string GetArmorDecoDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmArmorKit == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindArmorKitTemplate(m_kCEPawn.m_kCEAppearance.nmArmorKit).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetArmorDecoIndex()
{
    local int Index;

    SortArmorKitTemplates(m_kCEPawn.m_arrCEArmorKits);

    for (Index = 0; Index < m_kCEPawn.m_arrCEArmorKits.Length; Index++)
    {
        if (m_kCEPawn.m_arrCEArmorKits[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmArmorKit)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function string GetArmorTintDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmArmorColor == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindArmorColorTemplate(m_kCEPawn.m_kCEAppearance.nmArmorColor).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetArmorTintIndex()
{
    local int Index;

    SortArmorColorTemplates(m_kCEPawn.m_arrCEArmorColors);

    for (Index = 0; Index < m_kCEPawn.m_arrCEArmorColors.Length; Index++)
    {
        if (m_kCEPawn.m_arrCEArmorColors[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmArmorColor)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function string GetFacialHairDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmFacialHair == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindFacialHairTemplate(m_kCEPawn.m_kCEAppearance.nmFacialHair).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetFacialHairIndex()
{
    local int Index;

    SortFacialHairTemplates(m_kCEPawn.m_arrCEFacialHairs);

    for (Index = 0; Index < m_kCEPawn.m_arrCEFacialHairs.Length; Index++)
    {
        if (m_kCEPawn.m_arrCEFacialHairs[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmFacialHair)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function string GetHairColorDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmHairColor == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindHairColorTemplate(m_kCEPawn.m_kCEAppearance.nmHairColor).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetHairColorIndex()
{
    local int Index;

    SortHairColorTemplates(m_kCEPawn.m_arrCEHairColors);

    for (Index = 0; Index < m_kCEPawn.m_arrCEHairColors.Length; Index++)
    {
        if (m_kCEPawn.m_arrCEHairColors[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmHairColor)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function string GetHairDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmHaircut == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindHairTemplate(m_kCEPawn.m_kCEAppearance.nmHaircut).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetHairIndex()
{
    local int Index;

    SortHairTemplates(m_kCEPawn.m_arrCEHairs);

    for (Index = 0; Index < m_kCEPawn.m_arrCEHairs.Length; Index++)
    {
        if (m_kCEPawn.m_arrCEHairs[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmHaircut)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function string GetHeadDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmHead == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindHeadTemplate(m_kCEPawn.m_kCEAppearance.nmHead).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetHeadIndex()
{
    local int Index;

    SortHeadTemplates(m_kCEPawn.m_arrCEHeads);

    for (Index = 0; Index < m_kCEPawn.m_arrCEHeads.Length; Index++)
    {
        if (m_kCEPawn.m_arrCEHeads[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmHead)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function string GetRaceDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmRace == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindRaceTemplate(m_kCEPawn.m_kCEAppearance.nmRace).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetRaceIndex()
{
    local int Index;

    SortRaceTemplates(m_kCEPawn.m_arrCERaces);

    for (Index = 0; Index < m_kCEPawn.m_arrCERaces.Length; Index++)
    {
        if (m_kCEPawn.m_arrCERaces[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmRace)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function string GetSkinColorDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmSkinColor == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindSkinColorTemplate(m_kCEPawn.m_kCEAppearance.nmSkinColor).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetSkinColorIndex()
{
    local int Index;

    SortSkinColorTemplates(m_kCEPawn.m_arrCESkinColors);

    for (Index = 0; Index < m_kCEPawn.m_arrCESkinColors.Length; Index++)
    {
        if (m_kCEPawn.m_arrCESkinColors[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmSkinColor)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function string GetVoiceDisplayName()
{
    local string strDisplayName;

    if (m_kCEPawn.m_kCEAppearance.nmVoice == '')
    {
        return m_strNoContent;
    }

    strDisplayName = m_kContentTemplateMgr.FindVoiceTemplate(m_kCEPawn.m_kCEAppearance.nmVoice).DisplayName;

    if (strDisplayName == "")
    {
        strDisplayName = "MISSING NAME";
    }

    return strDisplayName;
}

function int GetVoiceIndex()
{
    local int Index;

    SortVoiceTemplates(m_kCEPawn.m_arrCEVoices);

    for (Index = 0; Index < m_kCEPawn.m_arrCEVoices.Length; Index++)
    {
        if (m_kCEPawn.m_arrCEVoices[Index].GetContentTemplateName() == m_kCEPawn.m_kCEAppearance.nmVoice)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}

function SetActiveSoldier(XGStrategySoldier NewSoldier)
{
    if (m_kSoldier != none)
    {
        m_bSwitchedSoldier = true;
    }

    m_kSoldier = NewSoldier;
    m_kCESoldier = LWCE_XGStrategySoldier(m_kSoldier);

    m_kPawn = XComHumanPawn(NewSoldier.m_kPawn);
    m_kCEPawn = LWCE_XComHumanPawn(m_kPawn);
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
}

// TODO: replace the spinners with comboboxes
function UpdateMainMenu()
{
    local TMenuOption kOption;
    local TMenu kButtonMenu, kSpinnerMenu;
    local int iPossibleArmors;

    // First name
    kOption.strText = m_strFirstNameButton;
    kOption.iState = eUIState_Normal;

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kButtonMenu.arrOptions.AddItem(kOption);

    // Last name
    kOption.strText = m_strLastNameButton;
    kOption.iState = eUIState_Normal;

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kButtonMenu.arrOptions.AddItem(kOption);

    // Nickname
    kOption.strText = m_strNickNameButton;
    kOption.iState = m_kSoldier.GetRank() >= 3 ? eUIState_Normal : eUIState_Disabled;

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kButtonMenu.arrOptions.AddItem(kOption);
    m_kMainMenuButtonOptions.mnuOptions = kButtonMenu;

    // Reset handlers; first 3 are none for the 3 name buttons
    m_arrSpinnerHandlers.Length = 0;
    m_arrSpinnerHandlers.AddItem(none);
    m_arrSpinnerHandlers.AddItem(none);
    m_arrSpinnerHandlers.AddItem(none);

    // Language
    kOption.strText = m_strLanguageSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = string(GetLanguageIndex() + 1);

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceLanguage);

    // Voice
    kOption.strText = m_strVoiceSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = GetVoiceDisplayName();

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceVoice);

    // Race
    kOption.strText = m_strRaceSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = GetRaceDisplayName();

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceRace);

    // Gender
    kOption.strText = m_strGenderLabel;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = m_kCEPawn.m_kCEAppearance.iGender == eGender_Female ? m_strGenderFemale : m_strGenderMale;
    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceGender);

    // Head
    kOption.strText = m_strHeadSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = GetHeadDisplayName();

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceHead);

    // Skin color
    kOption.strText = m_strSkinColorSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = GetSkinColorDisplayName();

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceSkinColor);

    // Hair
    kOption.strText = m_strHairSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = GetHairDisplayName();

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceHair);

    // Hair color
    kOption.strText = m_strHairColorSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = GetHairColorDisplayName();
    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceHairColor);

    // Facial hair
    if (m_kCEPawn.m_kCEAppearance.iGender == eGender_Male)
    {
        kOption.strText = m_strFacialHairSpinner;
        kOption.iState = eUIState_Normal;
        kOption.strHelp = GetFacialHairDisplayName();
        kSpinnerMenu.arrOptions.AddItem(kOption);
        m_arrSpinnerHandlers.AddItem(AdvanceFacialHair);
    }

    // Armor decal
    kOption.strText = m_strArmorDecalSpinner;
    iPossibleArmors = m_kCEPawn.m_arrCEArmorKits.Length;

    if (iPossibleArmors == 1)
    {
        kOption.iState = eUIState_Bad;
        kOption.strHelp = m_strNoDecoAvailableForThisArmor;
    }
    else if (iPossibleArmors > 1)
    {
        kOption.iState = eUIState_Normal;
        kOption.strHelp = GetArmorDecoDisplayName();
    }
    else
    {
        kOption.iState = eUIState_Disabled;
        kOption.strHelp = GetArmorDecoDisplayName();
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceArmorDeco);

    // Armor tint
    kOption.strText = m_strArmorTintSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = GetArmorTintDisplayName();
    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceArmorTint);

    m_kMainMenuSpinnerOptions.mnuOptions = kSpinnerMenu;
}

`GENERATE_SORT(SortArmorKitTemplates,   LWCEArmorKitContentTemplate,   arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortFacialHairTemplates, LWCEFacialHairContentTemplate, arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortHairTemplates,       LWCEHairContentTemplate,       arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortHeadTemplates,       LWCEHeadContentTemplate,       arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortRaceTemplates,       LWCERaceTemplate,              arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortVoiceTemplates,      LWCEVoiceContentTemplate,      arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortArmorColorTemplates, LWCEArmorColorContentTemplate, arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortHairColorTemplates,  LWCEHairColorContentTemplate,  arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortSkinColorTemplates,  LWCESkinColorContentTemplate,  arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)