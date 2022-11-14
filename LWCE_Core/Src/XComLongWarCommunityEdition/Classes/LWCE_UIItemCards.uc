class LWCE_UIItemCards extends UIItemCards
    dependson(LWCETypes);

var LWCE_TItemCard m_tCEItemCard;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, TItemCard cardData)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

simulated function LWCE_Init(XComPlayerController _controller, UIFxsMovie _manager, LWCE_TItemCard cardData)
{
    BaseInit(_controller, _manager);
    m_tCEItemCard = cardData;
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
            if (m_tCEItemCard.iCardType != eItemCard_MPCharacter)
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
    local LWCEItemTemplate kItem;

    if (m_tCEItemCard.ItemName != '')
    {
        kItem = `LWCE_ITEM(m_tCEItemCard.ItemName);
    }

    switch (m_tCEItemCard.iCardType)
    {
        case eItemCard_Armor:
        case eItemCard_MECArmor:
            AS_SetCardTitle(Caps(m_tCEItemCard.strName));
            AS_SetStatData(0, m_strHealthBonusLabel, string(m_tCEItemCard.iArmorHPBonus));
            tmpStr = LWCE_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tCEItemCard.strFlavorText);

            if (m_tCEItemCard.ItemName == 'Item_BaseAugments') // TODO figure out why this is needed
            {
                AS_SetCardImage(kItem.ImagePath, eItemCard_Armor);
            }
            else
            {
                AS_SetCardImage(kItem.ImagePath, m_tCEItemCard.iCardType);
            }

            break;
        case eItemCard_EquippableItem:
            AS_SetCardTitle(Caps(m_tCEItemCard.strName));

            if (m_tCEItemCard.iCharges > 0)
            {
                AS_SetStatData(0, m_strChargesLabel, string(m_tCEItemCard.iCharges));
            }
            else
            {
                AS_SetStatData(0, "", "");
            }

            tmpStr = LWCE_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tCEItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tCEItemCard.iCardType);

            break;
        case eItemCard_SoldierWeapon:
            switch (m_tCEItemCard.iRangeCategory)
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

            AS_SetCardTitle(Caps(m_tCEItemCard.strName));
            AS_SetStatData(0, m_strEffectiveRangeLabel, tmpStr);

            if (m_tCEItemCard.iBaseDamage < 0)
            {
                AS_SetStatData(1, "", "");
            }
            else
            {
                if (m_tCEItemCard.iBaseDamage == m_tCEItemCard.iBaseDamageMax || m_tCEItemCard.iBaseDamageMax < 0)
                {
                    AS_SetStatData(1, m_strBaseDamageLabel, string(m_tCEItemCard.iBaseDamage));
                }
                else
                {
                    AS_SetStatData(1, m_strBaseDamageLabel, string(m_tCEItemCard.iBaseDamage) @ "-" @ string(m_tCEItemCard.iBaseDamageMax));
                }
            }

            if (m_tCEItemCard.iBaseCritChance < 0)
            {
                AS_SetStatData(2, "", "");
            }
            else
            {
                AS_SetStatData(2, m_strBaseCriticalDamageLabel, string(m_tCEItemCard.iBaseCritChance) $ "%");
            }

            if (m_tCEItemCard.iCritDamage < 0)
            {
                AS_SetStatData(3, "", "");
            }
            else
            {
                if (m_tCEItemCard.iCritDamage == m_tCEItemCard.iCritDamageMax || m_tCEItemCard.iCritDamageMax < 0)
                {
                    AS_SetStatData(3, m_strCriticalDamageLabel, string(m_tCEItemCard.iCritDamage));
                }
                else
                {
                    AS_SetStatData(3, m_strCriticalDamageLabel, string(m_tCEItemCard.iCritDamage) @ "-" @ string(m_tCEItemCard.iCritDamageMax));
                }
            }

            tmpStr = LWCE_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tCEItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tCEItemCard.iCardType);

            break;
        case eItemCard_Interceptor:
        case eItemCard_InterceptorConsumable:
        case eItemCard_Satellite:
            AS_SetCardTitle(Caps(m_tCEItemCard.strName));
            AS_AddSimpleTextCardData(m_tCEItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tCEItemCard.iCardType);
            break;
        case eItemCard_ShipWeapon:
            AS_SetCardTitle(Caps(m_tCEItemCard.strName));
            AS_SetStatData(0, m_strHitChanceLabel, string(m_tCEItemCard.shipWpnHitChance) $ "%");

            switch (m_tCEItemCard.shipWpnRange)
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

            switch (m_tCEItemCard.shipWpnFireRate)
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

            switch (m_tCEItemCard.iBaseDamage)
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

            switch (m_tCEItemCard.shipWpnArmorPen)
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

            AS_SetStatData(0, m_strHitChanceLabel, string(Min(m_tCEItemCard.shipWpnHitChance - 15, 95)) $ "/" $ string(Min(m_tCEItemCard.shipWpnHitChance, 95)) $ "/" $ string(Min(m_tCEItemCard.shipWpnHitChance + 15, 95)) $ "");
            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tCEItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tCEItemCard.iCardType);
            break;
        case eItemCard_SHIV:
            AS_SetCardTitle(Caps(m_tCEItemCard.strName));
            switch (m_tCEItemCard.ItemName) // TODO generalize this
            {
                case 'Item_SHIV':
                    tmpStr = m_strChassisTypeNormal;
                    break;
                case 'Item_SHIVAlloy':
                    tmpStr = m_strChassisTypeAlloy;
                    break;
                case 'Item_SHIVHover':
                    tmpStr = m_strChassisTypeHover;
                    break;
            }

            AS_SetStatData(0, m_strWeaponTypeLabel, Caps(m_tCEItemCard.strShivWeapon));
            AS_SetStatData(1, m_strChassisTypeLabel, Caps(tmpStr));

            tmpStr = LWCE_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            tmpStr = LWCE_GenerateAlternativeAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strSHIVWeaponAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tCEItemCard.strFlavorText);
            AS_SetCardImage(kItem.ImagePath, m_tCEItemCard.iCardType);
            break;
        case eItemCard_MPCharacter:
            AS_SetCardTitle(Caps(m_tCEItemCard.strName));
            AS_SetStatData(0, m_strHPLabel, string(m_tCEItemCard.iHealth));
            AS_SetStatData(1, m_strWillLabel, string(m_tCEItemCard.iWill));
            AS_SetStatData(2, m_strAimLabel, string(m_tCEItemCard.iAim));
            AS_SetStatData(3, m_strDefenseLabel, string(m_tCEItemCard.iDefense));

            tmpStr = LWCE_GenerateAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strAbilitiesListHeader, tmpStr);
            }

            tmpStr = LWCE_GeneratePerkData();

            if (tmpStr != "")
            {
                AS_AddPerksCardData(m_strAbilitiesListHeader, tmpStr);
            }

            tmpStr = LWCE_GenerateAlternativeAbilityData();

            if (tmpStr != "")
            {
                AS_AddAbilitiesCardData(m_strSHIVWeaponAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tCEItemCard.strFlavorText);
            AS_SetCardImage(class'UIUtilities'.static.GetCharacterCardImage(ECharacter(m_tCEItemCard.iCharacterId)), m_tCEItemCard.iCardType);

            break;
        case eItemCard_GeneMod:
            AS_SetCardTitle(Caps(m_tCEItemCard.strName));
            tmpStr = LWCE_GeneratePerkData();

            if (tmpStr != "")
            {
                AS_AddPerksCardData(m_strAbilitiesListHeader, tmpStr);
            }

            AS_AddTacticalInfoCardData(m_strTacticalInfoHeader, m_tCEItemCard.strFlavorText);
            AS_SetCardImage("img:///UILibrary_MPCards.MPCard_GeneMod", m_tCEItemCard.iCardType);

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

protected simulated function string LWCE_GenerateAbilityData()
{
    local int I;
    local int iAbilityId;
    local int iItemCardAbilityId;
    local string Data;

    Data = "";

    for (I = 0; I < m_tCEItemCard.arrAbilities.Length; I++)
    {
        iAbilityId = m_tCEItemCard.arrAbilities[I];
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

        if (I < m_tCEItemCard.arrAbilities.Length - 1)
        {
            Data $= "//";
        }
    }

    return Data;
}

protected simulated function string LWCE_GeneratePerkData()
{
    local int I;
    local int iPerkID;
    local string strData;
    local XComPerkManager kPerkManager;

    kPerkManager = PERKS();
    strData = "";

    for (I = 0; I < m_tCEItemCard.arrPerkTypes.Length; I++)
    {
        iPerkID = m_tCEItemCard.arrPerkTypes[I];

        strData $= kPerkManager.GetPerkName(iPerkID, ePerkBuff_Passive);
        strData $= "||";
        strData $= class'XComLocalizer'.static.ExpandString(class'XComPerkManager'.default.m_strPassiveTxt[iPerkID]);
        strData $= "||";
        strData $= class'UIUtilities'.static.GetPerkIconLabel(iPerkID, kPerkManager);

        if (I < m_tCEItemCard.arrPerkTypes.Length - 1)
        {
            strData $= "//";
        }
    }

    return strData;
}

protected simulated function string LWCE_GenerateAlternativeAbilityData()
{
    local int I;
    local string Data;

    Data = "";

    for (I = 0; I < m_tCEItemCard.arrAbilitiesShiv.Length; I++)
    {
        Data $= m_tCEItemCard.arrAbilitiesShiv[I].strName;
        Data $= "||";
        Data $= m_tCEItemCard.arrAbilitiesShiv[I].strDesc;
        Data $= "||";
        Data $= class'UIUtilities'.static.GetAbilityIconLabel(m_tCEItemCard.arrAbilitiesShiv[I].iAbilityID);

        if (I < m_tCEItemCard.arrAbilitiesShiv.Length - 1)
        {
            Data $= "//";
        }
    }

    return Data;
}