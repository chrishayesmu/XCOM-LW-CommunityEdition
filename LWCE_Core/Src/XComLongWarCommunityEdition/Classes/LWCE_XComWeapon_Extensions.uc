class LWCE_XComWeapon_Extensions extends Object
    abstract;

static function PrepareProjectile(XComWeapon kSelf, int TemplateIndex)
{
    local bool bIsHit;
    local LWCE_XGUnit FiringUnit;
    local XGAction_Fire FireAction;
    local CustomProjectileTemplate Template;

    FiringUnit = LWCE_XGUnit(kSelf.m_kPawn.GetGameUnit());

    if (FiringUnit != none && kSelf.m_kGameWeapon != none && LWCE_XGWeapon(kSelf.m_kGameWeapon).m_TemplateName == 'Item_GrenadeLauncher')
    {
        if (FiringUnit.GetCharacter().HasUpgrade(`LW_PERK_ID(AlienGrenades)))
        {
            TemplateIndex = 1;
        }
        else
        {
            TemplateIndex = 0;
        }
    }

    if (kSelf.ProjectileTemplates.Length > TemplateIndex)
    {
        FireAction = XGAction_Fire(FiringUnit.GetAction());

        if (FireAction != none)
        {
            bIsHit = FireAction.IsHit();
        }

        Template = kSelf.ProjectileTemplates[TemplateIndex];
        kSelf.ProjectileTemplate = bIsHit ? Template.Hit : Template.Miss;
    }
}