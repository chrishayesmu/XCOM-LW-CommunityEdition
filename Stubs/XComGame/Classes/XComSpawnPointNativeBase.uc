class XComSpawnPointNativeBase extends Actor
    native(Level)
    notplaceable
    hidecategories(Navigation)
	dependson(XGGameData);
//complete stub

// Export UXComSpawnPointNativeBase::execGetSpawnGroupIndex(FFrame&, void* const)
native static final simulated function int GetSpawnGroupIndex(int iMapPlayCount);

// Export UXComSpawnPointNativeBase::execFindSpawnGroup(FFrame&, void* const)
native static final simulated function FindSpawnGroup(ETeam Team, out array<XComSpawnPointNativeBase> SpawnPoints, optional out name SearchTag, optional int SpawnIndex);

simulated event EUnitType GetUnitType()
{
    return 7;
}

