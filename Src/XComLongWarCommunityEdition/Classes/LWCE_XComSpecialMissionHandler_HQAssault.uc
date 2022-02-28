class LWCE_XComSpecialMissionHandler_HQAssault extends XComSpecialMissionHandler_HQAssault;

function XGUnit SpawnNextReinforcement(XComSpawnPoint DestinationSpawnPt, XComSpawnPoint OriginPoint, bool bLast)
{
    local XGUnit kUnit;
    local TTransferSoldier kTransfer;
    local TSoldierPawnContent kContent;

    if (m_arrReinforcements.Length > 0)
    {
        if (m_arrReinforcements.Length > 9)
        {
            kTransfer = m_arrReinforcements[Rand(m_arrReinforcements.Length - 6)];
        }
        else if (m_arrReinforcements.Length > 6)
        {
            if (m_arrReinforcements.Length == 9)
            {
                kTransfer = m_arrReinforcements[Rand(3)];
            }
            else
            {
                kTransfer = m_arrReinforcements[2 + Rand(m_arrReinforcements.Length - 2)];
            }
        }
        else
        {
            m_arrReinforcements[0].iCriticalWoundsTaken = 0;

            foreach AllActors(class'XGUnit', kUnit)
            {
                if (kUnit.GetCharacter().IsA('XGCharacter_Soldier') && !kUnit.IsDead())
                {
                    if (!XGCharacter_Soldier(kUnit.GetCharacter()).m_kSoldier.bBlueshirt)
                    {
                        ++ m_arrReinforcements[0].iCriticalWoundsTaken;
                    }
                }
            }

            if (m_arrReinforcements[0].iCriticalWoundsTaken < 6)
            {
                m_arrReinforcements[0].iCriticalWoundsTaken = 0;

                if (m_arrReinforcements.Length > 1)
                {
                    if (!m_arrReinforcements[1].kSoldier.bBlueshirt)
                    {
                        kTransfer = m_arrReinforcements[Rand(2)];
                    }
                    else
                    {
                        kTransfer = m_arrReinforcements[0];
                    }
                }
                else
                {
                    kTransfer = m_arrReinforcements[0];
                }
            }
            else
            {
                m_arrReinforcements[0].iCriticalWoundsTaken = 0;

                if (m_arrReinforcements.Length > 1)
                {
                    if (!m_arrReinforcements[1].kSoldier.bBlueshirt)
                    {
                        if (m_arrReinforcements.Length > 2)
                        {
                            kTransfer = m_arrReinforcements[2 + Rand(m_arrReinforcements.Length - 2)];
                        }
                        else
                        {
                            kTransfer = m_arrReinforcements[Rand(2)];
                        }
                    }
                    else
                    {
                        if (!m_arrReinforcements[0].kSoldier.bBlueshirt)
                        {
                            if (m_arrReinforcements.Length > 1)
                            {
                                kTransfer = m_arrReinforcements[1 + Rand(m_arrReinforcements.Length - 1)];
                            }
                            else
                            {
                                kTransfer = m_arrReinforcements[0];
                            }
                        }
                        else
                        {
                            kTransfer = m_arrReinforcements[Rand(m_arrReinforcements.Length)];
                        }
                    }
                }
                else
                {
                    kTransfer = m_arrReinforcements[0];
                }
            }
        }

        m_arrReinforcements.RemoveItem(kTransfer);
        kContent = `BATTLE.m_kDesc.BuildSoldierContent(kTransfer);
        kUnit = SpawnReinforcementUnit(OriginPoint, kTransfer, EPawnType(kContent.iPawn), DestinationSpawnPt != none);

        if (DestinationSpawnPt != none)
        {
            AddPendingTraversal(kUnit, DestinationSpawnPt, OriginPoint.Location);
        }

        `PRES.m_kUnitFlagManager.AddFlag(kUnit);
        return kUnit;
    }

    return none;
}

function XGUnit SpawnReinforcementUnit(XComSpawnPoint SpawnPt, TTransferSoldier kTransfer, EPawnType ePawn, bool bWillMove)
{
    local XGCharacter_Soldier kChar;
    local XGUnit kUnit;
    local XGPlayer kPlayer;

    kChar = Spawn(class'XGCharacter_Soldier');
    kChar.SetTSoldier(kTransfer.kSoldier);
    kChar.SetTCharacter(kTransfer.kChar);
    kChar.m_eType = ePawn;

    kPlayer = XGBattle_SP(`BATTLE).GetHumanPlayer();
    kUnit = kPlayer.SpawnUnit(class'XGUnit', kPlayer.m_kPlayerController, SpawnPt.Location, SpawnPt.Rotation, kChar, kPlayer.GetSquad(),, SpawnPt);
    kUnit.m_iUnitLoadoutID = kTransfer.iUnitLoadoutID;
    kUnit.AddStatModifiers(kTransfer.aStatModifiers);

    if (kTransfer.kChar.iType == eChar_Soldier)
    {
        XComHumanPawn(kUnit.GetPawn()).SetAppearance(kChar.m_kSoldier.kAppearance);
    }

    class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kUnit);
    kUnit.UpdateItemCharges();

    if (bWillMove)
    {
        XComTacticalController(GetALocalPlayerController()).IncBloodlustMove();
    }

    return kUnit;
}