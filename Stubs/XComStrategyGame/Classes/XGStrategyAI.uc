class XGStrategyAI extends XGStrategyActor
    config(GameData)
    notplaceable;
//completet stub

struct TResistance
{
    var array<int> arrCountries;
    var array<int> arrNoResistance;
    var array<int> arrHunted;
};

struct TAlienChance
{
    var ECharacter eAlien;
    var int iChance;
    var int iLimit;
};

struct TPossibleAlienSquad
{
    var array<TAlienChance> arrPossibleCommanders;
    var array<TAlienChance> arrPossibleSoldiers;
    var array<TAlienChance> arrPossibleSecondaries;
    var array<TAlienChance> arrPossibleRoaming;
};

struct TUFO
{
    var EShipType eUFO;
    var EAlienObjective eObj;
};

struct CheckpointRecord
{
    var bool m_bFirstMission;
    var array<XGShip_UFO> m_arrUFOs;
    var array<int> m_arrUFOsShotDown;
    var XGDateTime m_kStartDate;
    var TResistance m_kResistance;
    var array<XGAlienObjective> m_arrObjectives;
    var array<XGAlienObjective> m_arrOldObjectives;
    var array<TObjective> m_arrTObjectives;
    var int m_iAlienMonth;
    var array<ECityType> m_arrFirstBlitzTargets;
    var int m_iFirstBlitzCounter;
    var int m_iCouncilCounter;
    var int m_iTerrorCounter;
    var int m_iHQAssaultCounter;
    var array<TUFORecord> m_arrUFORecord;
    var array<TUFO> m_arrPool;
    var TUFO m_kLastUFO;
    var int m_iCounter;
};

var bool m_bFirstMission;
var array<XGShip_UFO> m_arrUFOs;
var array<int> m_arrUFOsShotDown;
var XGDateTime m_kStartDate;
var TResistance m_kResistance;
var array<XGAlienObjective> m_arrObjectives;
var array<XGAlienObjective> m_arrOldObjectives;
var array<TObjective> m_arrTObjectives;
var int m_iAlienMonth;
var array<ECityType> m_arrFirstBlitzTargets;
var int m_iFirstBlitzCounter;
var int m_iCouncilCounter;
var int m_iTerrorCounter;
var int m_iHQAssaultCounter;
var array<TUFORecord> m_arrUFORecord;
var array<TUFO> m_arrPool;
var TUFO m_kLastUFO;
var int m_iCounter;
var const localized string m_arrObjectiveNames[12];

