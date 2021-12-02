class Highlander_UIItemCards extends UIItemCards
    dependson(HighlanderTypes);

var HL_TItemCard m_tHLItemCard;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, TItemCard cardData)
{
    `HL_LOG_DEPRECATED_CLS(Init);
}

simulated function HL_Init(XComPlayerController _controller, UIFxsMovie _manager, HL_TItemCard cardData)
{
    BaseInit(_controller, _manager);
    m_tHLItemCard = cardData;
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
            if ((Arg & 2) != 0 || (Arg & 8) != 0 || (Arg & 4) != 0)
            {
                AS_ScrollUp(0.10, 20);
            }

            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
            if ((Arg & 2) != 0 || (Arg & 8) != 0 || (Arg & 4) != 0)
            {
                AS_ScrollDown(0.10, 20);
            }

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_L3:
        case class'UI_FxsInput'.const.FXS_KEY_F1:
            if (m_tHLItemCard.iCardType != eItemCard_MPCharacter)
            {
                if (CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
                {
                    if (IsInited())
                    {
                        OnClose("");
                        PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
                    }
                }
            }

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_B:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
        case class'UI_FxsInput'.const.FXS_KEY_F1:
            if (CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
            {
                if (IsInited())
                {
                    OnClose("");
                    PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
                }
            }

            break;
        default:
            break;
    }
    return true;
}

simulated function UpdateData()
{
    local string tmpStr;
    local HL_TItem kItem;

    if (m_tHLItemCard.iItemId != 0)
    {
        kItem = `HL_ITEM(m_tHLItemCard.iItemId);
    }

    switch (m_tHLItemCard.iCardType)
    {
        case eItemCard_Armor:
        case eItemCard_MECArmor:
            AS_SetCardTitle(Caps(m_tHLItemCard.strName));
            AS_SetStatData(0, m_strHealthBonusLabel, string(m_tHLItemCard.iArmorHPBonus));
            tmpStr = HL_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tHLItemCard.strFlavorText);

            if (m_tHLItemCard.iItemId == eItem_MecCivvies)
            {
                AS_SetCardImage(kItem.ImagePath, eItemCard_Armor);
            }
            else
            {
                AS_SetCardImage(kItem.ImagePath, m_tHLItemCard.iCardType);
            }

            break;
        case eItemCard_EquippableItem:
            AS_SetCardTitle(Caps(m_tHLItemCard.strName));

            if (m_tHLItemCard.iCharges > 0)
            {
                AS_SetStatData(0, m_strChargesLabel, string(m_tHLItemCard.iCharges));
            }
            else
            {
                AS_SetStatData(0, "", "");
            }

            tmpStr = HL_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tHLItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tHLItemCard.iCardType);

            break;
        case eItemCard_SoldierWeapon:
            switch (m_tHLItemCard.iRangeCategory)
            {
                case eWRC_Short:
                    tmpStr = m_strRangeShort;
                    break;
                case eWRC_Medium:
                    tmpStr = m_strRangeMedium;
                    break;
                case eWRC_Long:
                    tmpStr = m_strRangeLong;
                    break;
            }

            AS_SetCardTitle(Caps(m_tHLItemCard.strName));
            AS_SetStatData(0, m_strEffectiveRangeLabel, tmpStr);

            if (m_tHLItemCard.iBaseDamage < 0)
            {
                AS_SetStatData(1, "", "");
            }
            else
            {
                if (m_tHLItemCard.iBaseDamage == m_tHLItemCard.iBaseDamageMax || m_tHLItemCard.iBaseDamageMax < 0)
                {
                    AS_SetStatData(1, m_strBaseDamageLabel, string(m_tHLItemCard.iBaseDamage));
                }
                else
                {
                    AS_SetStatData(1, m_strBaseDamageLabel, string(m_tHLItemCard.iBaseDamage) @ "-" @ string(m_tHLItemCard.iBaseDamageMax));
                }
            }

            if (m_tHLItemCard.iBaseCritChance < 0)
            {
                AS_SetStatData(2, "", "");
            }
            else
            {
                AS_SetStatData(2, m_strBaseCriticalDamageLabel, string(m_tHLItemCard.iBaseCritChance) $ "%");
            }

            if (m_tHLItemCard.iCritDamage < 0)
            {
                AS_SetStatData(3, "", "");
            }
            else
            {
                if (m_tHLItemCard.iCritDamage == m_tHLItemCard.iCritDamageMax || m_tHLItemCard.iCritDamageMax < 0)
                {
                    AS_SetStatData(3, m_strCriticalDamageLabel, string(m_tHLItemCard.iCritDamage));
                }
                else
                {
                    AS_SetStatData(3, m_strCriticalDamageLabel, string(m_tHLItemCard.iCritDamage) @ "-" @ string(m_tHLItemCard.iCritDamageMax));
                }
            }

            tmpStr = HL_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tHLItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tHLItemCard.iCardType);

            break;
        case eItemCard_Interceptor:
        case eItemCard_InterceptorConsumable:
        case eItemCard_Satellite:
            AS_SetCardTitle(Caps(m_tHLItemCard.strName));
            AS_AddSimpleTextCardData(m_tHLItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tHLItemCard.iCardType);
            break;
        case eItemCard_ShipWeapon:
            AS_SetCardTitle(Caps(m_tHLItemCard.strName));
            AS_SetStatData(0, m_strHitChanceLabel, string(m_tHLItemCard.shipWpnHitChance) $ "%");

            switch (m_tHLItemCard.shipWpnRange)
            {
                case eWRC_Short:
                    tmpStr = m_strRangeShort;
                    break;
                case eWRC_Medium:
                    tmpStr = m_strRangeMedium;
                    break;
                case eWRC_Long:
                    tmpStr = m_strRangeLong;
                    break;
            }

            AS_SetStatData(1, m_strRangeLabel, tmpStr);

            switch (m_tHLItemCard.shipWpnFireRate)
            {
                case eSFR_Slow:
                    tmpStr = m_strRateSlow;
                    break;
                case eSFR_Medium:
                    tmpStr = m_strRateMedium;
                    break;
                case eSFR_Rapid:
                    tmpStr = m_strRateRapid;
                    break;
            }

            AS_SetStatData(2, m_strFireRateLabel, tmpStr);

            switch (m_tHLItemCard.iBaseDamage)
            {
                case eGTS_Low:
                    tmpStr = m_strGenericScaleLow;
                    break;
                case eGTS_Medium:
                    tmpStr = m_strGenericScaleMedium;
                    break;
                case eGTS_High:
                    tmpStr = m_strGenericScaleHigh;
                    break;
            }

            AS_SetStatData(3, m_strDamageLabel, tmpStr);

            switch (m_tHLItemCard.shipWpnArmorPen)
            {
                case eGTS_Low:
                    tmpStr = m_strGenericScaleLow;
                    break;
                case eGTS_Medium:
                    tmpStr = m_strGenericScaleMedium;
                    break;
                case eGTS_High:
                    tmpStr = m_strGenericScaleHigh;
                    break;
            }

            AS_SetStatData(4, m_strArmorPenetrationLabel, tmpStr);

            AS_SetStatData(0, m_strHitChanceLabel, string(Min(m_tHLItemCard.shipWpnHitChance - 15, 95)) $ "/" $ string(Min(m_tHLItemCard.shipWpnHitChance, 95)) $ "/" $ string(Min(m_tHLItemCard.shipWpnHitChance + 15, 95)) $ "");
            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tHLItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tHLItemCard.iCardType);
            break;
        case eItemCard_SHIV:
            AS_SetCardTitle(Caps(m_tHLItemCard.strName));
            switch (m_tHLItemCard.iItemId)
            {
                case eItem_SHIV:
                    tmpStr = m_strChassisTypeNormal;
                    break;
                case eItem_SHIV_Alloy:
                    tmpStr = m_strChassisTypeAlloy;
                    break;
                case eItem_SHIV_Hover:
                    tmpStr = m_strChassisTypeHover;
                    break;
            }

            AS_SetStatData(0, m_strWeaponTypeLabel, Caps(m_tHLItemCard.strShivWeapon));
            AS_SetStatData(1, m_strChassisTypeLabel, Caps(tmpStr));

            tmpStr = HL_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            tmpStr = HL_GenerateAlternativeAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strSHIVWeaponAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tHLItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tHLItemCard.iCardType);
            break;
        case eItemCard_MPCharacter:
            AS_SetCardTitle(Caps(m_tHLItemCard.strName));
            AS_SetStatData(0, m_strHPLabel, string(m_tHLItemCard.iHealth));
            AS_SetStatData(1, m_strWillLabel, string(m_tHLItemCard.iWill));
            AS_SetStatData(2, m_strAimLabel, string(m_tHLItemCard.iAim));
            AS_SetStatData(3, m_strDefenseLabel, string(m_tHLItemCard.iDefense));

            tmpStr = HL_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            tmpStr = HL_GeneratePerkData();

            if (tmpStr != "")
            {
                AS_AddPerksCardData(m_strAbilitiesListHeader, tmpStr);
            }

            tmpStr = HL_GenerateAlternativeAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strSHIVWeaponAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tHLItemCard.strFlavorText);
            AS_SetCardImage(class'UIUtilities'.static.GetCharacterCardImage(ECharacter(m_tHLItemCard.iCharacterId)), m_tHLItemCard.iCardType);

            break;
        case eItemCard_GeneMod:
            AS_SetCardTitle(Caps(m_tHLItemCard.strName));
            tmpStr = HL_GeneratePerkData();

            if (tmpStr != "")
            {
                AS_AddPerksCardData(m_strAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tHLItemCard.strFlavorText);
            AS_SetCardImage("img:///UILibrary_MPCards.MPCard_GeneMod", m_tHLItemCard.iCardType);

            break;
        default:
            OnClose();
    }
}

