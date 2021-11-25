class XComSpawnAlienMutator extends XComMutator
	config(RandomSpawns);

var config bool USE_OVERWATCH;
var config bool DROP_TO_COVER;
var config bool REVEAL_SPAWN;
var config int MAX_DROP_DIST;
var config int MIN_DROP_DIST;
var config array<config string> ExcludeMaps;

var SeqAct_SpawnAlien SpawnAlienObj;
var array<vector> UnitsLoc;
var array<vector> PrevSpawnLoc;
var vector SpawnLoc;
var array<XComCoverPoint> CoverPoints;

function XGBattle BATTLE(){}
function XComWorldData WORLD(){}
function bool IsLocationBlockedByRoof(vector TestLoc){}
function bool IsCloseToPrevSpawnLoc(vector TestLoc){}
function bool IsFlankedByXCOM(XComCoverPoint kCover){}
function bool IsInsideSpawnZone(vector CenterLoc, vector TestLoc){}
function bool IsValidSpawnLocation(vector TestLoc){}
function bool IsMutatorValid(string SeqActObjName){}
function MutateSpawnAlien(string SeqActObjName, PlayerController Sender){}
function bool GetUnitsLoc(){}
function GetCoverPoints(){}
function bool GetRandomElevatedPoint(){}
function bool GetRandomSpawnLoc(){}
function vector GetRandLoc(vector CenterLoc){}
function CenterSpawnLocOnTile(){}
function MutateSpawnAlienObj(){}