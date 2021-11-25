class XGFacility_Hangar extends XGFacility;

//complete stub

	struct TContinentInfo
{
    var EContinent eCont;
    var TText strContinentName;
    var int iNumShips;
    var array<XGShip_Interceptor> arrCraft;
    var array<int> m_arrInterceptorOrderIndexes;
};

var XGShip_Dropship m_kSkyranger;
var int m_iInterceptorCounter;
var int m_iFirestormCounter;
var array<XGShip_Interceptor> m_arrInts;
var int m_iJetsLost;
var EItemType m_eBestWeaponEquipped;
var bool m_bNarrLostJet;
var bool m_bBusy;
var array<SeqAct_Interp> m_arrHangarOpen;
var array<SeqAct_Interp> m_arrHangarClosed;
var array<SeqAct_Interp> m_arrHangarRepair;
var SeqAct_Interp m_cinViewWeapons;
var XGHangarShip m_kViewWeaponsShip;
var XGInterception m_kLaunchInterception;
var const localized string m_aDropshipNames[15];
var const localized string m_aSquadNames[9];
var const localized string m_aSquadMotto[9];
var const localized string m_strCallsignFireStorm;
var const localized string m_strCallsignInterceptor;
var const localized string m_strCallsignSkyranger;
var const localized string m_strCanEquipMessage;
var const localized string m_sUnavailable;

function Update(){}
function int GetShipMaintenanceCost(){}
function int GetCraftMaintenanceCost(EShipType eShip){}
function Init(bool bLoadingFromSave){}
function InitNewGame(){}
function LandDropship(XGShip_Dropship kSkyranger){}
function TContinentInfo GetContinentInfo(EContinent eCont){}
function UnloadArtifacts(XGShip_Dropship kSkyranger){}
function GiveMissionReward(XGShip_Dropship kSkyranger){}
function XGShip_Dropship GetDropship(){}
function bool IsSkyrangerAvailable(XGShip_Dropship kSkyranger){}
function XGShip_Dropship GetAvailableSkyranger(){}
function AddInterceptor(int iContinent){}
function AddDropship(){}
function int GetAvailableBay(){}
function bool IsBayAvailable(int iBay){}
function UpdateHangarBays(){}
function SetHangarShipsForKismet(){}
function SetupWeaponView(XGShip_Interceptor kShip){}
function UpdateWeaponView(EShipWeapon eWeapon){}
function ClearWeaponView(){}
function AddFirestorm(int iContinent){}
function bool OrderedHigher(XGShip_Interceptor kCraft1, XGShip_Interceptor kCraft2){}
function ReorderCraft(){}
function bool AreShipsFlying(){}
function bool AreShipsOnMission(){}
function array<XGShip_Interceptor> GetAllInterceptors(){}
function array<XGShip_Interceptor> GetInterceptorsByContinent(int iContinent){}
function int GetNumInterceptors(int iContinent){}
function RemoveInterceptor(XGShip_Interceptor kInt){}
function CompleteTransfer(XGShip_Interceptor kInt){}
function TransferCraft(XGShip_Interceptor kInt, int iNewContinent){}
function bool IsShipInTransitTo(int iContinent){}
function int GetNumInterceptorsInRange(XGShip_UFO kUFO){}
function int GetNumInterceptorsInRangeAndAvailable(XGShip_UFO kUFO){}
function int GetFreeHangerSpots(int iContinent){}
function int GetTotalInterceptorCapacity(optional int kContinent){}
function array<TItem> GetUpgrades(XGShip_Interceptor kShip){}
function bool CanEquip(int iItem, XGShip_Interceptor kShip, out string strHelp){}
function EquipWeapon(EItemType eItem, XGShip_Interceptor kShip){}
function ShowInterceptorLaunch(XGInterception kInterception) {}
function EItemType ShipWeaponToItemType(EShipWeapon eWeapon) {}
function EItemType ShipTypeToItemType(EShipType eShip) {}
static function EShipWeapon ItemTypeToShipWeapon(EItemType eItem) {}
function LandInterceptor(XGShip_Interceptor kInterceptor) {}
function DetermineInterceptorStatus(XGShip_Interceptor kInterceptor) {}
function OnInterceptorDestroyed(XGShip_Interceptor kInterceptor) {}
function bool HasNoJets(){}
function Enter(int iView){}
function Exit(){}
function ForceStreamMissionControlTextures(float Duration){}
function NotifyHangarCinematicEnd(){}
function bool PlayFirestormBuiltCinematic(){}
function bool IsHangarCinematicBusy(){}
