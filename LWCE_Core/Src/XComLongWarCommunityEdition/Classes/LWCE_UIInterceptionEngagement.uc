/// <summary>
/// LWCE UI for ship interceptions. The way this UI interacts with the underlying interception is
/// significantly changed from vanilla EW or LW 1.0. See <see cref="LWCE_XGInterceptionEngagement" />
/// for the changes and the reasoning behind them.
/// </summary>
class LWCE_UIInterceptionEngagement extends UIInterceptionEngagement
    dependson(LWCE_XGInterceptionEngagement);

// The time at which the next ship weapon will be fired during the engagement, as an offset
// from the current time, in seconds.
var float m_fNextWeaponTime;

simulated function OnInit()
{
    local LWCE_XGInterceptionEngagement kEngagement;
    local name nmAnalysisTech, nmEnemyShipTemplate, nmPlayerShipTemplate;
    local int I, playerShipType, enemyShipType;

    super(UI_FxsScreen).OnInit();

    m_iView = -1;
    m_kMgr = GetMgr();
    m_kMgr.PostInit(m_kXGInterception);
    m_fPlaybackTimeElapsed = 0.0;
    m_fEnemyEscapeTimer = 0.0;
    m_iTenthsOfSecondCounter = 0;
    m_fTrackingTimer = 0.0;
    m_fTotalBattleLength = m_kMgr.m_kInterceptionEngagement.GetTimeUntilOutrun(1);
    m_iInterceptorPlaybackIndex = 0;
    m_iUFOPlaybackIndex = 0;
    m_iBulletIndex = 0;
    m_iLastDodgeBulletIndex = -1;
    m_bPendingDisengage = false;
    m_bViewingResults = false;
    m_DataInitialized = false;

    kEngagement = LWCE_XGInterceptionEngagement(m_kMgr.m_kInterceptionEngagement);

    nmEnemyShipTemplate = kEngagement.LWCE_GetEnemyShip(0).m_nmShipTemplate;
    nmPlayerShipTemplate = kEngagement.LWCE_GetPlayerShip(0).m_nmShipTemplate;

    // All the graphics during interception are part of the Flash movie, so we have to map everything back somehow
    switch (nmEnemyShipTemplate)
    {
        case 'UFOFighter':
        case 'UFOScout':
            enemyShipType = eShip_UFOSmallScout;
            break;
        case 'UFODestroyer':
        case 'UFORaider':
            enemyShipType = eShip_UFOLargeScout;
            break;
        case 'UFOAbductor':
        case 'UFOHarvester':
            enemyShipType = eShip_UFOAbductor;
            break;
        case 'UFOTerrorShip':
        case 'UFOTransport':
            enemyShipType = eShip_UFOSupply;
            break;
        case 'UFOAssaultCarrier':
        case 'UFOBattleship':
            enemyShipType = eShip_UFOBattle;
            break;
        case 'UFOOverseer':
            enemyShipType = eShip_UFOEthereal;
            break;
        default:
            `LWCE_LOG_ERROR("Unknown ship type " $ kEngagement.LWCE_GetShip(0).m_nmShipTemplate $ "! Defaulting to eShip_UFOSmallScout");
            enemyShipType = eShip_UFOSmallScout;
            break;
    }

    playerShipType = nmPlayerShipTemplate == 'Interceptor' ? eShip_Interceptor : eShip_Firestorm;

    AS_SetResultsTitleLabels(m_strReport_Title, m_strReport_Subtitle);
    AS_InitializeData(playerShipType, enemyShipType, m_strPlayerDamageLabel, m_strEstablishingLinkLabel);

    for (I = 0; I < kEngagement.GetNumShips(); I++)
    {
        // TODO is calling this twice necessary?
        AS_SetHP(I, kEngagement.LWCE_GetShip(I).GetHullStrength(), true);
        AS_SetHP(I, kEngagement.LWCE_GetShip(I).m_iHP, true);
    }

    AS_SetAbortButtonText(m_strAbortMission);
    AS_SetEnemyEscapeTimerLabels(m_strEscapeTimerTitle, m_strTimeSufixSymbol);
    LWCE_SetConsumablesState(eAbilityState_Available);

    m_DataInitialized = true;

    nmAnalysisTech = `LWCE_SHIP(nmEnemyShipTemplate).nmAnalysisTech;
    if (!`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_UFOScanners') || (nmAnalysisTech != '' && !`LWCE_LABS.LWCE_IsResearched(nmAnalysisTech)))
    {
        Invoke("HideUFODamage");
    }
}

