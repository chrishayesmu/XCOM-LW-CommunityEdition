class XComDropshipAudioMgr extends Object
    config(GameData);

struct TAudio
{
    var int EnumID;
    var int SpecialMissionID;
    var string Narrative;

    structdefaultproperties
    {
        EnumID=0
        SpecialMissionID=0
        Narrative=""
    }
};
var config array<config TAudio> CountryAudio;
var config array<config TAudio> MissionAudio;
var bool m_bHasCountryAudio;
var XComNarrativeMoment CountryMoment;
var XComNarrativeMoment MissionMoment;
var XComNarrativeMoment IntroMoment;

function bool IsValidMissionType(XGGameData.EMissionType MissionType){}
function BeginDropshipNarrativeMoments(XGMission Mission, XGGameData.EMissionType MissionType, XGGameData.ECountry Country, optional bool bRecordPlayingOnly){}
private final function GetCountryAudio(XGGameData.ECountry Country, XGGameData.EMissionType MissionType, bool bRecordPlayingOnly){}
private final function GetMissionAudio(XGMission Mission, bool bRecordPlayingOnly){}
simulated function PreloadFirstMissionNarrative(){}


DefaultProperties
{
}
