class LWCE_XGMission_AlienBase extends LWCE_XGMission;

function int GetMainSpecies()
{
    return m_kDesc.m_kAlienInfo.iPodLeaderType;
}

defaultproperties
{
    m_iDetectedBy=-1
}