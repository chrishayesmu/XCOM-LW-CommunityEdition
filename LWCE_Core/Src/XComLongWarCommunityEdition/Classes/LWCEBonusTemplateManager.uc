class LWCEBonusTemplateManager extends LWCEDataTemplateManager;

static function LWCEBonusTemplateManager GetInstance()
{
    return LWCEBonusTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEBonusTemplateManager'));
}

function bool AddBonusTemplate(LWCEBonusTemplate Data, bool ReplaceDuplicate = false)
{
    if (AddDataTemplate(Data, ReplaceDuplicate))
    {
        Data.RegisterBonusEvents();
        return true;
    }

    return false;
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

// Overridden so we can give our templates an opportunity to adjust themselves as needed
function InitTemplates()
{
    local int Index;

    super.InitTemplates();

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        LWCEBonusTemplate(m_arrTemplates[Index].kTemplate).RegisterBonusEvents();
    }
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEBonusTemplate'
}