function Init();
function AddAIEvent(EMissionType eMission, int iHours, ECountry eTarget, out array<THQEvent> arrEvents){}
function GetEvents(out array<THQEvent> arrEvents){}
function InitNewGame(){}
function MakeMonthlyPlan(){}
function FastForward(int iHalfHours){}
function Update(){}
function UpdateObjectives(optional int iNumUnits, optional bool bPaydayUpdate){}
function bool CurrentlyHasObjective(EAlienObjective eObjective){}
function AddCouncilMission(){}
function AddHQAssaultMission(){}
function AddLateMission(){}
function AIAddNewObjectives(){}
function int GetNumAbductionSites(){}
function int AddNewAbductions(int iNumAbductions, optional bool bFirstBlitz){}
function AddNewTerrorMission(ECountry eTarget, optional int iStartDate){}
function AddHuntTarget(ECountry eTargetCountry){}
function bool IsCountryBeingHunted(ECountry eTargetCountry){}
function ECountry ChooseOverseerTarget(){}
function int AddNewOverseers(){}
function OnEtherealFlyby(XGShip_UFO kLastUFO);
function TUFO MakeUFO(EShipType eUFO, EAlienObjective eObj){}
function FillUFOPool(){}
function FillDatePool(out array<int> arrDates){}
function AddUFOToPool(TUFO kUFO){}
function int ChooseUFOTarget(out array<ECountry> arrCountries){}
function bool IsGoodUFOMissionChoice(TUFO kUFO){}
function int ChooseUFOMissionType(int iChoice){}
function int ChooseUFOMission(out array<TUFO> arrUFOs){}
function ChooseUFO(out array<TUFO> arrUFOs, out array<int> arrDates, out array<ECountry> arrCountries){}
function AddUFOs(int iNumUFOs, out array<ECountry> arrVisible){}
function array<ECountry> FilterCountries(array<EContinent> arrAvoid, array<ECountry> arrCountries){}
function array<ECityType> PickAbductionTargets(int iNumCities, out array<ECountry> arrCountries){}
function AddAbductionObjectives(int iNumAbductions, int iStartDate, out array<ECountry> arrCountries){}
function XGAlienObjective AIAddNewObjective(EAlienObjective eObjective, int iStartDate, Vector2D v2Target, int iCountry, optional int iCity, optional EShipType eUFO){}
function SignPact(XGShip_UFO kUFO, int iCountry){}
function AIAddNewUFO(XGShip_UFO kUFO){}
function XGMission AIAddNewMission(EMissionType eType, XGShip_UFO kUFO){}
function AIUpdateMissions(optional int iDuration){}
function RevealBase(){}
function array<XGMission> GetAlienBases(){}
function XGMission CreateTempleMission(){}
function XGMission CheatTerrorMission(){}
function XGMission CreateTerrorMission(XGShip_UFO kUFO){}
function XGMission CreateHQAssaultMission(){}
function XGMission CreateExaltRaidMission(ECountry ExaltCountry){}
function CheatAbduction(string strMapName){}
function CheatTerror(string strMapName){}
function XGMission CheatCrash(XGShip_UFO strMapName){}
function CheatLandedUFO(string strMapName){}
function CreateAlienBase(){}
function XGMission CreateFirstMission(){}
function XGMission CreateFirstMission_Controlled(){}
function CreateAbductionBlitz(out array<ECountry> arrPossibleTargets, int iNumTargets, int iStartDate){}
function LaunchBlitz(array<ECityType> arrTargetCities, optional bool bFirstBlitz){}
function EMissionDifficulty GetAbductionDifficulty(XGCountry kCountry){}
function CheckForAbductionBlitz(array<XGAlienObjective> arrAbductions){}
function DetermineAbductionReward(out TMissionReward kReward, EMissionDifficulty eDiff, EMissionRewardType eRewardType){}
function DetermineRandomAbductionReward(out TMissionReward kReward, EMissionDifficulty eDiff, EMissionRewardType eRewardType){}
function XGMission CreateCrashMission(XGShip_UFO kUFO){}
function XGMission CreateLandedUFOMission(XGShip_UFO kUFO){}
function XGMission CreateCovertOpsExtractionMission(ECountry eMissionCountry){}
function XGMission CreateCaptureAndHoldMission(ECountry eMissionCountry){}
function XGShip_UFO GetUFO(int iUFOindex){}
function RemoveUFO(XGShip_UFO kUFO){}
function OnUFODestroyed(XGShip_UFO kUFO){}
function OnUFOShotDown(XGShip_Interceptor kJet, XGShip_UFO kUFO){}
function bool CheckForHunterKiller(){}
function OnUFOAttacked(XGShip_UFO kUFO){}
function int GetMonth(){}
function int GetDay(){}
function DetermineCrashLoot(XGShip_UFO kUFO, EShipWeapon eWeapon){}
function int GetSurvivingCollectibles(int iTotal, int iSurvivalChance){}
function LogResistance(int iCountry){}
function LogNoResistance(int iCountry){}
function OnSatelliteDestroyed(int iCountry){}
function BuildObjectives(){}
function OnObjectiveEnded(XGAlienObjective kObj, XGShip_UFO kLastUFO){}
function bool ShouldHunt(XGShip_UFO eUFO, ECountry eTarget, EUFOMissionResult eResult){}
function LogUFORecord(XGShip_UFO kUFO, EUFOMissionResult eResult){}
function ApplyMissionPanic(XGMission kMission, bool bXComSuccess, optional bool bExpired, optional bool bDontApplyToContinent){}
function bool CalcTerrorMissionPanicResult(out int iCountryPanicChange, out int iContinentPanicChange){}
function array<ECountry> DetermineBestAbductionTargets(){}
function ECountry DetermineBestTerrorTarget(){}
function int SortTerrorTargets(ECountry eTarget1, ECountry eTarget2){}
function bool IsTerrorTarget(ECountry eTarget){}
function bool ClearFromAbductionList(ECountry eTarget){}
function int SortUFOTargets(ECountry eCountry1, ECountry eCountry2){}
function bool IsGoodOverseerTarget(ECountry eTarget){}
function array<ECountry> DetermineBestOverseerTargets(){}
function array<ECountry> DetermineBestVisibleTargets(optional bool bUnsorted){}
function array<int> DetermineBestHuntTargets(){}
function int GetNumResistingContinents(){}
function BuildObjective(EAlienObjective eObjective, bool bAbandonMission){}
function AddUFOMission(EAlienObjective eObjective, int iStartDate, EShipType eUFO, EUFOMission eMission, int iMissionRadius, int iRandomDays){}
function EndOfMonth(){}
function DestroyObjective(XGAlienObjective kObjective){}
function DestroyZombieUFOs(){}
function TAlienSquad DetermineUFOSquad(XGShip_UFO kUFO, bool bLanded, optional EShipType eShip){}
function TAlienSquad DetermineAbductionSquad(int iMissionDiff){}
function TAlienSquad DetermineCovertOpsSquad(){}
function TAlienSquad DetermineExaltRaidSquad(){}
function TAlienSquad DetermineSpecialMissionSquad(ECharacter eChar, EFCMission eMission, bool bAssault){}
function TAlienSquad DetermineTerrorSquad(){}
function TAlienSquad DetermineHQAssaultSquad(){}
function TAlienSquad DetermineAlienBaseSquad(){}
function int GetNumOutsiders(){}
function TAlienSquad DetermineSmallScoutSquad(bool bLanded){}
function TAlienSquad DetermineLargeScoutSquad(bool bLanded){}
function TAlienSquad DetermineAbductorSquad(bool bLanded){}
function TAlienSquad DetermineSupplySquad(bool bLanded){}
function TAlienSquad DetermineBattleshipSquad(){}
function ProcessPodTypes(out int iNumAliens, out array<EAlienPodType> arrTypes){}
function TAlienSquad DetermineFirstMissionSquad(){}
function TAlienSquad DetermineOverseerSquad(){}
function ECharacter GetCommanderType(){}
function EItemType GetAltWeapon(ECharacter eAlien){}
function TPossibleAlienSquad GetPossibleAliens(optional bool bExaltOnly, optional bool bExaltEliteOnly){}
function AddPossible(ECharacter eAlien, int iLikelihood, out array<TAlienChance> arrPossibles, optional int iLimit){}
function NormalizeValues(out array<TAlienChance> arrPossibles){}
function ECharacter GetSupportingAlien(ECharacter eMainAlien, optional bool bAlternate){}
function TAlienPod BuildPod(EAlienPodType eType, ECharacter eMainAlien, int iNumAliens, optional bool bExaltOnly){}
function ECharacter ChooseAlien(EAlienPodType eType, out TPossibleAlienSquad kPossible){}
function DistributeAliens(array<EAlienPodType> arrTypes, int iNumAliens, out TAlienSquad kSquad, optional ECharacter eForceAlien, optional bool bExaltOnly, optional bool bExaltEliteOnly, optional bool bForceFlightUnit){}
function int CountAlienTypes(TAlienSquad kSquad){}
function bool CanFly(ECharacter kChar){}
function UpdatePossibleAliens(ECharacter eAlien, int iNumAliens, out TPossibleAlienSquad kPossible){}
function LimitSquadCost(out array<TAlienPod> arrPods, int SoldierCostLimit){}
function bool CheckAlienLimited(ECharacter eAlien, out array<TAlienChance> arrPossible){}
function GetFreeAliens(out array<ECharacter> arrAliens, out array<TAlienChance> arrPossible, out array<ECharAssetFamilyType> arrAssets){}
function ReplaceAsset(int iPod, out array<TAlienPod> arrPods, out array<ECharacter> arrReplacementAliens){}
function bool IsAssetPresent(ECharacter eAlien, out array<ECharAssetFamilyType> arrAssets){}
function AddToAssets(ECharacter eAlien, out array<ECharAssetFamilyType> arrAssets){}
function CostAlienSquad(){}
function int TallySquadCost(optional bool bLog){}
function ECharAssetFamilyType GetAssetFamily(ECharacter eAlien){}
function int GetAlienAssetCost(ECharacter eAlien){}
function LogSquad(TAlienSquad kSquad, optional bool bCostLimited){}
function CostTest(){}
