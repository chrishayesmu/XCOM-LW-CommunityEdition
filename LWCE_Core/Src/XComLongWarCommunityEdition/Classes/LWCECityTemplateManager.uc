class LWCECityTemplateManager extends LWCEDataTemplateManager;

static function LWCECityTemplateManager GetInstance()
{
    return LWCECityTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCECityTemplateManager'));
}

function bool AddCityTemplate(LWCECityTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCECityTemplate FindCityTemplate(name DataName)
{
    return LWCECityTemplate(FindDataTemplate(DataName));
}

function array<LWCECityTemplate> GetAllCityTemplates()
{
    local array<LWCECityTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCECityTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCECityTemplate'
}