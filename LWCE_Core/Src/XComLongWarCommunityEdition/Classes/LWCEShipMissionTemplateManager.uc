class LWCEShipMissionTemplateManager extends LWCEDataTemplateManager;

static function LWCEShipMissionTemplateManager GetInstance()
{
    return LWCEShipMissionTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEShipMissionTemplateManager'));
}

function bool AddEventListenerTemplate(LWCEShipMissionTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEShipMissionTemplate FindShipMissionTemplate(name DataName)
{
    return LWCEShipMissionTemplate(FindDataTemplate(DataName));
}

function array<LWCEShipMissionTemplate> GetAllShipMissionTemplates()
{
    local array<LWCEShipMissionTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEShipMissionTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}