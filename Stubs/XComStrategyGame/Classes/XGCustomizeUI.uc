class XGCustomizeUI extends XGScreenMgr
    config(Game)
    notplaceable
    hidecategories(Navigation);

const SPINNER_LANGUAGE = 3;
const SPINNER_VOICE = 4;
const SPINNER_RACE = 5;
const SPINNER_HEAD = 6;
const SPINNER_SKINCOLOR = 7;
const SPINNER_HAIR = 8;
const SPINNER_HAIRCOLOR = 9;
const SPINNER_FACIALHAIR = 10;
const SPINNER_ARMORDECAL = 11;
const SPINNER_ARMORTINT = 12;

enum ECustomView
{
    eCustomView_MainMenu,
    eCustomView_Name,
    eCustomView_MAX
};

enum ENameCustomizationOptions
{
    eCustomizeName_First,
    eCustomizeName_Last,
    eCustomizeName_Nick,
    eCustomizeName_MAX
};

enum EEasterEggCharacter
{
    eEEC_None,
    eEEC_Sid,
    eEEC_Ken,
    eEEC_Otto,
    eEEC_Joe,
    eEEC_Carter,
    eEEC_Chris,
    eEEC_MAX
};

struct TCustomHeader
{
    var TText txtTitle;
    var TImage imgFlag;
    var TText txtName;
    var TText txtNickname;
};

struct TCustomMainMenu
{
    var TMenu mnuOptions;
};

struct TCustomName
{
    var TMenu mnuOptions;
};

struct TCustomFaceGraph
{
    var int iSkin;
    var int iFace;
    var array<TGraphNode> arrSkinNodes;
    var array<TGraphNode> arrFaceNodes;
};

struct TCustomHairGraph
{
    var int iStyle;
    var int iColor;
    var array<TGraphNode> arrStyleNodes;
    var array<TGraphNode> arrColorNodes;
};

var const localized string m_strFirstNameButton;
var const localized string m_strLastNameButton;
var const localized string m_strNickNameButton;
var const localized string m_strCountrySpinner;
var const localized string m_strRaceSpinner;
var const localized string m_strVoiceSpinner;
var const localized string m_strLanguageSpinner;
var const localized string m_strAttitudeSpinner;
var const localized string m_strHeadSpinner;
var const localized string m_strHairSpinner;
var const localized string m_strSkinColorSpinner;
var const localized string m_strHairColorSpinner;
var const localized string m_strFacialHairSpinner;
var const localized string m_strArmorDecalSpinner;
var const localized string m_strArmorTintSpinner;
var const localized string m_strLabelFirstName;
var const localized string m_strLabelFirstNameHelp;
var const localized string m_strLabelLastName;
var const localized string m_strLabelLastNameHelp;
var const localized string m_strLabelNickname;
var const localized string m_strLabelNicknameHelp;
var const localized string m_strLabelCustomizeName;
var const localized string m_strLabelCustFirstName;
var const localized string m_strLabelCustFirstNameHelp;
var const localized string m_strLabelCustLastName;
var const localized string m_strLabelCustLastNameHelp;
var const localized string m_strLabelCustNickname;
var const localized string m_strLabelCustNicknameHelp;
var const localized string m_strErrEarnNicknameFirst;
var const localized string m_strNoDecoAvailableForThisArmor;
var const localized string m_strAttitudeProfessional;
var const localized string m_strAttitudeBrash;
var const localized string m_strEasterEggTitle;
var const localized string m_strEasterEggBody;
var const localized string m_strEasterEggBodyPS3;
var const localized string m_strEasterEggOK;
var const localized string m_strEasterEggCancel;
var const localized string m_strNoArmorTint;
var const localized array<localized string> SuperSoldierFirstNames;
var const localized array<localized string> SuperSoldierLastNames;
var const localized array<localized string> SuperSoldierNickNames;
var TCustomHeader m_kHeader;
var TCustomName m_kName;
var TCustomMainMenu m_kMainMenuButtonOptions;
var TCustomMainMenu m_kMainMenuSpinnerOptions;
var EEasterEggCharacter m_eEEC;
var XGStrategySoldier m_kSoldier;
var XComHumanPawn m_kPawn;
var int m_iWaitingForVirtualKeyboard;
var bool m_bSwitchedSoldier;

function Init(int iView){}
function SetActiveSoldier(XGStrategySoldier NewSoldier){}
simulated function Tick(float DeltaTime){}
simulated function OnDeactivate();
function UpdateView(){}
function OnMainMenuOption(int iOption);
function bool OnInputPadLeft(int SelectedIndex){}
function bool OnInputPadRight(int SelectedIndex){}
function bool OnPlayVoice(int SelectedIndex){}
function bool AdvanceFeature(int Feature, int Dir){}
function AdvanceRace(int Dir){}
function int GetRaceIndex(){}
function AdvanceHead(int Dir){}
function int GetHeadIndex(){}
function AdvanceHair(int Dir){}
function int GetHairIndex(){}
function AdvanceHairColor(int Dir){}
function int GetHairColorIndex(){}
function AdvanceSkinColor(int Dir){}
function int GetSkinColorIndex(){}
function AdvanceFacialHair(int Dir){}
function int GetFacialHairIndex(){}
function AdvanceArmorTint(int Dir){}
function int GetArmorTintIndex(){}
function AdvanceArmorDeco(int Dir){}
function int GetArmorDecoIndex(){}
function AdvanceVoice(int Dir){}
function int GetVoiceIndex(){}
function AdvanceLanguage(int Dir){}
function int GetLanguageIndex(){}
simulated function RotateSoldier(int Dir){}
function OnLeaveNameView(){}
function UpdateHeader(){}
function UpdateMainMenu(){}
function UpdateNameView(){}
function OnKeyboardInputComplete(bool bWasSuccessful){}
function OnChooseNameOption(int iOption){}
function CheckForSuperSoldier(){}
function EEasterEggCharacter GetEasterEggChar(){}
function CreateEasterEggCharacter(EEasterEggCharacter eChar){}
function ConfirmEasterEggDialogue(){}
simulated function ConfirmEasterEggCallback(EUIAction eAction){}
