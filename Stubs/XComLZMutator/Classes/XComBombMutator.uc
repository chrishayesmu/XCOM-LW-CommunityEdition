class XComBombMutator extends XComSpawnMutator
	config(RandomSpawns);

const OBJ_DIST = 128;

struct AlienBomb
{
	var XComLevelActor Bomb;
	var XComInteractiveLevelActor Button;
	var XComLevelActor WaypointFloor;
	var Emitter FacingWaypoint;
	var Emitter Destroyed;
	var Emitter Active;
	var Emitter Inactive;
	var Emitter Exploding;
	var XComRebuildWorldDataVolume RebuildVolume;
	var XComSquadVisiblePoint VisiblePoint;
	var array<PointInSpace> ArrPoints;
	var vector Loc;
};

struct PowerNode
{
	var XComLevelActor Node;
	var XComInteractiveLevelActor Button;
	var Emitter Inactive;
	var Emitter Active;
	var XComRebuildWorldDataVolume RebuildVolume;
	var vector Loc;
};

var AlienBomb TheBomb;
var array<PowerNode> ArrNodes;
var array<vector> ArrNewLoc;
var bool Active;
var config int INITIAL_TIMER_VALUE;

struct CheckpointRecord
{
	var AlienBomb TheBomb;
	var array<PowerNode> ArrNodes;
	var Mutator NextMutator;
	var bool Active;
};

function MutateUpdateInteractClaim(string UnitObjName, PlayerController Sender){}
function FixUpdateInteractClaim(XGUnit Unit){}
function DoWorldDataRebuild(PlayerController Sender){}
function PostLevelLoaded(PlayerController Sender){}
function ModifyKismet(){}
function bool FindBomb(){}
function MoveBomb(){}
function MoveBombObjects(vector Loc){}
function DestroyFacingWaypoint(){}
function bool FindNodes(){}
function MoveNodes(){}
function MoveNodeObjects(int I, vector Loc){}