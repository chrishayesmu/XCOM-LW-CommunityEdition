class LWCE_XGWeapon_Extensions extends Object
    abstract;

static simulated function LWCEWeaponTemplate GetCEWeapon(XGWeapon kWeapon)
{
    if (LWCE_XGWeapon(kWeapon) != none)
    {
        return LWCE_XGWeapon(kWeapon).m_kTemplate;
    }

    return `LWCE_WEAPON(GetItemName(kWeapon));
}

static simulated function name GetItemName(XGItem kItem)
{
    if (LWCE_XGWeapon(kItem) != none)
    {
        return LWCE_XGWeapon(kItem).m_TemplateName;
    }

    return kItem == none ? '' : name(kItem.m_strUIImage);
}

static simulated function float LongRange(XGWeapon kWeapon)
{
    return `METERSTOUNITS(GetCEWeapon(kWeapon).iRange);
}