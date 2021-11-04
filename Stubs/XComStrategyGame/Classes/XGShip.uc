class XGShip extends XGStrategyActor;
//complete stub

struct CheckpointRecord
{
    var TShip m_kTShip;
    var Vector2D m_v2Coords;
    var Vector2D m_v2Destination;
    var Vector m_vHeading;
    var int m_iHP;
    var XGMission m_kMission;
    var int m_iStatus;
    var XGEntity m_kEntity;
    var XGGeoscape m_kGeoscape;
};

var TShip m_kTShip;
var int m_iStatus;
var Vector2D m_v2Coords;
var Vector2D m_v2Destination;
var Vector m_vHeading;
var int m_iHP;
var XGMission m_kMission;
var array<float> m_afWeaponCooldown;
var export editinline AudioComponent m_sndEngine;
var float m_fExpectedFlightTime;
var float m_fAdjustedFlightTime;
var float m_fCurrentFlightTime;
var XGGeoscape m_kGeoscape;
var const localized string m_strPostFixMPH;
var const localized string m_strPostFixMiles;

function Update(float fDeltaT);
function InitSound();
function UpdateWeapons(float fDeltaT){}
function ResetWeapons(){}
function Init(TShip kTShip){}
function InitWatchVariables(){}
function UpdateEngineSound(){}
function bool CanPlayEngineSound(){}
function int GetHP(){}
function bool IsDamaged(){}
function Vector2D GetCoords(){}
function bool IsFlying(){}
function int GetStatus(){}
function string GetStatusString(){}
function TShipUIInfo GetUIInfo(){}
function int GetStatusUIState(){}
function SetMission(XGMission kMission){}
function EShipType GetType(){}
function int GetSpeed(){}
function int GetRange(){}
function int GetHullStrength(){}
function array<TShipWeapon> GetWeapons(){}
function Vector2D GetScreenSpeedPerSecond(){}
function string GetSpeedString(){}
function bool IsAlienShip(){}
function bool IsHumanShip(){}
