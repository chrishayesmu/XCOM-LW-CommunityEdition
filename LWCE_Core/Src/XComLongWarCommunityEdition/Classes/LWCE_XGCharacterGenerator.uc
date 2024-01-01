class LWCE_XGCharacterGenerator extends XGCharacterGenerator
    config(LWCECharacters);

struct LWCE_TDefaultSoldierAppearance
{
    var int iSoldierClassId;
    var name nmArmorColor;
    var name nmArmorKit;
    var name nmHair;
};

struct LWCE_TNextVoice
{
    var int iNextIndex;
    var name nmLanguage;
    var name nmGender;
    var bool bIsMec;
};

var config array<LWCE_TDefaultSoldierAppearance> arrSoldierColors;

var private array<LWCE_TNextVoice> m_arrNextVoices;

static function LWCE_TDefaultSoldierAppearance FindDefaultAppearanceForClass(int iSoldierClassId)
{
    local int Index;
    local LWCE_TDefaultSoldierAppearance Appearance;

    Index = default.arrSoldierColors.Find('iSoldierClassId', iSoldierClassId);

    if (Index != INDEX_NONE)
    {
        Appearance = default.arrSoldierColors[Index];
    }

    return Appearance;
}

static function name LanguageNameByBaseID(int iLanguage)
{
    // Note: this reflects the full list of languages as entered in XComStrategyGame.int
    switch (iLanguage)
    {
        case 0:
            return 'EnglishAmerican';
        case 1:
            return 'French';
        case 2:
            return 'German';
        case 3:
            return 'Italian';
        case 4:
            return 'Polish';
        case 5:
            return 'Russian';
        case 6:
            return 'Spanish';
        case 7:
            return 'EnglishBritish';
        case 8:
            return 'EnglishAustralian';
        case 9:
            return 'EnglishScottish';
        case 10:
            return 'EnglishIrish';
        case 11:
            return 'EnglishSouthAfrican';
        case 12:
            return 'EnglishSoutheastAsian';
        case 13:
            return 'EnglishWestAfrican';
        case 14:
            return 'EnglishEuropean';
        case 16:
            return 'EnglishCanadian';
        case 17:
            return 'Chinese';
        case 18:
            return 'Japanese';
        case 19:
            return 'Hindi';
        case 20:
            return 'Korean';
        case 21:
            return 'Portuguese';
        case 22:
            return 'SpanishWestern';
        case 23:
            return 'Ukrainian';
        case 24:
            return 'Hebrew';
        case 25:
            return 'Greek';
        case 26:
            return 'Swedish';
        case 27:
            return 'Norwegian';
        case 28:
            return 'Dutch';
        case 29:
            return 'Arabic';
        default:
            // Use language based on the game's language (should always terminate after one recursive call)
            return LanguageNameByBaseID(GetLanguageByString());
    }
}

static function ECharacterRace RaceBaseIDByName(name nmRace)
{
    switch (nmRace)
    {
        case 'African':
            return eRace_African;
        case 'Asian':
            return eRace_Asian;
        case 'Caucasian':
            return eRace_Caucasian;
        case 'Hispanic':
            return eRace_Hispanic;
        default:
            return eRace_MAX;
    }
}

static function name RaceNameByBaseID(int iRace)
{
    switch (iRace)
    {
        case eRace_African:
            return 'African';
        case eRace_Asian:
            return 'Asian';
        case eRace_Caucasian:
            return 'Caucasian';
        case eRace_Hispanic:
            return 'Hispanic';
        default:
            return '';
    }
}

