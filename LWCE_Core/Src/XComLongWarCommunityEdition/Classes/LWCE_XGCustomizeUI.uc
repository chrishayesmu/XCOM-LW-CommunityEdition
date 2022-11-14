class LWCE_XGCustomizeUI extends XGCustomizeUI
    dependson(LWCETypes);

var const localized string m_strGenderLabel;
var const localized string m_strGenderMale;
var const localized string m_strGenderFemale;

var array< delegate<LWCETypes.OnSpinnerChanged> > m_arrSpinnerHandlers;

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
    local LWCE_XComHumanPawn kPawn;
    local LWCE_XGStrategySoldier kSoldier;
    local int iGender;

    kPawn = LWCE_XComHumanPawn(m_kPawn);
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    iGender = kPawn.m_kAppearance.iGender == eGender_Female ? eGender_Male : eGender_Female;

    // XComHumanPawn doesn't have a function to change gender, so we need to set the underlying
    // variables directly. We then call SetRace because that triggers enough of the processing
    // to update the face mesh to the new gender.
    kPawn.m_kAppearance.iGender = iGender;
    kPawn.bIsFemale = iGender == eGender_Female;
    kPawn.SetRace(ECharacterRace(kPawn.m_kAppearance.iRace));

    // Hair meshes are different between genders, so we need to make the pawn load a new one.
    // Most of the lower index meshes are hair, not helmets, which is ideal because the player probably
    // wants to see what their soldier looks like. We do Rand(560) because the RNG in use seems to have
    // some clumping issues with small inputs.
    kPawn.SetHair(kPawn.PossibleHairs[(Rand(560) % 14) + 1]);

    // Finally, we need to trigger a reload of the character's skeleton and armor mesh, because female
    // soldiers are scaled down relative to male soldiers. If we don't do this, the soldier's head has
    // the scale of the new gender, but the rest of the model doesn't. SetInventory reloads that content
    // for us.
    kPawn.LWCE_SetInventory(kPawn.m_kCEChar, kSoldier.m_kCEChar.kInventory, kPawn.m_kCEAppearance);

    // Sync back our changes to the soldier data
    kSoldier.m_kSoldier.kAppearance.iGender = m_kPawn.m_kAppearance.iGender;
    kSoldier.m_kSoldier.kAppearance.iHead = m_kPawn.m_kAppearance.iHead;
    kSoldier.m_kSoldier.kAppearance.iHaircut = m_kPawn.m_kAppearance.iHaircut;
    kSoldier.m_kSoldier.kAppearance.iHairColor = m_kPawn.m_kAppearance.iHairColor;
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
}

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
    kOption.strHelp = string(GetVoiceIndex() + 1);

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceVoice);

    // Race
    kOption.strText = m_strRaceSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = string(GetRaceIndex() + 1);

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceRace);

    // Head
    kOption.strText = m_strHeadSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = string(GetHeadIndex() + 1);

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceHead);

    // Skin color
    kOption.strText = m_strSkinColorSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = string(GetSkinColorIndex() + 1);

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Disabled;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceSkinColor);

    // Hair
    kOption.strText = m_strHairSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = string(GetHairIndex() + 2);

    if (m_kSoldier.IsASpecialSoldier())
    {
        kOption.iState = eUIState_Normal;
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceHair);

    // Hair color
    kOption.strText = m_strHairColorSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = string(GetHairColorIndex() + 1);
    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceHairColor);

    // Facial hair
    kOption.strText = m_strFacialHairSpinner;
    kOption.iState = m_kPawn.m_kAppearance.iGender == 1 ? eUIState_Normal : eUIState_Disabled;
    kOption.strHelp = string(GetFacialHairIndex() + 1);
    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceFacialHair);

    // Gender
    kOption.strText = m_strGenderLabel;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = m_kPawn.m_kAppearance.iGender == eGender_Female ? m_strGenderFemale : m_strGenderMale;
    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceGender);

    // Armor decal
    kOption.strText = m_strArmorDecalSpinner;
    iPossibleArmors = m_kPawn.PossibleArmorKits.Length;

    if (iPossibleArmors == 1)
    {
        kOption.iState = eUIState_Bad;
        kOption.strHelp = m_strNoDecoAvailableForThisArmor;
    }
    else if (iPossibleArmors > 1)
    {
        kOption.iState = eUIState_Normal;
        kOption.strHelp = string(GetArmorDecoIndex() + 1);
    }
    else
    {
        kOption.iState = eUIState_Disabled;
        kOption.strHelp = string(GetArmorDecoIndex() + 1);
    }

    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceArmorDeco);

    // Armor tint
    kOption.strText = m_strArmorTintSpinner;
    kOption.iState = eUIState_Normal;
    kOption.strHelp = GetArmorTintIndex() < 0 ? m_strNoArmorTint : string(GetArmorTintIndex() + 1);
    kSpinnerMenu.arrOptions.AddItem(kOption);
    m_arrSpinnerHandlers.AddItem(AdvanceArmorTint);

    m_kMainMenuSpinnerOptions.mnuOptions = kSpinnerMenu;
}
