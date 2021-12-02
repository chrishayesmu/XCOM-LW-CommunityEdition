class Highlander_UIHiring_Hangar extends UIHiring_Hangar;

simulated function bool OnAccept(optional string selectedOption = "")
{
    if (GetMgr().OnAcceptHiringOrder())
    {


        PlaySound(SoundCue(DynamicLoadObject("SoundUI.MenuSelectCue", class'SoundCue')), true);
    }
    else
    {
        PlaySound(SoundCue(DynamicLoadObject("SoundUI.MenuCancelCue", class'SoundCue')), true);
    }

    return true;
}