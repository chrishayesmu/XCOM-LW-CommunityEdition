class LWCE_UISoldierListBase_Extensions extends Object
    abstract;

static simulated function UpdateDisplay(UISoldierListBase kSelf)
{
    local bool bSomeoneHasClass;
    local int I, numAvailableSoldiers;
    local LWCE_XGFacility_Barracks kBarracks;

    kBarracks = `LWCE_BARRACKS;

    kSelf.Invoke("ClearSoldierList");

    if (kSelf.m_iCurrentSelection < 0 || kSelf.m_iCurrentSelection >= kSelf.m_arrUIOptions.Length)
    {
        kSelf.m_iCurrentSelection = 0;
    }

    bSomeoneHasClass = false;

    for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
    {
        if (kSelf.m_arrUIOptions[I].strClassName != "")
        {
            bSomeoneHasClass = true;
        }

        kSelf.AS_AddSoldierWithNickname(kSelf.m_arrUIOptions[I].strName,
                                        kSelf.m_arrUIOptions[I].strNickName,
                                        kSelf.m_arrUIOptions[I].strClassName,
                                        class'UIUtilities'.static.GetHTMLColoredText(kSelf.m_arrUIOptions[I].strStatus, kSelf.m_arrUIOptions[I].iStatusState),
                                        kSelf.m_arrUIOptions[I].iState == eUIState_Disabled,
                                        kSelf.m_arrUIOptions[I].bPromotable,
                                        kSelf.m_arrUIOptions[I].bPsiPromotable,
                                        class'UIUtilities'.static.GetRankLabel(kSelf.m_arrUIOptions[I].iRank, kSelf.m_arrUIOptions[I].bShiv),
                                        kBarracks.GetClassIcon(kSelf.m_arrUIOptions[I].iClass, kSelf.m_arrUIOptions[I].bIsPsiSoldier, kSelf.m_arrUIOptions[I].bHasGeneMod),
                                        class'UIScreen'.static.GetFlagPath(kSelf.m_arrUIOptions[I].iCountry), kSelf.m_arrUIOptions[I].strMedals);

        if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
        {
            ++ numAvailableSoldiers;
        }
    }

    if (bSomeoneHasClass)
    {
        kSelf.AS_SetTitleLabels(kSelf.m_strSoldierListBaseTitle, kSelf.m_strSoldierListBaseClassLabel, kSelf.m_strSoldierListBaseStatusLabel);
    }

    kSelf.AS_SetCountLabel(numAvailableSoldiers $ "<font size='14'>/" $ kSelf.m_arrUIOptions.Length);

    if (numAvailableSoldiers > 0)
    {
        // kSelf.m_arrUIOptions[0] is just being used as a scratch variable here for building up a string with all of the class labels
        // and the count of how many units are available to augment of each class. We start by adding ** in the front so we can
        // ultimately restore the string to its original value.
        // TODO: rewrite all of this to be cleaner and to extend to modded classes
        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ "**<font size='20'>";
        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ numAvailableSoldiers $ "<font size='14'>/" $ kSelf.m_arrUIOptions.Length $ "</font></font> ";

        numAvailableSoldiers = 0;
        for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
        {
            if (kSelf.m_arrUIOptions[I].iClass == 11) // Sniper
            {
                numAvailableSoldiers = numAvailableSoldiers + 256;

                if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
                {
                    ++numAvailableSoldiers;
                }
            }
        }

        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ " <font color='#ffd800' size='20'>" $ "<img src='img://LongWar.ClassIcons.sniper' height='32' width='32' vspace='-16'>" $ string(numAvailableSoldiers & 255) $ "<font size='14'>/" $ string(numAvailableSoldiers >> 8) $ "</font></font>";

        numAvailableSoldiers = 0;
        for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
        {
            if (kSelf.m_arrUIOptions[I].iClass == 21) // Scout
            {
                numAvailableSoldiers = numAvailableSoldiers + 256;

                if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
                {
                    ++numAvailableSoldiers;
                }
            }
        }

        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ " <font color='#fe642e' size='20'>" $ "<img src='img://LongWar.ClassIcons.scout' height='32' width='32' vspace='-16'>" $ string(numAvailableSoldiers & 255) $ "<font size='14'>/" $ string(numAvailableSoldiers >> 8) $ "</font></font>";

        numAvailableSoldiers = 0;
        for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
        {
            if (kSelf.m_arrUIOptions[I].iClass == 12) // Rocketeer
            {
                numAvailableSoldiers = numAvailableSoldiers + 256;

                if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
                {
                    ++numAvailableSoldiers;
                }
            }
        }

        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ " <font color='#c01080' size='20'>" $ "<img src='img://LongWar.ClassIcons.rocketeer' height='32' width='32' vspace='-16'>" $ string(numAvailableSoldiers & 255) $ "<font size='14'>/" $ string(numAvailableSoldiers >> 8) $ "</font></font>";

        numAvailableSoldiers = 0;
        for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
        {
            if (kSelf.m_arrUIOptions[I].iClass == 22) // Gunner
            {
                numAvailableSoldiers = numAvailableSoldiers + 256;

                if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
                {
                    ++numAvailableSoldiers;
                }
            }
        }

        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ " <font color='#609020' size='20'>" $ "<img src='img://LongWar.ClassIcons.heavy' height='32' width='32' vspace='-16'>" $ string(numAvailableSoldiers & 255) $ "<font size='14'>/" $ string(numAvailableSoldiers >> 8) $ "</font></font>";

        numAvailableSoldiers = 0;
        for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
        {
            if (kSelf.m_arrUIOptions[I].iClass == 13) // Medic
            {
                numAvailableSoldiers = numAvailableSoldiers + 256;

                if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
                {
                    ++numAvailableSoldiers;
                }
            }
        }

        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ " <font color='#fafafa' size='20'>" $ "<img src='img://LongWar.ClassIcons.support' height='32' width='32' vspace='-16'>" $ string(numAvailableSoldiers & 255) $ "<font size='14'>/" $ string(numAvailableSoldiers >> 8) $ "</font></font>";

        numAvailableSoldiers = 0;
        for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
        {
            if (kSelf.m_arrUIOptions[I].iClass == 23) // Engineer
            {
                numAvailableSoldiers = numAvailableSoldiers + 256;

                if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
                {
                    ++numAvailableSoldiers;
                }
            }
        }

        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ " <font color='#20b0a0' size='20'>" $ "<img src='img://LongWar.ClassIcons.engineer' height='32' width='32' vspace='-16'>" $ string(numAvailableSoldiers & 255) $ "<font size='14'>/" $ string(numAvailableSoldiers >> 8) $ "</font></font>";

        numAvailableSoldiers = 0;
        for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
        {
            if (kSelf.m_arrUIOptions[I].iClass == 14) // Assault
            {
                numAvailableSoldiers = numAvailableSoldiers + 256;

                if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
                {
                    ++numAvailableSoldiers;
                }
            }
        }

        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ " <font color='#fe2e2e' size='20'>" $ "<img src='img://LongWar.ClassIcons.assault' height='32' width='32' vspace='-16'>" $ string(numAvailableSoldiers & 255) $ "<font size='14'>/" $ string(numAvailableSoldiers >> 8) $ "</font></font>";

        numAvailableSoldiers = 0;
        for (I = 0; I < kSelf.m_arrUIOptions.Length; I++)
        {
            if (kSelf.m_arrUIOptions[I].iClass == 24) // Infantry
            {
                numAvailableSoldiers = numAvailableSoldiers + 256;

                if (kSelf.m_arrUIOptions[I].iStatusState == eUIState_Good || kSelf.m_arrUIOptions[I].iStatusState == eUIState_Normal)
                {
                    ++numAvailableSoldiers;
                }
            }
        }

        kSelf.m_arrUIOptions[0].strName = kSelf.m_arrUIOptions[0].strName $ " <font color='#5882fa' size='20'>" $ "<img src='img://LongWar.ClassIcons.infantry' height='32' width='32' vspace='-16'>" $ string(numAvailableSoldiers & 255) $ "<font size='14'>/" $ string(numAvailableSoldiers >> 8) $ "</font></font>";

        kSelf.AS_SetCountLabel(Mid(kSelf.m_arrUIOptions[0].strName, InStr(kSelf.m_arrUIOptions[0].strName, "**") + 2, 2048));
        kSelf.m_arrUIOptions[0].strName = Mid(kSelf.m_arrUIOptions[0].strName, 0, InStr(kSelf.m_arrUIOptions[0].strName, "**"));
    }

    kSelf.RealizeSelected();
    kSelf.Show();
}