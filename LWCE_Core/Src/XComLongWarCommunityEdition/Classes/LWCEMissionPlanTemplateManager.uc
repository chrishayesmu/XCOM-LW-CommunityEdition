class LWCEMissionPlanTemplateManager extends LWCEDataTemplateManager;

static function LWCEMissionPlanTemplateManager GetInstance()
{
    return LWCEMissionPlanTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEMissionPlanTemplateManager'));
}

function bool AddMissionPlanTemplate(LWCEMissionPlanTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEMissionPlanTemplate FindMissionPlanTemplate(name DataName)
{
    return LWCEMissionPlanTemplate(FindDataTemplate(DataName));
}

function array<LWCEMissionPlanTemplate> GetAllMissionPlanTemplates()
{
    local array<LWCEMissionPlanTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEMissionPlanTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEMissionPlanTemplate'
}