class LWCEContentTemplate extends LWCEDataTemplate
    config(LWCEContent)
    abstract;

var config string ArchetypeName;

var localized string DisplayName;

function name GetContentTemplateName()
{
    return DataName;
}