simulated event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}

simulated function ActivateDodgeAbility()
{
    local LWCE_XGInterceptionEngagement kEngagement;

    kEngagement = LWCE_XGInterceptionEngagement(m_kMgr.m_kInterceptionEngagement);

    if (m_bPendingDisengage || m_bViewingResults)
    {
        return;
    }

    if (kEngagement.LWCE_CanUseConsumable('Item_DefenseMatrix'))
    {
        kEngagement.LWCE_UseConsumable('Item_DefenseMatrix');
        PlaySound(m_kMgr.SNDLIB().SFX_Int_ConsumeDodge);
        AS_DisplayEffectEvent(eDodgeHits, GetAbilityDescription(eDodgeHits), true, kEngagement.LWCE_GetNumConsumableInEffect('Item_DefenseMatrix'));
    }
}

simulated function ActivateAimAbility()
{
    local LWCE_XGInterceptionEngagement kEngagement;

    kEngagement = LWCE_XGInterceptionEngagement(m_kMgr.m_kInterceptionEngagement);

    if (m_bPendingDisengage || m_bViewingResults)
    {
        return;
    }

    if (kEngagement.LWCE_CanUseConsumable('Item_UplinkTargeting'))
    {
        kEngagement.LWCE_UseConsumable('Item_UplinkTargeting');
        PlaySound(m_kMgr.SNDLIB().SFX_Int_ConsumeAim);
        AS_DisplayEffectEvent(eEnhancedAccuracy, GetAbilityDescription(eEnhancedAccuracy), true);
    }
}

simulated function ActivateTrackAbility()
{
    local LWCE_XGInterceptionEngagement kEngagement;

    kEngagement = LWCE_XGInterceptionEngagement(m_kMgr.m_kInterceptionEngagement);

    if (m_bPendingDisengage || m_bViewingResults)
    {
        return;
    }

    if (kEngagement.LWCE_CanUseConsumable('Item_UFOTracking'))
    {
        kEngagement.LWCE_UseConsumable('Item_UFOTracking');
        m_fTrackingTimer = m_kMgr.m_kInterceptionEngagement.GetTimeUntilOutrun(1) - m_fTotalBattleLength;

        if (m_kMgr.m_kInterceptionEngagement.m_fInterceptorTimeOffset != 0.0)
        {
            AS_MovementEvent(1, ePlayer_CloseDistance, 1.0);
        }

        PlaySound(m_kMgr.SNDLIB().SFX_Int_ConsumeTrack);
        AS_DisplayEffectEvent(eTrack, GetAbilityDescription(eTrack), true);
    }
}

simulated function int GetWeaponType(CombatExchange kCombatExchange)
{
    `LWCE_LOG_DEPRECATED_CLS(GetWeaponType);

    return -1;
}

/// <summary>
/// Maps the weapon fired in the exchange to an EProjectileType, which tells the Flash movie what image to show for the projectile.
/// </summary>
simulated function int LWCE_GetWeaponType(LWCE_TCombatExchange kCombatExchange)
{
    local array<name> arrShipWeapons;
    local LWCEShipWeaponTemplate kShipWeaponTemplate;

    arrShipWeapons = LWCE_XGInterceptionEngagement(m_kMgr.m_kInterceptionEngagement).LWCE_GetShip(kCombatExchange.iSourceShip).LWCE_GetWeapons();
    kShipWeaponTemplate = `LWCE_SHIP_WEAPON(arrShipWeapons[kCombatExchange.iWeapon]);

    if (kShipWeaponTemplate == none)
    {
        return ePT_None;
    }

    return kShipWeaponTemplate.eProjectile;
}

