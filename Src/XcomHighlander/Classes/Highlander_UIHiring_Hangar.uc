class Highlander_UIHiring_Hangar extends UIHiring_Hangar;

simulated function bool OnAccept(optional string selectedOption = "")
{
    if (GetMgr().OnAcceptHiringOrder())
    {
        // Highlander issue #1: normally when you order interceptors, the strategy HUD (particularly the player's current money)
        // doesn't update until you back out to the main HQ screen. This fix simply updates the HUD immediately.
        XComHQPresentationLayer(controllerRef.m_Pres).GetStrategyHUD().UpdateDefaultResources();

        PlaySound(SoundCue(DynamicLoadObject("SoundUI.MenuSelectCue", class'SoundCue')), true);
    }
    else
    {
        PlaySound(SoundCue(DynamicLoadObject("SoundUI.MenuCancelCue", class'SoundCue')), true);
    }

    return true;
}