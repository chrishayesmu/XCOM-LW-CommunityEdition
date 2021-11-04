class XGFacility_Barracks extends XGFacility
    hidecategories(Navigation)
    config(GameData)
    notplaceable;
//complete stub

enum ELastMissionResult
{
    eLastResult_None,
    eLastResult_Bad,
    eLastResult_Good,
    eLastResult_MAX
};
struct TMedal
{
    var EMedalType m_eType;
    var EPerkType m_ePowerA;
    var EPerkType m_ePowerB;
    var int m_iMaxAwards;
    var int m_iMissions;
};

struct Medal
{
    var string m_Name;
    var int m_eType;
    var EPerkType m_eChosenPower;
    var int m_iAvailable;
    var int m_iUsed;
    var int m_iMissionsLeft;
};
	
struct MedalRequirements
{
    var int m_iNumAbductions;
    var bool m_bSoldierKilledOrCritWounded;
    var array<EContinent> m_arrContinentMissions;
    var int m_iNumTerrorMissions;
    var int m_iNumCovertOpsMissions;
    var int m_iNumSpecialMissions;
    var bool m_bHQAssaultComplete;
};
struct RecycledMedals
{
    var int m_iNumMissions;
    var array<EMedalType> m_arrMedalsToRecycle;
};

var config int NUM_RECYCLE_MISSIONS;
var config int NUM_INTERNATIONAL_SERVICE_CONTINENTS;
var config int NUM_MEDALOFHONOR_MISSIONS;
var config int NUM_PER_CLASS_DISTRIBUTION;
var config int NUM_REMOVE_CLASS_DISTRIBUTION;
var XGStrategySoldier m_kVolunteer;
var array<XGStrategySoldier> m_arrSoldiers;
var array<XGStrategySoldier> m_aLastMissionSoldiers;
var XGStrategySoldier m_kLastMissionCovertOperative;
var array<XGStrategySoldier> m_arrFallen;
var array<int> m_arrOTSUpgrades;
var XGFacility_PsiLabs m_kPsiLabs;
var XGFacility_GeneLabs m_kGeneLabs;
var XGFacility_CyberneticsLab m_kCyberneticsLab;
var int m_iSoldierCounter;
var int m_iTankCounter;
var int m_iAlloyTankCounter;
var int m_iHoverTankCounter;
var int m_iCapacity;
var int m_iHighestRank;
var int m_iHighestMecRank;
var int m_iHighestPsiRank;
var int m_aLastFemaleVoice[ECharacterLanguage];
var int m_aLastMaleVoice[ECharacterLanguage];
var XGFacility_Barracks.ELastMissionResult m_eLastResult;
var SoundNodeWave.EXComSpeakerType m_eLastResultSpeaker;
var int m_iMoreSoldiersCounter;
var bool m_bVolunteerUrged;
var bool m_bNotifyPromotions;
var transient bool bInitingNewGame;
var Medal m_arrMedals[EMedalType];
var MedalRequirements m_kMedalRequirements;
var MedalBattleData m_kMedalBattleData;
var array<RecycledMedals> m_arrRecycledMedals;
var array<ESoldierClass> m_arrClassWaitingList;
var TMedal m_arrTMedals[EMedalType];
var XGCharacterGenerator m_kCharGen;
var XGFacility_Lockers m_kLockers;
var XComPerkManager m_kPerkManager;
var XGStrategySoldier m_kAwardCeremonySoldier;
var int m_iAwardCeremonyPreviousLocation;
var const localized string m_strSHIVPrefix;
var const localized string m_strAlloySHIVPrefix;
var const localized string m_strHoverSHIVPrefix;
var const localized string m_strKIADateTimeFormat;
var const localized string m_arrMedalNames[11];

