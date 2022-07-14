class LWCETechDataSet extends LWCEDataSet;

static function OnPostTemplatesCreated()
{
    local LWCETechTemplateManager kTemplateMgr;
    local array<LWCETechTemplate> arrTemplates;
    local int Index;

    kTemplateMgr = `LWCE_TECH_TEMPLATE_MGR;
    arrTemplates = kTemplateMgr.GetAllTechTemplates();

    AdjustTechTimes(arrTemplates);

    kTemplateMgr.FindTechTemplate('Tech_AlienCommunications').IsPriorityFn = IsPriority_Always;
    kTemplateMgr.FindTechTemplate('Tech_AlienCommandAndControl').IsPriorityFn = IsPriority_Always;
    kTemplateMgr.FindTechTemplate('Tech_AlienOperations').IsPriorityFn = IsPriority_Always;
    kTemplateMgr.FindTechTemplate('Tech_Xenoneurology').IsPriorityFn = IsPriority_Always;
    kTemplateMgr.FindTechTemplate('Tech_Xenopsionics').IsPriorityFn = IsPriority_Always;

    kTemplateMgr.FindTechTemplate('Tech_AlienPropulsion').IsPriorityFn = IsPriority_AlienPropulsion;
    kTemplateMgr.FindTechTemplate('Tech_Xenobiology').IsPriorityFn = IsPriority_Xenobiology;
    kTemplateMgr.FindTechTemplate('Tech_Xenogenetics').IsPriorityFn = IsPriority_Xenogenetics;

    for (Index = 0; Index < arrTemplates.Length; Index++)
    {
        if (arrTemplates[Index].bIsInterrogation)
        {
            arrTemplates[Index].IsPriorityFn = IsPriority_Interrogation;
        }
    }
}

static function bool IsPriority_Always()
{
    return true;
}

private static function AdjustTechTimes(array<LWCETechTemplate> arrTemplates)
{
    local int Index;

    for (Index = 0; Index < arrTemplates.Length; Index++)
    {
        arrTemplates[Index].iPointsToComplete *= class'XGTacticalGameCore'.default.TECH_TIME_BALANCE;
    }
}

private static function bool IsPriority_AlienPropulsion()
{
    return `LWCE_HQ.m_kObjectiveManager.m_eObjective == eObj_ShootDownOverseer;
}

private static function bool IsPriority_Interrogation()
{
    return !`LWCE_LABS.HasInterrogatedCaptive();
}

private static function bool IsPriority_Xenobiology()
{
    return `LWCE_LABS.GetNumTechsResearched() > 2;
}

private static function bool IsPriority_Xenogenetics()
{
    return `LWCE_HQ.m_kObjectiveManager.m_eObjective == eObj_CaptureOutsider;
}