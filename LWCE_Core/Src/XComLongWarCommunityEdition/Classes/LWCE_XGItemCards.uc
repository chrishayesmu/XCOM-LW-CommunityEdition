class LWCE_XGItemCards extends Object
    dependson(LWCETypes);

private static function TConfigWeapon GetConfigWeapon(int iWeaponItemId)
{
    local TConfigWeapon W;

    foreach `GAMECORE.default.Weapons(W)
    {
        if (W.iType == iWeaponItemId)
        {
            return W;
        }
    }

    return W;
}

private static function TConfigArmor GetConfigArmor(int iArmorItemId)
{
    local TConfigArmor W;

    foreach `GAMECORE.default.Armors(W)
    {
        if (W.iType == iArmorItemId)
        {
            return W;
        }
    }

    return W;
}

private static function string Expand(string Str)
{
    return class'XComLocalizer'.static.ExpandString(Str);
}

static function LWCE_TItemCard BuildArmorCard(name ItemName)
{
    local LWCEArmorTemplate kArmor;
    local LWCE_TCharacterStats kStatChanges;
    local LWCE_TItemCard kItemCard;
    local int iIndex;

    if (ItemName == '')
    {
        kItemCard.iCardType = eItemCard_NONE;
        return kItemCard;
    }

    kArmor = LWCEArmorTemplate(`LWCE_ITEM(ItemName));
    kArmor.GetStatChanges(kStatChanges);

    kItemCard.iCardType = eItemCard_Armor;
    kItemCard.ItemName = ItemName;
    kItemCard.strName = Expand(kArmor.strName);
    kItemCard.strFlavorText = Expand(kArmor.strTacticalText);
    kItemCard.iArmorHPBonus = kStatChanges.iHP;

    for (iIndex = 0; iIndex < kArmor.arrAbilities.Length; iIndex++)
    {
        kItemCard.arrAbilities.AddItem(class'LWCE_XGAbilityTree'.static.AbilityBaseIdFromName(kArmor.arrAbilities[iIndex]));
    }

    if (kArmor.HasArmorProperty(eAP_Grapple))
    {
        kItemCard.arrAbilities.AddItem(eAbility_Grapple);
    }

    return kItemCard;
}

static function TItemCard BuildCharacterCard(ECharacter eCharacterType)
{
    local TItemCard kItemCard;

    // This is only used for multiplayer
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetItemCardFromOption);

    return kItemCard;
}

static function LWCE_TItemCard BuildEquippableItemCard(name ItemName, optional LWCE_XGStrategySoldier kSoldier)
{
    local LWCEEquipmentTemplate kItem;
    local LWCE_TItemCard kItemCard;

    if (ItemName == '')
    {
        kItemCard.iCardType = eItemCard_NONE;
        return kItemCard;
    }

    kItem = LWCEEquipmentTemplate(`LWCE_ITEM(ItemName));

    kItemCard.iCardType = eItemCard_EquippableItem;
    kItemCard.ItemName = ItemName;
    kItemCard.strName = Expand(kItem.strName);
    kItemCard.strFlavorText = Expand(kItem.strTacticalText);

    if (kSoldier != none)
    {
        kItemCard.iCharges = kItem.GetClipSize(kSoldier.m_kCEChar);
    }
    else
    {
        kItemCard.iCharges = kItem.GetClipSize();
    }

    return kItemCard;
}

static function LWCE_TItemCard BuildGeneModTemplateCard(EMPGeneModTemplateType eGeneModTemplateType)
{
    local LWCE_TItemCard kItemCard;
    local TMPGeneModTemplate kGeneModTemplate;
    local EPerkType ePerk;
    local int iIndex;

    kItemCard.iCardType = eItemCard_GeneMod;

    if (eGeneModTemplateType != 0)
    {
        for (iIndex = 0; iIndex < class'XComMPData'.default.m_arrGeneModTemplates.Length; iIndex++)
        {
            kGeneModTemplate = class'XComMPData'.default.m_arrGeneModTemplates[iIndex];

            if (kGeneModTemplate.m_eGeneModTemplateType == eGeneModTemplateType)
            {
                break;
            }
        }

        kItemCard.strName = (class'XGTacticalGameCore'.default.GeneMods $ " - ") $ kGeneModTemplate.m_strGeneModTemplateName;
        kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(class'XGTacticalGameCore'.default.m_aSoldierMPGeneModTemplateTacticalText[eGeneModTemplateType]);

        for (iIndex = 0; iIndex < 5; iIndex++)
        {
            ePerk = kGeneModTemplate.m_iGeneMods[iIndex];

            if (ePerk != 0)
            {
                kItemCard.arrPerkTypes.AddItem(ePerk);
            }
        }
    }

    return kItemCard;
}

