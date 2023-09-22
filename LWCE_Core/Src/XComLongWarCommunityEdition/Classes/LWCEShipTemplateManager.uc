class LWCEShipTemplateManager extends LWCEDataTemplateManager;

static function LWCEShipTemplateManager GetInstance()
{
    return LWCEShipTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEShipTemplateManager'));
}

function bool AddShipTemplate(LWCEShipTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEShipTemplate FindShipTemplate(name DataName)
{
    return LWCEShipTemplate(FindDataTemplate(DataName));
}

function array<LWCEShipTemplate> GetAllShipTemplates()
{
    local array<LWCEShipTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEShipTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEShipTemplate'
}