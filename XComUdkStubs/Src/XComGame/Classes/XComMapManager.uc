class XComMapManager extends Object
    native(Core)
    config(Maps);

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

    structdefaultproperties
    {
        InitialChance=20.0
        InitialGain=1.050
    }
};

var protected config array<config XComMapMetaData> Maps;
var privatewrite config array<config string> GlamCamMaps;
var const transient array<Level> PreloadedLevels;
var config int TurnsToParity;
var config int MinChance;
var config float MinimumGain;