class Highlander_XGBattle_SPCovertOpsExtraction extends XGBattle_SPCovertOpsExtraction;

// IMPORTANT: This function is an override of a function in XGBattle_SP. Since we can't modify the inheritance hierarchy,
// this function has been inserted into each Highlander child class override of XGBattle_SP.
// ***If you modify this function, apply the changes in all child classes as well!***
function InitDescription()
{
    local XGNarrative kNarr;

    if (m_kTransferSave != none)
    {
        m_kDesc = m_kTransferSave.m_kBattleDesc;
        m_kDesc.InitAlienLoadoutInfos();
        PRES().SetNarrativeMgr(m_kDesc.m_kDropShipCargoInfo.m_kNarrative);

        if (class'Engine'.static.GetCurrentWorldInfo().GetMapName() == "DLC1_1_LowFriends")
        {
            PRES().UIPreloadNarrative(XComNarrativeMoment(DynamicLoadObject("NarrativeMomentsDLC60.DLC1_M01_ZhangIntroCin", class'XComNarrativeMoment')));
        }
    }
    else
    {
        m_kDesc = Spawn(class'Highlander_XGBattleDesc');
        m_kDesc.m_iNumPlayers = m_iNumPlayers;
        m_kDesc.Generate();
        m_kDesc.InitHumanLoadoutInfosFromProfileSettingsSaveData(m_kProfileSettings);
        m_kDesc.InitCivilianContent(m_kProfileSettings);
        m_kDesc.InitAlienLoadoutInfos();
        m_kDesc.m_kDropShipCargoInfo.m_arrSoldiers = m_kProfileSettings.m_aSoldiers;

        if (PRES().m_kNarrative == none)
        {
            kNarr = Spawn(class'Highlander_XGNarrative');
            kNarr.InitNarrative();
            PRES().SetNarrativeMgr(kNarr);
        }
    }

    InitDifficulty();
}