function TSoldier CreateTSoldier(optional EGender eForceGender, optional int iCountry = -1, optional int iRace = -1, optional ESoldierClass eClass)
{
    local TSoldier kSoldier;

    `LWCE_LOG_DEPRECATED_CLS(CreateTSoldier);

    return kSoldier;
}

function LWCE_TSoldier LWCE_CreateTSoldier(optional name nmForceGender, optional name nmCountry = '', optional name nmRaceTemplate = '', optional bool bIsAugmented = false)
{
    local LWCE_TSoldier kSoldier;
    local LWCE_TDefaultSoldierAppearance DefaultAppearance;
    local LWCEContentTemplateManager kTemplateMgr;
    local LWCECountryTemplate kCountryTemplate;
    local array<LWCEHairContentTemplate> arrHairs;
    local array<LWCEHeadContentTemplate> arrHeads;

    kTemplateMgr = `LWCE_CONTENT_TEMPLATE_MGR;
    DefaultAppearance = FindDefaultAppearanceForClass(/* iSoldierClassId */ 0);

    if (nmCountry == '')
    {
        nmCountry = LWCE_PickOriginCountry();
    }

    kCountryTemplate = `LWCE_COUNTRY(nmCountry);

    kSoldier.nmCountry = nmCountry;
    kSoldier.kAppearance.strFlagPath = kCountryTemplate.strFlagIconPath;
    kSoldier.iRank = 0;

    if (nmRaceTemplate == '')
    {
        kSoldier.kAppearance.nmRace = kCountryTemplate.RollForRace();
    }
    else
    {
        kSoldier.kAppearance.nmRace = nmRaceTemplate;
    }

    if (nmForceGender != '')
    {
        kSoldier.kAppearance.nmGender = nmForceGender;
    }
    else
    {
        // TODO: set up a config somewhere to roll for genders (maybe specify weight in a new gender template)
        kSoldier.kAppearance.nmGender = Rand(2) == 0 ? 'Female' : 'Male';
    }

    // Soldier language: check the game setting for whether all soldiers should speak the player's language
    if (`PROFILESETTINGS != none && `PROFILESETTINGS.Data != none && `PROFILESETTINGS.Data.m_bForeignLanguages)
    {
        kSoldier.kAppearance.nmLanguage = kCountryTemplate.RollForSpokenLanguage();
    }
    else
    {
        kSoldier.kAppearance.nmLanguage = LanguageNameByBaseID(GetLanguageByString());
    }

    if (DefaultAppearance.nmHair != '')
    {
        kSoldier.kAppearance.nmHaircut = DefaultAppearance.nmHair;
    }
    else
    {
        arrHairs = kTemplateMgr.FindMatchingHair(kSoldier.kAppearance.nmGender, /* bCivilianOnly */ false, /* bAllowHelmets */ false);
        kSoldier.kAppearance.nmHaircut = arrHairs[Rand(arrHairs.Length)].GetContentTemplateName();
    }

    arrHeads = kTemplateMgr.FindMatchingHeads(eChar_Soldier, kSoldier.kAppearance.nmRace, kSoldier.kAppearance.nmGender);
    kSoldier.kAppearance.nmHead = arrHeads[Rand(arrHeads.Length)].GetContentTemplateName();

    // bIsAugmented: right now soldiers are only generated as bio troops, but possibly a mod will want hooks to create new MECs directly
    kSoldier.kAppearance.nmVoice = LWCE_GetNextVoice(kSoldier.kAppearance.nmGender, kSoldier.kAppearance.nmLanguage, /* bIsAugmented */ false);

    // Not all languages have voice packs for all gender/MEC combos; fallback if we get an invalid combination
    if (kSoldier.kAppearance.nmVoice == '')
    {
        kSoldier.kAppearance.nmLanguage = PickFallbackLanguageForVoice(kSoldier.kAppearance.nmLanguage);
        kSoldier.kAppearance.nmVoice = LWCE_GetNextVoice(kSoldier.kAppearance.nmGender, kSoldier.kAppearance.nmLanguage, /* bIsAugmented */ false);
    }

    kSoldier.kAppearance.nmArmorColor = DefaultAppearance.nmArmorColor;
    kSoldier.kAppearance.nmArmorKit = DefaultAppearance.nmArmorKit;
    kSoldier.kAppearance.nmHairColor = ChooseRandomHairColor().GetContentTemplateName();
    kSoldier.kAppearance.nmSkinColor = ChooseRandomSkinColorForRace(kSoldier.kAppearance.nmRace).GetContentTemplateName();

    LWCE_GenerateName(kSoldier.kAppearance.nmGender, kSoldier.nmCountry, kSoldier.kAppearance.nmRace, kSoldier.strFirstName, kSoldier.strLastName);

    return kSoldier;
}

function GenerateName(int iGender, int iCountry, out string strFirst, out string strLast, optional int iRace = -1)
{
    `LWCE_LOG_DEPRECATED_CLS(GenerateName);
}

/// <summary>
/// Generates a first and last name using the provided gender, country, and race.
/// </summary>
function LWCE_GenerateName(name nmGender, name nmCountry, name nmRace, out string strFirst, out string strLast)
{
    local LWCECountryTemplate kCountryTemplate;
    local LWCENameListTemplate kNameListTemplate;
    local name nmFirstNameList, nmLastNameList;

    kCountryTemplate = `LWCE_COUNTRY(nmCountry);

    nmFirstNameList = kCountryTemplate.RollForFirstNameList(nmRace, nmGender);
    nmLastNameList = kCountryTemplate.RollForLastNameList(nmRace, nmGender);

    if (nmFirstNameList != '')
    {
        kNameListTemplate = `LWCE_NAME_LIST(nmFirstNameList);
        strFirst = kNameListTemplate.RollForName();
    }

    if (nmLastNameList != '')
    {
        kNameListTemplate = `LWCE_NAME_LIST(nmLastNameList);
        strLast = kNameListTemplate.RollForName();
    }
}

function int GetNextFemaleVoice(ECharacterLanguage eLang, bool IsMec)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetNextFemaleVoice was called. This needs to be replaced with LWCE_GetNextVoice. Stack trace follows.");
    ScriptTrace();

    return -1;
}

function int GetNextMaleVoice(ECharacterLanguage eLang, bool IsMec)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetNextMaleVoice was called. This needs to be replaced with LWCE_GetNextVoice. Stack trace follows.");
    ScriptTrace();

    return -1;
}

