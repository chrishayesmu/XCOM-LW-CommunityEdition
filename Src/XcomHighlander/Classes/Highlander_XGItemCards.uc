class Highlander_XGItemCards extends Object;

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

static function HL_TItemCard BuildArmorCard(int iArmorItemId)
{
    local HL_TItem kItem;
    local HL_TItemCard kItemCard;
    local TConfigArmor kArmor;
    local int iIndex;

    if (iArmorItemId == eItem_None)
    {
        kItemCard.iCardType = eItemCard_NONE;
        return kItemCard;
    }

    kItem = `HL_ITEM(iArmorItemId);

    kItemCard.iCardType = eItemCard_Armor;
    kItemCard.iItemId = iArmorItemId;
    kArmor = GetConfigArmor(iArmorItemId);
    kItemCard.strName = Expand(kItem.strName);
    kItemCard.strFlavorText = Expand(kItem.strTacticalText);
    kItemCard.iArmorHPBonus = kArmor.iHPBonus;

    for (iIndex = 0; iIndex < 4; iIndex++)
    {
        if (kArmor.ABILITIES[iIndex] != 0)
        {
            kItemCard.arrAbilities.AddItem(kArmor.ABILITIES[iIndex]);
        }
    }

    if (`GAMECORE.ArmorHasProperty(iArmorItemId, eAP_Grapple))
    {
        kItemCard.arrAbilities.AddItem(eAbility_Grapple);
    }

    return kItemCard;
}

static function HL_TItemCard BuildCharacterCard(int iCharacterId)
{
    local HL_TItemCard kItemCard;
    local TCharacter kCharacter;
    local array<int> arrPerks;
    local int iPerkId;

    if (iCharacterId == eChar_None)
    {
        kItemCard.iCardType = eItemCard_NONE;
        return kItemCard;
    }

    kCharacter = `GAMECORE.GetTCharacter(iCharacterId);
    kItemCard.iCardType = eItemCard_MPCharacter;
    kItemCard.iCharacterId = iCharacterId;
    kItemCard.strName = class'XComLocalizer'.static.ExpandString(kCharacter.strName);
    kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(class'XLocalizedData'.default.m_aCharacterTacticalText[iCharacterId]);
    kItemCard.iHealth = kCharacter.aStats[eStat_HP];
    kItemCard.iWill = kCharacter.aStats[eStat_Will];
    kItemCard.iAim = kCharacter.aStats[eStat_Offense];
    kItemCard.iDefense = kCharacter.aStats[eStat_Defense];
    arrPerks = GetCharacterPerks(iCharacterId);

    foreach arrPerks(iPerkId)
    {
        if (iPerkId != 0)
        {
            kItemCard.arrPerkTypes.AddItem(iPerkId);
        }
    }

    return kItemCard;
}

static function HL_TItemCard BuildEquippableItemCard(int iItemId)
{
    local HL_TItem kItem;
    local HL_TItemCard kItemCard;

    if (iItemId == eItem_None)
    {
        kItemCard.iCardType = eItemCard_NONE;
        return kItemCard;
    }

    kItem = `HL_ITEM(iItemId);

    kItemCard.iCardType = eItemCard_EquippableItem;
    kItemCard.iItemId = iItemId;
    kItemCard.strName = Expand(kItem.strName);
    kItemCard.strFlavorText = Expand(kItem.strTacticalText);

    return kItemCard;
}

