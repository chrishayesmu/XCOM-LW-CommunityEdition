class SpawnAlienQueue extends Actor
    notplaceable
    hidecategories(Navigation);

var private array<XComSpawnPoint_Alien> m_arrSpawnPoints;
var private array<XGAISpawnMethod> m_arrSpawnActions;
var private XComSpawnPoint_Alien m_kCompletedPoint;
var array<DelayedOverwatch> m_arrOverwatches;