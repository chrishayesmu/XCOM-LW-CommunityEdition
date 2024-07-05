class LWCELocalizer extends Object
    abstract;

static function string ExpandString(string InString)
{
    local array<string> arrTokens;
    local string strExpanded, strToken, strTagName, strTagValue, OutString;
    local LWCELocalizeContext kContext;

    kContext = `LWCE_XEXPANDCONTEXT;

    class'XComLocalizer'.static.EscapeAndTokenize(arrTokens, InString);

    foreach arrTokens(strToken)
    {
        strTagName = "";
        strTagValue = "";
        class'XComLocalizer'.static.ExtractTag(strToken, strTagName, strTagValue);

        // Skip past non-tags by simply appending them
        if (strTagName == "" || strTagValue == "")
        {
            strExpanded $= strToken;
            continue;
        }

        kContext.Expand(strTagName, strTagValue, OutString);
        strExpanded $= OutString;
    }

    `LWCE_LOG_VERBOSE("ExpandString: input string \"" $ InString $ "\" expanded to \"" $ strExpanded $ "\"");

    return strExpanded;
}