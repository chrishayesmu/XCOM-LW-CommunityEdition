class LWCETechTemplateManager extends LWCEDataTemplateManager;

static function LWCETechTemplateManager GetInstance()
{
    return LWCETechTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCETechTemplateManager'));
}

function bool AddTechTemplate(LWCETechTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCETechTemplate FindTechTemplate(name DataName)
{
    return LWCETechTemplate(FindDataTemplate(DataName));
}

function array<LWCETechTemplate> GetAllTechTemplates()
{
    local array<LWCETechTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCETechTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCETechTemplate'
}