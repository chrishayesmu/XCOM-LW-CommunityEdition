class XGMedalsUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EMedalsView
{
    eMedalsView_Main,
    eMedalsView_EditMedal,
    eMedalsView_AssignPower,
    eMedalsView_SoldierList,
    eMedalsView_EditMedalName,
    eMedalsView_MAX
};

enum EMedalsEditingOptions
{
    eMedalsEditing_Rename,
    eMedalsEditing_Assign,
    eMedalsEditing_Award,
    eMedalsEditing_MAX
};

struct TMedalMainMenuItem
{
    var EMedalType Type;
    var string strName;
    var string Status;
    var bool bIsLocked;
};

struct TMedalEditing
{
    var array<int> arrOptions;
    var TMenu mnuOptions;
    var string m_tMedalEditingHelp;
    var string m_tMedalEditingSubtitle;
    var string m_tMedalEditingSubtitle2;
};

struct TMedalPower
{
    var string Name;
    var string Desc;
    var EPerkType Type;
};

struct TMedalAssignPower
{
    var string Title;
    var TMedalPower P0;
    var TMedalPower P1;
};

struct TSoldierTable
{
    var TTableMenu mnuSoldiers;
};

var const localized string m_strTitleCurrentMedals;
var const localized string m_strTitleEditMedal;
var const localized string m_strTitleAssignPower;
var const localized string m_strAssignPopupTitle;
var const localized string m_strAssignPopupBody;
var const localized string m_strMedalMainMenuStatus;
var const localized string m_strMedalMainMenuLocked;
var const localized string m_strEdit_Rename;
var const localized string m_strEdit_AssignPower;
var const localized string m_strEdit_AlreadyAssigned;
var const localized string m_strEdit_PowerLabel;
var const localized string m_strEdit_AwardMedal;
var const localized string m_strEdit_NeedPowerHelp;
var const localized string m_strEdit_Help;
var const localized string m_strAssignPower1;
var const localized string m_strAssignPower2;
var const localized string m_strCustomizeNameDirections;
var const localized string m_sWarnPowerTitle;
var const localized string m_sWarnPowerBody;
var const localized string m_sConfirmAssignMedalTitle;
var const localized string m_sConfirmAssignMedalBody;
var array<TMedalMainMenuItem> m_arrMainMenu;
var TMedalEditing m_kEditMenu;
var TSoldierTable m_kSoldierTable;
var TMedalAssignPower m_kPowerInfo;
var int m_iCurrentMedal;
var int m_iCurrentPower;
var int m_iCurrentSoldier;

function Init(int iView){}
function UpdateView(){}
function UpdateCurrentMedals(){}
function OnSelectCurrentMedal(int Index){}
function UpdateEditMedal(){}
function OnCustomizeName(optional string Text){}
function OnSelectEditOption(int Index){}
function UpdateAssignPower(){}
function OnSelectPower(int Index){}
function WarnAboutPower(){}
function ConfirmPowerSelection(EUIAction eAction){}
function ConfirmAwardMedal(){}
function OnMedalAwardConfirmed(EUIAction eAction){}
function UpdateSoldierList(){}
function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int iSoldierListIndex){}
function bool OnChooseSoldier(int iOption, optional int iSelectedRow, optional int iSelectedCol){}
function OnLeaveSoldierList(){}
function OnLeaveFacility(){}
function XComPerkManager PERKS(){}
