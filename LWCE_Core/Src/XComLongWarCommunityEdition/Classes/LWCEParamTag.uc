class LWCEParamTag extends LWCELocalizeTag;

var int IntValue0;
var int IntValue1;
var int IntValue2;
var string StrValue0;
var string StrValue1;
var string StrValue2;

function bool Expand(string InString, out string OutString)
{
    local Name TagName;

    TagName = name(InString);

    switch (TagName)
    {
        case 'IntValue0':
            OutString = string(IntValue0);
            break;
        case 'IntValue1':
            OutString = string(IntValue1);
            break;
        case 'IntValue2':
            OutString = string(IntValue2);
            break;
        case 'StrValue0':
            OutString = StrValue0;
            break;
        case 'StrValue1':
            OutString = StrValue1;
            break;
        case 'StrValue2':
            OutString = StrValue2;
            break;
        default:
            return false;
    }

    return true;
}

defaultproperties
{
    Tag="LWCEParam"
}