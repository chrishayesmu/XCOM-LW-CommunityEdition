class LWCEContentTemplateManager extends LWCEDataTemplateManager;

static function LWCEContentTemplateManager GetInstance()
{
    return LWCEContentTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEContentTemplateManager'));
}

function bool AddContentTemplate(LWCEContentTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEBodyContentTemplate FindBodyTemplate(name DataName)
{

}

function LWCEHairContentTemplate FindHairTemplate(name DataName)
{
    return LWCEHairContentTemplate(FindDataTemplate(DataName));
}

function LWCEHeadContentTemplate FindHeadTemplate(name DataName)
{
    return LWCEHeadContentTemplate(FindDataTemplate(DataName));
}

function LWCEPawnContentTemplate FindPawnTemplate(name DataName)
{
    return LWCEPawnContentTemplate(FindDataTemplate(DataName));
}

function LWCEVoiceContentTemplate FindVoiceTemplate(name DataName)
{
    return LWCEVoiceContentTemplate(FindDataTemplate(DataName));
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

        if (Hair.Gender != Gender)
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

defaultproperties
{
    ManagedTemplateClass=class'LWCEContentTemplate'
}