class XComTacticalGRI extends XComGameReplicationInfo
    native(Core)
    config(Game)
    hidecategories(Navigation,Movement,Collision);

enum EXComTacticalEvent
{
    PAWN_INDOOR_OUTDOOR,
    PAWN_SELECTED,
    PAWN_UNSELECTED,
    PAWN_CHANGED_FLOORS,
    PAWN_MAX
};

struct native XComDelegateListToEvent
{
    var EXComTacticalEvent EEvent;
    var array< delegate<XComTacticalDelegate> > DelegateList;
};

var XGCharacterGenerator m_CharacterGen;
var XGBattle m_kBattle;
var protected StrategyGameTransport m_kTransferSave;
var protected XComOnlineProfileSettings m_kProfileSettings;
var SimpleShapeManager mSimpleShapeManager;
var XComTraceManager m_kTraceMgr;
var XComPrecomputedPath m_kPrecomputedPath;
var class<XGPlayer> m_kPlayerClass;
var XComDirectedTacticalExperience DirectedExperience;
var array<XComDelegateListToEvent> TacticalDelegateLists;

delegate XComTacticalDelegate(Object Params)
{
}

defaultproperties
{
    m_kPlayerClass=class'XGPlayer'
    SoundManagerClassToSpawn=class'XComTacticalSoundManager'
}