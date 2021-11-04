class XComContentManager extends Object
    native(Core)
    config(Content)
	dependson(XGTacticalGameCoreNativeBase);

//complete stub
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
    ePalette_HairColor,
    ePalette_ShirtColor,
    ePalette_PantsColor,
    ePalette_FormalClothesColor,
    ePalette_CaucasianSkin,
    ePalette_AfricanSkin,
    ePalette_HispanicSkin,
    ePalette_AsianSkin,
    ePalette_EyeColor,
    ePalette_ArmorTint,
    ePalette_MAX
};

struct TSoldierPawnContent
{
    var int iPawn;
    var int iKit;
    var TAppearance kAppearance;
    var TInventory kInventory;
    var array<int> arrPerkWeapons;
    var array<int> arrPerkContent;

};

struct TCivilianPawnContent
{
    var int iPawn;
    var array<int> MaleBodies;
    var array<int> MaleHeads;
    var array<int> MaleHairs;
    var array<int> FemaleBodies;
    var array<int> FemaleHeads;
    var array<int> FemaleHairs;

};

struct TPawnContent
{
    var array<int> arrAlienPawns;
    var array<TCivilianPawnContent> arrCivilianPawns;
    var array<TSoldierPawnContent> arrSoldierPawns;

};

struct TTransferSoldier
{
    var TCharacter kChar;
    var TSoldier kSoldier;
    var int aStatModifiers[19];
    var int iHPAfterCombat;
    var int iCriticalWoundsTaken;
    var int iUnitLoadoutID;
    var bool bLeftBehind;
    var init string CauseOfDeathString;
};

struct ArchetypeLoadedCallback
{
    var Object Target;
    var delegate<OnArchetypeLoaded> Callback;
    var int ArchetypeIndex;
};

struct XComPackageInfo
{
    var init config string ArchetypeName;
    var transient Object Archetype;
    var init array<init ArchetypeLoadedCallback> LoadedCallbacks;

};

struct XComUnitPackageInfo extends XComPackageInfo
{
    var config XGGameData.EPawnType PawnType;
    var config array<config string> SkinArchetypeNames;
    var transient array<Actor> SkinArchetypes;
};

struct XComWeaponPackageInfo extends XComPackageInfo
{
    var config XGGameData.EItemType ItemType;
};

struct XComArmorKitPackageInfo extends XComPackageInfo
{
    var config XGGameData.EArmorKit KitType;
};

struct XComHeadPackageInfo extends XComPackageInfo
{
    var config int Id;
    var config name CustomTag;
    var config XGTacticalGameCoreNativeBase.EGender Gender;
    var config XGGameData.ECharacter Character;
    var config XGTacticalGameCoreNativeBase.ECharacterRace Race;
};

struct XComBodyPackageInfo extends XComPackageInfo
{
    var config int Id;
    var config name CustomTag;
    var config XGTacticalGameCoreNativeBase.EGender Gender;
    var config XGGameData.ECharacter Character;
    var config XGTacticalGameCoreNativeBase.ECharacterRace Race;
    var config XGTacticalGameCoreNativeBase.ECivilianType Type;
};

struct XComHairPackageInfo extends XComPackageInfo
{
    var config int Id;
    var config name CustomTag;
    var config XGTacticalGameCoreNativeBase.EGender Gender;
    var config XGGameData.ECharacter Character;
    var config XGTacticalGameCoreNativeBase.ECharacterRace Race;
    var config XGGameData.EPawnType Pawn;
    var config bool bCanUseOnCivilian;
    var config bool bIsHelmet;
};

struct XComVoicePackageInfo extends XComPackageInfo
{
    var config XGGameData.ECharacterVoice VoiceType;
    var int Language;
    var bool IsMec;
};

struct XComColorPalettePackageInfo extends XComPackageInfo
{
    var config EColorPalette Palette;
};

struct XComPerkPackageInfo extends XComPackageInfo
{
    var config XGTacticalGameCoreNativeBase.EPerkType Perk;
};

struct ArmorKitDesc
{
    var config XGGameData.EItemType Armor;
    var config XGGameData.EItemType Weapon;
    var config XGGameData.EArmorKit ArmorKit;
    var byte Padding;

};

struct CountryFlag
{
    var config XGGameData.ECountry Country;
    var config float U;
    var config float V;

};

struct FacialHairPreset
{
    var config float U;
    var config LinearColor Mask;
    var config int MaskARGB;

};

struct CivilianTemplate
{
    var config name TemplateName;
    var config name HeadTag;
    var config name BodyTag;
    var config name HairTag;

};
var config array<config XComUnitPackageInfo> UnitPackageInfo;
var config array<config XComWeaponPackageInfo> WeaponPackageInfo;
var config array<config XComArmorKitPackageInfo> ArmorKitPackageInfo;
var config array<config XComHeadPackageInfo> HeadPackageInfo;
var config array<config XComBodyPackageInfo> BodyPackageInfo;
var config array<config XComHairPackageInfo> HairPackageInfo;
var config array<config XComVoicePackageInfo> VoicePackageInfo;
var config array<config XComColorPalettePackageInfo> ColorPaletteInfo;
var config array<config XComPerkPackageInfo> PerkPackageInfo;
var transient array<int> RequiredUnits;
var transient array<int> RequiredWeapons;
var transient array<int> RequiredArmorKits;
var transient array<int> RequiredHeads;
var transient array<int> RequiredBodies;
var transient array<int> RequiredHair;
var transient array<int> RequiredVoices;
var transient array<int> RequiredPerks;
var config array<config ArmorKitDesc> ArmorKits;
var config array<config ArmorKitDesc> ArmorDeco;
var config array<config CountryFlag> Flags;
var config array<config FacialHairPreset> FacialHairPresets;
var config array<config CivilianTemplate> CivilianTemplates;
var config bool bAllowJITLoad;
var bool bNeedsFlushForGC;
var EUIMode LastUIMode;
var array<Object> MapContent;
var const Map_Mirror ResourceTags;
var const Map_Mirror GameContentCache;
var int NumActiveAsyncAlienContentRequests;
var Object AsyncAlienContentCallbackOwner;
var delegate<OnAlienContentFinishedLoading> AsyncAlienContentCallback;
var delegate<OnArchetypeLoaded> __OnArchetypeLoaded__Delegate;
var delegate<OnObjectLoaded> __OnObjectLoaded__Delegate;
var delegate<OnAlienContentFinishedLoading> __OnAlienContentFinishedLoading__Delegate;

