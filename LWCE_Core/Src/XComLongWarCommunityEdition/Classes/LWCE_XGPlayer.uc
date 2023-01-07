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
    `LWCE_LOG_DEPRECATED_CLS(LoadSquad);
}

function LWCE_LoadSquad(array<TTransferSoldier> Soldiers, array<LWCE_TTransferSoldier> ceSoldiers, array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes)
{
    local LWCE_XGCharacter_Soldier kChar;
    local LWCE_XGUnit kUnit;
    local int iNumSoldiersToSpawn, I;
    local XComSpawnPoint kSpawn;

    `LWCE_LOG_CLS("LoadSquad begin");

    iNumSoldiersToSpawn = Soldiers.Length;
    m_kSquad = Spawn(class'LWCE_XGSquad',,,,,,, m_eTeam);
    m_kSquad.m_kPlayer = self;

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
        kChar = Spawn(class'LWCE_XGCharacter_Soldier');
        kChar.m_kCESoldier = ceSoldiers[I].kSoldier;
        kChar.m_kCEChar = ceSoldiers[I].kChar;

        if (I >= 6)
        {
            kSpawn.Location = kSpawn.Location + (vector(kSpawn.Rotation) * -96.0);
        }

        kUnit = LWCE_SpawnUnit(m_kPlayerController, kSpawn.Location, kSpawn.Rotation, kChar, ceSoldiers[I].kChar, ceSoldiers[I].kSoldier, m_kSquad,, kSpawn);
        kUnit.m_iUnitLoadoutID = Soldiers[I].iUnitLoadoutID;
        kUnit.AddStatModifiers(ceSoldiers[I].aStatModifiers);

        `LWCE_LOG_CLS("Spawned soldier " $ I $ " in squad");

        if (kUnit != none)
        {
            if (kUnit.LWCE_GetCharacter().GetCharacterType() == eChar_Soldier)
            {
                LWCE_XComHumanPawn(kUnit.GetPawn()).LWCE_SetAppearance(kUnit.m_kCESoldier.kAppearance);
            }

            class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kUnit);
            kUnit.UpdateUnitBuffs();
            kUnit.UpdateItemCharges();
        }
    }

    `LWCE_LOG_CLS("LoadSquad end");
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

function LWCE_XGUnit LWCE_SpawnUnit(PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, LWCE_TCharacter kCEChar, LWCE_TSoldier kCESoldier, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
{
    local LWCE_XGUnit kUnit;

    kUnit = Spawn(class'LWCE_XGUnit', kPlayerController,, kLocation, kRotation,,, m_eTeam);
    kUnit.SetBattleScanner(bBattleScanner);
    kUnit.LWCE_GetCharacter().SetCharacter(kCEChar);
    kUnit.m_kCESoldier = kCESoldier;

    if (!kUnit.Init(self, kCharacter, kSquad, bDestroyOnBadLocation, bSnapToGround))
    {
        kUnit.Destroy();
        return none;
    }

    if (kSpawnPoint != none)
    {
        kSpawnPoint.m_kLastActorSpawned = kUnit;
    }

    if (kCharacter != none)
    {
        kCharacter.m_kUnit = kUnit;
    }

    return kUnit;
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