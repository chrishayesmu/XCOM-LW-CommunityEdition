class Highlander_XGAbility_Extensions extends Object;

static simulated function int CalculateAbilityModifiedDamage(XGAbility_Targeted kAbility)
{
    local int iBaseDamage, iDamage, iDamageBonusItemId;
    local int iWeaponItemId;
    local XGWeapon kWeapon;
    local HL_TWeapon kTWeapon;

    kWeapon = kAbility.m_kWeapon;

    if (kWeapon == none)
    {
        return iDamage;
    }

    kTWeapon = class'Highlander_XGWeapon_Extensions'.static.GetHLWeapon(kWeapon);
    iWeaponItemId = class'Highlander_XGWeapon_Extensions'.static.GetItemId(kWeapon);

    iBaseDamage = kTWeapon.iDamage;
    iDamage = kAbility.m_kUnit.m_aCurrentStats[eStat_Damage];

    // Weapon class is used here to represent the weapon tech tier
    // TODO: GetWeaponClass needs a Highlander equivalent
    switch (class'XGTacticalGameCore'.static.GetWeaponClass(kWeapon.ItemType()))
    {
        case 1: // Ballistic
        case 3: // Gauss
            iDamageBonusItemId = `LW_ITEM_ID(AlloyJacketedRounds);
            break;
        case 2: // Laser
        case 4: // Pulse
            iDamageBonusItemId = `LW_ITEM_ID(EnhancedBeamOptics);
            break;
        case 5: // Plasma
            iDamageBonusItemId = `LW_ITEM_ID(PlasmaStellerator);
            break;
        default:
            iDamageBonusItemId = 0;
            break;
    }

    // If unit has an applicable +damage item, apply it
    if (iDamageBonusItemId > 0)
    {
        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, iDamageBonusItemId))
        {
            if (kTWeapon.iSize == 1)
            {
                iDamage += 1;
            }
        }
    }

    switch (kAbility.GetType())
    {
        case eAbility_ShotStandard:
        case eAbility_RapidFire:
        case eAbility_ShotMayhem:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                if (kWeapon.HasProperty(eWP_Support)) // SAWs/LMGs
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iMayhemDamageBonusForMachineGuns;
                }

                if (kWeapon.HasProperty(eWP_Sniper))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iMayhemDamageBonusForSniperRifles;
                }
            }

            break;
        case eAbility_NeedleGrenade:
        case eAbility_MEC_GrenadeLauncher:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(AlienGrenades)))
            {
                iDamage += 2;
            }
        case eAbility_FragGrenade:
        case eAbility_AlienGrenade:
        case eAbility_MEC_ProximityMine:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Sapper)))
            {
                iDamage += class'Highlander_XGTacticalGameCore'.default.iSapperDamageBonus;
            }

            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                iDamage += class'Highlander_XGTacticalGameCore'.default.iMayhemDamageBonusForGrenades;
            }

            break;
        case eAbility_ShredderRocket:
            iDamage -= int(float(iBaseDamage) * class'Highlander_XGTacticalGameCore'.default.fShredderRocketDamageMultiplier);
        case eAbility_RocketLauncher:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                if (iWeaponItemId == `LW_ITEM_ID(RecoillessRifle))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iMayhemDamageBonusForRocketLaunchers;
                }

                if (iWeaponItemId == `LW_ITEM_ID(RocketLauncher))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iMayhemDamageBonusForRocketLaunchers;
                }

                if (iWeaponItemId == `LW_ITEM_ID(BlasterLauncher))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iMayhemDamageBonusForRocketLaunchers;
                }
            }

            break;
        case eAbility_PrecisionShot:
            if (kAbility.m_bCritical)
            {
                if (iWeaponItemId == `LW_ITEM_ID(GaussLongRifle))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iPrecisionShotDamageBonusForGaussSniper;
                }

                if (iWeaponItemId == `LW_ITEM_ID(SniperRifle))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iPrecisionShotDamageBonusForBallisticSniper;
                }

                if (iWeaponItemId == `LW_ITEM_ID(PulseSniperRifle))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iPrecisionShotDamageBonusForPulseSniper;
                }

                if (iWeaponItemId == `LW_ITEM_ID(LaserSniperRifle))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iPrecisionShotDamageBonusForLaserSniper;
                }

                if (iWeaponItemId == `LW_ITEM_ID(PlasmaSniperRifle))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iPrecisionShotDamageBonusForPlasmaSniper;
                }
            }

            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)))
            {
                if (kWeapon.HasProperty(eWP_Sniper))
                {
                    iDamage += class'Highlander_XGTacticalGameCore'.default.iMayhemDamageBonusForSniperRifles;
                }
            }

            break;
        case eAbility_ShotFlush:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Mayhem)) && kWeapon.HasProperty(eWP_Support)) // LMGs/SAWs
            {
                iDamage += class'Highlander_XGTacticalGameCore'.default.iMayhemDamageBonusForMachineGuns;
            }

            iDamage -= ((iBaseDamage + 1) / 2);
            break;
        case eAbility_MEC_Barrage:
            iDamage -= (iBaseDamage - 1);
            break;
        case eAbility_DisablingShot:
            iDamage -= (iBaseDamage - 1);
            break;
        case eAbility_MEC_Flamethrower:
            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(IncineratorModule)))
            {
                iDamage += 3;
            }

            break;
        case eAbility_MEC_KineticStrike:
            if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(MECCloseCombat)))
            {
                iDamage += 4;
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TheThumper)))
            {
                iDamage += 3;
            }

            // +3 damage for each extra Kinetic Strike Module. Take away 3 because we know there's at least one KSM equipped
            iDamage -= 3;

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[1] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iDamage += 3;
            }

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[2] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iDamage += 3;
            }

            if (kAbility.m_kUnit.GetCharacter().m_kChar.kInventory.arrLargeItems[3] == `LW_ITEM_ID(KineticStrikeModule))
            {
                iDamage += 3;
            }

            break;
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(BringEmOn)) && kAbility.m_bCritical)
    {
        iDamage += Min(4, 1 + (kAbility.m_kUnit.GetNumSquadVisibleEnemies(kAbility.m_kUnit) / 3));
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(KillerInstinct)) && kAbility.m_bCritical && kAbility.m_kUnit.RunAndGunPerkActive())
    {
        iDamage += ((iBaseDamage + 2) / 3);
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Ranger)))
    {
        if (kTWeapon.iSize == 1)
        {
            iDamage += 1;
        }
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(Ranger)))
    {
        if (kWeapon.HasProperty(eWP_Pistol))
        {
            iDamage += 1;
        }
    }

    if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 16) > 0) // Reflex Pistols
    {
        if (kWeapon.HasProperty(eWP_Pistol))
        {
            iDamage += 1;
        }
    }

    if (kAbility.m_kUnit.m_kCharacter.HasUpgrade(`LW_PERK_ID(VitalPointTargeting)))
    {
        if (kAbility.GetPrimaryTarget() != none && kAbility.GetType() != eAbility_MEC_Barrage)
        {
            if (`GAMECORE.m_kAbilities.HasAutopsyTechForChar(kAbility.GetPrimaryTarget().m_kCharacter.m_kChar.iType))
            {
                if (kWeapon.HasProperty(eWP_Pistol))
                {
                    iDamage += 1;
                }
                else
                {
                    iDamage += 2;
                }
            }
        }
    }

    if (class'XGTacticalGameCore'.static.GetWeaponClass(kWeapon.ItemType()) == 5)
    {
        if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 4) > 0) // Enhanced Plasma
        {
            iDamage += 1;
        }
    }

    if (kAbility.m_bCritical && class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kAbility.m_kUnit.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TargetingModule)))
    {
        iDamage += 1;
    }

    if (kAbility.m_bCritical)
    {
        if (iWeaponItemId == `LW_ITEM_ID(PlasmaRifle) && !kAbility.GetPrimaryTarget().IsVulnerableToElectropulse())
        {
            iDamage += 1;
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexCannon))
        {
            if (VSize(kAbility.m_kUnit.Location -kAbility. GetPrimaryTarget().Location) <= float(`TILESTOUNITS(4)))
            {
                iDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(ReflexRifle))
        {
            if (kAbility.GetPrimaryTarget().IsFlankedByLoc(kAbility.m_kUnit.Location) || kAbility.GetPrimaryTarget().IsFlankedBy(kAbility.m_kUnit) || !kAbility.GetPrimaryTarget().IsInCover())
            {
                iDamage += 1;
            }
        }

        if (iWeaponItemId == `LW_ITEM_ID(PlasmaSniperRifle))
        {
            if (VSize(kAbility.m_kUnit.Location - kAbility.GetPrimaryTarget().Location) >= float(`TILESTOUNITS(35)))
            {
                iDamage += 1;
            }
        }
    }

    if (iWeaponItemId == `LW_ITEM_ID(PlasmaDragon) && kAbility.GetPrimaryTarget().IsFlying())
    {
        iDamage += 1;
    }

    if (iWeaponItemId == `LW_ITEM_ID(ParticleCannon) && kAbility.GetPrimaryTarget().IsVulnerableToElectropulse())
    {
        iDamage += 1;
    }

    if (iWeaponItemId == `LW_ITEM_ID(HeavyPlasmaRifle) && kAbility.m_kUnit.IsAffectedByAbility(eAbility_Aim))
    {
        iDamage += 1;
    }

    if (kAbility.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(InTheZone)) && kAbility.m_kUnit.m_iNumTimesUsedInTheZone > 0)
    {
        iDamage = Max(iDamage - kAbility.m_kUnit.m_iNumTimesUsedInTheZone, 1 - iBaseDamage);
    }

    return iDamage;
}

/*
 * For healing abilities, returns the healing amount; for other abilities, returns the modified weapon damage, including
 * the weapon's base damage (if any).
 */
simulated function int GetPossibleDamage(XGAbility_Targeted kAbility)
{
    local int iPossibleDamage, iHealing;

    if (kAbility.m_kWeapon != none)
    {
        iPossibleDamage = CalculateAbilityModifiedDamage(kAbility) + `HL_GAMECORE.HL_GetTWeapon(kAbility.m_kWeapon.ItemType()).iDamage;
    }

    if (kAbility.GetType() == eAbility_Mindfray)
    {
        return class'Highlander_XGTacticalGameCore'.default.iMindfrayDamage;
    }

    if (kAbility.GetType() == eAbility_MedikitHeal)
    {
        iHealing = class'Highlander_XGTacticalGameCore'.default.iMedikitHealBase;

        if (kAbility.m_kUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(Savior)))
        {
            iHealing += class'Highlander_XGTacticalGameCore'.default.iSaviorHealBonus;
        }

        if ((kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 64) > 0) // Improved Medikit
        {
            iHealing += class'Highlander_XGTacticalGameCore'.default.iImprovedMedikitHealBonus;
        }

        if (kAbility.GetPrimaryTarget().GetCharacter().HasUpgrade(`LW_PERK_ID(SmartMacrophages)))
        {
            iHealing += class'Highlander_XGTacticalGameCore'.default.iSmartMacrophagesHealBonus;
        }

        return iHealing;
    }

    if (kAbility.GetType() == eAbility_RepairSHIV)
    {
        return class'Highlander_XGTacticalGameCore'.default.iRepairHealBaseXCOM;
    }

    if (kAbility.GetType() == eAbility_Repair)
    {
        return class'Highlander_XGTacticalGameCore'.default.iRepairHealBaseAliens;
    }

    return iPossibleDamage;
}