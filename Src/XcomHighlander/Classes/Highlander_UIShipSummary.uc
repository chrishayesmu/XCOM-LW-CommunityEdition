class Highlander_UIShipSummary extends UIShipSummary
    dependson(HighlanderTypes);

simulated function XGHangarUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGHangarUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGHangarUI', self, 1));
    }

    return m_kLocalMgr;
}

simulated function OnShipItemCard()
{
    local HL_TItemCard kCardData;

    if (`HQPRES.m_kItemCard != none)
    {
        return;
    }

    kCardData = Highlander_XGHangarUI(GetMgr()).HL_HANGARUIGetItemCard(-1, -1, 5);

    if (kCardData.iCardType != 0)
    {
        GetMgr().PlayGoodSound();

        if (`HQPRES.m_kItemCard == none)
        {
            `HL_HQPRES.HL_UIItemCard(kCardData);
        }
    }
    else
    {
        GetMgr().PlayBadSound();
    }
}

simulated function OnWeaponItemCard()
{
    local HL_TItemCard kCardData;

    if (`HQPRES.m_kItemCard != none)
    {
        return;
    }

    kCardData = Highlander_XGHangarUI(GetMgr()).HL_HANGARUIGetItemCard();

    if (kCardData.iCardType != 0)
    {
        GetMgr().PlayGoodSound();
        `HL_HQPRES.HL_UIItemCard(kCardData);
    }
    else
    {
        GetMgr().PlayBadSound();
    }
}

function UpdateData()
{
    local int shipStatusID;

    shipStatusID = eUIState_Normal;

    switch (m_kShip.GetStatus())
    {
        case eShipStatus_Ready:
            shipStatusID = eUIState_Good;
            break;
        case eShipStatus_Damaged:
        case eShipStatus_Repairing:
        case eShipStatus_Destroyed:
            shipStatusID = eUIState_Bad;
            break;
        case eShipStatus_Transfer:
        case eShipStatus_Rearming:
        case eShipStatus_Refuelling:
            shipStatusID = eUIState_Warning;
            break;
    }

    AS_SetShipName(m_kShip.m_strCallsign);
    AS_SetWeaponLabel(m_strWeaponLabel);
    AS_SetWeaponName(m_kShip.GetWeaponString());
    AS_SetShipStatus(class'UIUtilities'.static.GetHTMLColoredText(m_kShip.GetStatusString(), shipStatusID), shipStatusID);
    AS_SetKills(m_strKillsLabel @ string(m_kShip.m_iConfirmedKills));
    AS_SetWeaponImage(`HL_ITEM(m_kShip.GetWeapon()).ImagePath);
}