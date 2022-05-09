class LWCE_XGWeapon_Extensions extends Object
    abstract;

static simulated function LWCE_TWeapon GetCEWeapon(XGWeapon kWeapon)
{
    return `LWCE_GAMECORE.LWCE_GetTWeapon(GetItemId(kWeapon));
}

static simulated function int GetItemId(XGItem kItem)
{
    return int(kItem.m_strUIImage);
}

// TODO: replace all instances of XGWeapon.LongRange with this
static simulated function float LongRange(XGWeapon kWeapon)
{
    return float(64 * GetCEWeapon(kWeapon).iRange);
}