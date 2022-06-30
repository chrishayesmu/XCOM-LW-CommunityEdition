class LWCECouncilRequestTemplateManager extends LWCEDataTemplateManager;

static function LWCECouncilRequestTemplateManager GetInstance()
{
    return LWCECouncilRequestTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCECouncilRequestTemplateManager'));
}

function bool AddCouncilRequestTemplate(LWCECouncilRequestTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCECouncilRequestTemplate FindCouncilRequestTemplate(name DataName)
{
    return LWCECouncilRequestTemplate(FindDataTemplate(DataName));
}

function array<LWCECouncilRequestTemplate> GetAllRequestTemplates()
{
    local array<LWCECouncilRequestTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCECouncilRequestTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCECouncilRequestTemplate'
}