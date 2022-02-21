class LWCE_XGAIPlayer_Animal extends XGAIPlayer_Animal;

static simulated function class<XGCharacter> Unused_AlienTypeToClass(EPawnType eAlienType)
{
    return class'LWCE_XGPlayer_Extensions'.static.AlienTypeToClass(eAlienType);
}

function XGUnit SpawnUnit(class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
{
    return class'LWCE_XGPlayer_Extensions'.static.SpawnUnit(self, kUnitClassToSpawn, kPlayerController, kLocation, kRotation, kCharacter, kSquad, bDestroyOnBadLocation, kSpawnPoint, bSnapToGround, bBattleScanner);
}