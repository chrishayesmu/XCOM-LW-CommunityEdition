class XGInterception extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EUFOResult
{
    eUR_NONE,
    eUR_Crash,
    eUR_Destroyed,
    eUR_Escape,
    eUR_Disengaged,
    eUR_MAX
};

struct CheckpointRecord
{
    var array<XGShip_Interceptor> m_arrInterceptors;
    var XGShip_UFO m_kUFOTarget;
    var EUFOResult m_eUFOResult;
};

var array<XGShip_Interceptor> m_arrInterceptors;
var XGShip_UFO m_kUFOTarget;
var EUFOResult m_eUFOResult;
var int m_iSquadronSpeed;
var bool m_bSimulatedCombat;

function Init(XGShip_UFO kTarget) {}

function bool CheckForGood() {}

function OnArrival() {}

function Launch() {}

function ReturnToBase(optional XGShip_Interceptor kJet) {}

function ToggleInterceptor(XGShip_Interceptor kInterceptor) {}

function bool HasInterceptor(XGShip_Interceptor kInterceptor) {}

function ClearOtherEngagements(XGShip_UFO kUFO) {}

function CompleteEngagement() {}

function Vector2D GetLookAt() {}
