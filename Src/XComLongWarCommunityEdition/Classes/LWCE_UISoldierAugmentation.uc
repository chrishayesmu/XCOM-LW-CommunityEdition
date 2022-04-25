class LWCE_UISoldierAugmentation extends UISoldierAugmentation;

simulated function OnInit()
{
    local int iMecClassId;
    local LWCE_XGStrategySoldier kSoldier;
    local XGParamTag kTag;

    super(UI_FxsScreen).OnInit();

    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);
    iMecClassId = `LWCE_BARRACKS.GetResultingMecClass(kSoldier.m_kCEChar.iClassId);
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTag.StrValue0 = Caps(`LWCE_BARRACKS.GetClassName(iMecClassId));

    if (class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kSoldier.m_kCEChar))
    {
        AS_SetLabels(m_strScreenTitle, class'XComLocalizer'.static.ExpandString(m_strBonusAbilityLabel), m_strWarningLabel, class'UIUtilities'.static.GetHTMLColoredText(m_strWarningDescription, eUIState_Bad) @ class'UIUtilities'.static.GetHTMLColoredText(m_strWarningDescriptionGeneModded, eUIState_Warning));
    }
    else
    {
        AS_SetLabels(m_strScreenTitle, class'XComLocalizer'.static.ExpandString(m_strBonusAbilityLabel), m_strWarningLabel, class'UIUtilities'.static.GetHTMLColoredText(m_strWarningDescription, eUIState_Bad));
    }

    UpdateSoldierInfo();
    UpdateRequirements();
    UpdateButtonHelp();
    Show();
}

simulated function UpdateSoldierInfo()
{
    local bool bIsGeneModded, bIsPsionic;
    local int iMecClassId, iPerkId, iRank;
    local LWCE_TPerk kPerk;
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XComPerkManager kPerksMgr;
    local LWCE_XGStrategySoldier kSoldier;

    kBarracks = `LWCE_BARRACKS;
    kPerksMgr = LWCE_XComPerkManager(m_kSoldier.perkMgr());
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    if (kSoldier.IsATank())
    {
        iRank = kSoldier.GetSHIVRank();
    }
    else
    {
        iRank = kSoldier.GetRank();
    }

    iMecClassId = kBarracks.GetResultingMecClass(kSoldier.m_kCEChar.iClassId);
    bIsGeneModded = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kSoldier.m_kCEChar);
    bIsPsionic = kSoldier.m_kChar.bHasPsiGift;

    AS_SetSoldierData(kSoldier.GetName(eNameType_FullNick),
                      kSoldier.GetClassName(),
                      class'UIUtilities'.static.GetRankLabel(iRank, kSoldier.IsATank()),
                      kBarracks.GetClassIcon(kSoldier.m_kCEChar.iClassId, bIsGeneModded, bIsPsionic) $ "|" $ kBarracks.GetClassIcon(iMecClassId, false, false));

    iPerkId = kPerksMgr.LWCE_GetMecPerkForClass(kSoldier.m_kCEChar.iClassId);
    kPerk = kPerksMgr.LWCE_GetPerk(iPerkId);
    AS_SetBonusAbilityData(kPerk.strPassiveTitle, kPerk.strPassiveDescription, kPerk.Icon);

    iPerkId = `LW_PERK_ID(OneForAll);
    kPerk = kPerksMgr.LWCE_GetPerk(iPerkId);
    AS_SetBonusAbilityData(kPerk.strPassiveTitle, kPerk.strPassiveDescription, kPerk.Icon);

    iPerkId = `LW_PERK_ID(CombinedArms);
    kPerk = kPerksMgr.LWCE_GetPerk(iPerkId);
    AS_SetBonusAbilityData(kPerk.strPassiveTitle, kPerk.strPassiveDescription, kPerk.Icon);
}