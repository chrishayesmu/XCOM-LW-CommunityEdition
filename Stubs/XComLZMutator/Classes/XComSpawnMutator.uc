class XComSpawnMutator extends XComMutator
	config(RandomSpawns);

const MAX_NUM_SEC = 16;

struct GridSection
{
    var Vector Center;
    var Vector Size;
};

var array<GridSection> Grid;
var vector PlayerStartLoc;
var vector OpStartLoc;
var bool CheckOp;
var bool IsCaptureAndHoldMission;
var int NumSecOrig;
var int NumSec;
var array<vector> RandLoc;

var config float PLAYER_PROXIMITY;
var config float OP_PROXIMITY;
var config bool AVOID_CAPTURE_ZONES;

function XGBattle BATTLE(){}
function XComWorldData WORLD(){}
function InitBaseSpawnMutator(int aNumSec){}
function bool InitPlayerStartLoc(){}
function bool InitOpStartLoc(){}
function bool IsCloseToOtherRandLoc(vector TestLoc){}
function bool IsCloseToPlayerSpawnPoint(vector TestLoc){}
function bool IsInsideCaptureVolume(vector TestLoc){}
function bool IsCloseToLZ(vector TestLoc){}
function bool IsCloseToOp(vector TestLoc){}
function bool IsInsideLevelVolume(vector TestLoc){}
function bool IsValidSpawnLocation(vector TestLoc){}
function bool IsBadLocation(vector TestLoc){}
function BuildGrid(){}
function CalculateGrid(){}
function array<vector> GetRandomLocations(optional bool bRandomZ = true){}