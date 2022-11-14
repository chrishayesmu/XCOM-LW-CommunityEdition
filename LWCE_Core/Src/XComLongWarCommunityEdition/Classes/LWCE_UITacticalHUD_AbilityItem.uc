class LWCE_UITacticalHUD_AbilityItem extends UITacticalHUD_AbilityItem;

var private name m_nmWeapon;

simulated function UpdateData(int Index, XGAbility kAbility, out array<ASValue> arrData)
{
    local XGAbility_Targeted kTargettedAbility;
    local UITacticalHUD_AbilityItem.eBGColor eColor;
    local ASValue kASVal;
    local int iPrevDataLen, iType, iTargetIndex, iCooldown, iCharge, iTmp;
    local name nmWeapon;
    local bool bAvailable, bShowConsoleButtonHelp;
    local string strTemp;

    iPrevDataLen = arrData.Length;
    kTargettedAbility = XGAbility_Targeted(kAbility);
    iTargetIndex = `GAMECORE.m_kAbilities.FindAbilityIndexOnCooldown(kTargettedAbility);

    if (iTargetIndex != INDEX_NONE)
    {
        iCooldown = kAbility.m_kUnit.m_aAbilitiesOnCooldown[iTargetIndex].iCooldown / 2;

        if ((kAbility.m_kUnit.m_aAbilitiesOnCooldown[iTargetIndex].iCooldown % 2) != 0)
        {
            iCooldown++;
        }

        if (kAbility.m_kUnit.m_aAbilitiesOnCooldown[iTargetIndex].iCooldown == `GAMECORE.m_kAbilities.m_arrAbilities[kAbility.GetType()].iCooldown)
        {
            iCooldown = -1;
        }
    }
    else
    {
        iCooldown = -1;

        if (kTargettedAbility != none)
        {
            kAbility = kTargettedAbility;
        }
    }

    if (m_iCooldown != iCooldown)
    {
        m_iCooldown = iCooldown;

        if (iCooldown > 0)
        {
            QueueFunctionString("SetCooldown", m_kContainer.m_strCooldownPrefix $ string(iCooldown), arrData);
        }
        else
        {
            QueueFunctionNull("SetCooldown", arrData);
        }
    }

    iType = kAbility.GetType();

    if (kTargettedAbility.m_kWeapon != none)
    {
        nmWeapon = LWCE_XGWeapon(kTargettedAbility.m_kWeapon).m_TemplateName;
    }
    else
    {
        nmWeapon = '';
    }

    if (m_iType != iType || m_nmWeapon != nmWeapon)
    {
        m_iType = iType;
        m_nmWeapon = nmWeapon;
        QueueFunctionString("SetIconLabel", class'UIUtilities'.static.GetAbilityIconLabel(iType), arrData);

        if (m_kMovieMgr.IsMouseActive())
        {
            QueueFunctionString("SetAntennaText", Caps(kAbility.strName), arrData);
        }
    }

    if (!m_kMovieMgr.IsMouseActive())
    {
        bShowConsoleButtonHelp = iType == eAbility_Overwatch && !UITacticalHUD(m_kContainer.Owner).IsMenuRaised();

        if (m_bShowConsoleButtonHelp != bShowConsoleButtonHelp)
        {
            m_bShowConsoleButtonHelp = bShowConsoleButtonHelp;
            QueueFunctionBool("SetOverwatchButtonHelp", bShowConsoleButtonHelp, arrData);
        }
    }

    bAvailable = m_kContainer.CheckForAvailability(kAbility);

    if (m_bAvailable != bAvailable)
    {
        m_bAvailable = bAvailable;
        QueueFunctionBool("SetAvailable", bAvailable, arrData);
    }

    iCharge = kAbility.GetCharge();
    `LWCE_LOG_CLS("UpdateData: iType = " $ iType $ ", iCharge = " $ iCharge $ ", m_iCharge = " $ m_iCharge);

    if (true || m_iCharge != iCharge)
    {
        m_iCharge = iCharge;

        if (iCharge > 0)
        {
            QueueFunctionString("SetCharge", m_kContainer.m_strChargePrefix $ string(iCharge), arrData);
        }
        else
        {
            QueueFunctionNull("SetCharge", arrData);
        }
    }

    if (kAbility.HasProperty(eProp_Psionic))
    {
        eColor = eBGC_Purple;
    }
    else if (kAbility.HasDisplayProperty(eDisplayProp_Perk))
    {
        eColor = eBGC_Yellow;
    }
    else
    {
        eColor = eBGC_Cyan;
    }

    if (m_eBgColor != eColor)
    {
        m_eBgColor = eColor;

        switch (eColor)
        {
            case eBGC_Cyan:
                strTemp = "cyan";
                break;
            case eBGC_Yellow:
                strTemp = "yellow";
                break;
            case eBGC_Purple:
                strTemp = "purple";
                break;
        }

        QueueFunctionString("SetBGColorLabel", strTemp, arrData);
    }

    if (m_kMovieMgr.IsMouseActive())
    {
        iTmp = eTBC_Ability1 + Index;

        if (iTmp <= eTBC_Ability0)
        {
            strTemp = m_kController.m_Pres.m_kKeybindingData.GetPrimaryOrSecondaryKeyStringForAction(m_kController.PlayerInput, eTBC_Ability1 + Index);
        }
        else
        {
            strTemp = "";
        }

        if (m_strHotkeyLabel != strTemp)
        {
            m_strHotkeyLabel = strTemp;
            QueueFunctionString("SetHotkeyLabel", strTemp, arrData);
        }
    }

    if (arrData.Length != iPrevDataLen)
    {
        kASVal.Type = AS_Null;
        arrData.InsertItem(iPrevDataLen, kASVal);

        kASVal.N = float(Index);
        kASVal.Type = AS_Number;
        arrData.InsertItem(iPrevDataLen + 1, kASVal);
    }
}