static function LWCE_TItemCard BuildItemCard(name ItemName, optional LWCE_XGStrategySoldier kSoldier)
{
    local LWCEItemTemplate kItem;

    kItem = `LWCE_ITEM(ItemName);

    // TODO: potentially pass kSoldier to other functions also
    if (kItem.IsWeapon())
    {
        if (LWCEWeaponTemplate(kItem).IsAccessory())
        {
            return BuildEquippableItemCard(ItemName, kSoldier);
        }

        return BuildWeaponCard(ItemName);
    }
    else if (kItem.IsArmor())
    {
        return BuildArmorCard(ItemName);
    }
    else if (kItem.IsMecArmor())
    {
        return BuildMecSuitCard(ItemName);
    }
    else
    {
        return BuildEquippableItemCard(ItemName, kSoldier);
    }
}

static function LWCE_TItemCard BuildMecSuitCard(name ItemName, optional TMPMECSuitTemplate kMPTemplate)
{
    local LWCEArmorTemplate kArmor;
    local LWCE_TCharacterStats kStatChanges;
    local LWCE_TItemCard kItemCard;

    if (ItemName == '')
    {
        kItemCard.iCardType = eItemCard_NONE;
        return kItemCard;
    }

    kArmor = LWCEArmorTemplate(`LWCE_ITEM(ItemName));
    kArmor.GetStatChanges(kStatChanges);

    kItemCard.iCardType = eItemCard_MECArmor;
    kItemCard.ItemName = ItemName;

    if (kMPTemplate.m_eMECSuitTemplateType == eMPMECSTT_None)
    {
        kItemCard.strName = Expand(kArmor.strName);
        kItemCard.strFlavorText = Expand(kArmor.strTacticalText);
    }
    else
    {
        kItemCard.strName = kMPTemplate.m_strMECSuitTemplateName;
        kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(class'XGTacticalGameCore'.default.m_aSoldierMPMECSuitTemplateTacticalText[kMPTemplate.m_eMECSuitTemplateType]);
    }

    kItemCard.iArmorHPBonus = kStatChanges.iHP;

    return kItemCard;
}

