class LWCEMissionTemplateManager extends LWCEDataTemplateManager;

static function LWCEMissionTemplateManager GetInstance()
{
    return LWCEMissionTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEMissionTemplateManager'));
}

function bool AddMissionTemplate(LWCEMissionTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEMissionTemplate FindMissionTemplate(name DataName)
{
    return LWCEMissionTemplate(FindDataTemplate(DataName));
}

function array<LWCEMissionTemplate> GetAllMissionTemplates()
{
    local array<LWCEMissionTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEMissionTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEMissionTemplate'
}