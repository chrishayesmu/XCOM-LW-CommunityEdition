class LWCE_UIPauseMenu extends UIPauseMenu;

var int m_optModSettings;

simulated function BuildMenu()
{
    local int iCurrent;
    local XComMPTacticalGRI kMPGRI;
    local XGBattle_SP kBattle;

    kMPGRI = XComMPTacticalGRI(WorldInfo.GRI);

    AS_SetTitle(m_sPauseMenu);
    AS_Clear();

    iCurrent = 0;
    m_optSave = -1;
    m_optLoad = -1;
    m_optReturnToGame = ++iCurrent;

    AS_AddOption(m_optReturnToGame, m_sReturnToGame, eUIState_Normal);

    if (kMPGRI == none)
    {
        if (m_bIsIronman)
        {
            if (m_bAllowSaving)
            {
                m_optSave = ++iCurrent;
                AS_AddOption(m_optSave, m_sSaveAndExitGame, eUIState_Normal);
            }
        }
        else
        {
            if (m_bAllowSaving)
            {
                m_optSave = ++iCurrent;
                AS_AddOption(m_optSave, m_sSaveGame, eUIState_Normal);
            }

            m_optLoad = ++iCurrent;
            AS_AddOption(m_optLoad, m_sLoadGame, eUIState_Normal);
        }
    }

    if (manager.IsMouseActive())
    {
        m_optControllerMap = -1;
    }
    else
    {
        m_optControllerMap = ++iCurrent;
        AS_AddOption(m_optControllerMap, m_sControllerMap, eUIState_Normal);
    }

    m_optOptions = ++iCurrent;
    AS_AddOption(m_optOptions, m_sInputOptions, eUIState_Normal);

    // LWCE: add custom option for mods
    m_optModSettings = ++iCurrent;
    AS_AddOption(m_optModSettings, "Mod Settings", eUIState_Normal);

    if (kMPGRI == none)
    {
        if (XComPresentationLayer(controllerRef.m_Pres) != none)
        {
            if (!m_bIsIronman || `GAMECORE.IsOptionEnabled(/* Bronzeman Mode */ 16))
            {
                m_optRestart = ++iCurrent;
                AS_AddOption(m_optRestart, m_sRestartLevel, eUIState_Normal);
            }
            else
            {
                m_optRestart = -1;
            }
        }
    }

    if (controllerRef.m_Pres.m_eUIMode != eUIMode_Shell && kMPGRI == none)
    {
        m_optChangeDifficulty = ++iCurrent;
        AS_AddOption(m_optChangeDifficulty, m_sChangeDifficulty, eUIState_Normal);
    }
    else
    {
        m_optChangeDifficulty = -1;
    }

    if (controllerRef.m_Pres.m_eUIMode != eUIMode_Shell && kMPGRI == none)
    {
        m_optViewSecondWave = ++iCurrent;
        AS_AddOption(m_optViewSecondWave, m_sViewSecondWave, eUIState_Normal);
    }
    else
    {
        m_optViewSecondWave = -1;
    }

    if (XComPresentationLayer(controllerRef.m_Pres) != none)
    {
        kBattle = XGBattle_SP(`BATTLE);

        if (kBattle != none &&
            kBattle.m_kDesc.m_iMissionType != eMission_Final &&
           !kBattle.m_kDesc.m_bIsFirstMission &&
           !kBattle.m_kDesc.m_bIsTutorial &&
            kBattle.m_kDesc.m_iMissionType != eMission_HQAssault &&
            kBattle.m_iResult == eResult_UNINITIALIZED)
        {
            m_optAbortMission = ++iCurrent;
            AS_AddOption(m_optAbortMission, m_sAbortMission, eUIState_Normal);
        }
        else
        {
            m_optAbortMission = -1;
        }

        m_optXComDatabase = -1;
    }
    else
    {
        m_optXComDatabase = ++iCurrent;
        AS_AddOption(m_optXComDatabase, m_sXComDatabase, eUIState_Normal);
    }

    if (!m_bIsIronman)
    {
        m_optExitGame = ++iCurrent;
        AS_AddOption(m_optExitGame, m_sExitGame, eUIState_Normal);
    }

    if (!WorldInfo.IsConsoleBuild() && kMPGRI == none)
    {
        if (!m_bIsIronman)
        {
            m_optQuitGame = ++iCurrent;
            AS_AddOption(m_optQuitGame, m_sQuitGame, eUIState_Normal);
        }
    }

    MAX_OPTIONS = iCurrent;
}

simulated function OnUAccept()
{
    `LWCE_LOG_CLS("m_iCurrentSelection = " $ m_iCurrentSelection $ "; m_optRestart = " $ m_optRestart);

    if (m_iCurrentSelection == m_optModSettings)
    {
        PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);

        // TODO: may not be on strat layer, need to check tac pres also
        `LWCE_HQPRES.LWCE_UIModSettings();
        return;
    }

    super.OnUAccept();
}

simulated function RestartMissionDialgoueCallback(EUIAction eAction)
{
    local LWCE_XGBattleDesc kDesc;

    if (eAction == eUIAction_Accept)
    {
        `PRES.m_kNarrative.RestoreNarrativeCounters();
        controllerRef.ClientTravel("?restart", TRAVEL_Relative);

        kDesc = LWCE_XGBattleDesc(XGBattle_SP(`BATTLE).GetDesc());
        kDesc.m_kArtifactsContainer.Delete(`LW_ITEM_ID(WeaponFragment));
    }
}