simulated function Playback(float fDeltaT)
{
    local LWCE_XGInterceptionEngagementUI kMgr;
    local LWCE_XGInterceptionEngagement kEngagement;
    local bool bShipWasAlive;
    local int I, iConsumableIndex, iPlaybackStartIndex, iWeaponType;
    local float fElapsedTimeAtStart, fProjectileDuration;
    local LWCE_XGShip kSourceShip, kTargetShip;
    local LWCE_TCombatExchange kCombatExchange;

    kMgr = LWCE_XGInterceptionEngagementUI(m_kMgr);
    kEngagement = LWCE_XGInterceptionEngagement(m_kMgr.m_kInterceptionEngagement);

    if (!m_bIntroSequenceComplete)
    {
        return;
    }

    if (m_fPlaybackTimeElapsed == 0.0)
    {
        m_fEnemyEscapeTimer = kEngagement.GetTimeUntilOutrun(1);
        AS_MovementEvent(0, 0, m_fEnemyEscapeTimer);
        AS_SetEnemyEscapeTimer(int(m_fEnemyEscapeTimer * 10));

        if (kMgr.LWCE_IsShortDistanceWeapon(kEngagement.LWCE_GetPlayerShip(0).GetWeaponAtIndex(0)))
        {
            m_kMgr.VOCloseDistance();
            AS_MovementEvent(0, 1, 1.0f);
        }

        m_fNextWeaponTime = kEngagement.FindNextWeaponTime();
    }

    fElapsedTimeAtStart = m_fPlaybackTimeElapsed;
    m_fPlaybackTimeElapsed += fDeltaT;
    UpdateEnemyEscapeTimer(fDeltaT);

    // TODO: rather than doing playback of a pre-simulated combat, have the simulation update in real time, prompted
    // by the UI. Otherwise the simulation ends up making decisions based on state (e.g. is target ship dead) that may
    // not actually come to pass (such as if a module is used).
    // TODO get rid of having multiple playback streams also

    iPlaybackStartIndex = -1;

    while (fDeltaT >= m_fNextWeaponTime)
    {
        fDeltaT -= m_fNextWeaponTime;

        kEngagement.UpdateSim(m_fNextWeaponTime);

        if (iPlaybackStartIndex == -1)
        {
            iPlaybackStartIndex = kEngagement.m_iMostRecentExchangesStartIndex;
        }

        m_fNextWeaponTime = kEngagement.FindNextWeaponTime();
    }

    // Carry over any spare part of the elapsed time, or all of it if nothing fired
    if (fDeltaT > 0.0f)
    {
        kEngagement.UpdateSim(fDeltaT);
        m_fNextWeaponTime = kEngagement.FindNextWeaponTime();
    }

    if (iPlaybackStartIndex != -1)
    {
        // Iterate any exchanges which occurred during this update, and modify UI accordingly
        for (I = iPlaybackStartIndex; I < kEngagement.m_arrCECombatExchanges.Length; I++)
        {
            kCombatExchange = kEngagement.m_arrCECombatExchanges[I];

            m_iBulletIndex++;

            kSourceShip = kEngagement.LWCE_GetShip(kCombatExchange.iSourceShip);
            kTargetShip = kEngagement.LWCE_GetShip(kCombatExchange.iTargetShip);

            if (kSourceShip.m_iHP <= 0 || kTargetShip.m_iHP <= 0)
            {
                continue;
            }

            // TODO: do we need to let the underlying interception know about this? it probably never matters
            if (m_bPendingDisengage && kSourceShip.IsXComShip())
            {
                continue;
            }

            fProjectileDuration = kCombatExchange.bHit ? 0.3f : 0.6f;
            kEngagement.m_arrCECombatExchanges[I].fCompleteTime = kCombatExchange.fTime + fProjectileDuration;
            kEngagement.m_arrCECombatExchanges[I].iBulletID = m_iBulletIndex;

            if (!kSourceShip.IsAlienShip())
            {
                m_kMgr.VOInRange();
            }

            iWeaponType = LWCE_GetWeaponType(kCombatExchange);
            m_kMgr.SFXFire(iWeaponType);
            AS_AttackEvent(kCombatExchange.iSourceShip, kCombatExchange.iTargetShip, iWeaponType, m_iBulletIndex, kCombatExchange.iDamage, fProjectileDuration, kCombatExchange.bHit);

            // If this shot used our last aim module, do a little animation
            iConsumableIndex = kCombatExchange.arrConsumablesUsed.Find('Item_UplinkTargeting');

            if (iConsumableIndex != INDEX_NONE && kCombatExchange.arrConsumablesRemaining[iConsumableIndex] == 0)
            {
                AS_DisplayEffectEvent(eEnhancedAccuracy, GetAbilityDescription(eEnhancedAccuracy), false, m_iBulletIndex);
            }
        }
    }

    // Go through every exchange in this encounter, and find any which reached their target during this update
    for (I = 0; I < kEngagement.m_arrCECombatExchanges.Length; I++)
    {
        kCombatExchange = kEngagement.m_arrCECombatExchanges[I];

        if (kCombatExchange.fCompleteTime > fElapsedTimeAtStart && kCombatExchange.fCompleteTime <= m_fPlaybackTimeElapsed)
        {
            kTargetShip = kEngagement.LWCE_GetShip(kCombatExchange.iTargetShip);

            // If this shot was dodged due to a module, show a dodge animation on the player ship
            iConsumableIndex = kCombatExchange.arrConsumablesUsed.Find('Item_DefenseMatrix');

            if (iConsumableIndex != INDEX_NONE && kCombatExchange.arrConsumablesRemaining[iConsumableIndex] == 0)
            {
                AS_DisplayEffectEvent(eDodgeHits, GetAbilityDescription(eDodgeHits), false);
                AS_SetDodgeButton(m_strDodgeAbility, eAbilityState_Disabled);
            }

            if (kCombatExchange.bHit)
            {
                bShipWasAlive = kTargetShip.m_iHP > 0;
                kTargetShip.m_iHP -= kCombatExchange.iDamage;
                m_kMgr.SFXShipHit(kTargetShip, kCombatExchange.iDamage);

                `LWCE_LOG("Ship " $ kTargetShip $ " is taking " $ kCombatExchange.iDamage $ " damage; new HP is " $ kTargetShip.m_iHP);

                // Need to make sure the ship was actually alive before it got hit; in a big dogfight, there might be multiple projectiles
                // in the air, all landing at the same time
                if (kTargetShip.m_iHP <= 0 && bShipWasAlive)
                {
                    m_kMgr.SFXShipDestroyed(kTargetShip);

                    `LWCE_LOG(kTargetShip $ " was destroyed by " $ kSourceShip);
                    kSourceShip = kEngagement.LWCE_GetShip(kCombatExchange.iSourceShip);
                    LWCE_XGInterception(kEngagement.m_kInterception).RecordKill(kSourceShip, kTargetShip);
                }

                AS_SetHP(kCombatExchange.iTargetShip, kTargetShip.m_iHP, false, kCombatExchange.iBulletID);
            }
        }
    }
}