delegate OnArchetypeLoaded(Object LoadedArchetype, int ContentId, int SubID)
{}

delegate OnObjectLoaded(Object LoadedArchetype)
{}

delegate OnAlienContentFinishedLoading()
{}
simulated function GetPossibleVoices(EGender Gender, int LanguageIdx, bool bIsMec, out array<ECharacterVoice> VoiceIds)
{}
simulated function RequestContentCacheFlush() {}

simulated function GetContentForMap(string MapName, out TPawnContent Content){}
simulated function RequestContent(const out TPawnContent InContent, bool bRequestAlienCivilianContent){}
simulated function RequestContentForInventory(const out TInventory Inv){}
simulated function RequestAlienContent(const out TPawnContent InContent){}
simulated function RequestAlienContentForPawnType(XGGameData.EPawnType PawnType){}
simulated function ClearRequestedContent(){}
simulated function FlushArchetypeCache(){}
final function NotifyClientsOfRequiredContent(){}
native final simulated function RequestContentForCheckpoint(Checkpoint InCheckpoint);
final function RequestObjectAsync(string Object, optional Object CallbackObject, optional delegate<OnObjectLoaded> Callback){}
final function RequestContentArchetype(EContentCategory ContentType, int Id, optional int SubID=-1, optional Object CallbackObject, optional delegate<OnArchetypeLoaded> Callback, optional bool bAsync){}
final function RequestContentArchetypeByTag(EContentCategory ContentType, name CustomTag, optional Object CallbackObject, optional delegate<OnArchetypeLoaded> Callback, optional bool bAsync){}
final function int GetContentIdFromTag(EContentCategory ContentType, const out name CustomTag){}
final function GetContentIdsForGender(EContentCategory ContentType, XGTacticalGameCoreNativeBase.EGender Gender, out array<int> Ids, optional bool bCivilianOnly, optional bool bAllowHelmets){}
final function GetContentIdsForCharacter(EContentCategory ContentType, XGGameData.ECharacter CharType, out array<int> Ids, optional bool bCivilianOnly, optional bool bAllowHelmets){}
final function GetContentIdsForRace(EContentCategory ContentType, XGTacticalGameCoreNativeBase.ECharacterRace Race, out array<int> Ids, optional bool bCivilianOnly, optional bool bAllowHelmets){}
final function GetContentIdsForPawn(EContentCategory ContentType, XGGameData.EPawnType PawnType, out array<int> Ids, optional bool bAllowHelmets){}
final function GetContentIdsForArmor(EContentCategory ContentType, XGGameData.EItemType ArmorType, out array<int> Ids, optional bool bGeneModOnly){}
final function bool GetContentInfo_Unit(int Id, out XComUnitPackageInfo UnitInfo){}
final function bool GetContentInfo_Weapon(int Id, out XComWeaponPackageInfo WeaponInfo){}
final function bool GetContentInfo_ArmorKit(int Id, out XComArmorKitPackageInfo KitInfo){}
final function bool GetContentInfo_Head(int Id, out XComHeadPackageInfo HeadInfo){}
final function bool GetContentInfo_Body(int Id, out XComBodyPackageInfo BodyInfo){}
final function bool GetContentInfo_Hair(int Id, out XComHairPackageInfo HairInfo){}
final function bool GetContentInfo_Perk(int Id, out XComPerkPackageInfo PerkInfo){}
final function IntersectContentIds(const out array<int> IdsA, const out array<int> IdsB, out array<int> Intersection){}
final function GetCountryFlag(XGGameData.ECountry Country, out CountryFlag Flag){}
final function CacheAlienContentAsync(){}
final function ClearContentCache(optional bool bClearMapContent=true, optional bool bInitiateGCAfterClear){}
final function CacheGameContent(const out string ContentTag, Object ObjectToCache){}
final function Object GetGameContent(coerce string ContentTag){}
static simulated function Object LoadObjectFromContentPackage(string ObjectName){}
simulated function Object GetArchetypeFromCache(EContentCategory Category, const string ArchetypeName){}
simulated function UpdateContentEntitlements(){}
simulated function XComUnitPawn GetPawnTemplate(XGGameData.EPawnType PawnType){}
simulated function XComWeapon GetWeaponTemplate(XGGameData.EItemType WeaponType){}
simulated function XComArmorKit GetArmorKitTemplate(XGGameData.EArmorKit KitType){}
simulated function XComPerkContent GetPerkContent(XGTacticalGameCoreNativeBase.EPerkType Perk){}
simulated function array<int> GetPerkContentIds(){}
simulated function bool GetCivilianTemplate(name TemplateName, out CivilianTemplate Template){}
function OnAsyncAlienArchetypeLoaded(){}
static simulated function EArmorKit MapArmorAndWeaponToArmorKit(XGGameData.EItemType ArmorType, XGGameData.EItemType PrimaryWeaponType){}
static simulated function EArmorKit MapArmorToArmorDeco(XGGameData.EItemType ArmorType){}


