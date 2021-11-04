class XGGollopUI extends XGScreenMgr
    config(GameData);
//complete stub

enum EGollopView
{
    eGollopView_Main,
    eGollopView_Choose,
    eGollopView_MAX
};

struct TGollopUI
{
    var TButtonText btxtButton;
    var TText txtHelp;
};

struct TGollopList
{
    var TText txtTitle;
    var TTableMenu tmnuSoldiers;
    var array<XGStrategySoldier> arrVolunteers;
};

var TGollopUI m_kButton;
var TGollopList m_kList;
var XComNarrativeMoment lMoment;
var Vector kPlacement;
var const localized string m_strLabelUseProgenitorDevice;
var const localized string m_strPsiSoldierIsReady;
var const localized string m_strPsiSoldierIsWeak;
var const localized string m_strDeviceAlreadyUsed;
var const localized string m_strSelectSoldierForDevice;
var const localized string m_strGollopWarningTitle;
var const localized string m_strGollopWarningBody;
var const localized string m_strGollopWarningOK;
var const localized string m_strGollopWarningCancel;
var transient bool m_bAddedToMatinee;
var transient bool m_bCollideWorld;
var transient bool m_bCollideActors;
var transient bool m_bBlockActors;
var transient bool m_bIgnoreEncroachers;

function Init(int iView){}
function UpdateView(){}
function UpdateMain(){}
function UpdateVolunteerList(){}
function BuildVolunteerList(){}
function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories){}
function OnPressButton(){}
function OnLeaveFacility(){}
function OnChooseVolunteer(int iOption){}
function PostVolunteerMatinee(){}
function SendSoldierToChosenCinematic(){}
function SetGollupSoldierLighting(XComHumanPawn kPawn, LightingChannelContainer Lighting, bool disableDLE){}
function OnLeaveVolunteer(){}
simulated function OnLoseFocus(){}
simulated function OnReceiveFocus(){}
function GollopWarning(){}
function GollopWarningCallback(EUIAction eAction){}

state WaitingToStartVolunteerMatinee{
}
