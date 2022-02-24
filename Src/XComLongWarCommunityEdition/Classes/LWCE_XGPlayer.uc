class LWCE_XGPlayer extends XGPlayer;

`include(generators.uci)

`LWCE_GENERATOR_XGPLAYER

function Init(optional bool bLoading = false)
{
    `LWCE_LOG_CLS("Override successful");

    super.Init(bLoading);
}

function LoadInit()
{
    super.LoadInit();

    // PostLoadGame needs to wait briefly before running so everything is initialized
    SetTimer(0.10, false, 'PostLoadGame');
}

function LoadSquad(array<TTransferSoldier> Soldiers, array<int> arrTechHistory, array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes)
{
    local XGCharacter kChar;
    local XGUnit kSoldier;
    local int iNumSoldiersToSpawn, I;
    local XComSpawnPoint kSpawn;

    iNumSoldiersToSpawn = Soldiers.Length;
    m_kSquad = Spawn(class'XGSquad',,,,,,, m_eTeam);
    m_kSquad.m_kPlayer = self;
    m_arrTechHistory = arrTechHistory;

    // Some sort of fixes for specific maps/missions
    if (`BATTLE.m_kDesc.m_iMissionType != eMission_Special)
    {
        if (InStr(class'XComMapManager'.static.GetCurrentMapMetaData().DisplayName, "TempleShip") >= 0)
        {
            arrSpawnPoints.AddItem(arrSpawnPoints[3]);
            arrSpawnPoints.AddItem(arrSpawnPoints[1]);
            arrSpawnPoints.AddItem(arrSpawnPoints[0]);
            arrSpawnPoints.AddItem(arrSpawnPoints[4]);
            arrSpawnPoints.AddItem(arrSpawnPoints[2]);
            arrSpawnPoints.AddItem(arrSpawnPoints[5]);
            arrSpawnPoints.Remove(0, 6);
        }
        else
        {
            arrSpawnPoints.AddItem(arrSpawnPoints[0]);
            arrSpawnPoints.Remove(0, 1);
        }
    }
    else
    {
        I = `BATTLE.m_kDesc.m_eCouncilType;

        if (I == eFCM_Progeny_Portent)
        {
            arrSpawnPoints.AddItem(arrSpawnPoints[3]);
            arrSpawnPoints.AddItem(arrSpawnPoints[1]);
            arrSpawnPoints.AddItem(arrSpawnPoints[0]);
            arrSpawnPoints.AddItem(arrSpawnPoints[4]);
            arrSpawnPoints.AddItem(arrSpawnPoints[2]);
            arrSpawnPoints.AddItem(arrSpawnPoints[5]);
            arrSpawnPoints.Remove(0, 6);
        }
        else if (InStr(class'XComMapManager'.static.GetCurrentMapMetaData().DisplayName, "_Bomb") < 0)
        {
            arrSpawnPoints.AddItem(arrSpawnPoints[0]);
            arrSpawnPoints.Remove(0, 1);
        }
    }

    for (I = 0; I < iNumSoldiersToSpawn; I++)
    {
        kSpawn = arrSpawnPoints[I % 6];
        kChar = Spawn(class'XGCharacter_Soldier');
        XGCharacter_Soldier(kChar).SetTSoldier(Soldiers[I].kSoldier);
        kChar.SetTCharacter(Soldiers[I].kChar);
        kChar.m_eType = arrPawnTypes[I];

        if (I < 6)
        {
            kSoldier = SpawnUnit(class'XGUnit', m_kPlayerController, kSpawn.Location, kSpawn.Rotation, kChar, m_kSquad,, kSpawn);
        }
        else
        {
            kSpawn.Location = kSpawn.Location + (vector(kSpawn.Rotation) * -96.0);
            kSoldier = SpawnUnit(class'XGUnit', m_kPlayerController, kSpawn.Location, kSpawn.Rotation, kChar, m_kSquad,, kSpawn);
        }

        kSoldier.m_iUnitLoadoutID = Soldiers[I].iUnitLoadoutID;
        kSoldier.AddStatModifiers(Soldiers[I].aStatModifiers);

        if (kSoldier != none)
        {
            if (kChar.m_kChar.iType == eChar_Soldier)
            {
                XComHumanPawn(kSoldier.GetPawn()).SetAppearance(XGCharacter_Soldier(kChar).m_kSoldier.kAppearance);
            }

            class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kSoldier);
            kSoldier.UpdateUnitBuffs();
            kSoldier.UpdateItemCharges();
        }
    }
}

protected function PostLoadGame()
{
    local array<XGUnitNativeBase> EnemiesInSquadSight;
    local XGPlayer kHumanPlayer;
    local XGSquad Squad;
    local XGUnitNativeBase FriendlyUnit, EnemyUnit;

    // LWCE issue #10: when loading a game, the combat music doesn't restart if there are enemies in sight
    kHumanPlayer = XGBattle_SP(`BATTLE).GetHumanPlayer();
    Squad = kHumanPlayer.GetSquad();
    FriendlyUnit = Squad.GetNextGoodMember();

    if (FriendlyUnit == none)
    {
        return;
    }

    XGUnit(FriendlyUnit).DetermineEnemiesInSquadSight(EnemiesInSquadSight, FriendlyUnit.Location, false, false);

    foreach EnemiesInSquadSight(EnemyUnit)
    {
        if (!XGUnit(EnemyUnit).IsDeadOrDying())
        {
            XComTacticalSoundManager(XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetSoundManager()).PlayCombatMusic();
            break;
        }
    }
}

simulated event bool FromNativeCheckForEndTurn(XGUnitNativeBase kUnit)
{
    return super.FromNativeCheckForEndTurn(kUnit);
}

event XGSquadNativeBase GetNativeSquad()
{
    return super.GetNativeSquad();
}

event XGSquadNativeBase GetEnemySquad()
{
    return super.GetEnemySquad();
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
}

simulated state Active
{
    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
    }

    simulated event ContinuedState()
    {
        super.ContinuedState();
    }
}

simulated state BeginningTurn
{
    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
    }

    simulated event PushedState()
    {
        super.PushedState();
    }
}

simulated state EndingTurn
{
    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
    }

    simulated event PushedState()
    {
        super.PushedState();
    }
}

auto simulated state Inactive
{
    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
    }

    simulated event Tick(float fDeltaT)
    {
        super.Tick(fDeltaT);
    }
}

simulated state Panicking
{
    simulated event PushedState()
    {
        super.PushedState();
    }
}

state ServerWaitingForClientsToEndTurn
{
    event Tick(float fDeltaTime)
    {
        super.Tick(fDeltaTime);
    }
}

static simulated function class<XGCharacter> Unused_AlienTypeToClass(EPawnType eAlienType)
{
    return class'LWCE_XGPlayer_Extensions'.static.AlienTypeToClass(eAlienType);
}

//function XGUnit SpawnUnit(class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
//{
//    return class'LWCE_XGPlayer_Extensions'.static.SpawnUnit(self, kUnitClassToSpawn, kPlayerController, kLocation, kRotation, kCharacter, kSquad, bDestroyOnBadLocation, kSpawnPoint, bSnapToGround, bBattleScanner);
//}