class LWCEFoundryProjectTemplateManager extends LWCEDataTemplateManager;

static function LWCEFoundryProjectTemplateManager GetInstance()
{
    return LWCEFoundryProjectTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEFoundryProjectTemplateManager'));
}

function bool AddProjectTemplate(LWCEFoundryProjectTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEFoundryProjectTemplate FindProjectTemplate(name DataName)
{
    return LWCEFoundryProjectTemplate(FindDataTemplate(DataName));
}

function array<LWCEFoundryProjectTemplate> GetAllProjectTemplates()
{
    local array<LWCEFoundryProjectTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEFoundryProjectTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEFoundryProjectTemplate'
}