simulated function ShowResultScreen()
{
    local int I, battleResult;
    local string strDescription, strReport;
    local float fHealthPercent;
    local XGParamTag kTag;
    local LWCE_XGInterception kInterception;

    kInterception = LWCE_XGInterception(m_kMgr.m_kInterceptionEngagement.m_kInterception);
    m_bViewingResults = true;

    if (kInterception.m_eUFOResult == eUR_Disengaged)
    {
        AS_SetAbortLabel(m_strAbortedMission);
    }

    LWCE_SetConsumablesState(eAbilityState_Disabled);

    kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
    kTag.StrValue0 = kInterception.m_arrFriendlyShips[0].m_kTemplate.strName;

    switch (kInterception.m_eUFOResult)
    {
        case eUR_Crash:
            battleResult = eUFO_Destroyed;
            strDescription = class'XComLocalizer'.static.ExpandString(m_strResult_UFOCrashed);
            break;
        case eUR_Destroyed:
            battleResult = eUFO_Destroyed;
            strDescription = class'XComLocalizer'.static.ExpandString(m_strResult_UFODestroyed);
            break;
        case eUR_Escape:
            battleResult = eUFO_Escaped;
            strDescription = class'XComLocalizer'.static.ExpandString(m_strResult_UFOEscaped);
            break;
        case eUR_Disengaged:
            battleResult = ePlayer_Aborted;
            strDescription = class'XComLocalizer'.static.ExpandString(m_strResult_UFODisengaged);
            break;
    }

    for (I = 0; I < kInterception.m_arrFriendlyShips.Length; I++)
    {
        fHealthPercent = kInterception.m_arrFriendlyShips[I].GetHPPercentage();

        if (fHealthPercent <= 0.0)
        {
            battleResult = ePlayer_Destroyed;
            strReport = class'XComLocalizer'.static.ExpandString(m_strReport_ShotDown);
        }
        else if (fHealthPercent < 0.330)
        {
            strReport = class'XComLocalizer'.static.ExpandString(m_strReport_SevereDamage);
        }
        else if (fHealthPercent < 0.660)
        {
            strReport = class'XComLocalizer'.static.ExpandString(m_strReport_HeavyDamage);
        }
        else if (fHealthPercent < 1.0)
        {
            strReport = class'XComLocalizer'.static.ExpandString(m_strReport_LightDamage);
        }
        else
        {
            strReport = class'XComLocalizer'.static.ExpandString(m_strReport_NoDamage);
        }
    }

    AS_ShowResults(strDescription $ "\n" $ strReport, battleResult, m_strLeaveReportButtonLabel);
}

