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

/// <summary>
/// Calculates the percentage of armor which the target ship has.
/// </summary>
/// <param name="kTarget">The ship which is being attacked.</param>
function int CalculateArmor(LWCE_XGShip kTarget)
{
    // This function (and other incredibly simple calculations) exists basically so that subclasses can
    // potentially override how one stat is calculated without having to redo all of the air combat logic
    return kTarget.m_kTCachedStats.iArmor;
}

/// <summary>
/// Calculates the percentage of armor which the attacker can penetrate on the target. The output is
/// not capped to the target's actual armor amount, allowing for "over-penetration" mechanics if desired.
/// </summary>
/// <param name="kAttacker">The ship which is attacking.</param>
/// <param name="kTarget">The ship which is being attacked.</param>
/// <param name="kWeapon">The weapon which the attacking ship is currently firing.</param>
function int CalculateArmorPen(LWCE_XGShip kAttacker, LWCE_XGShip kTarget, LWCEShipWeaponTemplate kWeapon)
{
    local int iArmorPen;

    iArmorPen = kAttacker.m_kTCachedStats.iArmorPen;
    iArmorPen += kWeapon.GetArmorPen(kAttacker, kTarget);

    return iArmorPen;
}

/// <summary>
/// Calculates the percentage chance that the attacker will critically hit the target.
/// </summary>
/// <param name="iArmor">The armor of the targeted ship.</param>
/// <param name="kTarget">The total penetration of the attacker's weapon versus the target.</param>
function int CalculateCriticalChance(int iArmor, int iArmorPen)
{
    local int iCritChance;

    iCritChance = (iArmor - iArmorPen) / 2;

    return Clamp(iCritChance, 5, 25);
}

/// <summary>
/// Calculates the base damage of an attack. Does not include any random elements, such as critical hits,
/// or the random up-to-50% damage bonus which is inherent to all ship attacks.
/// </summary>
/// <param name="kAttacker">The ship which is attacking.</param>
/// <param name="kTarget">The ship which is being attacked.</param>
/// <param name="kWeapon">The weapon which the attacking ship is currently firing.</param>
function int CalculateDamage(LWCE_XGShip kAttacker, LWCE_XGShip kTarget, LWCEShipWeaponTemplate kShipWeaponTemplate)
{
    local int iDamage;

    iDamage = kShipWeaponTemplate.GetDamage(kAttacker, kTarget);
    iDamage += kAttacker.m_kTCachedStats.iDamage;
    iDamage -= kTarget.m_kTCachedStats.iDamageReduction;

    if (kTarget.m_kTemplate.nmAnalysisTech != '' && LWCE_XGFacility_Labs(LABS()).LWCE_IsResearched(kTarget.m_kTemplate.nmAnalysisTech))
    {
        iDamage *= 1.1f;
    }

    // XCOM gets 1% increased damage per confirmed kill
    if (kAttacker.IsXComShip())
    {
        iDamage *= (1.0f + (float(kAttacker.m_iConfirmedKills) / 100.0f));
    }

    return iDamage;
}

function float CalculateDamageMitigation(int iArmor, int iArmorPen)
{
    local float fEffectiveArmor;

    // Armor and penetration are integer percentages for ease-of-use, so divide to a float
    fEffectiveArmor = (iArmor - iArmorPen) / 100.0f;

    return FClamp(fEffectiveArmor, 0.0f, 0.95f);
}

