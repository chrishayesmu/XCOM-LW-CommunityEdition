class XGCountry extends XGStrategyActor
    hidecategories(Navigation)
    config(GameData)
    notplaceable;
//complete stub

struct CheckpointRecord
{
    var TCountry m_kTCountry;
    var bool m_bSecretPact;
    var array<int> m_arrCities;
    var array<TRect> m_arrBounds;
    var int m_iFunding;
    var int m_iPanic;
    var bool m_bSatellite;
    var array<TUFORecord> m_arrUFORecord;
    var XGEntity m_kEntity;

};
var TCountry m_kTCountry;
var bool m_bSecretPact;
var bool m_bSatellite;
var array<int> m_arrCities;
var array<TRect> m_arrBounds;
var int m_iFunding;
var int m_iPanic;
var array<TUFORecord> m_arrUFORecord;

function AddPanic(int iPanic, optional bool bSuppressHeadline){}
function string RecordPanicChanged(int iPrevPanic, int iCurPanic){}
function int GetPanicWarningThreshhold(){}
function int GetPanicBlocks(){}
function Color GetPanicColor(){}
function bool LeftXCom(){}
function SignPact(){}
function LeaveXComProject(){}
function string RecordCountryLeavesXCom(){}
function XGStrategyActorNativeBase.EEntityGraphic GetStormEntity(){}
function bool IsCouncilMember(){}
function InitNewGame(TCountry kCountry){}
function int CalcFunding(optional int iAdditionalPanic){}
function BeginPaying(){}
function StopPaying(){}
function int GetCurrentFunding(){}
function string GetNameAdjective(){}
function string GetName(optional bool bPossessive){}
function string GetNameWithArticle(optional bool bLowerCase){}
function int GetID(){}
function EContinent GetContinent(){}
function int GetRandomCity(){}
function Vector2D GetRandomLocation(){}
function bool Hit(Vector2D v2Loc){}
function TRect GetBounds(){}
function Vector2D GetCoords(){}
function bool HasSatelliteCoverage(){}
function SetSatelliteCoverage(bool bCoverage){}
function bool BeenHunted(){}