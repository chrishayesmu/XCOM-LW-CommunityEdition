class XComTacticalHUD extends XComHUD
    transient
    config(Game)
    hidecategories(Navigation);

var array<XComBuildingVolume> m_arrBuildingVolumes;
var IMouseInteractionInterface mShootEnemyTrace;
var IMouseInteractionInterface m_InteractionInterface;