class LWCE_XGWorld extends XGWorld;

function string RecordStartedGame()
{
    local string OutputString;
    local int Index;
    local XComHeadquartersGame HQGAME;

    HQGAME = XComHeadquartersGame(WorldInfo.Game);
    OutputString = "\n###########################  Starting New Game  ################################\n";
    OutputString = OutputString $ "XCOM LWCE is installed\n";
    OutputString = OutputString $ "Starting Continent: "          $ World().m_aContinentNames[HQ().m_iContinent] $ "\n";
    OutputString = OutputString $ "Difficulty    : "              $ class'UIShellDifficulty'.default.m_arrDifficultyTypeStrings[byte(Game().GetDifficulty())] $ "\n";
    OutputString = OutputString $ "Tutorial      : "              $ (HQGAME.m_bControlledStartFromShell ?    "Yes" : "No") $ "\n";
    OutputString = OutputString $ "Ironman       : "              $ (HQGAME.m_bEnableIronmanFromShell ?      "Yes" : "No") $ "\n";
    OutputString = OutputString $ "Slingshot     : "              $ (HQGAME.m_bEnableSlingshotFromShell ?    "Yes" : "No") $ "\n";
    OutputString = OutputString $ "Progeny       : "              $ (HQGAME.m_bEnableProgenyFromShell ?      "Yes" : "No") $ "\n";
    OutputString = OutputString $ "Meld Tutorial : "              $ (HQGAME.m_bEnableMeldTutorialFromShell ? "Yes" : "No") $ "\n\n";
    OutputString = OutputString $ "SuppressFirstTimeNarrative : " $ (HQGAME.m_bSuppressFirstTimeNarrative ?  "Yes" : "No") $ "\n\n";
    OutputString = OutputString $ "Second Wave Options:\n";

    for (Index = 0; Index < 36; Index++)
    {
        if (`HQGAME.GetGameCore().m_arrSecondWave[Index] > 0)
        {
            OutputString = OutputString $ "    " $ class'UIGameplayToggles'.default.m_arrGameplayToggleTitle[Index] $ "\n";
        }
    }

    OutputString = OutputString $ "############################################################################\n";

    return OutputString;
}