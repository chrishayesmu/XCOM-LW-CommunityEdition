class UITacticalHUD_Radar extends UI_FxsPanel
    native(UI)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum eUIRadarBlipTypes
{
    eBlipType_None,
    eBlipType_Friendly,
    eBlipType_FriendlyHurt,
    eBlipType_FriendlyDead,
    eBlipType_Opponent,
    eBlipType_Civilian,
    eBlipType_Item,
    eBlipType_ActiveNode,
    eBlipType_InactiveNode,
    eBlipType_Unknown,
    eBlipType_MAX
};

struct native TUIRadarBlip
{
    var Actor TargetActor;
    var eUIRadarBlipTypes Type;
    var Vector2D Loc;
};

var XGUnitNativeBase m_kActiveUnit;
var int m_iCurrUnitsSightRadius;
var Vector m_vNormalizedCamLook;
var array<TUIRadarBlip> m_arrBlips;
var int m_hCamWatchHandle;
var int m_hEnemyArrWatchHandle;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function Show(){}
simulated function Hide(){}
simulated function ActivateRadarTracking(){}
simulated function DeactivateRadarTracking(){}
simulated function EnableDisableCameraWatch(bool bEnable){}
simulated function UpdateActiveUnit(){}
simulated function UpdateBlips(){}
function UpdateCameraOrientation(){}
event UpdateCamLook(){}
function AS_SetRotation(float Angle){}
function AS_UpdateBlips(string Param){}
native simulated function int UpdateBlipByType(Actor pawnObj, eUIRadarBlipTypes blipType);
native simulated function int FindBlip(Actor _unit);
native simulated function CalculateRadarPosition(out TUIRadarBlip blip);
