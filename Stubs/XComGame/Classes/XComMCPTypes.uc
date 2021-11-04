class XComMCPTypes extends Object
    native;
//complete stub

enum EMCPInitStatus
{
    EMCPIS_NotInitialized,
    EMCPIS_Success,
    EMCPIS_DisabledByCommandLine,
    EMCPIS_DisabledByConfig,
    EMCPIS_DisabledByProfileStatus,
    EMCPIS_NoOnlineSubsystem,
    EMCPIS_MAX
};

enum EOnlineEventType
{
    EOET_Auth,
    EOET_Recap,
    EOET_GetRecap,
    EOET_GetDict,
    EOET_PingMCP,
    EOET_PlayerInfo,
    EOET_MissionInfo,
    EOET_MAX
};

struct native GlobalRecapStat
{
    var ERecapStats Stat;
    var int LoValue;
    var int HiValue;
    var string StrValue;
};

struct native MCPEventRequest
{
    var const string EventUrl;
    var EOnlineEnumerationReadState AsyncState;
    var const EOnlineEventType EventType;
    var const float TimeOut;
    var native const Pointer HttpDownloader;
    var const bool bResultIsCached;
};

struct native KeyCountsEntry
{
    var string Key;
    var int Value;
    var int Type;
};

struct native TileCoord
{
    var int X;
    var int Y;
    var int Z;
};