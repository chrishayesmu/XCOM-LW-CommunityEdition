class Highlander_UIPauseMenu extends UIPauseMenu;

simulated function RestartMissionDialgoueCallback(EUIAction eAction)
{
    local Highlander_XGBattleDesc kDesc;

    if (eAction == eUIAction_Accept)
    {
        `PRES.m_kNarrative.RestoreNarrativeCounters();
        controllerRef.ClientTravel("?restart", TRAVEL_Relative);

        kDesc = Highlander_XGBattleDesc(XGBattle_SP(`BATTLE).GetDesc());
        kDesc.m_kArtifactsContainer.Delete(`LW_ITEM_ID(WeaponFragment));
    }
}