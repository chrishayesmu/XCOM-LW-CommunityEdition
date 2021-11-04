class XGContinent extends XGStrategyActor
	config(GameData);
//complete stub

struct CheckpointRecord
{
    var array<TRect> m_arrBounds;
    var string m_strName;
    var EContinent m_eContinent;
    var int m_iImage;
    var array<int> m_arrCountries;
    var Vector2D m_v2Coords;
    var TMonthlySummary m_kMonthly;
    var int m_iPanic;
    var EContinentBonus m_eBonus;
    var array<TSatBonus> m_arrSatBonuses;
    var int m_iNumSatellites;
    var array<TUFORecord> m_arrUFORecord;
};

var array<TRect> m_arrBounds;
var string m_strName;
var EContinent m_eContinent;
var EContinentBonus m_eBonus;
var int m_iImage;
var array<int> m_arrCountries;
var Vector2D m_v2Coords;
var TMonthlySummary m_kMonthly;
var int m_iPanic;
var array<TSatBonus> m_arrSatBonuses;
var int m_iNumSatellites;
var array<TUFORecord> m_arrUFORecord;

function AddPanic(int iPanic) {}
function InitNewGame(){}
function TContinentBonus GetBonus(){}
function string GetName() {}
function int GetID(){}
function Vector2D GetHQLocation() {}
function int GetRandomCity(){}
function int GetRandomCouncilCountry(){}
function int GetMaxFunding(){}
function int GetMaxScientists(){}
function int GetMaxEngineers(){}
function Vector2D GetRandomLocation(){}
function bool Hit(Vector2D v2Loc){}
function TRect GetBounds(){}
function EndOfMonth(out TCouncilMeeting kCouncil){}
function WhoIsLeaving(out TCouncilMeeting kCouncil){}
function WhoIsAdding(){}
function WhoIsJoining(){}
function CalcRewards(){}
function int GetNumRemainingCountries(){}
function bool HasSatelliteCoverage(){}
function bool HasBonus(){}
function RecordCountryHelped(ECountry eHelpedCountry){}
function RecordCountryNotHelped(ECountry eNotHelpedCountry){}
function SetSatelliteCoverage(int iCountry, bool bCoverage){}
function bool CheckForAllTogetherNow(){}
function int GetScientists(){}
function int GetEngineers() {}
function int GetNumSatellites() {}
function int GetNumSatNodes(){}

