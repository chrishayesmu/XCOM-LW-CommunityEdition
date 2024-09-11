/// <summary>
/// A very simple template class that holds a list of localized names. Its main use is for character
/// generation; a character's race and country can be mapped to a name list, then a name is rolled. However,
/// the same concept is broadly applicable, and the same system is used for generating mission names.
/// </summary>
class LWCENameListTemplate extends LWCEDataTemplate
    config(LWCENameList);

var const localized array<string> arrNames;

/// <summary>
/// Rolls randomly and returns one of the names in this list.
/// </summary>
function string RollForName()
{
    if (arrNames.Length == 0)
    {
        return "";
    }

    return arrNames[Rand(arrNames.Length)];
}