function name LWCE_GetNextVoice(name nmGender, name nmLanguage, bool bIsMec)
{
    local int iVoiceTrackingIndex;
    local LWCE_TNextVoice kNextVoice;
    local array<LWCEVoiceContentTemplate> PossibleVoices;

    iVoiceTrackingIndex = GetVoiceTrackingRecordIndex(nmGender, nmLanguage, bIsMec);

    if (iVoiceTrackingIndex == INDEX_NONE)
    {
        kNextVoice.iNextIndex = 0;
        kNextVoice.nmGender = nmGender;
        kNextVoice.nmLanguage = nmLanguage;
        kNextVoice.bIsMec = bIsMec;

        iVoiceTrackingIndex = m_arrNextVoices.Length;
        m_arrNextVoices.AddItem(kNextVoice);
    }

    PossibleVoices = `LWCE_CONTENT_TEMPLATE_MGR.FindMatchingVoices(nmGender, nmLanguage, bIsMec);

    if (PossibleVoices.Length == 0)
    {
        return '';
    }

    if (m_arrNextVoices[iVoiceTrackingIndex].iNextIndex >= PossibleVoices.Length)
    {
        m_arrNextVoices[iVoiceTrackingIndex].iNextIndex = 0;
    }

    m_arrNextVoices[iVoiceTrackingIndex].iNextIndex++;

    return PossibleVoices[m_arrNextVoices[iVoiceTrackingIndex].iNextIndex - 1].GetContentTemplateName();
}

function ECharacterLanguage GetLanguageByCountry(ECountry Country)
{
    `LWCE_LOG_DEPRECATED_BY(LWCECountryTemplate.RollForSpokenLanguage);

    return ECharacterLanguage(0);
}

function int GetRandomRaceByCountry(int iCountry)
{
    `LWCE_LOG_DEPRECATED_BY(LWCECountryTemplate.RollForRace);

    return -1;
}

function int PickOriginCountry(optional int iContinent)
{
    `LWCE_LOG_DEPRECATED_CLS(PickOriginCountry);

    return -1;
}

function name LWCE_PickOriginCountry()
{
    local array<LWCE_XGCountry> arrCountries;
    local LWCE_XGCountry kCountry;
    local int iRoll, iSum, iTotalWeight;

    arrCountries = `LWCE_WORLD.LWCE_GetCountries();

    foreach arrCountries(kCountry)
    {
        iTotalWeight += kCountry.m_kTemplate.iSoldierOriginWeight;
    }

    iRoll = Rand(iTotalWeight);

    foreach arrCountries(kCountry)
    {
        iSum += kCountry.m_kTemplate.iSoldierOriginWeight;

        if (iRoll < iSum)
        {
            return kCountry.m_nmCountry;
        }
    }

    return arrCountries[arrCountries.Length - 1].m_nmCountry;
}

static protected function LWCEHairColorContentTemplate ChooseRandomHairColor()
{
    local array<LWCEHairColorContentTemplate> arrPossibleHairColors;

    arrPossibleHairColors = `LWCE_CONTENT_TEMPLATE_MGR.GetHairColors();

    return arrPossibleHairColors[Rand(arrPossibleHairColors.Length)];
}

static protected function LWCESkinColorContentTemplate ChooseRandomSkinColorForRace(name nmRace)
{
    local array<LWCESkinColorContentTemplate> arrPossibleSkinColors;

    arrPossibleSkinColors = `LWCE_CONTENT_TEMPLATE_MGR.FindMatchingSkinColors(nmRace);

    return arrPossibleSkinColors[Rand(arrPossibleSkinColors.Length)];
}

/// <summary>
/// Chooses a language which should have a voice pack available, using the original language to
/// try and get something kinda similar. This is only meant as a stopgap for logic in the original
/// game, and isn't dynamic based on actual loaded voice packs or anything else.
/// </summary>
static protected function name PickFallbackLanguageForVoice(name nmLanguage)
{
    // TODO: replace this with some sort of config-based fallback
    switch (nmLanguage)
    {
        case 'EnglishBritish':
        case 'EnglishAustralian':
        case 'EnglishScottish':
        case 'EnglishIrish':
        case 'EnglishSouthAfrican':
        case 'EnglishCanadian':
            return 'EnglishAmerican';
        case 'SpanishWestern':
            return 'Spanish';
        case 'Ukrainian':
            return 'Russian';
        default:
            return LanguageNameByBaseID(GetLanguageByString());
    }
}

protected function int GetVoiceTrackingRecordIndex(name nmGender, name nmLanguage, bool bIsMec)
{
    local int Index;

    for (Index = 0; Index < m_arrNextVoices.Length; Index++)
    {
        if (m_arrNextVoices[Index].nmGender == nmGender && m_arrNextVoices[Index].nmLanguage == nmLanguage && m_arrNextVoices[Index].bIsMec == bIsMec)
        {
            return Index;
        }
    }

    return INDEX_NONE;
}