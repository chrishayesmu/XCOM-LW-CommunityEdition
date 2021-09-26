class Highlander_XGStrategy extends XGStrategy;


function NewGame() {
    LogInternal(string(Class) $ " : (highlander override)");

    m_kWorld = Spawn(class'XGWorld');
    m_kGeoscape = Spawn(class'XGGeoscape');
    m_kHQ = Spawn(class'XGHeadQuarters');
    m_kAI = Spawn(class'XGStrategyAI');
    m_kRecapSaveData = Spawn(class'XGRecapSaveData');
    m_kExaltSimulation = Spawn(class'XGExaltSimulation');
    m_arrMissionTotals.Add(41);
    m_arrMissionTotals[30] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.20);
    m_arrMissionTotals[31] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70);
    m_arrMissionTotals[32] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.40);
    m_arrMissionTotals[35] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70);
    m_arrMissionTotals[36] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.50);
    m_kNarrative = Spawn(class'XGNarrative');

    m_kNarrative.InitNarrative(XComHeadquartersGame(WorldInfo.Game).m_bSuppressFirstTimeNarrative);

    m_arrItemUnlocks.Add(255);
    m_arrGeneModUnlocks.Add(11);
    m_arrFacilityUnlocks.Add(24);
    m_arrFoundryUnlocks.Add(48);
    m_arrSecondWave.Add(36);

    Init(false);
    GotoState('Initing');
}