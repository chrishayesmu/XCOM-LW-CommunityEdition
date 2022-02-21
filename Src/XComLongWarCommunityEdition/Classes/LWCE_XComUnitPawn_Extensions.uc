class LWCE_XComUnitPawn_Extensions extends Object;

static simulated function ApplyShredderRocket(XComUnitPawn kUnitPawn, const DamageEvent Dmg, bool enemyOfUnitHit)
{
    local int iAbilityId;
    local LWCE_TWeapon kInstigatorWeapon;
    local XGUnit kVictim, kInstigator;
    local XComPresentationLayer kPres;
    local XComUIBroadcastWorldMessage kBroadcastWorldMessage;

    `LWCE_LOG("LWCE_XComUnitPawn_Extensions: ApplyShredderRocket");

    if (kUnitPawn.Role != ROLE_Authority)
    {
        return;
    }

    if (Dmg.EventInstigator == none)
    {
        return;
    }

    if (Dmg.DamageType == class'XComDamageType_Psionic')
    {
        return;
    }

    kVictim = XGUnit(kUnitPawn.GetGameUnit());
    kInstigator = XGUnit(Dmg.EventInstigator);
    kInstigatorWeapon = `LWCE_TWEAPON_FROM_XG(kInstigator.GetInventory().GetActiveWeapon());
    iAbilityId = kInstigator.GetUsedAbility();

    if (iAbilityId == eAbility_ShredderRocket)
    {
        kVictim.m_iShredderRocketCtr = Max(kVictim.m_iShredderRocketCtr, 4);
    }
    else if (!kInstigator.IsAlien_CheckByCharType() &&
             `GAMECORE.WeaponHasProperty(kInstigator.GetInventory().GetActiveWeapon().ItemType(), eWP_Support) &&
             kInstigator.m_kCharacter.HasUpgrade(`LW_PERK_ID(ShredderAmmo)))
    {
        kVictim.m_iShredderRocketCtr = Max(kVictim.m_iShredderRocketCtr, 4);
    }
    else if (kInstigator.IsAugmented() &&
             iAbilityId == eAbility_ShotStandard &&
             kInstigator.m_kCharacter.HasUpgrade(`LW_PERK_ID(ShredderAmmo)))
    {
        kVictim.m_iShredderRocketCtr = Max(kVictim.m_iShredderRocketCtr, 4);
    }
    else if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInstigator.GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ShredderAmmo)) && kInstigatorWeapon.iSize == 1)
    {
        kVictim.m_iShredderRocketCtr = Max(kVictim.m_iShredderRocketCtr, 2);
    }
    else if (kInstigator.IsAlien_CheckByCharType() && kInstigator.m_kCharacter.HasUpgrade(/* Shredder Ammo */ 115))
    {
        // TODO: not clear if this is intended to apply to grenades, or if it's an oversight. Add a config option to disable it.
        kVictim.m_iShredderRocketCtr = Max(kVictim.m_iShredderRocketCtr, 2);
    }
    else
    {
        return;
    }

    kPres = XComPresentationLayer(XComPlayerController(`WORLDINFO.GetALocalPlayerController()).m_Pres);

    kVictim.UpdateUnitBuffs();
    kBroadcastWorldMessage = kPres.GetWorldMessenger().Message(`GAMECORE.GetUnexpandedLocalizedMessageString(5), kVictim.GetLocation(), 4,,, kUnitPawn.m_eTeamVisibilityFlags,,,, class'XComUIBroadcastWorldMessage_UnexpandedLocalizedString');

    if (kBroadcastWorldMessage != none)
    {
        XComUIBroadcastWorldMessage_UnexpandedLocalizedString(kBroadcastWorldMessage).Init_UnexpandedLocalizedString(5, kVictim.GetLocation(), 4, kUnitPawn.m_eTeamVisibilityFlags);
    }
}

static function DoDeathOnOutsideOfBounds(XComUnitPawn kUnitPawn)
{
    local Vector vZero;

    if (kUnitPawn.m_kGameUnit != none && !XGUnit(kUnitPawn.m_kGameUnit).IsDead())
    {
        XGUnit(kUnitPawn.m_kGameUnit).m_bMPForceDeathOnMassiveTakeDamage = true;
        XGUnit(kUnitPawn.m_kGameUnit).OnTakeDamage(1000000, class'XComDamageType_Plasma', none, vZero, vZero);
    }
}