static function HL_TItemCard BuildGeneModTemplateCard(EMPGeneModTemplateType eGeneModTemplateType)
{
    local HL_TItemCard kItemCard;
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

static function HL_TItemCard BuildItemCard(int iItemId)
{
    if (`GAMECORE.ItemIsWeapon(iItemId))
    {
        return BuildWeaponCard(iItemId);
    }
    else if (`GAMECORE.ItemIsArmor(iItemId))
    {
        return BuildArmorCard(iItemId);
    }
    else if (`GAMECORE.ItemIsMecArmor(iItemId))
    {
        return BuildMecSuitCard(iItemId);
    }
    else
    {
        return BuildEquippableItemCard(iItemId);
    }
}

static function HL_TItemCard BuildMecSuitCard(int iMecArmorId, optional TMPMECSuitTemplate kMPTemplate)
{
    local HL_TItem kItem;
    local HL_TItemCard kItemCard;
    local TConfigArmor kArmor;

    if (iMecArmorId == eItem_None)
    {
        kItemCard.iCardType = eItemCard_NONE;
        return kItemCard;
    }

    kItem = `HL_ITEM(iMecArmorId);

    kItemCard.iCardType = eItemCard_MECArmor;
    kItemCard.iItemId = iMecArmorId;
    kArmor = GetConfigArmor(iMecArmorId);

    if (kMPTemplate.m_eMECSuitTemplateType == eMPMECSTT_None)
    {
        kItemCard.strName = Expand(kItem.strName);
        kItemCard.strFlavorText = Expand(kItem.strTacticalText);
    }
    else
    {
        kItemCard.strName = kMPTemplate.m_strMECSuitTemplateName;
        kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(class'XGTacticalGameCore'.default.m_aSoldierMPMECSuitTemplateTacticalText[kMPTemplate.m_eMECSuitTemplateType]);
    }

    kItemCard.iArmorHPBonus = kArmor.iHPBonus;

    return kItemCard;
}

static function HL_TItemCard BuildSoldierTemplateCard(EMPTemplate eSoldierTemplate)
{
    local HL_TItemCard kItemCard;
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

static function HL_TItemCard BuildWeaponCard(int iWeaponId)
{
    local HL_TItem kItem;
    local HL_TItemCard kItemCard;
    local TConfigWeapon kWeapon;
    local int iMinDamage, iMaxDamage, iMinCrit, iMaxCrit;

    // TODO: rewrite this in a while that doesn't require bit fiddling
    if ((iWeaponId & 255) == 0)
    {
        kItemCard.iCardType = 0;
        return kItemCard;
    }

    kItem = `HL_ITEM(iWeaponId);
    kWeapon = GetConfigWeapon(byte(iWeaponId & 255));

    kItemCard.iCardType = eItemCard_SoldierWeapon;
    kItemCard.iItemId = iWeaponId;
    kItemCard.strName = Expand(kItem.strName);
    kItemCard.strFlavorText = Expand(kItem.strTacticalText);
    kItemCard.iRangeCategory = `HL_GAMECORE.HL_GetWeaponCatRange(iWeaponId & 255);

    if ((iWeaponId & 65536) > 0) // Damage Roulette enabled
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

    iMaxCrit = kWeapon.iDamage + ((iWeaponId >> 8) & 255);

    if ((iWeaponId & 131072) > 0) // Enhanced Plasma
    {
        if (class'XGTacticalGameCore'.static.GetWeaponClass(EItemType(iWeaponId & 255)) == 5)
        {
            iMaxCrit += 1;
        }
    }

    kItemCard.iBaseDamage = ((iMaxCrit * iMinDamage) + 1) / 4;
    kItemCard.iBaseDamageMax = ((iMaxCrit * (iMinDamage + iMaxDamage)) + 2) / 4;

    if (`GAMECORE.m_arrWeapons[iWeaponId & 255].aProperties[eWP_Explosive] > 0)
    {
        kItemCard.iBaseDamage -= 1;
        kItemCard.iBaseDamageMax += 1;
        kItemCard.iBaseCritChance = -1;
        kItemCard.iCritDamage = -1;
        kItemCard.iCritDamageMax = -1;
    }
    else
    {
        kItemCard.iBaseCritChance = kWeapon.iCritical;
        kItemCard.iCritDamage = Max((iMaxCrit * iMinCrit + 1) / 4, kItemCard.iBaseDamageMax);
        kItemCard.iCritDamageMax = ((iMaxCrit * (iMinCrit + iMaxDamage)) + 2) / 4;
    }

    return kItemCard;
}

static function int GetMecWeaponAbility(int iMecWeaponId)
{
    local HL_TWeapon kMecWeapon;

    kMecWeapon = `HL_GAMECORE.HL_GetTWeapon(iMecWeaponId);

    if (kMecWeapon.arrAbilities.Length == 0)
    {
        return 255;
    }

    return kMecWeapon.arrAbilities[0];
}

// TODO document
private static function array<int> GetCharacterPerks(int iCharacterId)
{
    local array<int> arrPerkTypes;

    switch (iCharacterId)
    {
        case eChar_Sectoid:
            arrPerkTypes.AddItem(ePerk_MindMerge);
            break;
        case eChar_SectoidCommander:
            arrPerkTypes.AddItem(ePerk_MindFray);
            arrPerkTypes.AddItem(ePerk_GreaterMindMerge);
            arrPerkTypes.AddItem(ePerk_PsiPanic);
            arrPerkTypes.AddItem(100);
            break;
        case eChar_Floater:
            arrPerkTypes.AddItem(79);
            arrPerkTypes.AddItem(80);
            break;
        case eChar_FloaterHeavy:
            arrPerkTypes.AddItem(81);
            arrPerkTypes.AddItem(79);
            arrPerkTypes.AddItem(80);
            break;
        case eChar_ThinMan:
            arrPerkTypes.AddItem(82);
            arrPerkTypes.AddItem(83);
            break;
        case eChar_Chryssalid:
            arrPerkTypes.AddItem(82);
            arrPerkTypes.AddItem(84);
            arrPerkTypes.AddItem(104);
            break;
        case eChar_Zombie:
            arrPerkTypes.AddItem(105);
            break;
        case eChar_Muton:
            arrPerkTypes.AddItem(21);
            arrPerkTypes.AddItem(85);
            arrPerkTypes.AddItem(86);
            break;
        case eChar_MutonElite:
            arrPerkTypes.AddItem(21);
            arrPerkTypes.AddItem(81);
            break;
        case eChar_MutonBerserker:
            arrPerkTypes.AddItem(89);
            arrPerkTypes.AddItem(88);
            break;
        case eChar_Cyberdisc:
            arrPerkTypes.AddItem(79);
            arrPerkTypes.AddItem(98);
            arrPerkTypes.AddItem(81);
            break;
        case eChar_Sectopod:
            arrPerkTypes.AddItem(103);
            arrPerkTypes.AddItem(96);
            break;
        case eChar_Seeker:
            arrPerkTypes.AddItem(79);
            arrPerkTypes.AddItem(127);
            arrPerkTypes.AddItem(166);
            break;
        case eChar_Ethereal:
        case eChar_EtherealUber:
            arrPerkTypes.AddItem(97);
            arrPerkTypes.AddItem(73);
            arrPerkTypes.AddItem(100);
            arrPerkTypes.AddItem(101);
            arrPerkTypes.AddItem(68);
            break;
        case eChar_Drone:
            arrPerkTypes.AddItem(79);
            arrPerkTypes.AddItem(99);
            arrPerkTypes.AddItem(102);
            break;
        case eChar_Mechtoid:
            arrPerkTypes.AddItem(126);
            break;
        case eChar_ExaltEliteOperative:
            arrPerkTypes.AddItem(147);
        case eChar_ExaltOperative:
            break;
        case eChar_ExaltEliteSniper:
            arrPerkTypes.AddItem(11);
        case eChar_ExaltSniper:
            arrPerkTypes.AddItem(15);
            arrPerkTypes.AddItem(16);
            break;
        case eChar_ExaltEliteHeavy:
            arrPerkTypes.AddItem(23);
        case eChar_ExaltHeavy:
            arrPerkTypes.AddItem(18);
            arrPerkTypes.AddItem(19);
            arrPerkTypes.AddItem(21);
            break;
        case eChar_ExaltEliteMedic:
            arrPerkTypes.AddItem(52);
        case eChar_ExaltMedic:
            arrPerkTypes.AddItem(47);
            arrPerkTypes.AddItem(48);
            break;
    }

    return arrPerkTypes;
}