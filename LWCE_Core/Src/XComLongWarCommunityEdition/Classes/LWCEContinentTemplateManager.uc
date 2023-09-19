class LWCEContinentTemplateManager extends LWCEDataTemplateManager;

static function LWCEContinentTemplateManager GetInstance()
{
    return LWCEContinentTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEContinentTemplateManager'));
}

function bool AddContinentTemplate(LWCEContinentTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEContinentTemplate FindContinentTemplate(name DataName)
{
    return LWCEContinentTemplate(FindDataTemplate(DataName));
}

function array<LWCEContinentTemplate> GetAllContinentTemplates()
{
    local array<LWCEContinentTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEContinentTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEContinentTemplate'
}