class LWCE_XGWeapon extends XGWeapon;

struct CheckpointRecord_LWCE_XGWeapon extends CheckpointRecord_XGWeapon
{
    var name m_TemplateName;
};

var privatewrite name m_TemplateName;
var privatewrite LWCEWeaponTemplate m_kTemplate;

static simulated function EItemType ItemType()
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function ItemType was called. This needs to be replaced with LWCE_XGWeapon.m_TemplateName. Stack trace follows.");
    ScriptTrace();

    return eItem_None;
}

static simulated function EItemType ZZGameplayType()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GameplayType);

    return eItem_None;
}

function InitFromTemplate(name TemplateName)
{
    // Check if we already init'd
    if (m_kTemplate != none)
    {
        return;
    }

    // TODO: might be able to drop the superclass init
    super.Init();

    m_TemplateName = TemplateName;
    m_kTemplate = `LWCE_WEAPON(TemplateName);

    if (m_kTemplate.eEquipLocation != eSlot_None)
    {
        m_eEquipLocation = m_kTemplate.eEquipLocation;
    }

    // TODO: need to handle GlamCamTag

`if(`notdefined(FINAL_RELEASE))
    if (m_kTemplate == none)
    {
        `LWCE_LOG_CLS("ERROR: template for weapon '" $ TemplateName $ "' could not be found!");
    }
`endif
}

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();

    // Skip some XGWeapon logic we don't want here

    if (m_TemplateName != '')
    {
        InitFromTemplate(m_TemplateName);
    }
}

simulated function Actor CreateEntity()
{
    local XComWeapon kNewWeapon, Template;
    local Actor kOwner;

    if (m_TemplateName != '')
    {
        InitFromTemplate(m_TemplateName);
    }
    else
    {
        InitFromTemplate(`LWCE_GAMECORE.nmItemToCreate);
    }

    if (Role == ROLE_Authority)
    {
        Template = `LWCE_CONTENT_MGR.GetWeaponTemplate(m_TemplateName);

        kOwner = m_kOwner != none ? m_kOwner.GetPawn() : none;
        kNewWeapon = Spawn(class'XComWeapon', kOwner,,,, Template);
        kNewWeapon.SetGameData(self);
        m_kReplicatedWeaponEntity = kNewWeapon;
    }

    return kNewWeapon;
}

simulated function bool DoesRadiusDamage()
{
    return m_kTemplate.iRadius > 0;
}

simulated function float GetDamageRadius()
{
    switch (m_TemplateName)
    {
        case 'BlasterLauncher':
        case 'RecoillessRifle':
        case 'RocketLauncher':
        case 'GrenadeLauncher':
        case 'ProximityMineLauncher':
            if (m_kOwner != none && m_kOwner.GetCharacter().HasUpgrade(ePerk_DangerZone))
            {
                return m_kTemplate.iRadius * Sqrt(1.60); // TODO make configurable
            }

            break;
        case 'HEGrenade':
            if (m_kOwner != none && m_kOwner.GetCharacter().HasUpgrade(`LW_PERK_ID(AlienGrenades)))
            {
                return m_kTemplate.iRadius * Sqrt(2.0);
            }

            break;
    }

    return m_kTemplate.iRadius;
}

simulated function int GetDamageStat()
{
    return m_kTemplate.iDamage;
}

simulated function int GetOverallDamageRadius()
{
    return m_kTemplate.iRadius;
}

simulated function bool HasProperty(int iWeaponProperty)
{
    return m_kTemplate.HasWeaponProperty(EWeaponProperty(iWeaponProperty));
}

simulated function bool IsRearBackPackItem()
{
    return HasProperty(eWP_Backpack);
}

simulated event float LongRange()
{
    return 64.0f * m_kTemplate.iRange;
}

simulated function bool WeaponHasStandardShot()
{
    return m_kTemplate.HasAbility('StandardShot');
}

// ----------------------------------------
// Deprecated functions
// ----------------------------------------

function ApplyAmmoCost(int iCost)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(ApplyAmmoCost);
}

simulated function int GetOverheatChance()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetOverheatChance);

    return 0;
}

simulated function CoolDown()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(CoolDown);
}

simulated function ApplyOverheatIncrement(XGUnit kUnit, int iAmount)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(ApplyOverheatIncrement);
}

simulated function bool HasHeat()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(HasHeat);

    return false;
}

simulated function bool IsOverheated()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(IsOverheated);

    return false;
}

simulated function Overheat(XGUnit kUnit)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(Overheat);
}