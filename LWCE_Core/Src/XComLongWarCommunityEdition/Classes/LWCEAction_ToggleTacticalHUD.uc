class LWCEAction_ToggleTacticalHUD extends LWCEAction;

var bool m_bShowHUD;

state Executing
{
Begin:
    if (m_bShowHUD)
    {
        `LWCE_LOG_CLS("Showing HUD");
        `LWCE_TACPRES.HUDShow();
    }
    else
    {
        `LWCE_LOG_CLS("Hiding HUD");
        `LWCE_TACPRES.HUDHide();
    }

    CompleteAction();
}