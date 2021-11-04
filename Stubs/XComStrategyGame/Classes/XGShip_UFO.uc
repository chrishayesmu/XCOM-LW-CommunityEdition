class XGShip_UFO extends XGShip
    notplaceable;

enum EFlightPlanType
{
    eFlightPlan_Arrive,
    eFlightPlan_SpendTime,
    eFlightPlan_Land,
    eFlightPlan_FlyOver,
    eFlightPlan_Depart,
    eFlightPlan_LiftOff,
    eFlightPlan_MAX
};

enum EApproachType
{
    eApproach_SeekingLatitude,
    eApproach_SeekingLongitude,
    eApproach_MAX
};

var XGAlienObjective m_kObjective;
var int m_iDetectedBy;
var XGGameData.ECharacter m_eSpecies;
var XGShip_UFO.EApproachType m_eApproach;
var XGGameData.ECountry m_eCountryTarget;
var int m_iCounter;
var bool m_bEverDetected;
var bool m_bWasEngaged;
var bool m_bLanded;
var Vector2D m_v2Target;
var Vector2D m_v2Intermediate;
var array<int> m_arrFlightPlan;
var float m_fTimeInCountry;
var const localized string m_strAltitudeLow;
var const localized string m_strAltitudeHigh;
var const localized string m_strAltitudeVeryHigh;

function Update(float fDeltaT){}
function NotifyOfTakeOff(){}
function bool CanPlayEngineSound(){}
function OnArrival(){}
function Init(TShip kTShip){}
function InitSound(){}
function SetObjective(XGAlienObjective kObjective){}
function int GetContinent() {}
function int GetCountry() {}
function bool IsInCountry(){}
function SetFlightPlan(array<int> arrFlightPlan, Vector2D v2Target, XGGameData.ECountry eTargetCountry, float fFlightTime){}
function string GetHeadingString(){}
function string GetAltitudeString() {}
function string GetSizeString() {}
function int GetSpeed() {}
function bool IsDetected(){}
function SetDetection(int iDetector){}
function EFlightPlanType CurrentPlan(){}
function CalcNewWayPoint(){}
function CalculateSpendTime(TRect kBound){}
function CalculateFlyover(Vector2D v2Target, TRect kBound){}
function CalculateLanding(Vector2D v2Target, TRect kBound){}
function CalculateArrival(Vector2D v2Target, TRect kBound){}
function ChooseApproach(Vector2D v2Relative){}
function CalculateDeparture(TRect kBound){}
function CalculateLiftoff(){}
function AdjustHeading(){}
function bool IsAlienShip(){}
