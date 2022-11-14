class LWCE_UIShipLoadout extends UIShipLoadout;

simulated function bool OnCancel(optional string Arg = "")
{
    local LWCE_XGHangarUI kMgr;
    local LWCEShipWeaponTemplate kShipWeapon;

    kMgr = LWCE_XGHangarUI(GetMgr());

    kShipWeapon = LWCEShipWeaponTemplate(`LWCE_ITEM(LWCE_XGShip_Interceptor(m_kShip).LWCE_GetWeapon()));
    kMgr.LWCE_UpdateShipWeaponView(m_kShip, kShipWeapon);
    kMgr.OnLeaveTable();

    return true;
}

function RealizeSelected()
{
    local int shipWpnRange, shipWpnFireRate, shipWpnBaseDamage, shipWpnArmorPen;
    local string tmpStr;
    local LWCE_XGHangarUI kMgr;
    local LWCEShipWeaponTemplate kShipWeapon;

    kMgr = LWCE_XGHangarUI(GetMgr());

    kShipWeapon = LWCEShipWeaponTemplate(kMgr.m_arrCEItems[m_iCurrentSelection]);
    kMgr.LWCE_UpdateShipWeaponView(m_kShip, kShipWeapon);

    shipWpnRange = kMgr.GetShipWeaponRangeBin(kShipWeapon.iRange);
    shipWpnFireRate = kMgr.GetShipWeaponFiringRateBin(kShipWeapon.fFiringTime);
    shipWpnBaseDamage = kMgr.GetShipWeaponDamageBin(kShipWeapon.iDamage);
    shipWpnArmorPen = kMgr.GetShipWeaponArmorPenetrationBin(kShipWeapon.iArmorPen);

    // TODO make hit chance per stance configurable
    AS_SetStatData(0, class'UIItemCards'.default.m_strHitChanceLabel, Min(kShipWeapon.iHitChance - 15, 95) $ "/" $ Min(kShipWeapon.iHitChance, 95) $ "/" $ Min(kShipWeapon.iHitChance + 15, 95) $ "");

    switch (shipWpnRange)
    {
        case eWRC_Short:
            tmpStr = class'UIItemCards'.default.m_strRangeShort;
            break;
        case eWRC_Medium:
            tmpStr = class'UIItemCards'.default.m_strRangeMedium;
            break;
        case eWRC_Long:
            tmpStr = class'UIItemCards'.default.m_strRangeLong;
            break;
    }

    AS_SetStatData(1, class'UIItemCards'.default.m_strRangeLabel, tmpStr);

    switch (shipWpnFireRate)
    {
        case eSFR_Slow:
            tmpStr = class'UIItemCards'.default.m_strRateSlow;
            break;
        case eSFR_Medium:
            tmpStr = class'UIItemCards'.default.m_strRateMedium;
            break;
        case eSFR_Rapid:
            tmpStr = class'UIItemCards'.default.m_strRateRapid;
            break;
    }

    AS_SetStatData(2, class'UIItemCards'.default.m_strFireRateLabel, tmpStr);

    switch (shipWpnBaseDamage)
    {
        case eGTS_Low:
            tmpStr = class'UIItemCards'.default.m_strGenericScaleLow;
            break;
        case eGTS_Medium:
            tmpStr = class'UIItemCards'.default.m_strGenericScaleMedium;
            break;
        case eGTS_High:
            tmpStr = class'UIItemCards'.default.m_strGenericScaleHigh;
            break;
    }

    AS_SetStatData(3, class'UIItemCards'.default.m_strDamageLabel, tmpStr);

    switch (shipWpnArmorPen)
    {
        case eGTS_Low:
            tmpStr = class'UIItemCards'.default.m_strGenericScaleLow;
            break;
        case eGTS_Medium:
            tmpStr = class'UIItemCards'.default.m_strGenericScaleMedium;
            break;
        case eGTS_High:
            tmpStr = class'UIItemCards'.default.m_strGenericScaleHigh;
            break;
    }

    AS_SetStatData(4, class'UIItemCards'.default.m_strArmorPenetrationLabel, tmpStr);

    AS_SetSelected(m_iCurrentSelection);
    AS_SetWeaponName(kShipWeapon.strName);
    AS_SetWeaponImage(kMgr.m_kTable.arrSummaries[m_iCurrentSelection].imgOption.strPath, 0.90);
    AS_SetWeaponDescription(kMgr.m_kTable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue);
}