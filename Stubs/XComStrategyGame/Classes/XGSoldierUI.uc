class XGSoldierUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EBaseView
{
    eSoldierView_MainMenu,
    eSoldierView_Promotion,
    eSoldierView_PsiPromotion,
    eSoldierView_MECPromotion,
    eSoldierView_GeneMods,
    eSoldierView_Gear,
    eSoldierView_Customize,
    eSoldierView_Medals,
    eSoldierView_Dismiss,
    eSoldierView_MAX
};
struct TSoldierHeader
{
    var TText txtName;
    var TText txtNickname;
    var TLabeledText txtStatus;
    var TLabeledText txtOffense;
    var TLabeledText txtDefense;
    var TLabeledText txtHP;
    var TLabeledText txtSpeed;
    var TLabeledText txtWill;
    var TLabeledText txtStrength;
    var TLabeledText txtCritShot;
    var TText txtOffenseMod;
    var TText txtDefenseMod;
    var TText txtHPMod;
    var TText txtSpeedMod;
    var TText txtWillMod;
    var TText txtStrengthMod;
    var TText txtCritShotMod;
};

struct TSoldierDoll
{
    var int iFlag;
    var TImage imgFlag;
    var TImage imgSoldier;
};

struct TSoldierMainMenu
{
    var array<int> arrOptions;
    var TMenu mnuOptions;

};

struct TSoldierAbilities
{
    var TTableMenu tblAbilities;

};

struct TSoldierPerks
{
    var TText txtNickname;
    var TTableMenu tblNewPerks;
};

struct TInventoryOption
{
    var int iOptionType;
    var bool bHighlight;
    var bool bShowItemCard;
    var bool bInfinite;
    var TImage imgItem;
    var TText txtName;
    var TText txtLabel;
    var TText txtQuantity;
    var string strHelp;
    var int iState;
    var int iSlot;
    var int iItem;
};

struct TSoldierGear
{
    var TText txtTitle;
    var int iHighlight;
    var bool bDataDirty;
    var array<TInventoryOption> arrOptions;

};

struct TSoldierLocker
{
    var TText txtTitle;
    var TText txtMsg;
    var int iHighlight;
    var bool bIsSelected;
    var array<TInventoryOption> arrOptions;

};

struct TAbilityTree
{
    var TText txtName;
    var TText txtLabel;
    var int branch;
    var int Option;
    var array<int> arrOptions;
    var string testVar;
};

var const localized string m_strDismissSoldierDialogTitle;
var const localized string m_strDismissSoldierDialogText;
var const localized string m_strDismissTankDialogTitle;
var const localized string m_strDismissTankDialogText;
var const localized string m_strLockedAbilityLabel;
var const localized string m_strLockedAbilityDescription;
var const localized string m_strLockedGeneModDescription;
var const localized string m_strLockedPsiAbilityDescription;
var TSoldierHeader m_kHeader;
var TSoldierMainMenu m_kMainMenu;
var TSoldierDoll m_kDoll;
var TSoldierAbilities m_kAbilities;
var TSoldierPerks m_kPerks;
var TSoldierGear m_kGear;
var TSoldierLocker m_kLocker;
var XGStrategySoldier m_kSoldier;
var TButtonBar m_kButtonBar;
var TAbilityTree m_kSoldierAbilityTree;
var TAbilityTree m_kSoldierPsiTree;
var bool m_bUrgeGollop;
var bool m_bPreventSoldierCycling;
var bool m_bReturnToDebriefUI;
var bool m_bCovertOperativeMode;
var const localized string m_strLabelPressRTForPromote;
var const localized string m_strLabelStatus;
var const localized string m_strLabelOffense;
var const localized string m_strLabelDefense;
var const localized string m_strLabelHPSPACED;
var const localized string m_strLabelMobility;
var const localized string m_strLabelWill;
var const localized string m_strLabelStrength;
var const localized string m_strLabelCritical;
var const localized string m_strLoadout;
var const localized string m_strNoEditSHIV;
var const localized string m_strNoEditAwaySoldiers;
var const localized string m_strChooseEquipGoop;
var const localized string m_strLabelAbilities;
var const localized string m_strLabelAbilityHelp;
var const localized string m_strLabelPsiAbilities;
var const localized string m_strLabelPsiAbilityHelp;
var const localized string m_strLabelCustomize;
var const localized string m_strLabelCustomizeHelp;
var const localized string m_strLabelDismiss;
var const localized string m_strLabelDismissHelp;
var const localized string m_strLabelTankDismiss;
var const localized string m_strLabelTankDismissHelp;
var const localized string m_strLabelGeneView;
var const localized string m_strLabelGeneViewHelp;
var const localized string m_strLabelLocker;
var const localized string m_strLabelNoneAvailable;
var const localized string m_strLabelRequiresResearch;
var const localized string m_strLabelClassTypeOnly;
var const localized string m_strLabelItemUnavailableToClass;
var const localized string m_strLabelUnavailableToVolunteer;
var const localized string m_strLabelUniqueEquip;
var const localized string m_strLabelPrevSoldier;
var const localized string m_strLabelNextSoldier;
var const localized string m_strLabelReaperRoundsRestriction;
var const localized string m_strLabelGeneModHotLink;
var const localized string m_strLabelGeneModConfirm;
var const localized string m_strLabelMedals;
var const localized string m_strLabelMedalsHelp;
var const localized string m_strArmor;
var const localized string m_strPistol;
var const localized string m_strLargeItem;
var const localized string m_strSmallItem;
var const localized string m_strEmpty;
var const localized string m_strNoEditWoundedSoldiers;
var const localized string m_strNoDismissWoundedSoldiers;
var const localized string m_strNoDismissWhilePsiTesting;
var const localized string m_strNoDismissWhileAugmenting;
var const localized string m_strNoDismissWhileGeneModding;
var const localized string m_strNoDismissCovertOperative;
var const localized string m_strNoDismissVolunteer;
var float m_fSoldierSwitchCount;