protected function int ConvertAbilityIdToItemCard(int iAbilityId)
{
    // Copied from XGTacticalGameCore.ConvertAbilityIdToItemCard
    switch (iAbilityId)
    {
        case eAbility_Ghost:
            return eICA_Ghost;
        case eAbility_Grapple:
            return eICA_Grapple;
        case eAbility_ShotDamageCover:
            return eICA_DestroyCover;
        case eAbility_Fly:
            return eICA_ArchangelFlight;
        case eAbility_FlyUp:
            return eICA_SHIVFlight;
        case eAbility_MEC_Flamethrower:
            return eICA_MEC_Flamethrower;
        case eAbility_MEC_KineticStrike:
            return eICA_MEC_KineticStrike;
        case eAbility_MEC_ProximityMine:
            return eICA_MEC_ProximityMine;
        case eAbility_MEC_GrenadeLauncher:
            return eICA_MEC_GrenadeLauncher;
        case eAbility_MEC_RestorativeMist:
            return eICA_MEC_RestorativeMist;
        case eAbility_MEC_ElectroPulse:
            return eICA_MEC_ElectroPulse;
        default:
            return eICA_NONE;
    }
}

protected simulated function string HL_GenerateAbilityData()
{
    local int I;
    local int iAbilityId;
    local int iItemCardAbilityId;
    local string Data;

    Data = "";

    for (I = 0; I < m_tHLItemCard.arrAbilities.Length; I++)
    {
        iAbilityId = m_tHLItemCard.arrAbilities[I];
        iItemCardAbilityId = ConvertAbilityIdToItemCard(iAbilityId);

        if (iItemCardAbilityId == 0)
        {
            Data $= class'XGAbilityTree'.default.AbilityNames[iAbilityId];
            Data $= "||";
            Data $= class'XComLocalizer'.static.ExpandString(class'XGAbilityTree'.default.HelpMessages[iAbilityId]);
            Data $= "||";
            Data $= class'UIUtilities'.static.GetAbilityIconLabel(iAbilityId);
        }
        else
        {
            Data $= m_strItemCardAbilityName[iItemCardAbilityId];
            Data $= "||";
            Data $= class'XComLocalizer'.static.ExpandString(m_strItemCardAbilityDesc[iItemCardAbilityId]);
            Data $= "||";
            Data $= class'UIUtilities'.static.GetAbilityIconLabel(iAbilityId);
        }

        if (I < m_tHLItemCard.arrAbilities.Length - 1)
        {
            Data $= "//";
        }
    }

    return Data;
}

