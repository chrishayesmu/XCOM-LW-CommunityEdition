class LWCEContentTemplateManager extends LWCEDataTemplateManager;

static function LWCEContentTemplateManager GetInstance()
{
    return LWCEContentTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEContentTemplateManager'));
}

function bool AddContentTemplate(LWCEContentTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEArmorColorContentTemplate FindArmorColorTemplate(name DataName)
{
    return LWCEArmorColorContentTemplate(FindDataTemplate(DataName));
}

function LWCEArmorKitContentTemplate FindArmorKitTemplate(name DataName)
{
    return LWCEArmorKitContentTemplate(FindDataTemplate(DataName));
}

function LWCEFacialHairContentTemplate FindFacialHairTemplate(name DataName)
{
    return LWCEFacialHairContentTemplate(FindDataTemplate(DataName));
}

function LWCEHairContentTemplate FindHairTemplate(name DataName)
{
    return LWCEHairContentTemplate(FindDataTemplate(DataName));
}

function LWCEHairColorContentTemplate FindHairColorTemplate(name DataName)
{
    return LWCEHairColorContentTemplate(FindDataTemplate(DataName));
}

function LWCEHeadContentTemplate FindHeadTemplate(name DataName)
{
    return LWCEHeadContentTemplate(FindDataTemplate(DataName));
}

function LWCEPawnContentTemplate FindPawnTemplate(name DataName)
{
    return LWCEPawnContentTemplate(FindDataTemplate(DataName));
}

function LWCERaceTemplate FindRaceTemplate(name DataName)
{
    return LWCERaceTemplate(FindDataTemplate(DataName));
}

function LWCESkinColorContentTemplate FindSkinColorTemplate(name DataName)
{
    return LWCESkinColorContentTemplate(FindDataTemplate(DataName));
}

function LWCEVoiceContentTemplate FindVoiceTemplate(name DataName)
{
    return LWCEVoiceContentTemplate(FindDataTemplate(DataName));
}

/**
 * Finds all armor kits which are usable with the given armor. If nmWeapon and kDefaultKit are provided, then kDefaultKit will be populated with whichever
 * armor kit is set as the default to go with the given weapon, if any. If multiple armor kits are set this way, which one is used is unspecified.
 */
function array<LWCEArmorKitContentTemplate> FindMatchingArmorKits(name nmArmor, optional name nmWeapon, optional out LWCEArmorKitContentTemplate kDefaultKit)
{
    local int Index;
    local LWCEArmorKitContentTemplate ArmorKit;
    local array<LWCEArmorKitContentTemplate> ArmorKits;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        ArmorKit = LWCEArmorKitContentTemplate(m_arrTemplates[Index].kTemplate);

        if (ArmorKit == none)
        {
            continue;
        }

        if (ArmorKit.arrSupportedArmors.Find(nmArmor) == INDEX_NONE)
        {
            continue;
        }

        if (nmWeapon != '' && ArmorKit.arrDefaultForWeapons.Find(nmWeapon) != INDEX_NONE)
        {
            kDefaultKit = ArmorKit;
        }

        ArmorKits.AddItem(ArmorKit);
    }

    return ArmorKits;
}

function array<LWCEHairContentTemplate> FindMatchingHair(EGender Gender, optional bool bCivilianOnly = false, optional bool bAllowHelmets = false, optional name CustomTag = '')
{
    local int Index;
    local LWCEHairContentTemplate Hair;
    local array<LWCEHairContentTemplate> HairTemplates;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        Hair = LWCEHairContentTemplate(m_arrTemplates[Index].kTemplate);

        if (Hair == none)
        {
            continue;
        }

        if (Hair.Gender != Gender && !Hair.bIsHelmet)
        {
            continue;
        }

        if (bCivilianOnly && !Hair.bCanUseOnCivilian)
        {
            continue;
        }

        if (!bAllowHelmets && Hair.bIsHelmet)
        {
            continue;
        }

        if (Hair.CustomTag != CustomTag)
        {
            continue;
        }

        HairTemplates.AddItem(Hair);
    }

    return HairTemplates;
}

function array<LWCEHeadContentTemplate> FindMatchingHeads(ECharacter Character, name nmRace, optional EGender Gender = eGender_None, optional name CustomTag = '')
{
    local int Index;
    local LWCEHeadContentTemplate Head;
    local array<LWCEHeadContentTemplate> Heads;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        Head = LWCEHeadContentTemplate(m_arrTemplates[Index].kTemplate);

        if (Head == none)
        {
            continue;
        }

        if (Head.Character != Character)
        {
            continue;
        }

        if (nmRace != '' && Head.Race != nmRace)
        {
            continue;
        }

        if (Gender != eGender_None && Head.Gender != Gender)
        {
            continue;
        }

        if (Head.CustomTag != CustomTag)
        {
            continue;
        }

        Heads.AddItem(Head);
    }

    return Heads;
}

