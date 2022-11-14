class LWCEItemTemplateManager extends LWCEDataTemplateManager;

static function LWCEItemTemplateManager GetInstance()
{
    return LWCEItemTemplateManager(class'LWCE_XComEngine'.static.GetTemplateManager(class'LWCEItemTemplateManager'));
}

function bool AddItemTemplate(LWCEItemTemplate Data, bool ReplaceDuplicate = false)
{
    return AddDataTemplate(Data, ReplaceDuplicate);
}

function LWCEArmorTemplate FindArmorTemplate(name DataName)
{
    return LWCEArmorTemplate(FindDataTemplate(DataName));
}

function LWCEEquipmentTemplate FindEquipmentTemplate(name DataName)
{
    return LWCEEquipmentTemplate(FindDataTemplate(DataName));
}

function LWCEItemTemplate FindItemTemplate(name DataName)
{
    return LWCEItemTemplate(FindDataTemplate(DataName));
}

function LWCEShipWeaponTemplate FindShipWeaponTemplate(name DataName)
{
    return LWCEShipWeaponTemplate(FindDataTemplate(DataName));
}

function LWCEWeaponTemplate FindWeaponTemplate(name DataName)
{
    return LWCEWeaponTemplate(FindDataTemplate(DataName));
}

function array<LWCEArmorTemplate> GetAllArmorTemplates()
{
    local array<LWCEArmorTemplate> arrTemplates;
    local LWCEArmorTemplate kTemplate;
    local int Index;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        kTemplate = LWCEArmorTemplate(m_arrTemplates[Index].kTemplate);

        if (kTemplate != none)
        {
            arrTemplates.AddItem(kTemplate);
        }
    }

    return arrTemplates;
}

function array<LWCEItemTemplate> GetAllItemTemplates()
{
    local array<LWCEItemTemplate> arrTemplates;
    local int Index;

    arrTemplates.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrTemplates[Index] = LWCEItemTemplate(m_arrTemplates[Index].kTemplate);
    }

    return arrTemplates;
}

function array<LWCEShipWeaponTemplate> GetAllShipWeaponTemplates()
{
    local array<LWCEShipWeaponTemplate> arrTemplates;
    local LWCEShipWeaponTemplate kTemplate;
    local int Index;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        kTemplate = LWCEShipWeaponTemplate(m_arrTemplates[Index].kTemplate);

        if (kTemplate != none)
        {
            arrTemplates.AddItem(kTemplate);
        }
    }

    return arrTemplates;
}

function array<LWCEWeaponTemplate> GetAllWeaponTemplates()
{
    local array<LWCEWeaponTemplate> arrTemplates;
    local LWCEWeaponTemplate kTemplate;
    local int Index;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        kTemplate = LWCEWeaponTemplate(m_arrTemplates[Index].kTemplate);

        if (kTemplate != none)
        {
            arrTemplates.AddItem(kTemplate);
        }
    }

    return arrTemplates;
}

defaultproperties
{
    ManagedTemplateClass=class'LWCEItemTemplate'
}