function CreateCheckpointRecord(){}
function ApplyCheckpointRecord(){}
function Init(bool bLoadingFromSave){}
function InitNewGame(){}
function Update(){}
function BuildMedals(){}
function BuildMedal(EMedalType Type, EPerkType PowerA, EPerkType PowerB, int MaxAwards, int Missions){}
function StartMatinee(){}
function StopMatinee(){}
function Enter(int iView){}
function Exit(){}
function int GetNumSoldiers(){}
function int GetNumAvailableSoldiers(){}
function int GetNumVeterans(){}
function AddNewSoldiers(int iNumSoldiers, optional bool bCreatePawns){}
function AddTank(EItemType eArmor, EItemType eWeapon){}
function DismissSoldier(XGStrategySoldier kSoldier){}
function XGStrategySoldier GetTank(){}
function UpdateTankWeapons(EItemType eWeapon){}
function UpdateGrenades(EItemType eWeapon){}
function bool HasAvailablePromotions(){}
function array<XGStrategySoldier> GetAvailableSoldiers(){}
function ReorderRanks(){}
function int SortTheFallen(XGStrategySoldier kSoldier1, XGStrategySoldier kSoldier2){}
function SelectSoldiersForSkyrangerSquad(XGShip_Dropship kSkyranger, out array<XGStrategySoldier> arrSoldiers, optional XGMission kMission){}
function ChooseSquadForNewMission(XGMission kMission, XGShip_Dropship kSkyranger){}
function ChooseHQAssaultSquad(XGShip_Dropship kSkyranger, bool bReinforcements){}
function RecordLastMissionSoldiers(XGShip_Dropship kSkyranger){}
function ClearSquad(XGShip_Dropship kSkyranger){}
function XGStrategySoldier GetSoldierByID(int iID){}
function int GetNumSoldiersOfClass(ESoldierClass eClass){}
function int GetNumPsiSoldiers(){}
function bool HasPotentialVolunteer(){}
function int LoadOrUnloadSoldier(int kSoldier, XGShip_Dropship kSkyranger, optional int kMission){}
function bool CanLoadSoldier(XGStrategySoldier kSoldier, optional bool bAllowInjured){}
function OnLoadSoldier(XGStrategySoldier Soldier, int SlotIdx){}
function bool LoadSoldierIntoSlot(XGStrategySoldier Soldier, int SlotIdx, XGShip_Dropship Skyranger){}
function bool UnloadSoldierFromSlot(XGStrategySoldier Soldier, int SlotIdx, XGShip_Dropship Skyranger){}
function CommitSoldiersInDropship(XGShip_Dropship Skyranger){}
function RemoveNoneSoldiersFromDropship(XGShip_Dropship Skyranger){}
function MarkFirstSoldiers(XGShip_Dropship Skyranger){}
function MarkWussySoldiers(XGShip_Dropship Skyranger){}
function bool LoadSoldier(XGStrategySoldier kSoldier, XGShip_Dropship kSkyranger, optional bool bAllowInjured){}
function bool UnloadSoldier(XGStrategySoldier kSoldier){}
function MoveToMorgue(XGStrategySoldier kSoldier, string strLastOperationName, XGDateTime kDeathDateTime){}
function MoveToInfirmary(XGStrategySoldier kSoldier){}
function RemoveTank(XGStrategySoldier kTank){}
function PostMission(XGShip_Dropship kSkyranger, bool bSkipSetHQLocation){}
function SetAllSoldierHQLocations(){}
function LandSoldiers(XGShip_Dropship kSkyranger){}
function HealAndRest(){}
function DetermineTimeOut(XGStrategySoldier kSoldier){}
function int RemoveSoldier(XGStrategySoldier kSoldier){}
function XGStrategySoldier GetDefaultCovertOpsSoldier(){}
function bool HasOTSUpgrade(EOTSTech eUpgrade){}
function UpdateOTSFlags(){}
function bool HasDeadSoldiers(){}
function UpdateMemorialPictures(){}
function AddNewSoldier(XGStrategySoldier kSoldier, optional bool bSkipReorder, optional bool bBlueshirt){}
function NameCheck(XGStrategySoldier kSoldier){}
function bool NameMatch(XGStrategySoldier kSoldier){}
function GenerateNewNickname(XGStrategySoldier kNickSoldier){}
function NickNameCheck(XGStrategySoldier kSoldier){}
function bool NickNameMatch(XGStrategySoldier kSoldier){}
function XGStrategySoldier CreateSoldier(ESoldierClass eClass, int iSoldierLevel, int iCountry, optional bool bBlueshirt){}
function CheckForAlerts();
function UIAnnounceNewSoldiers();
function UIAnnounceNewSoldiersCallBack(int iOption);
function FirstTimeHelp();
function ESoldierClass PickRewardSoldierClass(){}
function ESoldierClass NeverGiven(){}
function ESoldierClass PickAClass(){}
final function CreateClassWaitingList(){}
function ESoldierClass GetLeastCommonClass(){}
function RandomizeStats(XGStrategySoldier kRecruit){}
function int RollStat(XGStrategySoldier iLow, int iHigh, int iMultiple){}
function UpdateOTSPerks(){}
function UpdateOTSPerksForSoldier(XGStrategySoldier kSoldier){}
function UpdateFoundryPerks(){}
function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier){}
function DEMOAddNewSoldiers(int iNumSoldiers){}
function DEMOEquipNewSoldiers(){}
function TUTORIALLoadSoldiers(XGShip_Dropship kSkyranger){}
function int GetDelta1Voice(int iLanguage){}
function int GetDelta2Voice(int iLanguage){}
function int GetDelta3Voice(int iLanguage){}
function MedalRequirementsDeadOrCritWounded(bool MetRequirement){}
function MedalRequirementsPostCombat(XGMission kMission, bool bSuccess){}
function UnlockMedal(EMedalType Type){}
function bool AwardMedal(EMedalType Type){}
function bool IsMedalMaxedOut(EMedalType Type){}
function bool IsMedalUnlocked(EMedalType Type){}
function bool IsMedalAwardsAvailable(EMedalType Type){}
function int GetNumMedalsAvailable(){}
function int GetNumMedalsUnlocked(){}
function bool CanAwardMedalToSoldier(EMedalType Type, XGStrategySoldier Soldier){}
function bool AwardMedalToSoldier(EMedalType Type, XGStrategySoldier Soldier){}
function string RecordMedalAwarded(XGStrategySoldier Soldier, Medal AwardedMedal){}
function bool HasMedalPowerSet(EMedalType Type){}
function bool SetMedalPower(EMedalType Type, EPerkType Power){}
function MedalBattleData GetMedalBattleData(){}
function SetMedalName(EMedalType Type, string NewName){}
function ResetMedalName(EMedalType Type){}
function AwardCeremony(XGStrategySoldier kSoldier){}
function SendSoldierToAwardCeremony(){}
function AwardCeremonyComplete(){}
function string RecordBarracksSnapshot(){}
function bool IsAnnetteAlive(){}
function bool AllSoldiersReadyForViewing(){}
