class XComSpecialMissionHandler_ChrysHive extends XComSpecialMissionHandler
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XComSpecialMissionHandler_ChrysHive extends CheckpointRecord
{
    var TriggerVolume kTheOne;
    var array<XGUnit> m_arrEnemiesSeen;
};

var TriggerVolume kVolume;
var TriggerVolume kTheOne;
var array<XGUnit> m_arrEnemiesSeen;