static function LWCE_TItemCard BuildSoldierTemplateCard(EMPTemplate eSoldierTemplate)
{
    local LWCE_TItemCard kItemCard;
    local TCharacter kCharacter;
    local TMPClassPerkTemplate kTemplate;
    local EPerkType ePerk;
    local ESoldierClass eClass;
    local ESoldierRanks eRank;
    local int iIndex, iAim, iDefense, iWill, iHealth, iMobility;

    kCharacter = `GAMECORE.GetTCharacter(eChar_Soldier);
    kItemCard.iCardType = eItemCard_MPCharacter;
    kItemCard.iCharacterId = eChar_Soldier;

    if (eSoldierTemplate == eMPT_None)
    {
        kItemCard.strName = kCharacter.strName $ " - " $ class'XComLocalizer'.static.ExpandString(class'XGTacticalGameCore'.default.m_aSoldierClassNames[eSoldierTemplate]);
    }
    else
    {
        kItemCard.strName = kCharacter.strName $ " - " $ class'XComLocalizer'.static.ExpandString(class'XGTacticalGameCore'.default.m_aSoldierMPTemplate[eSoldierTemplate]);
    }

    kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(class'XGTacticalGameCore'.default.m_aSoldierMPTemplateTacticalText[eSoldierTemplate]);
    iHealth = kCharacter.aStats[eStat_HP];
    iWill = kCharacter.aStats[eStat_Will];
    iAim = kCharacter.aStats[eStat_Offense];
    iDefense = kCharacter.aStats[eStat_Defense];
    iMobility = kCharacter.aStats[eStat_Mobility];

    for (iIndex = 0; iIndex < class'XComMPData'.default.m_arrPerkTemplate.Length; iIndex++)
    {
        kTemplate = class'XComMPData'.default.m_arrPerkTemplate[iIndex];

        if (kTemplate.m_eTemplate == eSoldierTemplate)
        {
            eRank = kTemplate.m_eRank;
            eClass = kTemplate.m_eClassType;
            break;
        }
    }

    class'XGTacticalGameCore'.static.LevelUpStats(eClass, eRank, iHealth, iAim, iWill, iMobility, iDefense, false, true);

    kItemCard.iHealth = iHealth;
    kItemCard.iWill = iWill;
    kItemCard.iAim = iAim;
    kItemCard.iDefense = kCharacter.aStats[eStat_Defense];

    for (iIndex = 0; iIndex < 10; iIndex++)
    {
        ePerk = kTemplate.m_iPerks[iIndex];

        if (ePerk != 0)
        {
            kItemCard.arrPerkTypes.AddItem(ePerk);
        }
    }

    return kItemCard;
}

static function LWCE_TItemCard BuildWeaponCard(name ItemName)
{
    local LWCEWeaponTemplate kWeapon;
    local LWCE_TCharacterStats kStatChanges;
    local LWCE_TItemCard kItemCard;
    local LWCE_XGFacility_Engineering kEngineering;
    local int iMinDamage, iMaxDamage, iMinCrit, iMaxCrit;

    if (ItemName == '')
    {
        kItemCard.iCardType = eItemCard_NONE;
        return kItemCard;
    }

    kEngineering = `LWCE_ENGINEERING;
    kWeapon = `LWCE_WEAPON(ItemName);
    kWeapon.GetStatChanges(kStatChanges);

    kItemCard.iCardType = eItemCard_SoldierWeapon;
    kItemCard.ItemName = ItemName;
    kItemCard.strName = Expand(kWeapon.strName);
    kItemCard.strFlavorText = Expand(kWeapon.strTacticalText);
    kItemCard.iRangeCategory = kWeapon.GetWeaponCatRange();

    // TODO: move all of this into template
    if (`LWCE_HQ.IsOptionEnabled(`LW_SECOND_WAVE_ID(DamageRoulette)))
    {
        iMinDamage = 2;
        iMinCrit = 6;
        iMaxDamage = 4;
    }
    else
    {
        iMinDamage = 3;
        iMinCrit = 5;
        iMaxDamage = 2;
    }

    iMaxCrit = kWeapon.iDamage;

    if (kWeapon.HasWeaponProperty(eWP_Pistol) && kEngineering.LWCE_IsFoundryTechResearched('Foundry_ReflexPistols'))
    {
        iMaxCrit += 1;
    }

    if (ItemName == 'Item_APGrenade' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_AlienGrenades'))
    {
        iMaxCrit += 2;
    }

    if (ItemName == 'Item_KineticStrikeModule' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_MecCloseCombat'))
    {
        iMaxCrit += 4;
    }

    if (ItemName == 'Item_GrenadeLauncher' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_AlienGrenades'))
    {
        iMaxCrit += 1;
    }

    if (ItemName == 'Item_Flamethrower' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_JelliedElerium'))
    {
        iMaxCrit += 3;
    }

    if (kWeapon.nmTechTier == 'wpn_plasma' && kEngineering.LWCE_IsFoundryTechResearched('Foundry_EnhancedPlasma'))
    {
        iMaxCrit += 1;
    }

    kItemCard.iBaseDamage = ((iMaxCrit * iMinDamage) + 1) / 4;
    kItemCard.iBaseDamageMax = ((iMaxCrit * (iMinDamage + iMaxDamage)) + 2) / 4;

    if (kWeapon.HasWeaponProperty(eWP_Explosive))
    {
        kItemCard.iBaseDamage -= 1;
        kItemCard.iBaseDamageMax += 1;
        kItemCard.iBaseCritChance = -1;
        kItemCard.iCritDamage = -1;
        kItemCard.iCritDamageMax = -1;
    }
    else
    {
        kItemCard.iBaseCritChance = kStatChanges.iCriticalChance;
        kItemCard.iCritDamage = Max((iMaxCrit * iMinCrit + 1) / 4, kItemCard.iBaseDamageMax);
        kItemCard.iCritDamageMax = ((iMaxCrit * (iMinCrit + iMaxDamage)) + 2) / 4;
    }

    if (kWeapon.HasWeaponProperty(eWP_Pistol) && kEngineering.LWCE_IsFoundryTechResearched('Foundry_MagPistols'))
    {
        kItemCard.iBaseCritChance += 10; // TODO config
    }

    return kItemCard;
}

static function int GetMecWeaponAbility(int iMecWeaponId)
{
    `LWCE_LOG_DEPRECATED_CLS(GetMecWeaponAbility);

    return -1;
}

static function int LWCE_GetMecWeaponAbility(name WeaponName)
{
    local LWCEWeaponTemplate kWeapon;

    kWeapon = `LWCE_WEAPON(WeaponName);

    if (kWeapon.arrAbilities.Length == 0)
    {
        return 255;
    }

    return class'LWCE_XGAbilityTree'.static.AbilityBaseIdFromName(kWeapon.arrAbilities[0]);
}