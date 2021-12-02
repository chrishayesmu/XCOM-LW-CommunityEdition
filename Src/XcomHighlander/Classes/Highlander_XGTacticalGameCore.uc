class Highlander_XGTacticalGameCore extends XGTacticalGameCore;

simulated event Init()
{
    `HL_LOG_CLS("Init");

    m_arrWeapons.Add(255);
    m_arrArmors.Add(255);
    m_arrCharacters.Add(32);

    if (Role == ROLE_Authority)
    {
        m_kAbilities = Spawn(class'Highlander_XGAbilityTree', self);
        m_kAbilities.Init();
    }

    BuildWeapons();
    BuildArmors();
    BuildCharacters();
    m_bInitialized = true;
}

simulated function GetInventoryStatModifiers(out int aModifiers[ECharacterStat], out TCharacter kCharacter, EItemType iEquippedWeapon, array<int> arrBackPackItems)
{
    `HL_LOG_DEPRECATED_CLS(GetInventoryStatModifiers);
    HL_GetInventoryStatModifiers(aModifiers, kCharacter, iEquippedWeapon, arrBackPackItems);
}

simulated function HL_GetInventoryStatModifiers(out int aModifiers[ECharacterStat], out TCharacter kCharacter, int iEquippedWeaponItemId, array<int> arrBackpackItemIds)
{
    local int iStat;

    for (iStat = 0; iStat < eStat_MAX; iStat++)
    {
        aModifiers[iStat]  = GetWeaponStatBonus(iStat, iEquippedWeaponItemId, kCharacter);
        aModifiers[iStat] += GetArmorStatBonus(iStat, kCharacter.kInventory.iArmor, kCharacter);

        if (kCharacter.aUpgrades[27] > 0) // Extra Conditioning
        {
            aModifiers[iStat] += GetExtraArmorStatBonus(iStat, kCharacter.kInventory.iArmor);
        }

        if ( !WeaponHasProperty(iEquippedWeaponItemId, eWP_Pistol) || (iStat != eStat_Offense && iStat != eStat_CriticalShot) )
        {
            aModifiers[iStat] += GetBackpackStatBonus(iStat, arrBackPackItemIds, kCharacter);

            switch (iStat)
            {
                case eStat_HP:
                    if ((kCharacter.aUpgrades[123] & 1) > 0) // Shaped Armor
                    {
                        if (kCharacter.iType == eChar_Tank || kCharacter.eClass == eSC_Mec)
                        {
                            aModifiers[iStat] += 3;
                        }
                    }

                    break;
                case eStat_Mobility:
                    aModifiers[iStat] += TotalStatFromItem(kCharacter.kInventory.iArmor, ECharacterStat(iStat));

                    if (kCharacter.aUpgrades[31] > 0) // Sprinter
                    {
                        aModifiers[iStat] += 4;
                    }

                    break;
                case eStat_DamageReduction:
                    aModifiers[iStat] += TotalStatFromItem(kCharacter.kInventory.iArmor, ECharacterStat(iStat));

                    if (kCharacter.aUpgrades[132] > 0) // Automated Threat Assessment
                    {
                        aModifiers[iStat] += 5;
                    }

                    if (kCharacter.aUpgrades[148] > 0) // Iron Skin
                    {
                        aModifiers[iStat] += 10;
                    }

                    break;
                case eStat_Offense:
                    aModifiers[iStat] += TotalStatFromItem(kCharacter.kInventory.iArmor, ECharacterStat(iStat));
                    break;
                case eStat_FlightFuel:
                    if ((kCharacter.aUpgrades[123] & 8) > 0) // Advanced Flight
                    {
                        aModifiers[iStat] *= float(2);
                    }

                    break;
                default:
                    break;
            }
        }
    }
}

simulated function int TotalStatFromItem(int iItemId, ECharacterStat eStat)
{
    local TCharacterBalance kCharacterBalance;
    local int iTotal;

    iTotal = 0;

    foreach BalanceMods_Classic(kCharacterBalance)
    {
        if (kCharacterBalance.eType == iItemId)
        {
            // Stats are mapped strangely since the original balance struct has limited fields
            switch (eStat)
            {
                case eStat_Offense:
                    iTotal += kCharacterBalance.iAim;
                    break;
                case eStat_Defense:
                    iTotal += kCharacterBalance.iDefense;
                    break;
                case eStat_Mobility:
                    iTotal += kCharacterBalance.iMobility;
                    break;
                case eStat_DamageReduction:
                    iTotal += kCharacterBalance.iHP;
                    break;
                case eStat_CriticalShot:
                    iTotal += kCharacterBalance.iCritHit;
                    break;
                case eStat_FlightFuel:
                    iTotal += kCharacterBalance.iDamage;
                    break;
                default:
                    break;
            }
        }
    }

    return iTotal;
}

function eWeaponRangeCat GetWeaponCatRange(EItemType eWeapon)
{
    `HL_LOG_DEPRECATED_CLS(GetWeaponCatRange);

    return 0;
}

function eWeaponRangeCat HL_GetWeaponCatRange(int iWeaponItemId)
{
    if (GetTWeapon(iWeaponItemId).iRange > 30)
    {
        return eWRC_Long;
    }

    if (GetTWeapon(iWeaponItemId).iReactionRange < 30)
    {
        return eWRC_Short;
    }

    return eWRC_Medium;
}

// TODO: rewrite all of the ItemIs* functions, maybe move into XGItemTree
simulated function bool ItemIsAccessory(int iItem)
{
    if (m_arrWeapons[iItem].iType > 0 && m_arrWeapons[iItem].iDamage <= 0)
    {
        return true;
    }

    return false;
}

simulated function bool ItemIsWeapon(int iItem)
{
    return m_arrWeapons[iItem].iDamage > 0;
}

simulated function bool ItemIsArmor(int iItem)
{
    return m_arrArmors[iItem].iHPBonus > 0;
}

simulated function bool ItemIsMecArmor(int iItem)
{
    switch (iItem)
    {
        case 192:
        case 193:
        case 194:
        case 195:
        case 145:
        case 148:
        case 191:
        case 210:
            return true;
        default:
            return false;
    }
}

simulated function bool ItemIsShipWeapon(int iItem)
{
    return iItem >= 116 && iItem < 123;
}