class XGMission_AlienBase extends XGMission
    config(GameData)
    notplaceable
    hidecategories(Navigation);

function int GetMainSpecies()
{
    return m_kDesc.m_kAlienInfo.iPodLeaderType;
    //return ReturnValue;    
}
