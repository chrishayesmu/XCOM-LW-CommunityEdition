class XGMission_Abduction extends XGMission
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

simulated function string GetTitle()
{
    return m_strTitle;
}

defaultproperties
{
    m_iMissionType=2
}