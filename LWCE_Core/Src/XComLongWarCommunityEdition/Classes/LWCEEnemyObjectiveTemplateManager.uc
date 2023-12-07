class LWCEEnemyObjectiveTemplateManager extends LWCEDataTemplateManager;

static function LWCEEnemyObjectiveTemplateManager GetInstance()
{
    return LWCEEnemyObjectiveTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEEnemyObjectiveTemplateManager'));
}

function bool AddEnemyObjectiveTemplate(LWCEEnemyObjectiveTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEEnemyObjectiveTemplate FindEnemyObjectiveTemplate(name DataName)
{
    return LWCEEnemyObjectiveTemplate(FindDataTemplate(DataName));
}

function array<LWCEEnemyObjectiveTemplate> GetAllEnemyObjectiveTemplates()
{
    local array<LWCEEnemyObjectiveTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEEnemyObjectiveTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEEnemyObjectiveTemplate'
}