class XComHeadquartersInput extends XComInputBase within XComHeadquartersController;

var Vector2D m_fFreeMovementMouseScrollRate;
var bool m_bDisableAccept;
var bool m_bDisableCancel;
var bool m_bDisableLeftStick;
var bool m_bDisableRightStick;
var bool m_bDisableDPad;
var bool m_bDisableBumpers;
var bool m_bDisableSelect;
var bool m_bDisableStart;
var bool m_bMouseDraggingGeoscape;
var bool mIsCameraMoved;
var bool m_bIsDoubleClick;
var bool isDebugZoomOut;
var XGGameData.EFacilityType centeredFacility;

simulated function ProcessSoldierRotation(){}
function bool EscapeKey(int Actionmask){}
function bool Start_Button(int Actionmask){}
function bool Key_F10(int Actionmask){}
function bool CheckForFacilityClick(){}

function bool IsMouseInHUDArea(){}
function bool LDoubleClick(int Actionmask){}


DefaultProperties
{
}
