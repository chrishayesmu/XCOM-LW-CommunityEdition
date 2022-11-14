class LWCEContentTemplate extends LWCEDataTemplate
    config(LWCEContent)
    abstract;

var config string ArchetypeName;

function name GetContentTemplateName()
{
    return DataName;
}