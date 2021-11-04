class XGInterceptionEngagement extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);

const cfMovementPerSecond = -5.0;

struct CombatExchange
{
    var int iSourceShip;
    var int iWeapon;
    var int iTargetShip;
    var bool bHit;
    var int iDamage;
    var float fTime;

};

struct Combat
{
    var array<CombatExchange> m_aInterceptorExchanges;
    var array<CombatExchange> m_aUFOExchanges;

};

var XGInterception m_kInterception;
var Combat m_kCombat;
var array<int> m_aiShipHP;
var array<float> m_afShipDistance;
var float m_fTimeElapsed;
var int m_iPlaybackIndex;
var float m_fEncounterStartingRange;
var array<int> m_aiConsumableQuantitiesInEffect;
var float m_fInterceptorTimeOffset;
var int m_iUFOTarget;
var array<int> m_aiConsumablesUsed;

function Init(XGInterception kInterception){}
function float GetTimeUntilOutrun(int iShip){}
function float GetPosition(int iShip, float fTimeElapsed){}
function UpdatePositions(){}
function UpdateWeapons(float fDeltaT){}
function int GetShipDamage(TShipWeapon SHIPWEAPON, CombatExchange comExchange){}
function float GetDamageMitigation(TShipWeapon SHIPWEAPON, CombatExchange comExchange){}
function UpdateSim(float fDeltaT){}
function XGShip GetShip(int iIndex){}
function int GetNumShips(){}
function int GetNumPlayerShips(){}
function bool IsShipDead(int iShip){}
function bool IsShipOutrun(int iShip){}
function bool IsUFODead(){}
function bool AnyAllInterceptorsDead(){}
function bool AnyInterceptorsChasing(){}
//below to be moved to SUInterceptionEngagement
//---------------------------------------------
function string GetSquadronStatusBrief(){}
//---------------------------------------------
function float FindNextWeaponTime(){}
function bool IsUfo(int iShip){}
function bool IsAnyWeaponInRange(int iShip){}
function bool AreAllWeaponsInRange(int iShip){}
function float GetShortestWeaponRange(int iShip){}
function float GetEncounterStartingRange(){}
function StaggerWeaponsForShip(int iShip){}
function bool IsConsumable(int iItemType){}
function bool IsConsumableAvailable(int iItemType){}
function bool IsConsumableResearched(int iItemType){}
function bool CanUseConsumable(int iItemType){}
function UseConsumable(int iItemType, float fPlaybackTime){}
function bool HasConsumableBeenUsed(int iItemType){}
function int GetNumConsumableInEffect(int iItemType){}
function bool IsConsumableInEffect(int iItemType){}
function UseConsumableEffect(int iItemType){}
function Combat GetCombat(){}
function UpdateEngagementResult(float fElapsedTime){}
function SetBoostAdjustedTimeOffset(float fPlaybackTimeElapsed){}

