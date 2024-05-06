class XGAIPlayer_Animal extends XGAIPlayer
    native(AI)
    notplaceable
    hidecategories(Navigation);

const MAX_SPAWN_DIST_FROM_PODS = 960;

var bool m_bSkipAnimals;
var bool m_bSpawningSurvivor;
var array<XGUnit> m_akMovingUnit;
var(Terror) array<XGUnit> m_arrCivilian;
var(Terror) int m_nDeadCivilians;
var(Terror) int m_nLiveCivilians;
var(Terror) int m_nSavedCivilians;
var(Terror) int m_nHiddenCivilians;
var(Terror) array<XGUnit> m_arrHiddenCivilian;
var(Salvage) array<XGUnit> m_arrSurvivor;
var array<Vector> m_arrPodLoc;
var const localized string m_strCivilianSaved;
var const localized string m_strSurvivorRescued;

delegate bool CoverValidator(Vector vCoverLoc, XComCoverPoint kPoint)
{
}

defaultproperties
{
    m_fDefaultMinEngageRange=256.0
    m_eTeam=eTeam_Neutral
}