function LWCEPawnContentTemplate FindMatchingPawn(ECharacter Character, optional EGender Gender = eGender_None, optional name nmArmor)
{
    local int Index;
    local LWCEPawnContentTemplate Pawn;
    local array<LWCEPawnContentTemplate> Pawns;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        Pawn = LWCEPawnContentTemplate(m_arrTemplates[Index].kTemplate);

        if (Pawn == none)
        {
            continue;
        }

        if (Pawn.Character != Character)
        {
            continue;
        }

        if (Gender != eGender_None && Pawn.Gender != Gender)
        {
            continue;
        }

        if (Pawn.ArmorTemplate != nmArmor)
        {
            continue;
        }

        Pawns.AddItem(Pawn);
    }

    if (Pawns.Length != 1)
    {
        `LWCE_LOG_CLS("WARNING: expected to find exactly 1 pawn matching character " $ Character $ ", Gender " $ Gender $ ", and armor '" $ nmArmor $ "'. Content may be misconfigured.");
    }

    return Pawns[0];
}

function array<LWCESkinColorContentTemplate> FindMatchingSkinColors(name nmRace)
{
    local int Index;
    local LWCESkinColorContentTemplate SkinColor;
    local array<LWCESkinColorContentTemplate> SkinColors;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        SkinColor = LWCESkinColorContentTemplate(m_arrTemplates[Index].kTemplate);

        if (SkinColor == none)
        {
            continue;
        }

        if (SkinColor.Race != nmRace)
        {
            continue;
        }

        SkinColors.AddItem(SkinColor);
    }

    return SkinColors;
}

function array<LWCEVoiceContentTemplate> FindMatchingVoices(EGender Gender, name Language, optional bool bIsMec = false, optional name CustomTag = '')
{
    local int Index;
    local LWCEVoiceContentTemplate Voice;
    local array<LWCEVoiceContentTemplate> Voices;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        Voice = LWCEVoiceContentTemplate(m_arrTemplates[Index].kTemplate);

        if (Voice == none)
        {
            continue;
        }

        if (Voice.Gender != Gender)
        {
            continue;
        }

        if (Voice.Language != Language)
        {
            continue;
        }

        if (Voice.bIsMec != bIsMec)
        {
            continue;
        }

        if (Voice.CustomTag != CustomTag)
        {
            continue;
        }

        Voices.AddItem(Voice);
    }

    return Voices;
}

function array<LWCEArmorColorContentTemplate> GetArmorColors()
{
    local int Index;
    local LWCEArmorColorContentTemplate ArmorColor;
    local array<LWCEArmorColorContentTemplate> ArmorColorTemplates;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        ArmorColor = LWCEArmorColorContentTemplate(m_arrTemplates[Index].kTemplate);

        if (ArmorColor == none)
        {
            continue;
        }

        ArmorColorTemplates.AddItem(ArmorColor);
    }

    return ArmorColorTemplates;
}

function array<LWCEFacialHairContentTemplate> GetFacialHairs()
{
    local int Index;
    local LWCEFacialHairContentTemplate FacialHair;
    local array<LWCEFacialHairContentTemplate> FacialHairTemplates;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        FacialHair = LWCEFacialHairContentTemplate(m_arrTemplates[Index].kTemplate);

        if (FacialHair == none)
        {
            continue;
        }

        FacialHairTemplates.AddItem(FacialHair);
    }

    return FacialHairTemplates;
}

function array<LWCEHairColorContentTemplate> GetHairColors()
{
    local int Index;
    local LWCEHairColorContentTemplate HairColor;
    local array<LWCEHairColorContentTemplate> HairColorTemplates;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        HairColor = LWCEHairColorContentTemplate(m_arrTemplates[Index].kTemplate);

        if (HairColor == none)
        {
            continue;
        }

        HairColorTemplates.AddItem(HairColor);
    }

    return HairColorTemplates;
}

function array<LWCERaceTemplate> GetRaces()
{
    local int Index;
    local LWCERaceTemplate Race;
    local array<LWCERaceTemplate> RaceTemplates;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        Race = LWCERaceTemplate(m_arrTemplates[Index].kTemplate);

        if (Race == none)
        {
            continue;
        }

        RaceTemplates.AddItem(Race);
    }

    return RaceTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEContentTemplate'
}