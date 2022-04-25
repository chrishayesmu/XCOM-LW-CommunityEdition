class LWCE_XGLocalizeContext extends Object;

var array<LWCE_XGLocalizeTag> arrLocalizeTags;

function LWCE_XGLocalizeTag FindTag(string TagName)
{
    local LWCE_XGLocalizeTag kTag;

    foreach arrLocalizeTags(kTag)
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
    local LWCE_XGLocalizeTag kTag;

    kTag = FindTag(TagName);

    if (kTag == none)
    {
        `LWCE_LOG_CLS("Couldn't find LWCE_XGLocalizeTag matching " $ TagName);
        return false;
    }

    return kTag.Expand(OptName, OutString);
}