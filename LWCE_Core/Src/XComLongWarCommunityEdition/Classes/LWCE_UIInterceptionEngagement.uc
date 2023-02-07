class LWCE_UIInterceptionEngagement extends UIInterceptionEngagement;

simulated function OnInit()
{
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

    enemyShipType = m_kMgr.m_kInterceptionEngagement.GetShip(0).GetType();

    switch (enemyShipType)
    {
        case 10: // Fighter
            I = eShip_UFOSmallScout;
            break;
        case 11: // Raider
            I = eShip_UFOLargeScout;
            break;
        case 12: // Harvester
            I = eShip_UFOAbductor;
            break;
        case 13: // Terror Ship
            I = eShip_UFOSupply;
            break;
        case 14: // Assault Carrier
            I = eShip_UFOBattle;
            break;
    }

    if (enemyShipType >= 10)
    {
        enemyShipType = I;
    }

    playerShipType = m_kMgr.m_kInterceptionEngagement.GetShip(1).GetType();

    AS_SetResultsTitleLabels(m_strReport_Title, m_strReport_Subtitle);
    AS_InitializeData(playerShipType, enemyShipType, m_strPlayerDamageLabel, m_strEstablishingLinkLabel);

    for (I = 0; I < m_kMgr.m_kInterceptionEngagement.GetNumShips(); I++)
    {
        AS_SetHP(I, m_kMgr.m_kInterceptionEngagement.GetShip(I).GetHullStrength(), true);
        AS_SetHP(I, m_kMgr.m_kInterceptionEngagement.GetShip(I).m_iHP, true);
    }

    AS_SetAbortButtonText(m_strAbortMission);
    AS_SetEnemyEscapeTimerLabels(m_strEscapeTimerTitle, m_strTimeSufixSymbol);
    LWCE_SetConsumablesState(eAbilityState_Available);

    m_DataInitialized = true;
    enemyShipType = m_kMgr.m_kInterceptionEngagement.GetShip(0).GetType();

    if (!`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_UFOScanners'))
    {
        Invoke("HideUFODamage");
    }
    else if (!`LWCE_LABS.LWCE_IsResearched(UFOTypeToAnalysisTech(enemyShipType)))
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
        kEngagement.LWCE_UseConsumable('Item_DefenseMatrix', m_fPlaybackTimeElapsed);
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
        kEngagement.LWCE_UseConsumable('Item_UplinkTargeting', m_fPlaybackTimeElapsed);
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
        kEngagement.LWCE_UseConsumable('Item_UFOTracking', m_fPlaybackTimeElapsed);
        m_fTrackingTimer = m_kMgr.m_kInterceptionEngagement.GetTimeUntilOutrun(1) - m_fTotalBattleLength;

        if (m_kMgr.m_kInterceptionEngagement.m_fInterceptorTimeOffset != 0.0)
        {
            AS_MovementEvent(1, 1, 1.0);
        }

        PlaySound(m_kMgr.SNDLIB().SFX_Int_ConsumeTrack);
        AS_DisplayEffectEvent(eTrack, GetAbilityDescription(eTrack), true);
    }
}

