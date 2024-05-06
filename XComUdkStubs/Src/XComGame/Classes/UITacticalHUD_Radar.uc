class UITacticalHUD_Radar extends UI_FxsPanel
    native(UI)
    notplaceable
    hidecategories(Navigation);

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
    var UITacticalHUD_Radar.eUIRadarBlipTypes Type;
    var Vector2D Loc;
};

var private XGUnitNativeBase m_kActiveUnit;
var private int m_iCurrUnitsSightRadius;
var private Vector m_vNormalizedCamLook;
var private array<TUIRadarBlip> m_arrBlips;
var private int m_hCamWatchHandle;
var private int m_hEnemyArrWatchHandle;

defaultproperties
{
    s_name="theRadarMC"
}