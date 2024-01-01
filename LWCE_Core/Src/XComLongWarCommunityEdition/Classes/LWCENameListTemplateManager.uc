class LWCENameListTemplateManager extends LWCEDataTemplateManager;

static function LWCENameListTemplateManager GetInstance()
{
    return LWCENameListTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCENameListTemplateManager'));
}

function bool AddNameListTemplate(LWCENameListTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCENameListTemplate FindNameListTemplate(name DataName)
{
    return LWCENameListTemplate(FindDataTemplate(DataName));
}

function array<LWCENameListTemplate> GetAllNameListTemplates()
{
    local array<LWCENameListTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCENameListTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCENameListTemplate'
}