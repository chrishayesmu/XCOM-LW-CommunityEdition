class Highlander_XGBattle_SPCovertOpsExtraction extends Highlander_XGBattle_SP
    config(GameData);

struct CheckpointRecord_XGBattle_SPCovertOpsExtraction extends CheckpointRecord_XGBattle_SP
{
    var XGUnit m_kCovertOperative;
};

var const config int m_iCovertOpsCashRewardAmount;
var XGUnit m_kCovertOperative;

function XGUnit GetCovertOperative()
{
    return m_kCovertOperative;
}

function CollectLoot()
{
    super(XGBattle).CollectLoot();
    m_kDesc.m_kDropShipCargoInfo.m_kReward.iCredits += m_iCovertOpsCashRewardAmount;

    if (ShouldAwardIntel())
    {
        m_kDesc.m_arrArtifacts[181] = 1;
    }
}

function bool ShouldAwardIntel()
{
    if (m_iResult != 1)
    {
        return false;
    }

    return !m_kCovertOperative.IsDead() || m_kCovertOperative.m_bInDropShip;
}

function bool DoesCovertOperativeHaveToSurvive()
{
    return m_kCovertOperative != none;
}

final function XComSpawnPoint ChooseCovertOperativeSpawnPoint()
{
    local array<XComSpawnPoint> arrSpawnPoints;
    local XComSpawnPoint kSpawnPoint;

    foreach AllActors(class'XComSpawnPoint', kSpawnPoint)
    {
        if (kSpawnPoint.GetUnitType() == UNIT_TYPE_CovertOperative)
        {
            arrSpawnPoints.AddItem(kSpawnPoint);
        }
    }

    if (arrSpawnPoints.Length == 0)
    {
        return none;
    }
    else
    {
        return arrSpawnPoints[Rand(arrSpawnPoints.Length)];
    }
}

final function TTransferSoldier CreateDebugCovertOperative(XGUnit kTemplate)
{
    local TTransferSoldier kTransferSoldier;

    kTransferSoldier.kChar.iType = 2;
    kTransferSoldier.kChar = XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kGameCore.GetTCharacter(2);
    kTransferSoldier.kChar.kInventory.iPistol = 2;
    kTransferSoldier.kSoldier.strFirstName = "Debug";
    kTransferSoldier.kSoldier.strNickName = "The Tester";
    kTransferSoldier.kSoldier.strLastName = "McGee";
    kTransferSoldier.kSoldier.kAppearance = XComHumanPawn(kTemplate.GetPawn()).m_kAppearance;
    kTransferSoldier.kChar.aUpgrades[151] = 1;
    return kTransferSoldier;
}

final function ForceCovertOperativeLoadout(out TTransferSoldier kTransferSoldier)
{
    class'XGTacticalGameCoreNativeBase'.static.TInventoryLargeItemsClear(kTransferSoldier.kChar.kInventory);
    kTransferSoldier.kChar.kInventory.iArmor = eItem_ArmorCovertOps;
}

