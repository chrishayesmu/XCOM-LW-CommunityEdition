class XComMCP extends MCPBase
    native
    dependson(XComMCPTypes);

var array<GlobalRecapStat> GlobalRecapStats;
var array<MCPEventRequest> EventItems;
var const array<MCPEventRequest> ActiveRequests;
var bool bEnableMcpService;
var bool McpStatsDisableReporting;
var private transient bool Tracking;
var private native transient Array_Mirror KeyCountEntries;
var private native transient Array_Mirror MetricEntries;
var private transient string StringBlob;
var const localized string ServiceNotAvailable;
var OnlineSubsystem OnlineSub;
var privatewrite array<XComMCPEventListener> EventListeners;
var privatewrite EMCPInitStatus eInitStatus;

defaultproperties
{
    EventItems(0)=(EventUrl="Auth.ashx",TimeOut=10.0)
    EventItems(1)=(EventUrl="Recap.ashx",EventType=EOnlineEventType.EOET_Recap,TimeOut=10.0)
    EventItems(2)=(EventUrl="Global.ashx",EventType=EOnlineEventType.EOET_GetRecap,TimeOut=10.0)
    EventItems(3)=(EventUrl="Dict.ashx",EventType=EOnlineEventType.EOET_GetDict,TimeOut=30.0)
    EventItems(4)=(EventUrl="Ping.ashx",EventType=EOnlineEventType.EOET_PingMCP,TimeOut=4.0)
    EventItems(5)=(EventUrl="PlayerInfo.ashx",EventType=EOnlineEventType.EOET_PlayerInfo,TimeOut=10.0)
    EventItems(6)=(EventUrl="MissionInfo.ashx",EventType=EOnlineEventType.EOET_MissionInfo,TimeOut=10.0)
    bEnableMcpService=true
}