class XComTraceManager extends Actor
    native(Core)
    notplaceable
    hidecategories(Navigation);

enum EXComTraceType
{
    eXTrace_Screen,
    eXTrace_UnitVisibility,
    eXTrace_UnitVisibility_IgnoreTeam,
    eXTrace_UnitVisibility_IgnoreAllButTarget,
    eXTrace_CameraObstruction,
    eXTrace_World,
    eXTrace_AllActors,
    eXTrace_NoPawns,
    eXTrace_MAX
};

var XComTraceManager.EXComTraceType m_eCurrentType;
var ETeam m_eIgnoreTeam;
var Actor m_Target;