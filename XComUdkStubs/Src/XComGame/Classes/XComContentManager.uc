class XComContentManager extends Object
    native(Core)
    config(Content);

enum EUIMode
{
    eUIMode_Common,
    eUIMode_Shell,
    eUIMode_Tactical,
    eUIMode_Strategy,
    eUIMode_MAX
};

enum EContentCategory
{
    eContent_Unit,
    eContent_Weapon,
    eContent_ArmorKit,
    eContent_UI,
    eContent_Head,
    eContent_Body,
    eContent_Hair,
    eContent_Voice,
    eContent_Palette,
    eContent_Perk,
    eContent_MAX
};

enum EColorPalette
{
    ePalette_HairColor<DisplayName=Hair Color>,
    ePalette_ShirtColor<DisplayName=Shirt Color>,
    ePalette_PantsColor<DisplayName=Pants Color>,
    ePalette_FormalClothesColor<DisplayName=Formal Clothes Color>,
    ePalette_CaucasianSkin<DisplayName=Caucasian Skin>,
    ePalette_AfricanSkin<DisplayName=African Skin>,
    ePalette_HispanicSkin<DisplayName=Hispanic Skin>,
    ePalette_AsianSkin<DisplayName=Asian Skin>,
    ePalette_EyeColor<DisplayName=Eye Color>,
    ePalette_ArmorTint<DisplayName=Armor Tints>,
    ePalette_MAX
};

struct native TSoldierPawnContent
{
    var int iPawn;
    var int iKit;
    var TAppearance kAppearance;
    var TInventory kInventory;
    var array<int> arrPerkWeapons;
    var array<int> arrPerkContent;

    structdefaultproperties
    {
        kAppearance=(iHead=-1,iHaircut=-1,iBody=-1,iBodyMaterial=-1,iSkinColor=-1,iEyeColor=-1,iFlag=-1,iArmorSkin=-1,iVoice=-1,iArmorDeco=-1,iArmorTint=-1)
    }
};

struct native TCivilianPawnContent
{
    var int iPawn;
    var array<int> MaleBodies;
    var array<int> MaleHeads;
    var array<int> MaleHairs;
    var array<int> FemaleBodies;
    var array<int> FemaleHeads;
    var array<int> FemaleHairs;
};

struct native TPawnContent
{
    var array<int> arrAlienPawns;
    var array<TCivilianPawnContent> arrCivilianPawns;
    var array<TSoldierPawnContent> arrSoldierPawns;
};

struct native TTransferSoldier
{
    var TCharacter kChar;
    var TSoldier kSoldier;
    var int aStatModifiers[ECharacterStat];
    var int iHPAfterCombat;
    var int iCriticalWoundsTaken;
    var int iUnitLoadoutID;
    var bool bLeftBehind;
    var init string CauseOfDeathString;

    structdefaultproperties
    {
        iUnitLoadoutID=-1
    }
};

struct native ArchetypeLoadedCallback
{
    var Object Target;
    var delegate<OnArchetypeLoaded> Callback;
    var int ArchetypeIndex;
};

struct native XComPackageInfo
{
    var init config string ArchetypeName;
    var transient Object Archetype;
    var init array<init ArchetypeLoadedCallback> LoadedCallbacks;
};

struct native XComUnitPackageInfo extends XComPackageInfo
{
    var config EPawnType PawnType;
    var config array<config string> SkinArchetypeNames;
    var transient array<Actor> SkinArchetypes;
};

struct native XComWeaponPackageInfo extends XComPackageInfo
{
    var config EItemType ItemType;
};

struct native XComArmorKitPackageInfo extends XComPackageInfo
{
    var config EArmorKit KitType;
};

struct native XComHeadPackageInfo extends XComPackageInfo
{
    var config int Id;
    var config name CustomTag;
    var config EGender Gender;
    var config ECharacter Character;
    var config ECharacterRace Race;
};

struct native XComBodyPackageInfo extends XComPackageInfo
{
    var config int Id;
    var config name CustomTag;
    var config EGender Gender;
    var config ECharacter Character;
    var config ECharacterRace Race;
    var config ECivilianType Type;
};

struct native XComHairPackageInfo extends XComPackageInfo
{
    var config int Id;
    var config name CustomTag;
    var config EGender Gender;
    var config ECharacter Character;
    var config ECharacterRace Race;
    var config EPawnType Pawn;
    var config bool bCanUseOnCivilian;
    var config bool bIsHelmet;
};

struct native XComVoicePackageInfo extends XComPackageInfo
{
    var config ECharacterVoice VoiceType;
    var int Language;
    var bool IsMec;
};

struct native XComColorPalettePackageInfo extends XComPackageInfo
{
    var config EColorPalette Palette;
};

struct native XComPerkPackageInfo extends XComPackageInfo
{
    var config EPerkType Perk;
};

struct native ArmorKitDesc
{
    var config EItemType Armor;
    var config EItemType Weapon;
    var config EArmorKit ArmorKit;
    var byte Padding;
};

struct native CountryFlag
{
    var config ECountry Country;
    var config float U;
    var config float V;
};

struct native FacialHairPreset
{
    var config float U;
    var config LinearColor Mask;
    var config int MaskARGB;
};

struct native CivilianTemplate
{
    var config name TemplateName;
    var config name HeadTag;
    var config name BodyTag;
    var config name HairTag;
};

var protected config array<config XComUnitPackageInfo> UnitPackageInfo;
var protected config array<config XComWeaponPackageInfo> WeaponPackageInfo;
var protected config array<config XComArmorKitPackageInfo> ArmorKitPackageInfo;
var protected config array<config XComHeadPackageInfo> HeadPackageInfo;
var protected config array<config XComBodyPackageInfo> BodyPackageInfo;
var protected config array<config XComHairPackageInfo> HairPackageInfo;
var protected config array<config XComVoicePackageInfo> VoicePackageInfo;
var protected config array<config XComColorPalettePackageInfo> ColorPaletteInfo;
var protected config array<config XComPerkPackageInfo> PerkPackageInfo;
var transient array<int> RequiredUnits;
var transient array<int> RequiredWeapons;
var transient array<int> RequiredArmorKits;
var transient array<int> RequiredHeads;
var transient array<int> RequiredBodies;
var transient array<int> RequiredHair;
var transient array<int> RequiredVoices;
var transient array<int> RequiredPerks;
var protected config array<config ArmorKitDesc> ArmorKits;
var protected config array<config ArmorKitDesc> ArmorDeco;
var protected config array<config CountryFlag> Flags;
var protectedwrite config array<config FacialHairPreset> FacialHairPresets;
var config array<config CivilianTemplate> CivilianTemplates;
var config bool bAllowJITLoad;
var privatewrite bool bNeedsFlushForGC;
var EUIMode LastUIMode;
var array<Object> MapContent;
var private native const Map_Mirror ResourceTags;
var private native const Map_Mirror GameContentCache;
var int NumActiveAsyncAlienContentRequests;
var Object AsyncAlienContentCallbackOwner;
var delegate<OnAlienContentFinishedLoading> AsyncAlienContentCallback;

delegate OnArchetypeLoaded(Object LoadedArchetype, int ContentId, int SubID)
{
}

delegate OnObjectLoaded(Object LoadedArchetype)
{
}

delegate OnAlienContentFinishedLoading()
{
}