class UISoldierGeneMods extends UI_FxsScreen
	implements(IScreenMgrInterface)
	dependsOn(XGTacticalGameCoreNativeBase);

const MAX_COLS = 2;
const MAX_ROWS = 5;
const UNKNOWN_ICON_LABEL = "unknown";
const GENE_IMAGE_PATH = "img:///UILibrary_StrategyImages.GeneMods.GeneMods_";

var const localized string m_strScreenTitle;
var const localized string m_strImplantActionLabel;
var const localized string m_strImplantActionLabelPC;
var const localized string m_strRemoveActionLabel;
var const localized string m_strRemoveActionLabelPC;
var const localized string m_strInsufficientResourcesActionLabel;
var const localized string m_strConfirmNotificationTitle;
var const localized string m_strConfirmNotificationDescription;
var const localized string m_strConfirmNotificationDescriptionWithRemovedGenes;
var const localized string m_strViewOnlyNotificationTitle;
var const localized string m_strViewOnlyNotificationTitleNoEdit;
var const localized string m_strViewOnlyNotificationDescription;
var const localized string m_strViewOnlyNotificationNoSlotsDescription;
var const localized string m_strViewOnlyNotificationInSquadSelectDescription;
var const localized string m_strPopupGoToGeneLab;
var const localized string m_strHasOppositeGeneModNotificationTitle;
var const localized string m_strHasOppositeGeneModNotificationDescription;
var const localized array<localized string> m_strCategoryTitles;
var XGSoldierUI m_kLocalMgr;
var name DisplayTag;
var string m_strCameraTag;
var const array<string> m_arrPerkSoundCues;
var XGTechTree m_kTechTree;
var XComPerkManager m_kPerkMgr;
var XGStrategySoldier m_kSoldier;
var XGFacility_GeneLabs m_kGeneLabs;
var UIStrategyComponent_SoldierInfo m_kSoldierHeader;
var UIStrategyComponent_SoldierStats m_kSoldierStats;
var UIStrategyComponent_SoldierAbilityList m_kAbilityList;
var bool m_bViewOnly;
var int m_iSelectedRow;
var int m_iSelectedColumn;
var array<EPerkType> m_arrSelectedPerks;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager, bool viewGenesOnly, int iSelectedRow, int iSelectedCol){}
simulated function XGSoldierUI GetMgr(optional int iStaringView){}
simulated function Actor FindActorByTag(class<Actor> kBaseClass, name nTag){}
simulated function ShowXRayView(){}
simulated function MatchCameras(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateAbilityData(){}
simulated function PlayGeneModSoundCue(EGeneModTech eGeneMod){}
simulated function RealizeSelected(optional bool bFirstCall){}
simulated function string GetRequiredMeldStr(int requiredMeld, bool insufficientMeld){}
simulated function string GetRequiredCashStr(int requiredCash, bool insufficientCash){}
simulated function UpdateButtonHelp(){}
simulated function HotlinkGeneLab(){}
simulated function UpdateResources(){}
simulated function OnReceiveFocus(){}
simulated function OnMousePrevSoldier(){}
simulated function PrevSoldier(){}
simulated function OnMouseNextSoldier(){}
simulated function NextSoldier(){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function EquipSelectedMods(EUIAction eAction){}
simulated function array<EGeneModTech> GetGeneTechArray(){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function BackOutOfScreen(optional bool bPopSoldierList){}
simulated function ShowConfirmNotification(){}
simulated function string GetGenesToBeEquipped(){}
simulated function string GetGenesToBeRemoved(){}
simulated function ShowViewOnlyNotification(){}
simulated function ViewOnlyNotificationCallback_JumpRequest(UIDialogueBox.EUIAction eAction){}
simulated function bool IsSpaceAvailableInGeneLab(){}
simulated function bool IsSoldierAvailableForGeneLab(){}
simulated function int GetTotalMoneyCost(optional TGeneModTech geneTechData){}
simulated function int GetTotalMeldCost(optional TGeneModTech geneTechData){}
simulated function int GetTotalTimeCost(){}
simulated function bool CanAffordSelectedGeneMods(){}
simulated function Remove(){}
simulated function AS_InitializeTree(string treeTitleLabel){}
simulated function AS_SetIcon(int Row, int column, string iconLabel, string bgColor, bool isFaded){}
simulated function AS_ToggleCheckedIcon(int Row, int column, optional bool overrideOppositePerk){}
simulated function AS_SetRowData(int ColumnIndex, string Label, bool isLocked){}
simulated function AS_SetSelectedIcon(int Row, int column){}
simulated function AS_SetDescription(string abilityName, string abilityDescription){}
simulated function AS_SetImplantButtonHelp(string buttonLabel, string buttonIcon){}
simulated function AS_SetConfirmButtonHelp(string buttonLabel, string buttonIcon){}
simulated function AS_SetRequirements(string meldLabel, string cashLabel){}
simulated function AS_SetCalloutImage(string img){}
function OnDeactivate(){}
event Destroyed(){}
