class XComLZMutator extends XComMutator
	config(LZMutator);

struct CheckpointRecord
{
    var int IdxSaved;
	var Mutator NextMutator;
};

enum ELZDirection
{
   ELZD_North,
   ELZD_East,
   ELZD_South,
   ELZD_West
};

enum ESpawnLocation
{
	ESL_Default,
	ESL_Normal,
	ESL_Inside,
	ESL_Alternate,
	ESL_NoEvacZone
};

struct LZObjectData
{
	var Actor LevelActorObj;
	var Actor BuildingVolumeObj;
	var Actor PlayerStartObj;
	var Actor PointObj;
	var Actor SpawnPt1;
	var Actor SpawnPt2;
	var Actor SpawnPt3;
	var Actor SpawnPt4;
	var Actor SpawnPt5;
	var Actor SpawnPt6;
};

struct LZData
{
	// map and mission bias
	var string MapName;
	var EMissionType MissionType;
	var EFCMissionType CouncilType;
	// LZ location
	var vector StartLoc;
	var ELZDirection StartDir;
	var ESpawnLocation ESpawnLoc;
	// alternate spawn location
	var vector AltSpawnLoc;
	var ELZDirection AltSpawnDir;
};

var config array <LZData> LZArray;
var vector dps, dbv, dla, dsp1, dsp2, dsp3, dsp4, dsp5, dsp6, dp;
var vector psLoc, bvLoc, laLoc, sp1Loc, sp2Loc, sp3Loc, sp4Loc, sp5Loc, sp6Loc, pLoc;
var rotator StartRot, FaceRot, BaseRot;
var LZObjectData LZObjects;
var string CurMapName;
var int IdxSaved;

function MutateNotifyKismetOfLoad(PlayerController Sender){}
function PostLoadSaveGame(PlayerController Sender){}
function PostLevelLoaded(PlayerController Sender){}
function RemoveUnknownSpawnPoints(){}
function RespawnLZObjects(LZData Data){}
function HideDropShip(){}
function bool FindLZObjectsByArchetype(LZData Data){}
function AdjustOffsets(ESpawnLocation ESpawnLoc){}
function CalcLocations(LZData Data){}
function rotator AdjRotation(rotator ObjRot){}