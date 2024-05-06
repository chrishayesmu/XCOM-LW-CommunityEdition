class UIControllerMap extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

enum ELayout
{
    eLayout_Battlescape,
    eLayout_MissionControl,
    eLayout_MAX
};

struct UIGamepadLabel
{
    var string Label;
};

var const localized string m_sController;
var const localized string m_sControllerPS3;
var const localized string m_sKeyboardAndMouse;
var const localized string m_sBattlescape;
var const localized string m_sMissionControl;
var const localized string m_sDone;
var const localized string m_sDefaults;
var const localized string m_sUnused;
var const localized string m_sTakeAction;
var const localized string m_sCancel;
var const localized string m_sSwapWeapons;
var const localized string m_sOverwatch;
var const localized string m_sMoveCursor;
var const localized string m_sPanCamera;
var const localized string m_sRotateCamera;
var const localized string m_sEndTurn;
var const localized string m_sPauseMenu;
var const localized string m_sNextUnit;
var const localized string m_sPrevUnit;
var const localized string m_sZoom;
var const localized string m_sTargetMode;
var const localized string m_sDetails;
var const localized string m_sHeightAdjust;
var const localized string m_sAccept;
var const localized string m_sCancelHQ;
var const localized string m_sAltChoice;
var const localized string m_sMainRoom;
var const localized string m_sSelectAnalogHQ;
var const localized string m_sPanCameraHQ;
var const localized string m_sSelectHQ;
var const localized string m_sDatabaseHQ;
var const localized string m_sNextUnitHQ;
var const localized string m_sPrevUnitHQ;
var const localized string m_sZoomHQ;
var const localized string m_sExpandEventList;
var const localized string m_sItemSelect;
var private UIControllerMap.ELayout layout;
var UIGamepadLabel UIGamePad[16];

defaultproperties
{
    s_package="/ package/gfxControllerMap/ControllerMap"
    s_screenId="gfxControllerMap"
    e_InputState=eInputState_Consume
    s_name="theControllerMap"
}