class LWCE_UITacticalHUD_PerkContainer extends UITacticalHUD_PerkContainer;

simulated function UpdatePerks()
{
    local LWCE_XComPerkManager kPerksMgr;
    local LWCE_XGUnit kActiveUnit;
    local TUIPerkInfo kUIPerkInfo;
    local LWCE_TPerk kPerk;
    local int I, iPerkId;
    local array<EItemType_Info> arrItemInfos;

    if (!IsInited())
    {
        return;
    }

    Invoke("clear");
    m_arrPerkData.Remove(0, m_arrPerkData.Length);
    kActiveUnit = LWCE_XGUnit(XComTacticalController(controllerRef).GetActiveUnit());

    if (kActiveUnit != none)
    {
        kPerksMgr = LWCE_XComPerkManager(XComTacticalController(controllerRef).PERKS());

        // TODO: iterate these in order of perk ID, to match vanilla behavior
        for (I = 0; I < kActiveUnit.m_kCEChar.arrPerks.Length; I++)
        {
            iPerkId = kActiveUnit.m_kCEChar.arrPerks[I].Id;

            if (iPerkId == 0)
            {
                continue;
            }

            kPerk = kPerksMgr.LWCE_GetPerk(iPerkId);

            if (kPerk.iCategory != ePerkCat_Passive)
            {
                continue;
            }

            if (!kPerk.bShowPerk)
            {
                continue;
            }

            kUIPerkInfo.strPerkImage = kPerk.Icon;
            kUIPerkInfo.strPerkName = kPerk.strPassiveTitle;
            kUIPerkInfo.strCharges = "";

            if (kPerk.iPerkId == ePerk_RepairServos)
            {
                kUIPerkInfo.strCharges = string(kActiveUnit.m_iRepairServosHPLeft);
            }
            else if (kPerk.iPerkId == ePerk_DamageControl)
            {
                kUIPerkInfo.strCharges = string(kActiveUnit.m_iDamageControlTurns);
            }

            // TODO: need a mod hook to pull perk charges

            m_arrPerkData.AddItem(kUIPerkInfo);
        }

        arrItemInfos = kActiveUnit.GetItemInfos();

        for (I = 0; I < arrItemInfos.Length; I++)
        {
            kUIPerkInfo.strPerkName = class'XComLocalizer'.static.ExpandString(class'XLocalizedData'.default.m_aInventoryName[arrItemInfos[I]]);
            kUIPerkInfo.strPerkImage = class'UIUtilities'.static.GetEItemType_InfoIcon(arrItemInfos[I]);
            kUIPerkInfo.strCharges = "";
            kUIPerkInfo.strCooldown = "";

            m_arrPerkData.AddItem(kUIPerkInfo);
        }
    }

    if (m_arrPerkData.Length > 0)
    {
        m_arrPerkData.Sort(SortPerks);

        for (I = 0; I < m_arrPerkData.Length; I++)
        {
            if (m_arrPerkData[I].strCooldown != "")
            {
                m_arrPerkData[I].strCooldown = class'UITacticalHUD_AbilityContainer'.default.m_strCooldownPrefix $ m_arrPerkData[I].strCooldown;
            }

            if (m_arrPerkData[I].strCharges != "")
            {
                m_arrPerkData[I].strCharges = class'UITacticalHUD_AbilityContainer'.default.m_strChargePrefix $ m_arrPerkData[I].strCharges;
            }

            AddPerk(I, m_arrPerkData[I].strPerkImage, m_arrPerkData[I].strCooldown, m_arrPerkData[I].strCharges);
        }

        Show();
    }
    else
    {
        Hide();
    }
}

protected function int SortPerks(TUIPerkInfo kPerkA, TUIPerkInfo kPerkB)
{
    // Sort by perk name in ascending order
    return kPerkB.strPerkName < kPerkA.strPerkName ? -1 : 0;
}