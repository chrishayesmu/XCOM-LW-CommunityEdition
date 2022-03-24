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