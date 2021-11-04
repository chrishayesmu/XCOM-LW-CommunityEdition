class XGLayout extends XGOvermindActor;

//complete stub
const VALIDATE_RADIUS = 1440;

struct CheckpointRecord
{
    var array<TBuilding> m_arrBuildings;
    var Box m_kBounds;
    var array<TMapSection> m_arrSections;
    var int m_iNumSectionRows;
    var int m_iNumSectionColumns;
    var float m_fSectionWidth;
    var float m_fSectionHeight;
};

var array<TBuilding> m_arrBuildings;
var Box m_kBounds;
var array<TMapSection> m_arrSections;
var int m_iNumSectionRows;
var int m_iNumSectionColumns;
var float m_fSectionWidth;
var float m_fSectionHeight;


function GetCanSeeTiles(TTile kLookTile, out array<TTile> arrCanSeeTiles, int iSightDistInMeters){}
function float PathLength(TTile kStartTile, TTile kEndTile){}
function GetClosestTile(TTile kStartTile, const out array<TTile> arrPossibleDestTiles, out TTile kClosestTile){}
function TTile GetNearestPathableTile(Vector vLocation, optional bool bCanFly, optional bool bSameZ){}
function int GetNumMoves(XGUnit kUnit, TTile kStartTile, TTile kEndTile){}
function BuildLayout(){}
function BuildBounds(){}
function BuildBuildings(){}
function bool IsBehindUFO(Vector vLoc){}
function bool ValidateBuildingVolume(XComBuildingVolume kVolume){}
function int GetUFOVolumeIndex(){}
function TBuilding GetBuildingByIndex(int iBldg){}
function int PointToBuilding(Vector vPoint){}
function ClampRectToBounds(out TRect kRect){}
function Bound(out Vector vPoint){}
function bool IsInBounds(Vector vPoint){}
function int GetNumRows(){}
function int GetNumColumns(){}
function CreateSearchTarget(int iColumn, int iRow, int iTurnsLeft){}
function CreateSearchEvent(Vector vEventLoc){}
function int GetMapSection(int iColumn, int iRow){}
function int LocationToSection(Vector vLocation){}
function bool IsValidSection(int iColumn, int iRow){}
function BuildMapSections(){}
function CreateSection(int iColumn, int iRow, TRect kRect, Vector vCenter){}
function bool FitRectToMap(out TRect kRect, float fZ){}
function bool ValidateLoc(out Vector vLoc){}
