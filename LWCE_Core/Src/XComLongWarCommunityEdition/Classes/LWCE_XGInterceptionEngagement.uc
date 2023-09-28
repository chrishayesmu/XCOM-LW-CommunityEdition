class LWCE_XGInterceptionEngagement extends XGInterceptionEngagement;

var array<name> m_arrCEConsumablesUsed;
var array<LWCE_TItemQuantity> m_arrCEConsumableQuantitiesInEffect;

function Init(XGInterception kInterception)
{
    // Resetting state for the new interception
    HANGAR().m_bNarrLostJet = false;
    m_kInterception = kInterception;
    m_fTimeElapsed = 0.0;
    m_iPlaybackIndex = 0;
    m_fEncounterStartingRange = 0.0;
    m_fInterceptorTimeOffset = 0.0;

    m_arrCEConsumablesUsed.Remove(0, m_arrCEConsumablesUsed.Length);
    m_arrCEConsumableQuantitiesInEffect.Remove(0, m_arrCEConsumableQuantitiesInEffect.Length);
    m_kCombat.m_aInterceptorExchanges.Remove(0, m_kCombat.m_aInterceptorExchanges.Length);
    m_kCombat.m_aUFOExchanges.Remove(0, m_kCombat.m_aUFOExchanges.Length);

    // Base game code ranks interceptors by threat level, but there's only one at a time, so just
    // always target that guy
    m_iUFOTarget = 1;
}

function bool CanUseConsumable(int ItemName)
{
    `LWCE_LOG_DEPRECATED_CLS(CanUseConsumable);

    return false;
}

function bool LWCE_CanUseConsumable(name ItemName)
{
    if (!LWCE_IsConsumableAvailable(ItemName))
    {
        return false;
    }

    if (ItemName == 'Item_UplinkTargeting')
    {
        if (GetShip(1).m_kTShip.iRange == 2) // Defensive
        {
            return false;
        }
    }

    if (ItemName == 'Item_DefenseMatrix')
    {
        if (GetShip(1).m_kTShip.iRange == 1) // Aggressive
        {
            return false;
        }
    }

    return !LWCE_HasConsumableBeenUsed(ItemName);
}

function float GetDamageMitigation(TShipWeapon SHIPWEAPON, CombatExchange comExchange)
{
    `LWCE_LOG_DEPRECATED_CLS(GetDamageMitigation);
    return -100.0f;
}

function float LWCE_GetDamageMitigation(LWCEShipWeaponTemplate kShipWeaponTemplate, CombatExchange comExchange)
{
    local float firingShipArmorPen, firingWeaponArmorPen, targetShipArmor, armorMitigation, Defense, Offense,
	    finalMitigation;

    // TODO: these calculations are probably wrong right now, because LWCEShipWeaponTemplate uses 1-to-1 values for
    // armor pen (e.g. 25 -> 25%) but the old TShip data which is in use has 5-to-1 (e.g. 5 -> 25%). When moving ships
    // to templates, revisit this function.
    armorMitigation = 0.050;
    targetShipArmor = LWCE_XGShip(GetShip(comExchange.iTargetShip)).GetShipData().iArmor;
    firingShipArmorPen = LWCE_XGShip(GetShip(comExchange.iSourceShip)).GetShipData().iArmorPen;
    firingWeaponArmorPen = kShipWeaponTemplate.GetArmorPen(GetShip(comExchange.iSourceShip), !IsUfo(comExchange.iSourceShip)) / 100.0f;
    Offense = firingWeaponArmorPen + firingShipArmorPen;
    Defense = targetShipArmor;
    finalMitigation = FClamp(armorMitigation * (Defense - Offense), 0.0, 0.950);
    return finalMitigation;
}

