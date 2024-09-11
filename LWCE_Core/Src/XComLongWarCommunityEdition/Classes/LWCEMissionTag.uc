class LWCEMissionTag extends LWCELocalizeTag;

var LWCE_XGMission Mission;

function bool Expand(string InString, out string OutString)
{
    local int OpNameIndex;
    local name TagName;

    OpNameIndex = INDEX_NONE;
    TagName = name(InString);

    switch (TagName)
    {
        case 'OpName0':
            OpNameIndex = 0;
            break;
        case 'OpName1':
            OpNameIndex = 1;
            break;
        case 'OpName2':
            OpNameIndex = 2;
            break;
        case 'OpName3':
            OpNameIndex = 3;
            break;
        case 'OpName4':
            OpNameIndex = 4;
            break;
        case 'TargetCity':
            OutString = "<<CITY>>";
            break;
        case 'TargetCountry':
            OutString = "<<COUNTRY>>";
            break;
        case 'TargetContinent':
            OutString = "<<CONTINENT>>";
            break;
    }

    if (OpNameIndex != INDEX_NONE)
    {
        if (Mission.m_kTemplate.arrNameLists.Length > 0)
        {
            // Keep the name list in bounds, just in case
            OpNameIndex = Clamp(OpNameIndex, 0, Mission.m_kTemplate.arrNameLists.Length - 1);

            OutString = GetNameFromList(Mission.m_kTemplate.arrNameLists[OpNameIndex]);
        }
    }

    if (OutString != "")
    {
        return true;
    }

    RestoreUnhandledTag(InString, OutString);
    return false;
}

protected function string GetNameFromList(name listTemplateName)
{
    local LWCENameListTemplate kTemplate;

    kTemplate = `LWCE_NAME_LIST(listTemplateName);

    return kTemplate.RollForName();
}

defaultproperties
{
    Tag="LWCEMission"
}