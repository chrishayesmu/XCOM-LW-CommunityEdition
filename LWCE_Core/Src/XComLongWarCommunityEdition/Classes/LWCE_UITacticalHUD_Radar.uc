class LWCE_UITacticalHUD_Radar extends UITacticalHUD_Radar;

simulated function Show()
{
    local LWCE_XGUnit kActiveUnit;
    local TInventory kInventory;

    if (`BATTLE.m_kDesc.m_bIsTutorial)
    {
        return;
    }

    m_kActiveUnit = XComTacticalController(controllerRef).GetActiveUnit();
    kActiveUnit = LWCE_XGUnit(m_kActiveUnit);

    if (kActiveUnit == none)
    {
        Hide();
        return;
    }

    kInventory = kActiveUnit.GetTInventory();

    if (kActiveUnit.HasPerk(`LW_PERK_ID(BioelectricSkin)))
    {
        super(UI_FxsPanel).Show();
        ActivateRadarTracking();
    }
    else if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInventory, 255))
    {
        super(UI_FxsPanel).Show();
        ActivateRadarTracking();
    }
    else if ((kActiveUnit.m_iZombieMoraleLoss & -2147483648) != 0)
    {
        super(UI_FxsPanel).Show();
        ActivateRadarTracking();
    }
}

simulated function UpdateActiveUnit()
{
    local LWCE_XGUnit kActiveUnit;
    local TInventory kInventory;

    if (!IsInited())
    {
        return;
    }

    m_kActiveUnit = XComTacticalController(controllerRef).GetActiveUnit();
    kActiveUnit = LWCE_XGUnit(m_kActiveUnit);

    if (kActiveUnit == none)
    {
        Hide();
        return;
    }

    kInventory = kActiveUnit.GetTInventory();

    if (kActiveUnit.HasPerk(`LW_PERK_ID(BioelectricSkin)))
    {
        Show();
    }
    else if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kInventory, 255))
    {
        Show();
    }
    else if ((kActiveUnit.m_iZombieMoraleLoss & -2147483648) != 0)
    {
        Show();
    }
    else
    {
        // Don't know why both are called here
        Show();
        Hide();
        return;
    }

    m_arrBlips.Remove(0, m_arrBlips.Length);
    UpdateBlips();
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kActiveUnit, 'm_bInCover', self, UpdateBlips);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kActiveUnit, 'Location', self, UpdateBlips);

    if (m_hEnemyArrWatchHandle != 0)
    {
        WorldInfo.MyWatchVariableMgr.UnRegisterWatchVariable(m_hEnemyArrWatchHandle);
    }

    m_hEnemyArrWatchHandle = WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kActiveUnit, 'm_arrVisibleEnemies', self, UpdateBlips);
}

simulated function UpdateBlips()
{
    local int I;
    local XComMeldContainerActor Index;
    local string Data;
    local XGUnit tmpUnit, ActiveUnit;
    local XComInteractiveLevelActor ILA;
    local float MaxDistance;

    ActiveUnit = XGUnit(m_kActiveUnit);
    if ((ActiveUnit == none) || XComTacticalController(controllerRef) == none)
    {
        return;
    }
    m_iCurrUnitsSightRadius = class'XGTacticalGameCore'.default.BASE_REMOVAL_DAYS * 64;
    for (I = 0; I < m_arrBlips.Length; ++I)
    {
        m_arrBlips[I].Type = eUIRadarBlipTypes.eBlipType_None;
    }
    for (I = 0; I < ActiveUnit.GetSquad().GetNumMembers(); ++I)
    {
        tmpUnit = ActiveUnit.GetSquad().GetMemberAt(I);
        if (tmpUnit != none && tmpUnit != ActiveUnit)
        {
            if (tmpUnit.IsDead())
            {
                UpdateBlipByType(tmpUnit, eUIRadarBlipTypes.eBlipType_FriendlyDead);
            }
            else if (tmpUnit.IsHurt())
            {
                UpdateBlipByType(tmpUnit, eUIRadarBlipTypes.eBlipType_FriendlyHurt);
            }
            else if (tmpUnit.IsBattleScanner())
            {
                UpdateBlipByType(tmpUnit, eUIRadarBlipTypes.eBlipType_InactiveNode);
            }
            else
            {
                UpdateBlipByType(tmpUnit, eUIRadarBlipTypes.eBlipType_Friendly);
            }
        }
    }
    if (XComPresentationLayer(controllerRef.m_Pres).m_kSpecialMissionHUD != none)
    {
        foreach AllActors(class'XComInteractiveLevelActor', ILA)
        {
            if (ILA.IconSocket == XGBUTTON_Icon)
            {
                if (ILA.CanInteract(none, 'None'))
                {
                    UpdateBlipByType(ILA, eUIRadarBlipTypes.eBlipType_ActiveNode);
                }
                else {
                    UpdateBlipByType(ILA, eUIRadarBlipTypes.eBlipType_InactiveNode);
                }
            }
        }
    }

    if ( (ActiveUnit.m_iZombieMoraleLoss & -2147483648) == 0)
    {
        AS_UpdateBlips("");
        return;
    }

    MaxDistance = float((class'XGTacticalGameCore'.default.BASE_REMOVAL_DAYS * class'XGTacticalGameCore'.default.BASE_REMOVAL_DAYS) * 4096);
    foreach AllActors(class'XGUnit', tmpUnit)
    {
        // LWCE change: Ignore line of sight helper units
        if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(tmpUnit))
        {
            continue;
        }
        else if (VSizeSq2D(tmpUnit.GetLocation() - ActiveUnit.GetLocation()) <= MaxDistance)
        {
            if (tmpUnit.IsAlien_CheckByCharType() && tmpUnit.IsAliveAndWell())
            {
                if ((XComSeeker(tmpUnit.GetPawn()) == none) || !XComSeeker(tmpUnit.GetPawn()).m_bStealthFXOn)
                {
                    if (!tmpUnit.IsBattleScanner())
                    {
                        if (tmpUnit.GetTeam() == eTeam_Alien)
                        {
                            UpdateBlipByType(tmpUnit, eUIRadarBlipTypes.eBlipType_Opponent);
                        }
                    }
                }
            } else if (tmpUnit.IsCivilian())
            {
                UpdateBlipByType(tmpUnit, eUIRadarBlipTypes.eBlipType_Civilian);
            }
        }
    }
    foreach AllActors(class'XComMeldContainerActor', Index)
    {
        if (!Index.IsCollected() && VSizeSq2D(Index.Location - ActiveUnit.GetLocation()) <= MaxDistance)
        {
            UpdateBlipByType(Index, eUIRadarBlipTypes.eBlipType_Item);
        }
    }
    Data = "";
    for (I = 0; I < m_arrBlips.Length; ++I)
    {
        // LWCE change: This has to use string(int(Type)) instead of string(Type) because the flash code expects "4" and not "eBlipType_Opponent"
        // I thought the stub might be wrong but If I change the TURadarBlip member to `int` then the game crashes.
        Data $= string(int(m_arrBlips[I].Type)) $ "," $ string(m_arrBlips[I].Loc.X) $ "," $ string(m_arrBlips[I].Loc.Y);
        if (I < (m_arrBlips.Length - 1))
        {
            Data $= "//";
        }
    }
    if (m_arrBlips.Length == 0)
    {
        Data $= "0,0,0";
    }
    AS_UpdateBlips(Data);
}
