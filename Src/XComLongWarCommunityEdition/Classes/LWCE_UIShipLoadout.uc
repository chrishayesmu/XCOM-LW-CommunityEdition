class LWCE_UIShipLoadout extends UIShipLoadout;

simulated function bool OnCancel(optional string Arg = "")
{
    local TShipWeapon kWeapon;

    kWeapon = GetMgr().SHIPWEAPON(`LWCE_HANGAR.LWCE_ItemTypeToShipWeapon(m_kShip.GetWeapon()));
    GetMgr().UpdateShipWeaponView(m_kShip, kWeapon.eType);
    GetMgr().OnLeaveTable();

    return true;
}

function RealizeSelected()
{
    local int shipWpnRange, shipWpnFireRate, shipWpnBaseDamage, shipWpnArmorPen;
    local string tmpStr;
    local LWCE_XGHangarUI kMgr;
    local TShipWeapon kWeapon;

    kMgr = LWCE_XGHangarUI(GetMgr());

    kWeapon = kMgr.SHIPWEAPON(`LWCE_HANGAR.LWCE_ItemTypeToShipWeapon(kMgr.m_arrCEItems[m_iCurrentSelection].iItemId));
    kMgr.UpdateShipWeaponView(m_kShip, kWeapon.eType);
    shipWpnRange = kMgr.GetShipWeaponRangeBin(kWeapon.iRange);
    shipWpnFireRate = kMgr.GetShipWeaponFiringRateBin(kWeapon.fFiringTime);
    shipWpnBaseDamage = kMgr.GetShipWeaponDamageBin(kWeapon.iDamage);
    shipWpnArmorPen = kMgr.GetShipWeaponArmorPenetrationBin(kWeapon.iAP);

    AS_SetStatData(0, class'UIItemCards'.default.m_strHitChanceLabel, string(Min(kWeapon.iToHit - 15, 95)) $ "/" $ string(Min(kWeapon.iToHit, 95)) $ "/" $ string(Min(kWeapon.iToHit + 15, 95)) $ "");

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
    AS_SetWeaponName(kWeapon.strName);
    AS_SetWeaponImage(kMgr.m_kTable.arrSummaries[m_iCurrentSelection].imgOption.strPath, 0.90);
    AS_SetWeaponDescription(kMgr.m_kTable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue);
}