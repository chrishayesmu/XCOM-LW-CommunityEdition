class XGLoadoutMgr extends Object
    abstract
    native(Core)
    config(Loadouts)
	DependsOn(XGTacticalGameCoreNativeBase);
//complete  stub

struct native LoadoutTemplate
{
    var ELoadoutTypes eLoadoutType;
    var TInventory Inventory;
};

struct native CharacterLoadoutPair
{
    var ECharacter eCharacterType;
    var ELoadoutTypes eLoadoutType;
    var byte Padding[2];
};

struct native TLoadout
{
    var int Items[26];
    var array<int> Backpack;
};

var const localized string LoadoutNames[255];
var config array<config LoadoutTemplate> LoadoutTemplates;
var config array<config CharacterLoadoutPair> CharacterLoadouts;

native static simulated function bool GetLoadoutTemplate(XGGameData.ELoadoutTypes LoadoutType, out LoadoutTemplate Template);
native static simulated function ELoadoutTypes GetLoadoutTemplateFromCharacter(XGGameData.ECharacter eCharacterType, optional bool bAlt=FALSE);

static simulated function string GetLoadoutDisplayName(ELoadoutTypes LoadoutType){}
static function ApplyInventory(XGUnit kUnit, optional bool bLoadFromCheckpoint=FALSE){}
static function ConvertTInventoryToSoldierLoadout(TCharacter kChar, TInventory kInventory, out TLoadout Loadout){}
static function ConvertTInventoryToTankLoadout(TInventory kInventory, out TLoadout Loadout){}
static function ConvertTInventoryToAlienLoadout(TCharacter kChar, TInventory kInventory, out TLoadout Loadout){}
static function EquipUnit(XGUnit kUnit, optional ELoadoutTypes eLoadoutType=60){}
static function ApplyLoadout(XGUnit kUnit, TLoadout kLoad, bool bLoadFromCheckpoint){}
static function XGLoadoutInstances ExtractLoadout(XGUnit kUnit){}
static function bool IsAlienLoadoutType(ELoadoutTypes eCheckLoadoutType){}