function float GetEncounterStartingRange()
{
    local LWCEShipWeaponTemplate kShipWeaponTemplate;
    local LWCE_XGShip kShip;
    local array<name> arrShipWeapons;
    local float fStartingRange;
    local int iShip, iWeapon;

    fStartingRange = 0.0;

    for (iShip = 0; iShip < GetNumShips(); iShip++)
    {
        kShip = LWCE_XGShip(GetShip(iShip));
        arrShipWeapons = kShip.LWCE_GetWeapons();

        for (iWeapon =  0; iWeapon < arrShipWeapons.Length; iWeapon++)
        {
            if (arrShipWeapons[iWeapon] == '')
            {
                continue;
            }

            kShipWeaponTemplate = `LWCE_SHIP_WEAPON(arrShipWeapons[iWeapon]);

            if (kShipWeaponTemplate == none)
            {
                continue;
            }

            if (kShipWeaponTemplate.iRange > fStartingRange)
            {
                fStartingRange = kShipWeaponTemplate.iRange;
            }
        }
    }

    return fStartingRange;
}

function int GetNumConsumableInEffect(int ItemName)
{
    `LWCE_LOG_DEPRECATED_CLS(GetNumConsumableInEffect);

    return -1;
}

function int LWCE_GetNumConsumableInEffect(name ItemName)
{
    if (!LWCE_IsConsumable(ItemName))
    {
        return -1;
    }

    return `LWCE_UTILS.GetItemQuantity(m_arrCEConsumableQuantitiesInEffect, ItemName).iQuantity;
}

function int GetShipDamage(TShipWeapon SHIPWEAPON, CombatExchange comExchange)
{
    `LWCE_LOG_DEPRECATED_CLS(GetShipDamage);

    return -100;
}

function int LWCE_GetShipDamage(LWCEShipWeaponTemplate kShipWeaponTemplate, CombatExchange comExchange)
{
    local int iBaseDmg, iFinalDmg;
    local float fDamageMitigation;

    iBaseDmg = kShipWeaponTemplate.GetDamage(GetShip(comExchange.iSourceShip), !IsUfo(comExchange.iSourceShip));
    fDamageMitigation = LWCE_GetDamageMitigation(kShipWeaponTemplate, comExchange);
    iFinalDmg = iBaseDmg * (1.0f - fDamageMitigation);

    return iFinalDmg;
}

function float GetShortestWeaponRange(int iShip)
{
    local LWCEShipWeaponTemplate kShipWeaponTemplate;
    local LWCE_XGShip kShip;
    local array<name> arrShipWeapons;
    local int iWeapon;
    local float fShortestWeaponRange;

    fShortestWeaponRange = 999999.0;
    kShip = LWCE_XGShip(GetShip(iShip));
    arrShipWeapons = kShip.LWCE_GetWeapons();

    for (iWeapon = 0; iWeapon < arrShipWeapons.Length; iWeapon++)
    {
        if (arrShipWeapons[iWeapon] == '')
        {
            continue;
        }

        kShipWeaponTemplate = `LWCE_SHIP_WEAPON(arrShipWeapons[iWeapon]);

        if (kShipWeaponTemplate == none)
        {
            continue;
        }

        fShortestWeaponRange = FMin(fShortestWeaponRange, kShipWeaponTemplate.iRange);
    }

    return fShortestWeaponRange;
}

function float GetTimeUntilOutrun(int iShip)
{
    local float fMaxOutrunTime;
    local XGShip kUFO, kInterceptor;
    local float fUFOSpeed, fInterceptorSpeed;
    local int iSlowestInterceptorSpeed, iBoostSpeedIncrease;

    fMaxOutrunTime = 9999.0;

    if (IsUfo(iShip))
    {
        return fMaxOutrunTime;
    }
    else
    {
        kUFO = GetShip(0);
        iSlowestInterceptorSpeed = 9999;
        kInterceptor = GetShip(iShip);
        iSlowestInterceptorSpeed = kInterceptor.m_kTShip.iEngagementSpeed;
        iBoostSpeedIncrease = int(float(iSlowestInterceptorSpeed) * 0.50);
        fUFOSpeed = float(kUFO.m_kTShip.iEngagementSpeed);
        fInterceptorSpeed = float(iSlowestInterceptorSpeed + (iBoostSpeedIncrease * (LWCE_GetNumConsumableInEffect('Item_UFOTracking'))));

        if (fUFOSpeed != 0.0)
        {
            return 30.0 * (fInterceptorSpeed / fUFOSpeed);
        }
        else
        {
            return fInterceptorSpeed;
        }
    }
}

function bool HasConsumableBeenUsed(int ItemName)
{
    `LWCE_LOG_DEPRECATED_CLS(HasConsumableBeenUsed);

    return false;
}

function bool LWCE_HasConsumableBeenUsed(name ItemName)
{
    local int I;

    for (I = 0; I < m_arrCEConsumablesUsed.Length; I++)
    {
        if (m_arrCEConsumablesUsed[I] == ItemName)
        {
            return true;
        }
    }

    return false;
}

function bool IsAnyWeaponInRange(int iShip)
{
    local LWCE_XGShip kShip;
    local LWCEShipWeaponTemplate kShipWeaponTemplate;
    local array<name> arrShipWeapons;
    local int iWeapon;

    kShip = LWCE_XGShip(GetShip(iShip));
    arrShipWeapons = kShip.LWCE_GetWeapons();

    for (iWeapon = 0; iWeapon < arrShipWeapons.Length; iWeapon++)
    {
        if (arrShipWeapons[iWeapon] == '')
        {
            continue;
        }

        kShipWeaponTemplate = `LWCE_SHIP_WEAPON(arrShipWeapons[iWeapon]);

        if (kShipWeaponTemplate == none)
        {
            continue;
        }

        if (m_afShipDistance[iShip] <= kShipWeaponTemplate.iRange)
        {
            return true;
        }
    }

    return false;
}

function bool IsConsumable(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(IsConsumable);

    return false;
}

function bool LWCE_IsConsumable(name ItemName)
{
    // TODO move to template
    if (ItemName == 'Item_DefenseMatrix' || ItemName == 'Item_UplinkTargeting' || ItemName == 'Item_UFOTracking')
    {
        return true;
    }

    return false;
}

function bool IsConsumableAvailable(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(IsConsumableAvailable);

    return false;
}

function bool LWCE_IsConsumableAvailable(name ItemName)
{
    if (!LWCE_IsConsumable(ItemName))
    {
        return false;
    }

    return LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable(ItemName) > 0;
}

function bool IsConsumableInEffect(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(IsConsumableInEffect);

    return false;
}

function bool LWCE_IsConsumableInEffect(name ItemName)
{
    return LWCE_GetNumConsumableInEffect(ItemName) > 0;
}

function bool IsConsumableResearched(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(IsConsumableResearched);

    return false;
}

function bool LWCE_IsConsumableResearched(name ItemName)
{
    local LWCEItemTemplate kItem;

    if (LWCE_IsConsumable(ItemName))
    {
        kItem = `LWCE_ITEM(ItemName);

        return `LWCE_HQ.ArePrereqsFulfilled(kItem.kPrereqs);
    }

    return false;
}

function StaggerWeaponsForShip(int iShip)
{
    local int I;
    local XGShip kShip;
    local array<name> arrShipWeapons;

    kShip = GetShip(iShip);
    arrShipWeapons = LWCE_XGShip(kShip).LWCE_GetWeapons();

    for (I = 0; I < arrShipWeapons.Length; I++)
    {
        kShip.m_afWeaponCooldown[I] = float(Rand(20)) / 10.0;
    }
}

function UpdateWeapons(float fDeltaT)
{
    local CombatExchange kCombatExchange;
    local LWCEItemTemplateManager kTemplateMgr;
    local LWCEShipWeaponTemplate kShipWeaponTemplate;
    local name nmAnalysisTech;
    local array<name> arrShipWeapons;
    local array<CombatExchange> akCombatExchange;
    local XGShip kShip;
    local int iChanceToHit, iShip, iWeapon, I;

    kTemplateMgr = `LWCE_ITEM_TEMPLATE_MGR;

    for (iShip = 0; iShip < GetNumShips(); iShip++)
    {
        kShip = GetShip(iShip);
        kShip.UpdateWeapons(fDeltaT);

        if (AreAllWeaponsInRange(iShip))
        {
            arrShipWeapons = LWCE_XGShip(kShip).LWCE_GetWeapons();

            for (iWeapon = 0; iWeapon < arrShipWeapons.Length; iWeapon++)
            {
                if (arrShipWeapons[iWeapon] == '')
                {
                    continue;
                }

                kShipWeaponTemplate = kTemplateMgr.FindShipWeaponTemplate(arrShipWeapons[iWeapon]);

                if (kShipWeaponTemplate == none)
                {
                    continue;
                }

                if (m_afShipDistance[iShip] <= kShipWeaponTemplate.iRange)
                {
                    if (kShip.m_afWeaponCooldown[iWeapon] <= 0.0)
                    {
                        kShip.m_afWeaponCooldown[iWeapon] += kShipWeaponTemplate.GetFiringTime(kShip, !IsUfo(iShip));
                        kCombatExchange.iSourceShip = iShip;
                        kCombatExchange.iWeapon = iWeapon;

                        if (iShip == 0) // UFO
                        {
                            if (!IsShipDead(m_iUFOTarget))
                            {
                                kCombatExchange.iTargetShip = m_iUFOTarget;
                            }
                            else
                            {
                                kCombatExchange.iTargetShip = 1;
                            }
                        }
                        else
                        {
                            kCombatExchange.iTargetShip = 0;
                        }

                        // TODO add aim and defense stats
                        iChanceToHit = kShipWeaponTemplate.GetHitChance(kShip, !IsUfo(iShip));

                        // For player ships, add aim per confirmed kill
                        // TODO put the aim-per-kill into config
                        if (iShip != 0)
                        {
                            iChanceToHit += Clamp(3 * m_kInterception.m_arrInterceptors[0].m_iConfirmedKills, 0, 30);
                        }

                        if (GetShip(1).m_kTShip.iRange == 1) // aggressive
                        {
                            iChanceToHit += 15; // TODO move hit chance adjustment to config
                        }
                        else if (GetShip(1).m_kTShip.iRange == 2) // defensive
                        {
                            iChanceToHit -= 15;
                        }

                        iChanceToHit = Clamp(iChanceToHit, 5, 95);
                        kCombatExchange.iDamage = LWCE_GetShipDamage(kShipWeaponTemplate, kCombatExchange);

                        // Roll for critical hit
                        if (Rand(100) <= Clamp((kShipWeaponTemplate.GetArmorPen(GetShip(kCombatExchange.iSourceShip), IsUfo(kCombatExchange.iSourceShip)) + GetShip(kCombatExchange.iSourceShip).m_kTShip.iAP - GetShip(kCombatExchange.iTargetShip).m_kTShip.iArmor) / 2, 5, 25))
                        {
                            kCombatExchange.iDamage *= 2.0f;
                        }

                        kCombatExchange.iDamage = kCombatExchange.iDamage + Rand(kCombatExchange.iDamage / 2);

                        if (iShip != 0)
                        {
                            // Check for UFO Analysis research
                            nmAnalysisTech = UFOTypeToAnalysisTech(LWCE_XGShip(GetShip(kCombatExchange.iTargetShip)).GetShipData().eType);

                            if (LWCE_XGFacility_Labs(LABS()).LWCE_IsResearched(nmAnalysisTech))
                            {
                                kCombatExchange.iDamage *= 1.10;
                            }

                            // Interceptors get 1% increased damage per confirmed kill
                            kCombatExchange.iDamage *= (1.0f + (float(m_kInterception.m_arrInterceptors[0].m_iConfirmedKills) / 100.0f));

                            // Weapons other than the primary (aka Wingtip Sparrowhawks) do half damage
                            if (iWeapon != 0)
                            {
                                kCombatExchange.iDamage /= 2.0;
                            }
                        }

                        if (Rand(100) <= iChanceToHit)
                        {
                            kCombatExchange.bHit = true;
                        }
                        else
                        {
                            kCombatExchange.bHit = false;

                            if (iShip == 0 || iWeapon != 0)
                            {
                                kCombatExchange.iDamage = 0;
                            }
                        }

                        kCombatExchange.fTime = m_fTimeElapsed;
                        akCombatExchange.AddItem(kCombatExchange);
                    }
                }
            }
        }
    }

    for (I = 0; I < akCombatExchange.Length; I++)
    {
        if (akCombatExchange[I].iSourceShip == 0)
        {
            m_kCombat.m_aUFOExchanges.AddItem(akCombatExchange[I]);
        }
        else
        {
            m_kCombat.m_aInterceptorExchanges.AddItem(akCombatExchange[I]);
        }

        if (akCombatExchange[I].bHit)
        {
            m_aiShipHP[akCombatExchange[I].iTargetShip] -= akCombatExchange[I].iDamage;
        }
    }
}

function UseConsumable(int iItemType, float fPlaybackTime)
{
    `LWCE_LOG_DEPRECATED_CLS(UseConsumable);
}

function LWCE_UseConsumable(name ItemName, float fPlaybackTime)
{
    local int iNumUses;

    if (!LWCE_CanUseConsumable(ItemName))
    {
        return;
    }

    if (ItemName == 'Item_UFOTracking')
    {
        iNumUses = 1;
        PRES().UINarrative(`XComNarrativeMoment("RoboUFOTracking"));
        STAT_AddStat(eRecap_TrackConsumablesUsed, 1);
    }
    else if (ItemName == 'Item_DefenseMatrix')
    {
        iNumUses = 2;
        PRES().UINarrative(`XComNarrativeMoment("RoboDefenseMatrix"));
        STAT_AddStat(eRecap_DodgeConsumablesUsed, 1);
    }
    else if (ItemName == 'Item_UplinkTargeting')
    {
        iNumUses = 2;
        PRES().UINarrative(`XComNarrativeMoment("RoboSatelliteAssistAim"));
        STAT_AddStat(eRecap_AimConsumablesUsed, 1);
    }

    `LWCE_UTILS.AdjustItemQuantity(m_arrCEConsumableQuantitiesInEffect, ItemName, iNumUses);
    m_arrCEConsumablesUsed.AddItem(ItemName);
    LWCE_XGStorage(STORAGE()).LWCE_RemoveItem(ItemName, 1);
}

function UseConsumableEffect(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(UseConsumableEffect);
}

function LWCE_UseConsumableEffect(name ItemName)
{
    `LWCE_UTILS.AdjustItemQuantity(m_arrCEConsumableQuantitiesInEffect, ItemName, -1);
}

// TODO replace this with ship template data
protected function name UFOTypeToAnalysisTech(int iShipType)
{
    switch (iShipType)
    {
        case 4:
            return 'Tech_UFOAnalysis_Scout';
        case 5:
            return 'Tech_UFOAnalysis_Destroyer';
        case 6:
            return 'Tech_UFOAnalysis_Abductor';
        case 7:
            return 'Tech_UFOAnalysis_Transport';
        case 8:
            return 'Tech_UFOAnalysis_Battleship';
        case 9:
            return 'Tech_UFOAnalysis_Overseer';
        case 10:
            return 'Tech_UFOAnalysis_Fighter';
        case 11:
            return 'Tech_UFOAnalysis_Raider';
        case 12:
            return 'Tech_UFOAnalysis_Harvester';
        case 13:
            return 'Tech_UFOAnalysis_TerrorShip';
        case 14:
            return 'Tech_UFOAnalysis_AssaultCarrier';
        default:
            return '';
    }
}