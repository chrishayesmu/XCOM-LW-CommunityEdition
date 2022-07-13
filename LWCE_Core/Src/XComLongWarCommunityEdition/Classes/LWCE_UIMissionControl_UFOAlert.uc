class LWCE_UIMissionControl_UFOAlert extends UIMissionControl_UFOAlert;

`include(generators.uci)

`LWCE_GENERATOR_ALERTWITHMULTIPLEBUTTONS

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
    local int I, colorState;
    local array<string> speciesList;
    local string formattedSpecies1, formattedSpecies2;
    local LWCE_TMCAlert kAlert;

    kAlert = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert;
    colorState = `HQGAME.GetGameCore().GetHQ().IsHyperwaveActive() ? eUIState_Hyperwave : eUIState_Bad;
    AS_SetTitle(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.txtTitle.StrValue), colorState));
    AS_SetContact(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.arrLabeledText[0].strLabel), colorState), kAlert.arrLabeledText[0].StrValue);
    AS_SetLocation(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.arrLabeledText[1].strLabel), colorState), kAlert.arrLabeledText[1].StrValue);
    AS_SetClass(class'UIUtilities'.static.GetHTMLColoredText(Caps(kAlert.arrLabeledText[2].strLabel), colorState), kAlert.arrLabeledText[2].StrValue);

    if (colorState == eUIState_Hyperwave)
    {
        ParseStringIntoArray(kAlert.arrLabeledText[5].StrValue, speciesList, "//", true);

        while (I < speciesList.Length)
        {
            if (I < 3)
            {
                formattedSpecies1 $= speciesList[I++];

                if (I < 3 && I < speciesList.Length)
                {
                    formattedSpecies1 $= "\n";
                }
            }
            else
            {
                formattedSpecies2 $= speciesList[I++];

                if (I < speciesList.Length)
                {
                    formattedSpecies2 $= "\n";
                }
            }
        }

        AS_SetHyperwaveData(m_strHyperwavePanelTitle, Caps(kAlert.arrLabeledText[3].strLabel), kAlert.arrLabeledText[3].StrValue, Caps(kAlert.arrLabeledText[4].strLabel), kAlert.arrLabeledText[4].StrValue, Caps(kAlert.arrLabeledText[5].strLabel), formattedSpecies1, formattedSpecies2);
    }

    UpdateButtonText();
}