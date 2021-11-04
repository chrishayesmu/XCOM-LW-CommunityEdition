class XGShip_Interceptor extends XGShip
    hidecategories(Navigation)
    config(GameData)
    notplaceable;
//complete stub

struct CheckpointRecord_XGShip_Interceptor extends CheckpointRecord
{
    var string m_strCallsign;
    var EItemType m_eWeapon;
    var int m_iConfirmedKills;
    var float m_fFlightTime;
    var XGInterception m_kEngagement;
    var int m_iHoursDown;
    var int m_iHomeContinent;
    var int m_iHomeBay;
};

var string m_strCallsign;
var EItemType m_eWeapon;
var int m_iConfirmedKills;
var float m_fFlightTime;
var XGInterception m_kEngagement;
var int m_iHoursDown;
var int m_iHomeContinent;
var int m_iHomeBay;
var XGHangarShip m_kHangarShip;
var const localized string m_strValueDays;
var const localized string m_strValueHours;
var const localized string m_strLabelReady;


function Update(float fDeltaT){}
function bool CanPlayEngineSound(){}
function OnArrival() {}
function Hunt(XGInterception kInterception) {}
function Vector2D GetHomeCoords() {}
function ReturnToBase() {}
function ConsumeFuel(float fFlightTime){}
function float GetFuelPct() {}
function float GetHPPct() {}
function Init(TShip kTShip){}
function InitSound(){}
function EquipWeapon(EItemType eItem){}
function UpdateHangarShip(){}
function XGHangarShip GetWeaponViewShip(){}
function XGHangarShip GetHangarShip(){}
function DestroyHangarShip(){}
function string GetCallsign() {}
function bool IsFirestorm() {}
function TShipUIInfo GetUIInfo(){}
function string GetWeaponString() {}
function EItemType GetWeapon() {}
function bool IsHumanShip() {}
function int GetStatus() {}
function string GetStatusString() {}
