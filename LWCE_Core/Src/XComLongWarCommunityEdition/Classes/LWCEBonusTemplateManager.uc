class LWCEBonusTemplateManager extends LWCEDataTemplateManager;

static function LWCEBonusTemplateManager GetInstance()
{
    return LWCEBonusTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEBonusTemplateManager'));
}

function bool AddBonusTemplate(LWCEBonusTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEBonusTemplate FindBonusTemplate(name DataName)
{
    return LWCEBonusTemplate(FindDataTemplate(DataName));
}

function array<LWCEBonusTemplate> GetAllBonusTemplates()
{
    local array<LWCEBonusTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEBonusTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEBonusTemplate'
}