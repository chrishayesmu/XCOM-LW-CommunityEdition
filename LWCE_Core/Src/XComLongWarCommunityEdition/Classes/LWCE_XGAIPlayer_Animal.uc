class LWCE_XGAIPlayer_Animal extends XGAIPlayer_Animal;

`include(generators.uci)

`LWCE_GENERATOR_XGPLAYER

simulated function CreateSquad(array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes)
{
    GetSquadLocation(m_kSquadStart.vCenter, m_kSquadStart.fRadius);
    m_kSquad = Spawn(class'LWCE_XGSquad',,,,,,, m_eTeam);
    m_kSquad.m_kPlayer = self;
    InitializeCivilians();
}

simulated function LoadInit()
{
    super.LoadInit();
}

simulated function bool OnUnitEndMove(XGUnit kUnit)
{
    local int I;
    local XGUnit kCivilian;
    local array<XGUnit> arrDeleteList;
    local bool bFoundUnit;
    local Vector vDest;

    vDest = kUnit.Location;
    vDest.Z = kUnit.GetWorldZ();

    if (kUnit.GetTeam() == eTeam_XCom)
    {
        UpdateBadCoverZone(vDest, kUnit.GetSquad().GetPermanentIndex(kUnit), kUnit.GetTeam());
    }
    else
    {
        UpdateBadCoverZone(vDest, kUnit.m_kBehavior.m_iAIIndex, kUnit.GetTeam());
    }

    if (kUnit.GetTeam() == eTeam_Neutral)
    {
        return false;
    }

    if (`BATTLE.m_kDesc.m_iMissionType == eMission_TerrorSite)
    {
        for (I = 0; I < kUnit.m_arrVisibleCivilians.Length; I++)
        {
            kCivilian = kUnit.m_arrVisibleCivilians[I];

            // Prevent visibility helpers from triggering "civilian rescued" messages
            if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kCivilian))
            {
                continue;
            }

            if (!kCivilian.IsAliveAndWell())
            {
                continue;
            }

            if (kCivilian.m_kBehavior.IsA('XGAIBehavior_Civilian') && XGAIBehavior_Civilian(kCivilian.m_kBehavior).m_eTerrorStatus == eTS_Saved)
            {
                continue;
            }

            if (kCivilian.IsCloseRange(kUnit.GetLocation()))
            {
                bFoundUnit = true;
                kCivilian.GetPathingPawn().SetActive(kCivilian);

                if (kUnit.isHuman())
                {
                    kUnit.UnitSpeak(eCharSpeech_CivilianRescued);
                }

                if (kUnit.isHuman() || kUnit.IsATank())
                {
                    PRES().GetWorldMessenger().Message(m_strCivilianSaved, kCivilian.GetLocation(), eColor_Good,,, kUnit.m_eTeamVisibilityFlags);
                    XGAIBehavior_Civilian(kCivilian.m_kBehavior).RunToDropship();
                }
            }
        }
    }

    for (I = 0; I < m_arrSurvivor.Length; I++)
    {
        kCivilian = m_arrSurvivor[I];

        if (kCivilian.IsCloseRange(kUnit.GetLocation()))
        {
            arrDeleteList.AddItem(kCivilian);
            `BATTLE.SwapTeams(kCivilian);
            kUnit.UnitSpeak(eCharSpeech_CivilianRescued);
            PRES().GetWorldMessenger().Message(m_strSurvivorRescued, kCivilian.GetLocation(), eColor_Good,,, kUnit.m_eTeamVisibilityFlags);
            bFoundUnit = true;
        }
    }

    while (arrDeleteList.Length > 0)
    {
        m_arrSurvivor.RemoveItem(arrDeleteList[0]);
        arrDeleteList.Remove(0, 1);
    }

    return bFoundUnit;
}

simulated function UpdateActiveUnits(optional bool bCheckAllActive = false)
{
    local XGUnit kUnit, kEnemy;
    local XGAIPlayer kAIPlayer;
    local XGSquad kAISquad;

    kAIPlayer = XGAIPlayer(XGBattle_SP(`BATTLE).GetAIPlayer());
    kAISquad = kAIPlayer.GetSquad();

    if (bCheckAllActive)
    {
        kEnemy = kAISquad.GetNextGoodMember();

        while (kEnemy != none)
        {
            if (kAIPlayer.UnitIsReady(kEnemy))
            {
                foreach kEnemy.m_arrVisibleCivilians(kUnit)
                {
                    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit))
                    {
                        continue;
                    }

                    if (XGAIBehavior_Civilian(kUnit.m_kBehavior).m_eTerrorStatus == eTS_InDanger && m_arrActiveEngaged.Find(kUnit) == INDEX_NONE && m_arrInactive.Find(kUnit) == INDEX_NONE)
                    {
                        AddActiveUnit(kUnit, false);
                    }
                }
            }

            kEnemy = kAISquad.GetNextGoodMember(kEnemy, true, false);
        }
    }

    while (m_arrActiveEngaged.Length > 5)
    {
        kUnit = m_arrActiveEngaged[m_arrActiveEngaged.Length - 1];
        m_arrActiveEngaged.Remove(m_arrActiveEngaged.Length - 1, 1);
        kUnit.m_kBehavior.m_bCanEngage = false;

        if (m_arrInactive.Find(kUnit) == INDEX_NONE)
        {
            m_arrInactive.AddItem(kUnit);
        }
    }

    while (m_arrInactive.Length > 0 && m_arrActiveEngaged.Length < 5)
    {
        kUnit = m_arrInactive[0];
        m_arrInactive.RemoveItem(kUnit);
        m_arrActiveEngaged.AddItem(kUnit);
        kUnit.m_kBehavior.m_bCanEngage = true;
    }
}