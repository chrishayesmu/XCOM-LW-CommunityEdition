class LWCELocalizeContext extends Object;

var array<LWCELocalizeTag> m_arrLocalizeTags;

function LWCELocalizeTag FindTag(string TagName)
{
    local LWCELocalizeTag kTag;

    foreach m_arrLocalizeTags(kTag)
    {
        if (kTag.Tag == TagName)
        {
            return kTag;
        }
    }

    return none;
}

function bool Expand(string TagName, string OptName, out string OutString)
{
    local LWCELocalizeTag kTag;

    kTag = FindTag(TagName);

    if (kTag == none)
    {
        `LWCE_LOG_WARN("Couldn't find LWCELocalizeTag matching " $ TagName);
        return false;
    }

    return kTag.Expand(OptName, OutString);
}