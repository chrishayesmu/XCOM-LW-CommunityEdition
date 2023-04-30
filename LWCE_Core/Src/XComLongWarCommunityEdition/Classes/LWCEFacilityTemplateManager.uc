class LWCEFacilityTemplateManager extends LWCEDataTemplateManager;

static function LWCEFacilityTemplateManager GetInstance()
{
    return LWCEFacilityTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEFacilityTemplateManager'));
}

function bool AddItemTemplate(LWCEFacilityTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEFacilityTemplate FindFacilityTemplate(name DataName)
{
    return LWCEFacilityTemplate(FindDataTemplate(DataName));
}

function array<LWCEFacilityTemplate> GetAllFacilityTemplates()
{
    local array<LWCEFacilityTemplate> arrTemplates;
    local LWCEFacilityTemplate kTemplate;
    local int Index;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        kTemplate = LWCEFacilityTemplate(m_arrTemplates[Index].kTemplate);
        arrTemplates.AddItem(kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEFacilityTemplate'
}