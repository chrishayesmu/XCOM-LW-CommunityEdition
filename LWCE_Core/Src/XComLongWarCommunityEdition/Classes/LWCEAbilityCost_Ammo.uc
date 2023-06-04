class LWCEAbilityCost_Ammo extends LWCEAbilityCost;

var int iAmmo;

function name CanAfford(LWCE_XGAbility kAbility, const LWCE_TAvailableTarget kTarget)
{
    local LWCE_XGWeapon kWeapon;

    kWeapon = LWCE_XGWeapon(kAbility.m_kWeapon);

    if (kWeapon == none)
    {
        return 'AA_NotAWeapon';
    }

    if (kWeapon.iAmmo < iAmmo)
    {
        return 'AA_CannotAfford_AmmoCost';
    }

    return 'AA_Success';
}

function ApplyCost(LWCE_XGAbility kAbility, const LWCE_TAvailableTarget kTarget)
{
    local LWCE_XGWeapon kWeapon;

    if (ShouldSkipCost())
    {
        return;
    }

    kWeapon = LWCE_XGWeapon(kAbility.m_kWeapon);
    kWeapon.iAmmo = Max(kWeapon.iAmmo - iAmmo, 0);
}