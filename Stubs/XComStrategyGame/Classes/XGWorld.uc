class XGWorld extends XGStrategyActor
    hidecategories(Navigation)
    config(GameData)
    notplaceable;
//complete stub

struct CheckpointRecord
{
    var array<XGCountry> m_arrCountries;
    var array<XGCity> m_arrCities;
    var array<XGContinent> m_arrContinents;
    var array<TSatNode> m_arrSatNodes;
    var XGFundingCouncil m_kFundingCouncil;
    var TCouncilMeeting m_kCouncil;
    var int m_iNumCountriesLost;
};

var array<XGCountry> m_arrCountries;
var array<XGCity> m_arrCities;
var array<XGContinent> m_arrContinents;
var array<TSatNode> m_arrSatNodes;
var XGFundingCouncil m_kFundingCouncil;
var TCouncilMeeting m_kCouncil;
var int m_iNumCountriesLost;
var const localized string m_aContinentNames[5];

function Init(bool bNewGame){}
function InitNewGame(){}
function StartGame(){}
function string RecordStartedGame(){}
function InitFunding(optional bool bChangeDifficulty){}
function int GetCountryFunding(ECountry eFundingCountry, EDifficultyLevel eDiff){}
function UpdateFunding(){}
function OnLoadGame();
function Update();

function XGCountry GetCountry(int iCountryID){}
function XGCountry GetRandomCountry(){}
function XGCountry GetRandomCouncilCountry(){}
function XGContinent GetContinent(int iContinent){}
function array<int> GetContinents(){}
function XGCity GetRandomCity(){}
function XGCity GetCity(int iCity){}
function EContinent GetRandomContinent(){}
function CreateContinents(){}
function BalanceContinent(XGContinent kContinent){}
function TSatNode GetSatelliteNode(int iCountry){}
function CreateSatNodes(){}
function AddInitialPanic(){}
function BuildSatNode(ECountry ECountry, Vector2D v2Coords){}
function int GetContinentByBonus(EContinentBonus eBonus){}
function TContinentBonus GetBonus(EContinentBonus eBonus){}
function CreateCities(){}
function BuildCity(){}
function CreateCountries(){}
function RandomizeFunding(){}
function BuildCouncilCountry(int iCountry, int iContinent, bool bDeveloped){}
function BuildCountry(int iCountry, int iContinent, bool bDeveloped){}
function BoundCouncilCountries(){}
function int HitCouncilCountry(Vector2D v2Hit){}
function int HitContinent(Vector2D v2Hit){}
function CouncilMeeting(){}
function string RecordCouncilMeeting(){}
function DetermineDefections(out TCouncilMeeting kCouncil){}
function ReducePanic(out TCouncilMeeting kCouncil){}
function AdjustDefections(out TCouncilMeeting kCouncil){}
function AddToDefectorsList(out TCouncilMeeting kMeeting, ECountry eDefector){}
function int SortDefectorsList(ECountry eDefector1, ECountry eDefector2){}
function int GetNumCouncilMembers(){}
function int PayDay(){}
function SetStartingContinent(int iStartContinent){}
function int GetIncome(){}
function int GetNetIncome(){}
function AddPanic(int iPanicChange){}
function int GetNumContinentsCovered(){}
function int GetNumContinentBonuses(){}
function int GetNumFundingCountries(){}
function int GetNumDefectors(){}
