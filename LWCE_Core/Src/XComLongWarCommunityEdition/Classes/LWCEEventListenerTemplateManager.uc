class LWCEEventListenerTemplateManager extends LWCEDataTemplateManager;

static function LWCEEventListenerTemplateManager GetInstance()
{
    return LWCEEventListenerTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEEventListenerTemplateManager'));
}

function bool AddEventListenerTemplate(LWCEEventListenerTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEEventListenerTemplate FindEventListenerTemplate(name DataName)
{
    return LWCEEventListenerTemplate(FindDataTemplate(DataName));
}

function array<LWCEEventListenerTemplate> GetAllEventListenerTemplates()
{
    local array<LWCEEventListenerTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEEventListenerTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

static function RegisterTacticalListeners()
{
    local int Index;
	local LWCEEventListenerTemplate ListenerTemplate;
    local LWCEEventListenerTemplateManager TemplateManager;

    `LWCE_LOG_CLS("Registering tactical game event listener templates");

	// unregister any previously registered templates
	UnregisterAllListeners();

    TemplateManager = GetInstance();

    for (Index = 0; Index < TemplateManager.m_arrTemplates.Length; Index++)
	{
		ListenerTemplate = LWCEEventListenerTemplate(TemplateManager.m_arrTemplates[Index].kTemplate);

		if (ListenerTemplate.bRegisterInTactical)
		{
			ListenerTemplate.RegisterAllEvents();
		}
	}
}

static function RegisterStrategyListeners()
{
    local int Index;
	local LWCEEventListenerTemplate ListenerTemplate;
    local LWCEEventListenerTemplateManager TemplateManager;

    `LWCE_LOG_CLS("Registering strategy game event listener templates");

	// unregister any previously registered templates
	UnregisterAllListeners();

    TemplateManager = GetInstance();

    for (Index = 0; Index < TemplateManager.m_arrTemplates.Length; Index++)
	{
		ListenerTemplate = LWCEEventListenerTemplate(TemplateManager.m_arrTemplates[Index].kTemplate);

		if (ListenerTemplate.bRegisterInStrategy)
		{
			ListenerTemplate.RegisterAllEvents();
		}
	}
}

static function UnregisterAllListeners()
{
    local int Index;
	local LWCEEventListenerTemplate ListenerTemplate;
    local LWCEEventListenerTemplateManager TemplateManager;

    `LWCE_LOG_CLS("Unregistering all current event listener templates");

    TemplateManager = GetInstance();

    for (Index = 0; Index < TemplateManager.m_arrTemplates.Length; Index++)
    {
		ListenerTemplate = LWCEEventListenerTemplate(TemplateManager.m_arrTemplates[Index].kTemplate);
        ListenerTemplate.UnregisterFromAllEvents();
    }
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEEventListenerTemplate'
}