function Init(int iView){}
event Destroyed(){}
simulated function bool IsInCovertOperativeMode(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus();
simulated function SetActiveSoldier(XGStrategySoldier Soldier){}
simulated function CheckSoldierIsLoaded(){}
simulated function SetAbilityTreeBranch(int setBranch){}
simulated function SetAbilityTreeOption(int setOption){}
simulated function int GetAbilityTreeBranch(){}
simulated function int GetAbilityTreeOption(){}
simulated function RotateSoldier(int Dir){}
function UpdateView(){}
function OnMainMenuOption(int iOption){}
function DEBUG_ShowTempMedalsPopup(){}
function DEBUG_ShowTempMedalsPopupCallback(UIDialogueBox.EUIAction eAction){}
function OnDismissSoldier(){}
function DismissSoldierActionCallback(UIDialogueBox.EUIAction eAction){}
function OnLeaveSoldierUI(){}
function OnLeavePromotion(){}
function OnLeaveSoldierDebrief(){}
function bool PreviousPerksToAssign(){}
function bool OnAcceptPromotion(){}
function bool CanPromote(){}
function OnPromotionRight(){}
function OnPromotionLeft(){}
function OnPromotionUp(){}
function OnPromotionDown(){}
function OnLevelUp(){}
function OnPsiLevelUp(){}
function bool ShouldAutoAssignPerk(out int iBranchToAssign){}
function int GetHighlightedPerk(){}
function string GetHighlightedPromoPerkName(){}
function string GetHighlightedPerkDescription(){}
function int GetPerkUnlockedAbility(int iPerk){}
simulated function Tick(float DeltaTime){}
function bool OnNextSoldier(optional bool includeSHIV, optional bool SkipSpecial, optional bool includeMEC){}
function bool OnPrevSoldier(optional bool includeSHIV, optional bool SkipSpecial, optional bool includeMEC){}
function int CycleSoldierIndex(int Direction, bool checkForPsi, optional bool includeTank, optional bool SkipSpecial, optional bool includeMEC){}
function OnLeaveGear(optional bool bForceQuit){}
function bool OnUnequipGear(optional int iGear){}
function OnGearAccept(){}
function OnGearDown(){}
function OnGearUp(){}
function OnClickGear(int iTarget){}
function UpdateHeader(){}
function UpdateMainMenu(){}
function UpdateAbilities(){}
final function string GetMedalName(XGGameData.EItemType ePerk){}
function UpdateDoll(){}
function bool IsSlotValid(XGFacility_Lockers.EInventorySlot eSlot){}
function UpdateGear(){}
function UpdateLocker(){}
function TItemCard SOLDIERUIGetItemCard(){}
function XGItemTree ITEMTREE(){}
function int GetItemCharges(XGGameData.EItemType eItem, optional bool bForce1_for_NonGrenades, optional bool bForItemCardDisplay){}
function TItemCard GetItemCardFromOption(TInventoryOption kItemOp){}
function TInventoryOption BuildInventoryOption(int iItem, int iOptionType, bool bHighlight){}
function TInventoryOption BuildLockerOption(TLockerItem kItem, int iOptionType){}
function string GetItemTypeName(XGGameData.EItemType iItem){}
function bool OnEquip(int iInventory, int iLocker){}
function UpdateButtonHelp(){}
function int GetCritDmgFromBaseDmg(int Dmg){}
simulated function OnLaunchCovertMission(){}
final simulated function int GetCurrentCountry(){}