/// <summary>
/// Maps the weapon fired in the exchange to an EProjectileType, which tells the Flash movie what image to show for the projectile.
/// </summary>
simulated function int GetWeaponType(CombatExchange kCombatExchange)
{
    local array<name> arrShipWeapons;
    local LWCEShipWeaponTemplate kShipWeaponTemplate;

    arrShipWeapons = LWCE_XGShip(m_kMgr.m_kInterceptionEngagement.GetShip(kCombatExchange.iSourceShip)).LWCE_GetWeapons();
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
    local bool bDeactivateAimEffect;
    local int I, iStreamIndex, iPlaybackIndex, iPlaybackLength;
    local TAttack kAttack;
    local TDamageData kDamageData;
    local XGShip kShip, kTargetShip;
    local CombatExchange kCombatExchange;
    local float fPlaybackTime, fTimeOffset;

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

        if (kMgr.LWCE_IsShortDistanceWeapon(LWCE_XGShip(kEngagement.GetShip(1)).GetWeaponAtIndex(0)))
        {
            m_kMgr.VOCloseDistance();
            AS_MovementEvent(0, 1, 1.0f);
        }
    }

    m_fPlaybackTimeElapsed += fDeltaT;
    UpdateEnemyEscapeTimer(fDeltaT);

    for (iStreamIndex = 0; iStreamIndex < 2; iStreamIndex++)
    {
        fPlaybackTime = m_fPlaybackTimeElapsed;
        fTimeOffset = 0.0;

        if (iStreamIndex == 0)
        {
            iPlaybackIndex = m_iInterceptorPlaybackIndex;
            iPlaybackLength = kEngagement.m_kCombat.m_aInterceptorExchanges.Length;
            fTimeOffset = kEngagement.m_fInterceptorTimeOffset;
        }
        else
        {
            iPlaybackIndex = m_iUFOPlaybackIndex;
            iPlaybackLength = kEngagement.m_kCombat.m_aUFOExchanges.Length;
        }

        fPlaybackTime += fTimeOffset;

        for (I = iPlaybackIndex; I < iPlaybackLength; I++)
        {
            if (iStreamIndex == 0)
            {
                kCombatExchange = kEngagement.m_kCombat.m_aInterceptorExchanges[I];
            }
            else
            {
                kCombatExchange = kEngagement.m_kCombat.m_aUFOExchanges[I];
            }

            if (kCombatExchange.fTime < fPlaybackTime)
            {
                if (iStreamIndex == 0)
                {
                    m_iInterceptorPlaybackIndex++;
                }
                else
                {
                    m_iUFOPlaybackIndex++;
                }

                m_iBulletIndex++;
                kAttack.iSourceShip = kCombatExchange.iSourceShip;
                kShip = kEngagement.GetShip(kAttack.iSourceShip);
                kTargetShip = kEngagement.GetShip(kAttack.iTargetShip);

                if (kShip.m_iHP <= 0 || kTargetShip.m_iHP <= 0)
                {
                }
                else
                {
                    if (m_bPendingDisengage && kAttack.iSourceShip != 0)
                    {
                    }
                    else
                    {
                        kAttack.iTargetShip = kCombatExchange.iTargetShip;
                        kAttack.iWeapon = GetWeaponType(kCombatExchange);
                        kAttack.iDamage = kCombatExchange.iDamage;
                        kAttack.fDuration = 0.30;
                        kAttack.bHit = kCombatExchange.bHit;
                        bDeactivateAimEffect = false;

                        if ((kEngagement.LWCE_GetNumConsumableInEffect('Item_UplinkTargeting') > 0) && kAttack.iTargetShip == 0)
                        {
                            if (kCombatExchange.iDamage > 0 && !kAttack.bHit)
                            {
                                kEngagement.LWCE_UseConsumableEffect('Item_UplinkTargeting');
                                kAttack.bHit = true;

                                if (kEngagement.LWCE_GetNumConsumableInEffect('Item_UplinkTargeting') == 0)
                                {
                                    bDeactivateAimEffect = true;
                                }
                            }
                        }

                        if (!kAttack.bHit)
                        {
                            kAttack.fDuration += 0.30;
                        }
                        else
                        {
                            kDamageData.iDamage = kAttack.iDamage;
                            kDamageData.iBulletID = m_iBulletIndex;
                            kDamageData.iShip = kAttack.iTargetShip;
                            kDamageData.fTime = (kCombatExchange.fTime + kAttack.fDuration) - fTimeOffset;
                            m_akDamageInformation.AddItem(kDamageData);
                        }

                        if (!kShip.IsAlienShip())
                        {
                            m_kMgr.VOInRange();
                        }

                        m_kMgr.SFXFire(kAttack.iWeapon);
                        AS_AttackEvent(kAttack.iSourceShip, kAttack.iTargetShip, kAttack.iWeapon, m_iBulletIndex, kAttack.iDamage, kAttack.fDuration, kAttack.bHit);

                        if (bDeactivateAimEffect)
                        {
                            AS_DisplayEffectEvent(eEnhancedAccuracy, GetAbilityDescription(eEnhancedAccuracy), false, m_iBulletIndex);
                        }
                    }
                }
            }
        }
    }

    for (I = m_iDamageDataIndex; I < m_akDamageInformation.Length; I++)
    {
        if (m_akDamageInformation[I].fTime < m_fPlaybackTimeElapsed)
        {
            m_iDamageDataIndex++;
            kShip = kEngagement.GetShip(m_akDamageInformation[I].iShip);

            if (kEngagement.LWCE_GetNumConsumableInEffect('Item_DefenseMatrix') > 0 && kShip.IsHumanShip())
            {
                kEngagement.LWCE_UseConsumableEffect('Item_DefenseMatrix');

                if (!kEngagement.LWCE_IsConsumableInEffect('Item_DefenseMatrix'))
                {
                    AS_DisplayEffectEvent(eDodgeHits, GetAbilityDescription(eDodgeHits), false);
                    AS_SetDodgeButton(m_strDodgeAbility, eAbilityState_Disabled);
                }
            }
            else
            {
                kShip.m_iHP -= m_akDamageInformation[I].iDamage;
                m_kMgr.SFXShipHit(kShip, m_akDamageInformation[I].iDamage);

                if (kShip.m_iHP <= 0)
                {
                    m_kMgr.SFXShipDestroyed(kShip);
                }

                AS_SetHP(m_akDamageInformation[I].iShip, kShip.m_iHP, false, m_akDamageInformation[I].iBulletID);
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

    m_bViewingResults = true;

    if (m_kMgr.m_kInterceptionEngagement.m_kInterception.m_eUFOResult == eUR_Disengaged)
    {
        AS_SetAbortLabel(m_strAbortedMission);
    }

    LWCE_SetConsumablesState(eAbilityState_Disabled);

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTag.StrValue0 = m_kMgr.m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[0].m_kTShip.strName;

    switch (m_kMgr.m_kInterceptionEngagement.m_kInterception.m_eUFOResult)
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

    for (I = 0; I < m_kMgr.m_kInterceptionEngagement.m_kInterception.m_arrInterceptors.Length; I++)
    {
        fHealthPercent = float(m_kMgr.m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[I].m_iHP) / float(m_kMgr.m_kInterceptionEngagement.m_kInterception.m_arrInterceptors[I].m_kTShip.iHP);

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