class XGStrategySoldier extends XGStrategyActorNativeBase
	native
	config(GameData)
	notplaceable;
//complete stub
enum ESoldierStatus
{
    eStatus_Active,
    eStatus_OnMission,
    eStatus_PsiTesting,
    eStatus_CovertOps,
    eStatus_GeneMod,
    eStatus_Augmenting,
    eStatus_Healing,
    eStatus_Dead,
    eStatus_MAX
};

enum ESoldierLocation
{
    eSoldierLoc_Barracks,
    eSoldierLoc_Dropship,
    eSoldierLoc_Infirmary,
    eSoldierLoc_Morgue,
    eSoldierLoc_PsiLabs,
    eSoldierLoc_PsiLabsCinematic,
    eSoldierLoc_Armory,
    eSoldierLoc_Gollup,
    eSoldierLoc_CyberneticsLab,
    eSoldierLoc_GeneticsLab,
    eSoldierLoc_CovertOps,
    eSoldierLoc_Outro,
    eSoldierLoc_MecCinematic,
    eSoldierLoc_GeneModCinematic,
    eSoldierLoc_GeneModNarrative,
    eSoldierLoc_MedalCeremony,
    eSoldierLoc_MAX
};

enum ENameType
{
    eNameType_First,
    eNameType_Last,
    eNameType_Nick,
    eNameType_Full,
    eNameType_Rank,
    eNameType_RankFull,
    eNameType_FullNick,
    eNameType_MAX
};

struct CheckpointRecord
{
    var TCharacter m_kChar;
    var TSoldier m_kSoldier;
    var int m_aStatModifiers[ECharacterStat];
    var ESoldierStatus m_eStatus;
    var int m_iHQLocation;
    var int m_iEnergy;
    var int m_iTurnsOut;
    var int m_iNumMissions;
    var string m_strKIAReport;
    var string m_strKIADate;
    var string m_strCauseOfDeath;
    var bool m_bPsiTested;
    var bool bForcePsiGift;
    var bool m_bMIA;
    var bool m_bAllIn;
    var TInventory m_kBackedUpLoadout;
    var XGCustomizeUI.EEasterEggCharacter m_eEasterEggChar;
    var array<EPerkType> m_arrRandomPerks;
    var int m_arrMedals[EMedalType];
    var bool m_bBlueShirt;
};


var TCharacter m_kChar;
var TSoldier m_kSoldier;
var int m_aStatModifiers[ECharacterStat];
var ESoldierStatus m_eStatus;
var XGCustomizeUI.EEasterEggCharacter m_eEasterEggChar;
var int m_iHQLocation;
var int m_iEnergy;
var int m_iTurnsOut;
var int m_iNumMissions;
var string m_strKIAReport;
var string m_strKIADate;
var string m_strCauseOfDeath;
var bool m_bPsiTested;
var bool bForcePsiGift;
var bool m_bMIA;
var bool m_bAllIn;
var bool m_bBlueShirt;
var bool m_bForcePawnUpdateOnLoadoutChange;
var transient XComUnitPawn m_kPawn;
var TInventory m_kBackedUpLoadout;
var array<EPerkType> m_arrRandomPerks;
var int m_arrMedals[EMedalType];
var const localized string m_strMessageGainedPsiRank;
var const localized string m_strStatAim;
var const localized string m_strStatDefense;
var const localized string m_strStatHealth;
var const localized string m_strStatWill;
var string m_arrSoldierLocation[ESoldierLocation];
var const localized string m_arrSoldierStatus[ESoldierStatus];
var const localized string m_strSHIVWounded;
var const localized string m_strSHIVDead;
var const localized string m_strHumanWounded;
var const localized string m_strHumanGravelyWounded;
var const localized string m_strHumanDead;

