class XGMission_ReturnToBase extends XGMission
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGMission_ReturnToBase extends CheckpointRecord
{
};

defaultproperties
{
    m_iMissionType=20
}