class LWCE_XGLocalizeTag extends Object
    abstract;

var string Tag;
var LWCE_XGTacticalGameCore m_kGameCore;

function bool Expand(string InString, out string OutString);

function RestoreUnhandledTag(string InString, out string OutString)
{
    OutString = "<" $ Tag $ ":" $ Instring $ "/>";
}