function ApplyCheckpointRecord(){}
simulated function string GetFirstName(){}
simulated function string GetLastName(){}
simulated function string GetNickname(optional bool noQuotes){}
simulated function SetName(string firstName, string lastName, string NickName){}
native function int GetMaxStat(const int iStat);
native function int GetCurrentStat(const int iStat);
native function int GetRank();
function int GetPsiRank(){}
function int GetSHIVRank(){}
function int GetCountry(){}
function bool IsReadyToLevelUp(){}
function bool IsReadyToPsiLevelUp(){}
function bool HasPsiGift(){}
function SetSoldierClass(ESoldierClass eNewClass){}
function AssignRandomPerks(){}
function bool IsRandomPerkValidToAdd(EPerkType Perk){}
function EPerkType GetPerkInClassTree(int branch, int Option, optional bool bIsPsiTree){}
function bool HasAvailablePerksToAssign(optional bool CheckForPsiPromotion){}
function bool PerkLockedOut(int Perk, int branch, optional bool isPsiPerk){}
function string GetClassName(){}
function PsiLevelUp(){}
function LevelUp(optional ESoldierClass eClass, optional out string statsString){}
function LevelUpStats(optional int statsString){}
native function bool IsInjured();
native function bool IsGravelyInjured();
native function bool IsDead();
function bool IsInPsiTesting(){}
function bool IsInGeneticsLab(){}
function bool IsBeingAugmented(){}
function bool IsATank(){}
function bool IsAugmented(){}
function bool IsASuperSoldier(){}
function bool IsASpecialSoldier(){}
function GiveBottomTreePerks(bool bActiveOnly){}
function GiveTopTreePerks(bool bActiveOnly){}
function GivePsiPerks(){}
function DEMOUltimateSoldier(){}
function XComPerkManager PERKS(){}
static function string HQLocToName(ESoldierLocation Loc){}
static function bool RoomRequiresHumanPawn(ESoldierLocation Loc){}
static function bool RoomRequiresTankPawn(ESoldierLocation Loc){}
function bool RoomRequiresPawn(ESoldierLocation Loc){}
final function AddToLocation(ESoldierLocation Loc, optional int SlotIdx){}
final function RemoveFromLocation(ESoldierLocation Loc, optional bool bDestroyPawn){}
function AdjustDLEForSquadSelectionScreen(int iNewHQLocation){}
function SetHQLocation(int iNewHQLocation, optional bool bForce, optional int SlotIdx, optional bool bForceNewPawn){}
static function bool CanWearMecInRoom(ESoldierLocation Loc){}
function XComUnitPawn CreatePawn(optional name DestState){}
function DestroyPawn(){}
function OnLoadoutChange(){}
simulated function PlaceOnPlinth(ESoldierLocation eLoc){}
function int GetHQLocation(){}
function AddFatigue(int iFatigue){}
function RemoveFatigue(int iFatigue){}
function Heal(int iHP){}
function int GetEnergy(){}
function string GetName(ENameType eType){}
function string GetStatusString(){}
function int GetStatusUIState(){}
final function ValidateStatus(ESoldierStatus eStatus){}
function SetStatus(ESoldierStatus eNewStatus, optional bool bMoveToDefaultHQLocation){}
function ESoldierStatus GetStatus(){}
function ESoldierLocation GetDefaultLocationForStatus(ESoldierStatus eStatus){}
function ESoldierClass GetClass(){}
function ClearPerks(optional bool bClearMedalPerks){}
function GivePerk(int iPerk){}
function bool HasPerk(int iPerk){}
function bool HasMedal(int iMedal){}
function bool HasAnyMedal(){}
function int MedalCount(){}
function EPerkType GetSpecialMecPerk(){}
function TInventory GetInventory(){}
function TTransferSoldier BuildTransferSoldier(){}
function UpdateTacticalRigging(bool bEnable){}
function RebuildAfterCombat(TTransferSoldier kTransfer){}
function bool IsAvailableForCovertOps(){}
native function int GetNumKills();
function int GetNumMissions(){}