protected simulated function string HL_GeneratePerkData()
{
    local int I;
    local int iPerkID;
    local string strData;
    local XComPerkManager kPerkManager;

    kPerkManager = PERKS();
    strData = "";

    for (I = 0; I < m_tHLItemCard.arrPerkTypes.Length; I++)
    {
        iPerkID = m_tHLItemCard.arrPerkTypes[I];

        strData $= kPerkManager.GetPerkName(iPerkID, ePerkBuff_Passive);
        strData $= "||";
        strData $= class'XComLocalizer'.static.ExpandString(class'XComPerkManager'.default.m_strPassiveTxt[iPerkID]);
        strData $= "||";
        strData $= class'UIUtilities'.static.GetPerkIconLabel(iPerkID, kPerkManager);

        if (I < m_tHLItemCard.arrPerkTypes.Length - 1)
        {
            strData $= "//";
        }
    }

    return strData;
}

protected simulated function string HL_GenerateAlternativeAbilityData()
{
    local int I;
    local string Data;

    Data = "";

    for (I = 0; I < m_tHLItemCard.arrAbilitiesShiv.Length; I++)
    {
        Data $= m_tHLItemCard.arrAbilitiesShiv[I].strName;
        Data $= "||";
        Data $= m_tHLItemCard.arrAbilitiesShiv[I].strDesc;
        Data $= "||";
        Data $= class'UIUtilities'.static.GetAbilityIconLabel(m_tHLItemCard.arrAbilitiesShiv[I].iAbilityID);

        if (I < m_tHLItemCard.arrAbilitiesShiv.Length - 1)
        {
            Data $= "//";
        }
    }

    return Data;
}