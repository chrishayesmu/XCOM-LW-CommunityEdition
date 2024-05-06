class XGLoadoutMgr extends Object
    abstract
    native(Core)
    config(Loadouts);

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

var const localized string LoadoutNames[ELoadoutTypes];
var protected config array<config LoadoutTemplate> LoadoutTemplates;
var protected config array<config CharacterLoadoutPair> CharacterLoadouts;