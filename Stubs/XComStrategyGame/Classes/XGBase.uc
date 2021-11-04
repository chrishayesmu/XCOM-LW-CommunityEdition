class XGBase extends XGStrategyActor;

enum ETileState
{
    eTileState_None,
    eTileState_Accessible,
    eTileState_NoAccess,
    eTileState_NoExcavation,
    eTileState_MAX
};

struct TTerrainTile
{
    var int X;
    var int Y;
    var int iType;
    var bool bSecondTile;
    var int iTileState;
    var bool bExcavation;
    var bool bConstruction;
};

struct TFacilityTile
{
    var int X;
    var int Y;
    var int iFacility;
    var bool bRemoval;
};

struct TBaseCost
{
    var int iEngineering;
    var int iCash;
    var int iPower;
    var int iHours;
};

var array<TFacilityTile> m_arrFacilities;
var array<TTerrainTile> m_arrTiles;
var array<int> m_arrSteamTiles;
var SkeletalMeshActor m_kCinDummy;
var EItemType m_currAlienCaptive;
var const localized string m_strLabelInsufficientFunds;
var bool m_bInterrogationQueued;

function EItemType GetCurrentCaptive(){}
function Init(){}
function Vector GetFacilityLocation(int iFacility){}
function Vector GetFacility3DLocation(int iFacility){}
function PerformAction(int iCursorState, int X, int Y, optional int iFacility, optional int iTimer){}
function bool IsValidTile(int X, int Y){}
function TTerrainTile GetTileAt(int X, int Y){}
function bool IsFacilityAt(int X, int Y){}
function int GetFacilityAt(int X, int Y){}
function bool IsPrimaryTile(int X, int Y){}
function GenerateTiles(){}
function SetFacility(int iFacility, int X, int Y){}
function int TileIndex(int X, int Y){}
function UpdateTiles(){}
function bool HasAccess(int X, int Y){}
function int GetAccessX(){}
function bool HasExcavation(int X, int Y){}
function bool IsAccessLocation(int X, int Y){}
function bool CanAfford(int iProjectType, TProjectCost kCost, out TText txtHelp){}
function LookAtFacility(int iFacilityType, optional float fInterpTime){}
function int GetAdjacencies(EAdjacencyType eAdj){}
function EAdjacencyType GetAdjacency(int X1, int Y1, int X2, int Y2){}
function int GetSurroundingAdjacencies(int X, int Y, EAdjacencyType eAdjType){}
function bool IsPowerFacility(EFacilityType eFacility){}
function bool IsSatelliteFacility(EFacilityType eFacility){}
function bool IsScienceFacility(EFacilityType eFacility){}
function bool IsEngineeringFacility(EFacilityType eFacility){}
function array<THQAnim> GetHQAnims(){}
function THQAnim BuildHQAnim(EHQAnimLocation eLoc, EHQAnimType eType, THQAnimCharacter kChar1, optional THQAnimCharacter kChar2, optional THQAnimCharacter kChar3){}
function THQAnimCharacter BuildHQAnimChar(EHQAnimCharacter eChar, optional int iID){}
function Vector GetRoomLocation(int iRow, int iCol){}
function string GetMapName(ETerrainTypes eTerrainType, EFacilityType eFacType){}
function StreamInBaseRooms(optional bool bImmediate){}
function UnstreamRooms(){}
function StreamInRoom(int iRow, int iCol, ETerrainTypes eTerrainType, EFacilityType eFacType, optional bool bImmediate){}
function HandleFacilitySpecificFuncitionality(EFacilityType eFacType, LevelStreaming LvlStreaming){}
function OnFaciltyStreamed_AlienContainment(name LevelStreamed){}
function OnFaciltyStreamed_OTS(name LevelStreamed){}
function RemoveRoom(int iRow, int iCol){}
function SkeletalMeshActor GetCineDummy(name LevelPackageName){}
function XComMapManager GetXComMapManager(){}
function CaptureAlienMapStreamFinished(name LevelPackageName){}
function OnAlienContainmentStreamed(name LevelPackageName){}
function BeginAlienContainment(EItemType kCaptive){}
function DoAlienInterrogation(EItemType kCaptive){}
function InterrogateContainedAlien(EItemType kCaptive){}
function OnInterrogationCinematicComplete(){}