function SpawnCovertOperative()
{
    local XGPlayer kPlayer;
    local XComSpawnPoint kSpawnPoint;
    local TTransferSoldier kTransferSoldier;
    local XGCharacter_Soldier kChar;
    local XGUnit kSoldier;
    local bool bGeneMod;

    kSpawnPoint = ChooseCovertOperativeSpawnPoint();

    if (kSpawnPoint == none)
    {
        return;
    }

    kPlayer = GetHumanPlayer();
    if (kPlayer == none)
    {
        return;
    }

    if (m_kTransferSave != none)
    {
        kTransferSoldier = m_kTransferSave.m_kBattleDesc.m_kDropShipCargoInfo.m_kCovertOperative;
    }
    else
    {
        kTransferSoldier = CreateDebugCovertOperative(kPlayer.GetSquad().GetMemberAt(0));
    }

    ForceCovertOperativeLoadout(kTransferSoldier);
    kChar = Spawn(class'XGCharacter_Soldier');
    kChar.SetTSoldier(kTransferSoldier.kSoldier);
    kChar.SetTCharacter(kTransferSoldier.kChar);
    bGeneMod = class'XComPerkManager'.static.HasAnyGeneMod(kTransferSoldier.kChar.aUpgrades);
    kChar.m_eType = EPawnType(class'XGBattleDesc'.static.MapSoldierToPawn(kTransferSoldier.kChar.kInventory.iArmor, kTransferSoldier.kSoldier.kAppearance.iGender, bGeneMod));
    kSoldier = kPlayer.SpawnUnit(class'XGUnit', kPlayer.m_kPlayerController, kSpawnPoint.Location, kSpawnPoint.Rotation, kChar, kPlayer.GetSquad(),, kSpawnPoint);
    kSoldier.m_iUnitLoadoutID = kTransferSoldier.iUnitLoadoutID;
    kSoldier.AddStatModifiers(kTransferSoldier.aStatModifiers);

    if (kSoldier != none)
    {
        XComHumanPawn(kSoldier.GetPawn()).SetAppearance(kChar.m_kSoldier.kAppearance);
        class'XGLoadoutMgr'.static.ApplyInventory(kSoldier);
        kSoldier.UpdateItemCharges();
    }

    m_kCovertOperative = kSoldier;
}

function InitPlayers(optional bool bLoading)
{
    bLoading = false;
    super.InitPlayers(bLoading);

    if (!bLoading)
    {
        SpawnCovertOperative();
    }
}

final simulated function InitRadarArrays()
{
    local array<XComRadarArrayActor> arrRadars;
    local XComRadarArrayActor kRadar;
    local array<XComLevelActor> arrFogPods;
    local XComLevelActor kLevelActor;

    // Covert Extraction: only 2 radars are active
    if (Desc().m_iMissionType == eMission_CovertOpsExtraction)
    {
        foreach AllActors(class'XComRadarArrayActor', kRadar)
        {
            arrRadars.AddItem(kRadar);
        }

        if (arrRadars.Length >= 2)
        {
            kRadar = arrRadars[Rand(arrRadars.Length)];
            kRadar.ActivateRadar(true);
            arrRadars.RemoveItem(kRadar);

            kRadar = arrRadars[Rand(arrRadars.Length)];
            kRadar.ActivateRadar(true);
        }
    }
    else
    {
        // Covert Data Recovery: all radars are active
        foreach AllActors(class'XComRadarArrayActor', kRadar)
        {
            kRadar.ActivateRadar(false);
        }
    }

    foreach AllActors(class'XComLevelActor', kLevelActor)
    {
        if (kLevelActor.Tag == 'FogPod')
        {
            arrFogPods.AddItem(kLevelActor);
        }
    }

    foreach arrFogPods(kLevelActor)
    {
        kLevelActor.Destroy();
    }
}

function PutSoldiersOnDropship()
{
    local TTransferSoldier kTransferSoldier;

    super.PutSoldiersOnDropship();
    kTransferSoldier = BuildReturningDropshipSoldier(m_kCovertOperative, false);
    Desc().m_kDropShipCargoInfo.m_kCovertOperative = kTransferSoldier;
    Desc().m_kDropShipCargoInfo.m_bHasCovertOperative = true;
}

simulated state Running
{
    event BeginState(name PrevState)
    {
        super.BeginState(PrevState);

        if (!m_bLoadingSave)
        {
            InitRadarArrays();
        }
    }

    stop;
}

state AbortMissionCheck
{
    function bool ShouldShowAbortDialog()
    {
        if (m_kActivePlayer.m_kSquad.GetNumInsideDropship() == 1 && m_kCovertOperative.m_bInDropShip)
        {
            return m_kActivePlayer.m_kSquad.GetNumAliveAndWell() == 1;
        }
        else
        {
            return super.ShouldShowAbortDialog();
        }
    }

    stop;
}