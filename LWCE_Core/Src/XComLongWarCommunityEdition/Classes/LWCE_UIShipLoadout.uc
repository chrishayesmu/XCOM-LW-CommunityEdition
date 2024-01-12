class LWCE_UIShipLoadout extends UIShipLoadout;

var LWCE_XGShip m_kCEShip;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, XGShip_Interceptor kShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

simulated function LWCE_Init(XComPlayerController _controller, UIFxsMovie _manager, LWCE_XGShip kShip)
{
    BaseInit(_controller, _manager);
    manager.LoadScreen(self);
    m_kCEShip = kShip;
}

simulated function OnInit()
{
    super.OnInit();

    GetMgr().m_kShip = m_kCEShip;
    AS_SetTitle(m_strScreenTitle);
    AS_SetListLabels(m_strShipWeaponColumnLabel, m_strQuantityColumnLabel);
    UpdateData();
    `HQPRES.GetStrategyHUD().ShowBackButton(OnMouseCancel);
}

simulated function bool OnAccept(optional string Arg = "")
{
    local LWCE_XGHangarUI kMgr;
    local XGParamTag kTag;
    local TDialogueBoxData kData;

    kMgr = LWCE_XGHangarUI(GetMgr());

    if (kMgr.m_kTable.mnuOptions.arrOptions[m_iCurrentSelection].iState == eUIState_Disabled)
    {
        kMgr.PlayBadSound();
    }
    else
    {
        kMgr.PlayOpenSound();
        kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
        kTag.StrValue0 = kMgr.m_kTable.mnuOptions.arrOptions[m_iCurrentSelection].arrStrings[0];
        kTag.IntValue0 = int(kMgr.m_kTable.mnuOptions.arrOptions[m_iCurrentSelection].arrStrings[2]);

        kData.strTitle = m_strConfirmEquipDialogTitle;
        kData.strText = class'XComLocalizer'.static.ExpandString(m_strConfirmEquipDialogText);
        kData.strAccept = m_strConfirmEquipDialogAcceptText;
        kData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
        kData.fnCallback = OnConfirmDialogComplete;

        `HQPRES.UIRaiseDialog(kData);
    }

    return true;
}

simulated function bool OnCancel(optional string Arg = "")
{
    local LWCE_XGHangarUI kMgr;
    local LWCEShipWeaponTemplate kShipWeapon;

    kMgr = LWCE_XGHangarUI(GetMgr());

    kShipWeapon = `LWCE_SHIP_WEAPON(m_kCEShip.GetWeaponAtIndex(0));
    kMgr.LWCE_UpdateShipWeaponView(kShipWeapon);
    kMgr.OnLeaveTable();

    return true;
}

function RealizeSelected()
{
    local int shipWpnRange, shipWpnBaseDamage, shipWpnHitChance, shipWpnArmorPen;
    local float shipWpnFireRate;
    local string strRangeValue;
    local LWCE_XGHangarUI kMgr;
    local LWCEShipWeaponTemplate kShipWeapon;

    kMgr = LWCE_XGHangarUI(GetMgr());

    kShipWeapon = kMgr.m_arrCEItems[m_iCurrentSelection];
    kMgr.LWCE_UpdateShipWeaponView(kShipWeapon);

    shipWpnRange = kMgr.GetShipWeaponRangeBin(kShipWeapon.iRange);
    shipWpnArmorPen = kShipWeapon.GetArmorPen(m_kCEShip);
    shipWpnBaseDamage = kShipWeapon.GetDamage(m_kCEShip) * (1 + m_kCEShip.m_iConfirmedKills / 100.0f);
    shipWpnFireRate = kShipWeapon.GetFiringTime(m_kCEShip);
    shipWpnHitChance = kShipWeapon.GetHitChance(m_kCEShip) + Clamp(3 * m_kCEShip.m_iConfirmedKills, 0, 30);

    AS_SetStatData(0, class'LWCE_UIItemCards'.default.m_strHitChanceLabel, class'LWCE_UIItemCards'.static.GetShipHitChanceString(shipWpnHitChance));

    switch (shipWpnRange)
    {
        case eWRC_Short:
            strRangeValue = class'LWCE_UIItemCards'.default.m_strRangeShort;
            break;
        case eWRC_Medium:
            strRangeValue = class'LWCE_UIItemCards'.default.m_strRangeMedium;
            break;
        case eWRC_Long:
            strRangeValue = class'LWCE_UIItemCards'.default.m_strRangeLong;
            break;
    }

    AS_SetStatData(1, class'LWCE_UIItemCards'.default.m_strRangeLabel, strRangeValue);
    AS_SetStatData(2, class'LWCE_UIItemCards'.default.m_strFireRateLabel, string(shipWpnFireRate));
    AS_SetStatData(3, class'LWCE_UIItemCards'.default.m_strDamageLabel, string(shipWpnBaseDamage));
    AS_SetStatData(4, class'LWCE_UIItemCards'.default.m_strArmorPenetrationLabel, string(shipWpnArmorPen));

    AS_SetSelected(m_iCurrentSelection);
    AS_SetWeaponName(kShipWeapon.strName);
    AS_SetWeaponImage(kMgr.m_kTable.arrSummaries[m_iCurrentSelection].imgOption.strPath, 0.90);
    AS_SetWeaponDescription(kMgr.m_kTable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue $ class'LWCE_XGHangarUI'.default.m_strShipStatDisclaimer);
}