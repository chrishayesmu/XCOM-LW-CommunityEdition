class LWCE_XComSpecialMissionHandler_HQAssault extends XComSpecialMissionHandler_HQAssault
    dependson(LWCEContentManager);

struct CheckpointRecord_LWCE_XComSpecialMissionHandler_HQAssault extends CheckpointRecord_XComSpecialMissionHandler_HQAssault
{
    var array<LWCE_TTransferSoldier> m_arrCEReinforcements;
};

var array<LWCE_TTransferSoldier> m_arrCEReinforcements;

// TODO: need to finish adding LWCE_TTransferSoldier equivalent for reinforcements
// TODO: need to figure out what XGBattle subclass is used on HQ assaults

function XGUnit SpawnNextReinforcement(XComSpawnPoint DestinationSpawnPt, XComSpawnPoint OriginPoint, bool bLast)
{
    local XGUnit kUnit;
    local LWCE_TTransferSoldier kTransfer;

    if (m_arrCEReinforcements.Length > 0)
    {
        if (m_arrCEReinforcements.Length > 9)
        {
            kTransfer = m_arrCEReinforcements[Rand(m_arrCEReinforcements.Length - 6)];
        }
        else if (m_arrCEReinforcements.Length > 6)
        {
            if (m_arrCEReinforcements.Length == 9)
            {
                kTransfer = m_arrCEReinforcements[Rand(3)];
            }
            else
            {
                kTransfer = m_arrCEReinforcements[2 + Rand(m_arrCEReinforcements.Length - 2)];
            }
        }
        else
        {
            m_arrCEReinforcements[0].iCriticalWoundsTaken = 0;

            foreach AllActors(class'XGUnit', kUnit)
            {
                if (kUnit.GetCharacter().IsA('XGCharacter_Soldier') && !kUnit.IsDead())
                {
                    if (!XGCharacter_Soldier(kUnit.GetCharacter()).m_kSoldier.bBlueshirt)
                    {
                        ++ m_arrCEReinforcements[0].iCriticalWoundsTaken;
                    }
                }
            }

            if (m_arrCEReinforcements[0].iCriticalWoundsTaken < 6)
            {
                m_arrCEReinforcements[0].iCriticalWoundsTaken = 0;

                if (m_arrCEReinforcements.Length > 1)
                {
                    if (!m_arrCEReinforcements[1].kSoldier.bBlueshirt)
                    {
                        kTransfer = m_arrCEReinforcements[Rand(2)];
                    }
                    else
                    {
                        kTransfer = m_arrCEReinforcements[0];
                    }
                }
                else
                {
                    kTransfer = m_arrCEReinforcements[0];
                }
            }
            else
            {
                m_arrCEReinforcements[0].iCriticalWoundsTaken = 0;

                if (m_arrCEReinforcements.Length > 1)
                {
                    if (!m_arrCEReinforcements[1].kSoldier.bBlueshirt)
                    {
                        if (m_arrCEReinforcements.Length > 2)
                        {
                            kTransfer = m_arrCEReinforcements[2 + Rand(m_arrCEReinforcements.Length - 2)];
                        }
                        else
                        {
                            kTransfer = m_arrCEReinforcements[Rand(2)];
                        }
                    }
                    else
                    {
                        if (!m_arrCEReinforcements[0].kSoldier.bBlueshirt)
                        {
                            if (m_arrCEReinforcements.Length > 1)
                            {
                                kTransfer = m_arrCEReinforcements[1 + Rand(m_arrCEReinforcements.Length - 1)];
                            }
                            else
                            {
                                kTransfer = m_arrCEReinforcements[0];
                            }
                        }
                        else
                        {
                            kTransfer = m_arrCEReinforcements[Rand(m_arrCEReinforcements.Length)];
                        }
                    }
                }
                else
                {
                    kTransfer = m_arrCEReinforcements[0];
                }
            }
        }

        m_arrCEReinforcements.RemoveItem(kTransfer);
        kUnit = SpawnReinforcementUnit(OriginPoint, kTransfer, DestinationSpawnPt != none);

        if (DestinationSpawnPt != none)
        {
            AddPendingTraversal(kUnit, DestinationSpawnPt, OriginPoint.Location);
        }

        `PRES.m_kUnitFlagManager.AddFlag(kUnit);
        return kUnit;
    }

    return none;
}

function XGUnit SpawnReinforcementUnit(XComSpawnPoint SpawnPt, LWCE_TTransferSoldier kTransfer, bool bWillMove)
{
    local LWCE_XGCharacter_Soldier kChar;
    local XGUnit kUnit;
    local XGPlayer kPlayer;

    kChar = Spawn(class'LWCE_XGCharacter_Soldier');
    kChar.m_kCESoldier = kTransfer.kSoldier;
    kChar.m_kCEChar = kTransfer.kChar;

    kPlayer = XGBattle_SP(`BATTLE).GetHumanPlayer();
    kUnit = kPlayer.SpawnUnit(class'LWCE_XGUnit', kPlayer.m_kPlayerController, SpawnPt.Location, SpawnPt.Rotation, kChar, kPlayer.GetSquad(),, SpawnPt);
    kUnit.m_iUnitLoadoutID = kTransfer.iUnitLoadoutID;
    kUnit.AddStatModifiers(kTransfer.aStatModifiers);

    if (kTransfer.kChar.iCharacterType == eChar_Soldier)
    {
        LWCE_XComHumanPawn(kUnit.GetPawn()).LWCE_SetAppearance(kChar.m_kCESoldier.kAppearance);
    }

    class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kUnit);
    kUnit.UpdateItemCharges();

    if (bWillMove)
    {
        XComTacticalController(GetALocalPlayerController()).IncBloodlustMove();
    }

    return kUnit;
}
