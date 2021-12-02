class Highlander_XGAIPlayer_Animal extends XGAIPlayer_Animal;

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