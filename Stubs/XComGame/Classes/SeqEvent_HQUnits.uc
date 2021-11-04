class SeqEvent_HQUnits extends SequenceEvent
	dependsOn(XGTacticalGameCoreNativeBase);

//complete stub

var Object Unit0;
var Object Unit1;
var Object Unit2;
var Object Unit3;
var Object Unit4;
var Object Unit5;
var Object Unit6;
var Object Unit7;
var Object Unit8;
var Object Unit9;
var Object Unit10;
var Object Unit11;
var() const int MaxUnits;
var() Actor CineDummy;
var() bool bDisableGenderBlender;

static event int GetObjClassVersion(){}
event Activated(){}
final function bool AddUnit(Object InUnit, int SlotIdx){}
function bool RemoveUnit(Object InUnit){}
function UpdateMatinee(){}
static function SeqEvent_HQUnits FindHQRoomSequence(string RoomName){}
static function SeqEvent_HQUnits FindHQUnitsInLevel(string LevelName){}
function bool AreHQUnitsReady(){}
static final function SeqEvent_HQUnits GetSpecializedRoom(string RoomName, const out TCharacter Char){}
static final function int GetFirstFreeSlot(string RoomName){}
static function bool AddUnitToRoomSequence(string RoomName, XComUnitPawn UnitPawn, const out TCharacter Char, optional int SlotIdx){}
static function RemoveUnitFromRoomSequence(string RoomName, XComUnitPawn UnitPawn, const out TCharacter Char){}
static function PlayRoomSequence(string RoomName){}
static function StopRoomSequence(string RoomName){}
