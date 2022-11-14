class LWCE_UIMissionControl_AlienBaseAlert extends UIMissionControl_AlienBaseAlert;

`include(generators.uci)

`LWCE_GENERATOR_ALERTBASE

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', none, iStaringView));
    }

    return m_kLocalMgr;
}

simulated function UpdateData()
{
    local LWCE_TMCAlert kAlertData;

    kAlertData = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;

    UpdateSimpleAlertData();
    AS_SetTitle(Caps(kAlertData.txtTitle.StrValue));
    AS_SetCountry(Caps(kAlertData.arrLabeledText[0].strLabel), kAlertData.arrLabeledText[0].StrValue);
    UpdateButtonText();

    if (`LWCE_STORAGE.LWCE_GetNumItemsAvailable('Item_SkeletonKey') == 0)
    {
        AS_ShowSkeletonKeyNotification(m_strSkeletonKeyRequired);
    }
}