protected simulated function LWCE_SetConsumablesState(optional int stateOverride = eAbilityState_Available)
{
    local LWCE_XGInterceptionEngagement kEngagement;

    kEngagement = LWCE_XGInterceptionEngagement(m_kMgr.m_kInterceptionEngagement);

    if (kEngagement.LWCE_IsConsumableResearched('Item_UplinkTargeting'))
    {
        if ((stateOverride == eAbilityState_Available || stateOverride == eAbilityState_Active) && kEngagement.LWCE_CanUseConsumable('Item_UplinkTargeting'))
        {
            AS_SetAimButton(m_strAimAbility, stateOverride);
        }
        else
        {
            AS_SetAimButton(m_strAimAbility, eAbilityState_Disabled);
        }
    }
    else
    {
        AS_SetAimButton(m_strAimAbility, eAbilityState_Unavailable);
    }

    if (kEngagement.LWCE_IsConsumableResearched('Item_DefenseMatrix'))
    {
        if ((stateOverride == eAbilityState_Available || stateOverride == eAbilityState_Active) && kEngagement.LWCE_CanUseConsumable('Item_DefenseMatrix'))
        {
            AS_SetDodgeButton(m_strDodgeAbility, stateOverride);
        }
        else
        {
            AS_SetDodgeButton(m_strDodgeAbility, eAbilityState_Disabled);
        }
    }
    else
    {
        AS_SetAimButton(m_strAimAbility, eAbilityState_Unavailable);
    }

    if (kEngagement.LWCE_IsConsumableResearched('Item_UFOTracking'))
    {
        if ((stateOverride == eAbilityState_Available || stateOverride == eAbilityState_Active) && kEngagement.LWCE_CanUseConsumable('Item_UFOTracking'))
        {
            AS_SetTrackButton(m_strTrackAbility, m_strTrackingText, stateOverride);
        }
        else
        {
            AS_SetDodgeButton(m_strDodgeAbility, eAbilityState_Disabled);
        }
    }
    else
    {
        AS_SetAimButton(m_strAimAbility, eAbilityState_Unavailable);
    }
}