class LWCECountryTemplateManager extends LWCEDataTemplateManager;

static function LWCECountryTemplateManager GetInstance()
{
    return LWCECountryTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCECountryTemplateManager'));
}

function bool AddCountryTemplate(LWCECountryTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCECountryTemplate FindCountryTemplate(name DataName)
{
    return LWCECountryTemplate(FindDataTemplate(DataName));
}

function array<LWCECountryTemplate> GetAllCountryTemplates()
{
    local array<LWCECountryTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCECountryTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCECountryTemplate'
}