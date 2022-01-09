class Highlander_XGPlayer extends XGPlayer;

function Init(optional bool bLoading = false)
{
    `HL_LOG_CLS("Override successful");

    super.Init(bLoading);
}

function LoadInit()
{
    super.LoadInit();

    // PostLoadGame needs to wait briefly before running so everything is initialized
    SetTimer(0.10, false, 'PostLoadGame');
}

protected function PostLoadGame()
{
    local array<XGUnitNativeBase> EnemiesInSquadSight;
    local XGPlayer kHumanPlayer;
    local XGSquad Squad;
    local XGUnitNativeBase FriendlyUnit, EnemyUnit;

    // Highlander issue #10: when loading a game, the combat music doesn't restart if there are enemies in sight
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

// IMPORTANT: This function is an override of a function in XGPlayer. Since we can't modify the inheritance hierarchy,
// this function has been inserted into each Highlander child class override of XGPlayer.
// ***If you modify this function, apply the changes in all child classes as well!***
function XGUnit SpawnUnit(class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
{
    local XGUnit kUnit;

    if (kUnitClassToSpawn == class'XGUnit')
    {
        kUnitClassToSpawn = class'Highlander_XGUnit';
    }

    kUnit = Spawn(kUnitClassToSpawn, kPlayerController,, kLocation, kRotation,,, m_eTeam);
    kUnit.SetBattleScanner(bBattleScanner);

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