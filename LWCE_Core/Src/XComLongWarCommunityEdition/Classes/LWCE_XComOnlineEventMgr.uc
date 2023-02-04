class LWCE_XComOnlineEventMgr extends XComOnlineEventMgr;

const FIRST_LWCE_SAVE_VERSION = 17;
const CURRENT_LWCE_SAVE_VERSION = 17; // Increment this any time LWCE makes a change that will be backwards-incompatible with old saves

event FillInHeaderForSave(out SaveGameHeader Header, out string SaveFriendlyName)
{
    local WorldInfo LocalWorldInfo;
    local XComGameInfo LocalGameInfo;
    local int Year, Month, DayOfWeek, Day, Hour, Minute, Second, Millisecond;

    LocalWorldInfo = `WORLDINFO;
    LocalGameInfo = XComGameInfo(LocalWorldInfo.Game);
    LocalWorldInfo.GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Minute, Second, Millisecond);

    FormatTimeStamp(Header.Time, Year, Month, Day, Hour, Minute);
    Header.GameNum = m_iCurrentGame;
    Header.bIsTacticalSave = XComTacticalGRI(LocalWorldInfo.GRI) != none;
    Header.bIsIronman = XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetAutosaveMgr().WasIronman();
    Header.Description = Header.Time;

    if (Header.bIsIronman)
    {
        Header.Description @= "- " $ m_strIronmanLabel $ ":";
    }
    else if (Header.bIsAutosave)
    {
        Header.Description @= "- " $ m_strAutosaveLabel $ ":";
    }
    else if (Header.bIsQuicksave)
    {
        Header.Description @= "- " $ m_strQuicksaveLabel $ ":";
    }
    else
    {
        Header.Description @= "-";
    }

    Header.Description @= m_strGameLabel @ string(Header.GameNum) @ "-";
    Header.Description @= LocalGameInfo.GetSavedGameDescription();
    Header.MapCommand = LocalGameInfo.GetSavedGameCommand();
    Header.VersionNumber = CURRENT_LWCE_SAVE_VERSION;
    Header.Language = GetLanguage();

    if (HasSlingshotPack())
    {
        Header.DLCPacks = Header.DLCPacks $ "Slingshot";
    }

    if (HasEliteSoldierPack())
    {
        Header.DLCPacks = Header.DLCPacks $ "EliteSoldierPack";
    }

    SaveFriendlyName = Header.Description;
}

function HideSaveIndicator()
{
    local XComPresentationLayerBase Presentation;

    bShowingSaveIndicator = false;
    ShownSaveIndicatorTime = 0.0;
    Presentation = XComPlayerController(class'UIInteraction'.static.GetLocalPlayer(0).Actor).m_Pres;

    // LWCE: fix None access of AnchoredMessageMgr
    if (Presentation != none && Presentation.GetAnchoredMessenger() != none)
    {
        Presentation.GetAnchoredMessenger().RemoveMessage("SaveIndicator");
    }
}

function SortSavedGameListByTimestamp(out array<OnlineSaveGame> SaveGameList)
{
    // LWCE issue #72: the native implementation of this function has some sort of bug that causes it to fail around
    // the start of each month. Save games on the first of the month will end up being placed in the middle of the previous
    // month's saves. We just reimplement the sort completely to fix this.
    SaveGameList.Sort(SortOnlineSaveGames);
}

protected function int SortOnlineSaveGames(OnlineSaveGame SaveA, OnlineSaveGame SaveB)
{
    local array<string> Parts;
    local string strDatePartA, strDatePartB;
    local string strTimePartA, strTimePartB;
    local int iYearA, iMonthA, iDayA, iYearB, iMonthB, iDayB, iTimeA, iTimeB;

    if (SaveA.SaveGames[0].SaveGameHeader.Time == "")
    {
        if (SaveB.SaveGames[0].SaveGameHeader.Time == "")
        {
            `LWCE_LOG_CLS("Neither save has time set");
            return 0;
        }

        `LWCE_LOG_CLS("Save A has no time set");
        return -1;
    }
    else if (SaveB.SaveGames[0].SaveGameHeader.Time == "")
    {
        `LWCE_LOG_CLS("Save B has no time set");
        return 0;
    }

    // Example timestamp string: "1/29/2023 - 23:38"
    `LWCE_LOG_CLS("Starting sort. SaveA time is " $ SaveA.SaveGames[0].SaveGameHeader.Time $ ", SaveB time is " $ SaveB.SaveGames[0].SaveGameHeader.Time );
    ParseStringIntoArray(SaveA.SaveGames[0].SaveGameHeader.Time, Parts, " - ", true);
    `LWCE_LOG_CLS("SaveA: String " $ SaveA.SaveGames[0].SaveGameHeader.Time $ " split into " $ Parts[0] $ " and " $ Parts[1]);
    strDatePartA = Parts[0];
    strTimePartA = Parts[1];

    ParseStringIntoArray(SaveB.SaveGames[0].SaveGameHeader.Time, Parts, " - ", true);
    `LWCE_LOG_CLS("SaveB: String " $ SaveB.SaveGames[0].SaveGameHeader.Time $ " split into " $ Parts[0] $ " and " $ Parts[1]);
    strDatePartB = Parts[0];
    strTimePartB = Parts[1];

    ParseStringIntoArray(strDatePartA, Parts, "/", true);
    iMonthA = int(Parts[0]);
    iDayA = int(Parts[1]);
    iYearA = int(Parts[2]);
    `LWCE_LOG_CLS("SaveA date: String " $ strDatePartA $ " split into " $ iMonthA $ ", " $ iDayA $ ", and " $ iYearA);

    ParseStringIntoArray(strDatePartB, Parts, "/", true);
    iMonthB = int(Parts[0]);
    iDayB = int(Parts[1]);
    iYearB = int(Parts[2]);
    `LWCE_LOG_CLS("SaveB date: String " $ strDatePartB $ " split into " $ iMonthB $ ", " $ iDayB $ ", and " $ iYearB);

    if (iYearA < iYearB)
    {
        `LWCE_LOG_CLS("Year: -1");
        return -1;
    }
    else if (iYearA > iYearB)
    {
        `LWCE_LOG_CLS("Year: 0");
        return 0;
    }

    if (iMonthA < iMonthB)
    {
        `LWCE_LOG_CLS("Month: -1");
        return -1;
    }
    else if (iMonthA > iMonthB)
    {
        `LWCE_LOG_CLS("Month: 0");
        return 0;
    }

    if (iDayA < iDayB)
    {
        `LWCE_LOG_CLS("Day: -1");
        return -1;
    }
    else if (iDayA > iDayB)
    {
        `LWCE_LOG_CLS("Day: 0");
        return 0;
    }

    ParseStringIntoArray(strTimePartA, Parts, ":", true);
    iTimeA = 60 * int(Parts[1]) + int(Parts[0]);

    ParseStringIntoArray(strTimePartB, Parts, ":", true);
    iTimeB = 60 * int(Parts[1]) + int(Parts[0]);

    if (iTimeA < iTimeB)
    {
        `LWCE_LOG_CLS("Time: -1");
        return -1;
    }

    `LWCE_LOG_CLS("Time: 0");
    return 0;
}