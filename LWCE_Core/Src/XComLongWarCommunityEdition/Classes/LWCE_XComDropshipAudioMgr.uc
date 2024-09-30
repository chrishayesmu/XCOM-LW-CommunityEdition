class LWCE_XComDropshipAudioMgr extends XComDropshipAudioMgr
    config(LWCEMissions);

struct LWCE_TDropshipAudio
{
    // If populated, this audio will only be playable if the current mission is occuring on one of these maps.
    var array<string> MapNames;

    // If populated, this audio will only be playable if the current mission is one of these types.
    var array<name> MissionTypes;

    // If populated, this audio will only be playable if the current mission has one of these subtypes.
    var array<name> MissionSubtypes;

    // If populated, this audio will only be playable if the current mission is in this country.
    var name Country;

    // Full path to dynamically load an XComNarrativeMoment when this audio is selected.
    var string Narrative;
};

var config array<LWCE_TDropshipAudio> arrCountryAudio;
var config array<LWCE_TDropshipAudio> arrMissionAudio;
var config array<name> arrMissionsWithoutCountryAudio;

function BeginDropshipNarrativeMoments(XGMission Mission, EMissionType MissionType, ECountry Country, optional bool bRecordPlayingOnly = false)
{
    `LWCE_LOG_DEPRECATED_CLS(BeginDropshipNarrativeMoments);
}

function LWCE_BeginDropshipNarrativeMoments(LWCE_XGMission kMission, optional bool bRecordPlayingOnly = false)
{
    local string strMapName, strNarrativePath;
    local name nmMissionType, nmMissionSubtype;
    local XComMapMetaData MetaData;

    class'XComMapManager'.static.GetMapInfoFromDisplayName(kMission.m_kDesc.m_strMapName, MetaData);
    strMapName = MetaData.Name;

    nmMissionType = kMission.m_nmMissionTemplate;
    nmMissionSubtype = kMission.GetSubtype();

    m_bHasCountryAudio = false;

    // Look for country audio first
    if (arrMissionsWithoutCountryAudio.Find(kMission.m_nmMissionTemplate) == INDEX_NONE)
    {
        strNarrativePath = FindBestMatchingAudio(arrCountryAudio, kMission.m_nmCountry, nmMissionType, nmMissionSubtype, strMapName);
        `LWCE_LOG("Country audio best matching narrative: " $ strNarrativePath);

        if (strNarrativePath != "")
        {
            if (!bRecordPlayingOnly)
            {
                CountryMoment = XComNarrativeMoment(DynamicLoadObject(strNarrativePath, class'XComNarrativeMoment'));

                if (CountryMoment != none)
                {
                    m_bHasCountryAudio = true;
                }
            }

            HandleNarrativeMoment(CountryMoment, strNarrativePath, bRecordPlayingOnly);
        }
    }
    else
    {
        `LWCE_LOG_VERBOSE("Mission type " $ nmMissionType $ " is in arrMissionsWithoutCountryAudio; skipping country audio");
    }

    // Now look for mission audio
    strNarrativePath = FindBestMatchingAudio(arrMissionAudio, kMission.m_nmCountry, nmMissionType, nmMissionSubtype, strMapName);
    `LWCE_LOG("Mission audio best matching narrative: " $ strNarrativePath);

    if (strNarrativePath != "")
    {
        if (!bRecordPlayingOnly)
        {
            MissionMoment = XComNarrativeMoment(DynamicLoadObject(strNarrativePath, class'XComNarrativeMoment'));
        }

        HandleNarrativeMoment(MissionMoment, strNarrativePath, bRecordPlayingOnly);
    }
}

function bool IsValidMissionType(EMissionType MissionType)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(IsValidMissionType);

    return false;
}

protected function string FindBestMatchingAudio(const out array<LWCE_TDropshipAudio> arrAudio, name nmCountry, name nmMissionType, name nmMissionSubtype, string mapName)
{
    local int I;
    local array<string> arrMatchingNarratives;

    // To find the best audio match, we just start with the specific criteria and work our way
    // to the least specific, stopping when we hit a match. It's not very efficient, but most missions
    // will match pretty quickly, and this is easy to read.

    // Country + MissionType + MissionSubtype + MapName
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].Country == nmCountry
         && arrAudio[I].MissionTypes.Find(nmMissionType) != INDEX_NONE
         && arrAudio[I].MissionSubtypes.Find(nmMissionSubtype) != INDEX_NONE
         && arrAudio[I].MapNames.Find(mapName) != INDEX_NONE)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    // MissionType + MissionSubtype + MapName
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].MissionTypes.Find(nmMissionType) != INDEX_NONE
         && arrAudio[I].MissionSubtypes.Find(nmMissionSubtype) != INDEX_NONE
         && arrAudio[I].MapNames.Find(mapName) != INDEX_NONE)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    // Country + MissionType + MissionSubtype
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].Country == nmCountry
         && arrAudio[I].MissionTypes.Find(nmMissionType) != INDEX_NONE
         && arrAudio[I].MissionSubtypes.Find(nmMissionSubtype) != INDEX_NONE)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    // MissionType + MissionSubtype
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].MissionTypes.Find(nmMissionType) != INDEX_NONE
         && arrAudio[I].MissionSubtypes.Find(nmMissionSubtype) != INDEX_NONE)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    // Country + MissionType
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].Country == nmCountry
         && arrAudio[I].MissionTypes.Find(nmMissionType) != INDEX_NONE)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    // MissionType
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].MissionTypes.Find(nmMissionType) != INDEX_NONE)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    // MapName
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].MapNames.Find(mapName) != INDEX_NONE)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    // Country
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].Country == nmCountry)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    // Fallback: any entry that only has the narrative configured is considered a fallback for any
    // otherwise-unmatched mission
    for (I = 0; I < arrAudio.Length; I++)
    {
        if (arrAudio[I].Country == ''
         && arrAudio[I].MissionTypes.Length == 0
         && arrAudio[I].MissionSubtypes.Length == 0
         && arrAudio[I].MapNames.Length == 0)
        {
            arrMatchingNarratives.AddItem(arrAudio[I].Narrative);
        }
    }

    if (arrMatchingNarratives.Length > 0)
    {
        return arrMatchingNarratives[`SYNC_RAND(arrMatchingNarratives.Length)];
    }

    return "";
}

protected function HandleNarrativeMoment(XcomNarrativeMoment kMoment, string strNarrativePath, bool bRecordPlayingOnly)
{
    local int I;

    if (bRecordPlayingOnly)
    {
        I = `HQPRES.m_kNarrative.FindMomentID(strNarrativePath);

        if (I > -1)
        {
            `HQPRES.m_kNarrative.m_arrNarrativeCounters[I] += 1;
        }
    }
    else if (kMoment != none)
    {
        `HQPRES.UIPreloadNarrative(kMoment);
    }
}