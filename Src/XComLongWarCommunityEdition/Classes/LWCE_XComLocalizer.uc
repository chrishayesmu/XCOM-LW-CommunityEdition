class LWCE_XComLocalizer extends Object
    abstract;

static function string ExpandString(string InString, optional LWCE_XGLocalizeContext kContext)
{
    local array<string> arrTokens;
    local string strExpanded, strToken, strTagName, strTagValue, OutString;

    if (kContext == none)
    {
        kContext = LWCE_XComEngine(class'Engine'.static.GetEngine()).CELocalizeContext;
    }

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

    `LWCE_LOG_CLS("Final string: " $ strExpanded);
    return strExpanded;
}