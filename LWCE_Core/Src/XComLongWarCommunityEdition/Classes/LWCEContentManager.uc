class LWCEContentManager extends Object
    config(LWCEContent)
    dependson(LWCEEquipmentTemplate);

struct LWCE_TArchetypeCacheEntry
{
    var string ArchetypeName;
    var Object Archetype;
};

// Default kit for a weapon + armor combo
struct LWCE_TDefaultKitConfig
{
    var name nmArmorItem;
    var name nmWeaponItem;
    var string ArchetypeName;
};

// All kits which can be selected in customization for a given piece of armor
struct LWCE_TDecoKitConfig
{
    var name nmArmorItem;
    var string ArchetypeName; // TODO: after templating content system, change to array of template names and condense config
};

struct LWCE_TKitFallback
{
    var name ItemName;
    var name FallbackTo;
};

struct LWCE_TCivilianPawnContent
{
    var name nmPawn;
    var array<name> MaleBodies;
    var array<name> MaleHeads;
    var array<name> MaleHairs;
    var array<name> FemaleBodies;
    var array<name> FemaleHeads;
    var array<name> FemaleHairs;
};

struct LWCE_TSoldierPawnContent
{
    var name nmPawn;
    var name nmKit;
    var LWCE_TAppearance kAppearance;
    var LWCE_TInventory kInventory;
    var array<name> arrPerkWeapons;
    var array<int> arrPerkContent;
};


struct LWCE_TPawnContent
{
    var array<int> arrAlienPawns;
    var array<TCivilianPawnContent> arrCivilianPawns;
    var array<TSoldierPawnContent> arrSoldierPawns;
};

var config array<LWCE_TDefaultKitConfig> arrDefaultKitConfigs;
var config array<LWCE_TDecoKitConfig> arrDecoKitConfigs;
var config array<LWCE_TKitFallback> arrArmorFallbacks;
var config array<LWCE_TKitFallback> arrWeaponFallbacks;

var private array<LWCE_TArchetypeCacheEntry> m_arrArchetypeCache;

var private LWCEItemTemplateManager m_kItemMgr;

// TODO: need to check performance and see if we have to delegate to native XComContentManager to keep load times sane

function Init()
{
    m_kItemMgr = `LWCE_ITEM_TEMPLATE_MGR;
}

simulated function Object GetArchetypeByPath(string ArchetypePath)
{
    local LWCE_TArchetypeCacheEntry kCacheEntry;
    local Object kArchetype;
    local int Index;

    for (Index = 0; Index < m_arrArchetypeCache.Length; Index++)
    {
        if (m_arrArchetypeCache[Index].ArchetypeName == ArchetypePath)
        {
            return m_arrArchetypeCache[Index].Archetype;
        }
    }

    kArchetype = class'XComContentManager'.static.LoadObjectFromContentPackage(ArchetypePath);

    // TODO: for some reason; LoadObjectFromContentPackage can load unit weapons on the tac layer, but not strat.
    // Conversely, DynamicLoadObject works on strat, but not tac.
    if (kArchetype == none)
    {
        kArchetype = DynamicLoadObject(ArchetypePath, class'Object', /* MayFail */ true);
    }

    kCacheEntry.Archetype = kArchetype;
    kCacheEntry.ArchetypeName = ArchetypePath;

    m_arrArchetypeCache.AddItem(kCacheEntry);

    return kArchetype;
}

simulated function Object GetDefaultKitArchetypeForWeaponAndArmor(name WeaponItemName, name ArmorItemName)
{
    local int Index;

    for (Index = 0; Index < arrDefaultKitConfigs.Length; Index++)
    {
        if (arrDefaultKitConfigs[Index].nmArmorItem == ArmorItemName && arrDefaultKitConfigs[Index].nmWeaponItem == WeaponItemName)
        {
            return GetArchetypeByPath(arrDefaultKitConfigs[Index].ArchetypeName);
        }
    }

    // Check for armor fallbacks first
    Index = arrArmorFallbacks.Find('ItemName', ArmorItemName);

    if (Index != INDEX_NONE)
    {
        return GetDefaultKitArchetypeForWeaponAndArmor(WeaponItemName, arrArmorFallbacks[Index].FallbackTo);
    }

    // Then we check for weapon fallbacks
    Index = arrWeaponFallbacks.Find('ItemName', WeaponItemName);

    if (Index != INDEX_NONE)
    {
        return GetDefaultKitArchetypeForWeaponAndArmor(WeaponItemName, arrWeaponFallbacks[Index].FallbackTo);
    }

    // Failed to find any kit archetype
    return none;
}

simulated function GetPossibleArmorKits(name ArmorItemName, out array<int> Ids)
{
    local int Index;

    Ids.Length = 0;

    // Add all matching deco kits
    for (Index = 0; Index < arrDecoKitConfigs.Length; Index++)
    {
        if (arrDecoKitConfigs[Index].nmArmorItem == ArmorItemName)
        {
            Ids.AddItem(Index);
        }
    }

    // If none were found, check for fallbacks
    if (Ids.Length == 0)
    {
        Index = arrArmorFallbacks.Find('ItemName', ArmorItemName);

        if (Index != INDEX_NONE)
        {
            GetPossibleArmorKits(arrArmorFallbacks[Index].FallbackTo, Ids);
        }
    }
}

simulated function SkeletalMesh GetWeaponSkeletalMesh(name WeaponItemName)
{
    local LWCEWeaponTemplate kWeapon;

    kWeapon = m_kItemMgr.FindWeaponTemplate(WeaponItemName);

    if (kWeapon == none || kWeapon.strSkeletalMesh == "")
    {
        return none;
    }

    return SkeletalMesh(GetArchetypeByPath(kWeapon.strSkeletalMesh));
}

simulated function XComWeapon GetWeaponTemplate(name WeaponItemName)
{
    local LWCEWeaponTemplate kWeapon;

    kWeapon = m_kItemMgr.FindWeaponTemplate(WeaponItemName);

    if (kWeapon == none || kWeapon.Archetype == "")
    {
        return none;
    }

    return XComWeapon(GetArchetypeByPath(kWeapon.Archetype));
}

simulated function RequestContentForInventory(const out LWCE_TInventory Inv)
{
    // TODO
    `LWCE_LOG_CLS("WARNING: RequestContentForInventory not yet implemented!");
}