/// <summary>
/// Calculates the chance for the attacker to hit the target with the given weapon. Should factor in every
/// aspect of the engagement except for the use of aim/dodge modules.
/// </summary>
/// <param name="kAttacker">The ship which is attacking.</param>
/// <param name="kTarget">The ship which is being attacked.</param>
/// <param name="kWeapon">The weapon which the attacking ship is currently firing.</param>
function int CalculateHitChance(LWCE_XGShip kAttacker, LWCE_XGShip kTarget, LWCEShipWeaponTemplate kWeapon)
{
    local int iHitChance;

    // TODO move a lot of stuff below to config
    iHitChance = kWeapon.GetHitChance(kAttacker, kTarget);
    iHitChance += kAttacker.m_kTCachedStats.iAim;
    iHitChance -= kTarget.m_kTCachedStats.iDefense;

    // Both the attacker and defender's stance factor into hit chance
    if (kAttacker.m_nmEngagementStance == 'Aggressive')
    {
        iHitChance += 15;
    }
    else if (kAttacker.m_nmEngagementStance == 'Defensive')
    {
        iHitChance -= 15;
    }

    if (kTarget.m_nmEngagementStance == 'Aggressive')
    {
        iHitChance += 15;
    }
    else if (kTarget.m_nmEngagementStance == 'Defensive')
    {
        iHitChance -= 15;
    }

    if (kAttacker.IsXComShip())
    {
        iHitChance += Clamp(3 * kAttacker.m_iConfirmedKills, 0, 30);
    }

    iHitChance = Clamp(iHitChance, 5, 95);

    return iHitChance;
}

