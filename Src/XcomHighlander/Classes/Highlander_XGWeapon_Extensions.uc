class Highlander_XGWeapon_Extensions extends Object;

static simulated function HL_TWeapon GetHLWeapon(XGWeapon kWeapon)
{
    return `HL_GAMECORE.HL_GetTWeapon(GetItemId(kWeapon));
}

static simulated function int GetItemId(XGItem kItem)
{
    return int(kItem.m_strUIImage);
}

// TODO: replace all instances of XGWeapon.LongRange with this
static simulated function float LongRange(XGWeapon kWeapon)
{
    return float(64 * GetHLWeapon(kWeapon).iRange);
}