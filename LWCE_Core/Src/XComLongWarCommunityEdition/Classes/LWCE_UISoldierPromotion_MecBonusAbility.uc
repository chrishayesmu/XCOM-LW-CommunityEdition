class LWCE_UISoldierPromotion_MecBonusAbility extends UISoldierPromotion_MecBonusAbility;

function UpdateData()
{
    local LWCE_TPerk kPerk;
    local LWCE_XGStrategySoldier kSoldier;
    local XGParamTag kTag;

    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    if (!`LWCE_BARRACKS.GetClassDefinition(kSoldier.LWCE_GetClass()).bIsAugmented)
    {
        Hide();
        return;
    }

    kPerk = LWCE_XComPerkManager(kSoldier.perkMgr()).LWCE_GetPerk(`LW_PERK_ID(OneForAll));

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTag.StrValue0 = Caps(kSoldier.GetClassName());

    AS_SetInfo(kPerk.Icon, class'XComLocalizer'.static.ExpandString(m_strBonusAbilityLabel), kPerk.strPassiveTitle, kPerk.strPassiveDescription);
    Show();
}