function bool CanUseConsumable(int ItemName)
{
    `LWCE_LOG_DEPRECATED_CLS(CanUseConsumable);

    return false;
}

/// <summary>
/// Checks if the given consumable can be used in this engagement. By default, each consumable can only
/// be used once per encounter. In addition, some consumables have stance requirements; e.g., aim modules can
/// only be used in Balanced or Aggressive stances. Since LWCE supports multiple ships per side, the updated
/// requirement is that at least one friendly ship must be in a supported stance for a consumable to be usable.
/// </summary>
function bool LWCE_CanUseConsumable(name ItemName)
{
    local LWCE_XGInterception kCEInterception;
    local LWCE_XGShip kShip;
    local bool bIsAnyShipInCorrectStance;

    kCEInterception = LWCE_XGInterception(m_kInterception);

    if (!LWCE_IsConsumableAvailable(ItemName))
    {
        return false;
    }

    bIsAnyShipInCorrectStance = false;

    if (ItemName == 'Item_UplinkTargeting')
    {
        foreach kCEInterception.m_arrFriendlyShips(kShip)
        {
            if (kShip.m_nmEngagementStance == 'Balanced' || kShip.m_nmEngagementStance == 'Aggressive')
            {
                bIsAnyShipInCorrectStance = true;
                break;
            }
        }
    }
    else if (ItemName == 'Item_DefenseMatrix')
    {
        foreach kCEInterception.m_arrFriendlyShips(kShip)
        {
            if (kShip.m_nmEngagementStance == 'Balanced' || kShip.m_nmEngagementStance == 'Defensive')
            {
                bIsAnyShipInCorrectStance = true;
                break;
            }
        }
    }
    else
    {
        bIsAnyShipInCorrectStance = true;
    }

    if (!bIsAnyShipInCorrectStance)
    {
        return false;
    }

    return !LWCE_HasConsumableBeenUsed(ItemName);
}

/// <summary>
/// Determines the next time (as an offset from the current time in the combat simulation) when any ship will fire
/// any of their weapons.
/// </summary>
function float FindNextWeaponTime()
{
    local int iShip, iWeapon;
    local float fLowestWeaponTime;
    local LWCE_XGShip kShip;

    fLowestWeaponTime = 9999.0;

    for (iShip = 0; iShip < GetNumShips(); iShip++)
    {
        if (!IsAnyWeaponInRange(iShip))
        {
            continue;
        }

        kShip = LWCE_GetShip(iShip);

        for (iWeapon = 0; iWeapon < kShip.m_afWeaponCooldown.Length; iWeapon++)
        {
            fLowestWeaponTime = FMin(kShip.m_afWeaponCooldown[iWeapon], fLowestWeaponTime);
        }
    }

    return fLowestWeaponTime;
}

/// <summary>
/// Gets the Combat struct, effectively simulating 60 seconds of interception. This is interpreted by the UI
/// layer and modified by the player aborting interception, using modules, etc.
/// </summary>
function Combat GetCombat()
{
    local LWCE_XGShip kShip;
    local int I;
    local float fNextWeaponTime;

    for (I = 0; I < GetNumShips(); I++)
    {
        kShip = LWCE_GetShip(I);
        m_aiShipHP.AddItem(kShip.GetHP());
    }

    m_fEncounterStartingRange = GetEncounterStartingRange();

    for (I = 0; I < GetNumShips(); I++)
    {
        m_afShipDistance.AddItem(m_fEncounterStartingRange);
    }

    for (I = 0; I < GetNumShips(); I++)
    {
        StaggerWeaponsForShip(I);
    }

    while (m_fTimeElapsed < 60.0)
    {
        fNextWeaponTime = FindNextWeaponTime();
        UpdateSim(fNextWeaponTime);
    }

    m_fTimeElapsed = 0.0;
    return m_kCombat;
}

function float GetDamageMitigation(TShipWeapon SHIPWEAPON, CombatExchange comExchange)
{
    `LWCE_LOG_DEPRECATED_BY(CalculateDamageMitigation);
    return -100.0f;
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
        kShip = LWCE_GetShip(iShip);
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

/// <summary>
/// Gets a specific enemy ship from this interception. Index must be between 0 and GetNumEnemyShips().
/// </summary>
function LWCE_XGShip LWCE_GetEnemyShip(int Index)
{
    return LWCE_XGInterception(m_kInterception).m_arrEnemyShips[Index];
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

/// <summary>
/// Gets how many enemy-aligned ships are participating in this interception.
/// </summary>
function int GetNumEnemyShips()
{
    return LWCE_XGInterception(m_kInterception).m_arrEnemyShips.Length;
}

/// <summary>
/// Gets the total number of ships participating in this interception.
/// </summary>
function int GetNumShips()
{
    local LWCE_XGInterception kCEInterception;

    kCEInterception = LWCE_XGInterception(m_kInterception);

    return kCEInterception.m_arrFriendlyShips.Length + kCEInterception.m_arrEnemyShips.Length;
}

/// <summary>
/// Gets how many XCOM-aligned ships are participating in this interception.
/// </summary>
function int GetNumPlayerShips()
{
    return LWCE_XGInterception(m_kInterception).m_arrFriendlyShips.Length;
}

/// <summary>
/// Gets a specific XCOM-aligned ship from this interception. Index must be between 0 and GetNumPlayerShips().
/// </summary>
function LWCE_XGShip LWCE_GetPlayerShip(int Index)
{
    return LWCE_XGInterception(m_kInterception).m_arrFriendlyShips[Index];
}

function XGShip GetShip(int iIndex)
{
    `LWCE_LOG_DEPRECATED_CLS(GetShip);

    return none;
}

/// <summary>
/// Retrieves a ship in the engagement by its index. By convention, enemy ships occupy indices 0..N-1 (where N
/// is the number of enemy ships), and friendly ships follow them. If you want a ship from a specific side of
/// the battle, it's better to use LWCE_GetEnemyShip or LWCE_GetPlayerShip instead.
/// </summary>
function LWCE_XGShip LWCE_GetShip(int iIndex)
{
    local LWCE_XGInterception kCEInterception;

    kCEInterception = LWCE_XGInterception(m_kInterception);

    if (iIndex < kCEInterception.m_arrEnemyShips.Length)
    {
        return kCEInterception.m_arrEnemyShips[iIndex];
    }
    else
    {
        return kCEInterception.m_arrFriendlyShips[iIndex - kCEInterception.m_arrEnemyShips.Length];
    }
}

function int GetShipDamage(TShipWeapon SHIPWEAPON, CombatExchange comExchange)
{
    `LWCE_LOG_DEPRECATED_BY(GetShipDamage, CalculateDamage);

    return -100;
}

function float GetShortestWeaponRange(int iShip)
{
    local LWCEShipWeaponTemplate kShipWeaponTemplate;
    local LWCE_XGShip kShip;
    local array<name> arrShipWeapons;
    local int iWeapon;
    local float fShortestWeaponRange;

    fShortestWeaponRange = 999999.0;
    kShip = LWCE_GetShip(iShip);
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
    local LWCE_XGShip kEnemyShip, kFriendlyShip;
    local int iEnemySpeed, iFinalSpeed, iFriendlySpeed, iBoostSpeedIncrease;

    fMaxOutrunTime = 9999.0;

    if (IsEnemyShip(iShip))
    {
        return fMaxOutrunTime;
    }
    else
    {
        kEnemyShip = LWCE_GetEnemyShip(0);
        iEnemySpeed = float(kEnemyShip.m_kTShip.iEngagementSpeed);

        kFriendlyShip = LWCE_GetShip(iShip);
        iFriendlySpeed = kFriendlyShip.GetEngagementSpeed();
        iBoostSpeedIncrease = iFriendlySpeed / 2;

        iFinalSpeed = iFriendlySpeed + (iBoostSpeedIncrease * LWCE_GetNumConsumableInEffect('Item_UFOTracking'));

        if (iEnemySpeed != 0.0)
        {
            return 30.0 * (iFinalSpeed / iEnemySpeed);
        }
        else
        {
            return iFinalSpeed;
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

    kShip = LWCE_GetShip(iShip);
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

/// <summary>
/// Checks whether the ship at the given index belongs to the enemy team.
/// </summary>
function bool IsEnemyShip(int iShip)
{
    // Enemy ships occupy the first indices when looking at all ships in an interception
    return iShip < LWCE_XGInterception(m_kInterception).m_arrEnemyShips.Length;
}

function bool IsUfo(int iShip)
{
    `LWCE_LOG_DEPRECATED_BY(IsUfo, IsEnemyShip);

    return false;
}

function int RollForDamage(int iBaseDamage, float fDamageMitigation, bool bIsCritical)
{
    local int iDamage;

    iDamage = iBaseDamage;

    if (bIsCritical)
    {
        iDamage *= 2;
    }

    iDamage += Rand(iDamage / 2);

    return Max(0, iDamage * (1.0f - fDamageMitigation));
}

function StaggerWeaponsForShip(int iShip)
{
    local int I;
    local LWCE_XGShip kShip;
    local array<name> arrShipWeapons;

    kShip = LWCE_GetShip(iShip);
    arrShipWeapons = kShip.LWCE_GetWeapons();

    for (I = 0; I < arrShipWeapons.Length; I++)
    {
        kShip.m_afWeaponCooldown[I] = float(Rand(20)) / 10.0;
    }
}

/// <summary>
///
/// </summary>
function UpdateEngagementResult(float fElapsedTime)
{
    local LWCE_XGInterception kCEInterception;
    local LWCE_XGShip kLeadEnemyShip;
    local int I;
    local bool bAnyShipsChasing;

    kCEInterception = LWCE_XGInterception(m_kInterception);

    if (m_kInterception.m_eUFOResult != eUR_NONE)
    {
        return;
    }

    kLeadEnemyShip = kCEInterception.m_arrEnemyShips[0];

    if (kLeadEnemyShip.m_iHP <= 0)
    {
        // TODO: make crash chance associated with the template somehow
        switch (kLeadEnemyShip.m_nmShipTemplate)
        {
            case 'UFOScout':
            case 'UFOFighter':
                if (Rand(100) >= (kLeadEnemyShip.m_iHP / -5))
                {
                    kCEInterception.m_eUFOResult = eUR_Crash;
                    return;
                }

                break;
            case 'UFODestroyer':
            case 'UFORaider':
                if (Rand(100) >= (kLeadEnemyShip.m_iHP / -6))
                {
                    kCEInterception.m_eUFOResult = eUR_Crash;
                    return;
                }

                break;
            case 'UFOAbductor':
            case 'UFOHarvester':
                if (Rand(100) >= (kLeadEnemyShip.m_iHP / -7))
                {
                    kCEInterception.m_eUFOResult = eUR_Crash;
                    return;
                }

                break;
            case 'UFOTransport':
            case 'UFOTerrorShip':
                if (Rand(100) >= (kLeadEnemyShip.m_iHP / -8))
                {
                    kCEInterception.m_eUFOResult = eUR_Crash;
                    return;
                }

                break;
            case 'UFOBattleship':
            case 'UFOAssaultCarrier':
                if (Rand(100) >= (kLeadEnemyShip.m_iHP / -15))
                {
                    kCEInterception.m_eUFOResult = eUR_Crash;
                    return;
                }

                break;
            case 'UFOOverseer':
                kCEInterception.m_eUFOResult = eUR_Crash;
                return;
        }

        // If not handled in the switch above, then the overkill damage was sufficient to destroy the UFO. UFOs
        // in the first month of the game are forced to be crashes and not outright destroyed.
        if (AI().GetMonth() == 0)
        {
            kCEInterception.m_eUFOResult = eUR_Crash;
        }
        else
        {
            kCEInterception.m_eUFOResult = eUR_Destroyed;
        }

        return;
    }
    else
    {
        bAnyShipsChasing = false;

        for (I = 0; I < kCEInterception.m_arrFriendlyShips.Length; I++)
        {
            if (kCEInterception.m_arrFriendlyShips[I].m_iHP > 0 && fElapsedTime <= GetTimeUntilOutrun(I + 1))
            {
                bAnyShipsChasing = true;
                break;
            }
        }

        if (!bAnyShipsChasing)
        {
            kCEInterception.m_eUFOResult = eUR_Escape;
        }
    }
}

function UpdateWeapons(float fDeltaT)
{
    local CombatExchange kCombatExchange;
    local LWCEItemTemplateManager kTemplateMgr;
    local LWCEShipWeaponTemplate kShipWeaponTemplate;
    local array<name> arrShipWeapons;
    local array<CombatExchange> akCombatExchange;
    local LWCE_XGShip kAttacker, kTarget;
    local bool bIsCritical;
    local float fDamageMitigation;
    local int iArmor, iArmorPen, iBaseDamage, iCriticalChance, iDamage, iHitChance, iShip, iWeapon, I;

    kTemplateMgr = `LWCE_ITEM_TEMPLATE_MGR;

    for (iShip = 0; iShip < GetNumShips(); iShip++)
    {
        kAttacker = LWCE_GetShip(iShip);
        kAttacker.UpdateWeapons(fDeltaT);

        if (AreAllWeaponsInRange(iShip))
        {
            arrShipWeapons = kAttacker.LWCE_GetWeapons();

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
                    if (kAttacker.m_afWeaponCooldown[iWeapon] <= 0.0)
                    {
                        kAttacker.m_afWeaponCooldown[iWeapon] += kShipWeaponTemplate.GetFiringTime(kAttacker);
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

                        kTarget = LWCE_GetShip(kCombatExchange.iTargetShip);

                        iArmor = CalculateArmor(kTarget);
                        iArmorPen = CalculateArmorPen(kAttacker, kTarget, kShipWeaponTemplate);
                        iCriticalChance = CalculateCriticalChance(iArmor, iArmorPen);
                        iHitChance = CalculateHitChance(kAttacker, kTarget, kShipWeaponTemplate);
                        iBaseDamage = CalculateDamage(kAttacker, kTarget, kShipWeaponTemplate);
                        fDamageMitigation = CalculateDamageMitigation(iArmor, iArmorPen);
                        bIsCritical = Roll(iCriticalChance);

                        `LWCE_LOG("UpdateWeapons: kAttacker = " $ kAttacker $ "; iArmor = " $ iArmor $ "; iArmorPen = " $ iArmorPen $ "; iCriticalChance = " $ iCriticalChance $ "; iHitChance = " $ iHitChance $ "; iBaseDamage = " $ iBaseDamage $ "; fDamageMitigation = " $ fDamageMitigation $ "; bIsCritical = " $ bIsCritical);
                        iDamage = RollForDamage(iBaseDamage, fDamageMitigation, bIsCritical);

                        if (iShip != 0)
                        {
                            // Weapons other than the primary (aka Wingtip Sparrowhawks) do half damage
                            // TODO: handle this by creating new ship weapon templates for the lower damage weapons instead
                            if (iWeapon != 0)
                            {
                                iDamage /= 2.0;
                            }
                        }

                        // Damage is always stored, even on a miss, in case an aim module is used
                        kCombatExchange.bHit = Rand(100) <= iHitChance;
                        kCombatExchange.iDamage = iDamage;

                        if (!kCombatExchange.bHit)
                        {
                            // This signals that aim modules can't change the outcome (i.e. don't allow Sparrowhawks to burn up
                            // aim module charges)
                            // TODO make this more flexible; some secondary weapons might want to be able to use aim modules
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