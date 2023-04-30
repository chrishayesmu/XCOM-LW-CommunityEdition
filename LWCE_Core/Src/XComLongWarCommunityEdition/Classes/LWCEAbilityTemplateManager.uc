class LWCEAbilityTemplateManager extends LWCEDataTemplateManager;

static function LWCEAbilityTemplateManager GetInstance()
{
    return LWCEAbilityTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEAbilityTemplateManager'));
}

function bool AddAbilityTemplate(LWCEAbilityTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEAbilityTemplate FindAbilityTemplate(name DataName)
{
    return LWCEAbilityTemplate(FindDataTemplate(DataName));
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEAbilityTemplate'
}