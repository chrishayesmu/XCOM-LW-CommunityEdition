class XComMapManager extends Object
    dependsOn(XGGameData)
    native(Core)
    config(Maps);
//complete stub

const MaxDynamicAliens = 2;

struct native StreamMapData
{
    var string MapName;
    var Vector Loc;
    var Rotator Rot;
};
struct native RecapStatValue
{
    var ERecapStats eStat;
    var int iValue;
};
struct native MapHistory
{
    var int iFamilyID;
    var int iPlayed;
    var float fChance;
    var float fGain;
};
struct native XComMapMetaData
{
    var name MapFamily;
    var init string Name;
    var init string DisplayName;
    var EMissionType MissionType;
    var bool bInRotation;
    var EMissionTime TimeOfDay;
    var EShipType ShipType;
    var EMissionRegion eRegion;
    var EFCMissionType CouncilType;
    var bool NewMap;
    var float InitialChance;
    var float InitialGain;
    var ECharacter DynamicAliens[2];
    var init array<init StreamMapData> StreamingMaps;
    var int PlayCount;
    var int FamilyID;
    var float Gain;
    var float Chance;
};

var protected config array<config XComMapMetaData> Maps;
var config array<config string> GlamCamMaps;
var const transient array<Level> PreloadedLevels;
var config int TurnsToParity;
var config int MinChance;
var config float MinimumGain;

native function PreloadTransitionLevels(optional bool bBlockOnLoad);
native function ClearPreloadedLevels();
native function SetTransitionMap(string MapName);
native function ResetTransitionMap();
native static simulated function bool GetMapInfosFromMapName(const out string MapName, out array<XComMapMetaData> aMapData);
native static simulated function bool GetMapInfoFromDisplayName(const out string MapDisplayName, out XComMapMetaData MapData);
native static simulated function bool GetMapDisplayNames(EMissionType MissionType, out array<string> MapDisplayNames, optional bool bAllMaps, optional bool bIncludeStrategyMaps=true);
native static simulated function string GetRandomMapDisplayName(EMissionType MissionType, EMissionTime TimeOfDay, EShipType eUFO, EMissionRegion Region, int Country, out array<MapHistory> MapPlayCount, out int PlayCount);
native static simulated function bool GetSpecialMissionDisplayNames(EFCMissionType FCType, out array<string> MapDisplayNames);
native static simulated function string InternalGetRandomMapDisplayName(out array<string> MapDisplayNames, EMissionTime TimeOfDay, EShipType eUFO, EMissionRegion Region, int Country, out array<MapHistory> MapPlayCount, out int PlayCount);
native static simulated function IncrementMapPlayHistory(string MapName, out array<MapHistory> MapPlayCount, out int PlayCount);
native static simulated function DecrementMapPlayHistory(string MapName, out array<MapHistory> MapPlayCount, out int PlayCount);
native static simulated function UpdateMapHistory(array<XComMapMetaData> MapDatas, out array<MapHistory> MapPlayCount);
native static simulated function SetCurrentMapMetaData(XComMapMetaData MapMetaData);
native static simulated function XComMapMetaData GetCurrentMapMetaData();
native static simulated function ResetMapCounts(out array<MapHistory> histories);
native static simulated function DumpMapCounts(array<MapHistory> histories);
native static simulated function bool IsTacticalMap(const out string MapName);
native static simulated function bool IsLevelLoaded(name MapName);
native static simulated function string GetMapCommandLine(string strMapDisplayName, bool bFromStrategy, optional bool bSeamless, optional XGBattleDesc BattleDesc);
native static simulated function LogMapSelection(string LogMsg);
static simulated function AddMapDynamicContent(string MapDisplayName, out TPawnContent Content){}
native static simulated function LevelStreaming AddStreamingMap(string MapName, optional Vector vOffset, optional Rotator rRot, optional bool bBlockOnLoad=true);
native static simulated function RemoveStreamingMap(Vector vOffset);
native static simulated function RemoveStreamingMapByName(string MapName);
native static simulated function bool IsStreamingComplete();
simulated function bool GetCinematicMapNameByCharacterType(int CharType, out string strCinematicMapName, bool bMultiplayer){}
static function string GetAlienContainmentStrUID(EItemType kCaptive){}
static function string GetAlienContainmentMatineeFromType(EItemType kCaptive){}
static function string GetAlienContainmentRemoteEventFromType(EItemType kCaptive){}
function AddCapturedAlienCinematics(array<int> arrCaptives);
simulated function OnGlamCamMapVisible(name LevelName){}
simulated function AddGlamCamMaps(bool bBlockOnLoad){}
simulated event GetRequiredGlamCamMaps(out array<string> RequiredGlamCamMaps, optional XGBattleDesc kDesc){}
simulated function FindStreamingMap(ECharacter eCharType, out array<string> arrStreaming){}
native static simulated function AddStreamingMaps(const string MapDisplayName, optional bool bAllowDropshipIntro=true);
native static simulated function AddStreamingMapsFromURL(const string URL, optional bool bAllowDropshipIntro=true);
function bool IsInitialized(){}
