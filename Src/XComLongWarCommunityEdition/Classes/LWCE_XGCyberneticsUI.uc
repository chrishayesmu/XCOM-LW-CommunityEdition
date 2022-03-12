class LWCE_XGCyberneticsUI extends XGCyberneticsUI;

// TODO: remove EItemType from everywhere in this class

function UpdateInventory()
{
    local array<LWCE_TItem> arrMecArmor;
    local TCyberneticsLabRepairingMec kRepairingMec;
    local LWCE_TItem kMecArmor;
    local TUIMECInventoryItem kUIMec;
    local int iItemCount;

    m_arrMECInventory.Length = 0;

    kUIMec.arrCost = GetRepairCosts(0, true);
    kUIMec.strName = m_strBuildNewMEC;
    kUIMec.strCostLabel = "";
    kUIMec.bCanUpgrade = false;
    kUIMec.iState = eUIState_Normal;
    m_arrMECInventory.AddItem(kUIMec);

    arrMecArmor = `LWCE_STORAGE.LWCE_GetDamagedItemsInCategory(0);

    foreach arrMecArmor(kMecArmor)
    {
        for (iItemCount = `LWCE_STORAGE.GetNumDamagedItems(EItemType(kMecArmor.iItemId)); iItemCount > 0; iItemCount--)
        {
            m_arrMECInventory.AddItem(LWCE_GenerateDamagedMEC(kMecArmor));
        }
    }

    foreach CYBERNETICSLAB().m_arrRepairingMecs(kRepairingMec)
    {
        m_arrMECInventory.AddItem(LWCE_GenerateRepairingMEC(kRepairingMec));
    }
}

simulated function TUIMECInventoryItem LWCE_GenerateDamagedMEC(LWCE_TItem kMecArmor)
{
    local TUIMECInventoryItem kUIMec;
    local LWCE_TItem kBaseArmor;
    local EItemType eBaseArmor;
    local int iCost;

    eBaseArmor = EItemType(kMecArmor.iItemId);
    kBaseArmor = `LWCE_ITEM(eBaseArmor, 0);

    kUIMec.strName = class'UIUtilities'.static.GetHTMLColoredText(m_strLabelDamaged, eUIState_Bad) @ kBaseArmor.strName;
    kUIMec.iState = eUIState_Normal;
    kUIMec.eArmorType = eBaseArmor;
    kUIMec.bCanUpgrade = false;
    kUIMec.strCostLabel = m_strRepairCostLabel;
    kUIMec.arrCost = GetRepairCosts(eBaseArmor, false);
    kUIMec.bCanRepair = true;

    for (iCost = 0; iCost < kUIMec.arrCost.Length; iCost++)
    {
        if (kUIMec.arrCost[iCost].iState == eUIState_Bad)
        {
            kUIMec.iState = eUIState_Disabled;
            kUIMec.bCanRepair = false;
            break;
        }
    }

    kUIMec.arrPerkInfo.AddItem(GenerateMecWeaponDescription(eBaseArmor));
    return kUIMec;
}

simulated function TUIMECInventoryItem LWCE_GenerateRepairingMEC(TCyberneticsLabRepairingMec kMec)
{
    local TUIMECInventoryItem kUIMec;
    local LWCE_TItem kBaseArmor;
    local EItemType eBaseArmor;
    local XGParamTag kTag;

    eBaseArmor = kMec.m_eMecItem;
    kBaseArmor = `LWCE_ITEM(eBaseArmor, 0);

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kTag.StrValue0 = kBaseArmor.strName;
    kTag.IntValue0 = kMec.m_iHoursLeft / 24;

    kUIMec.strName = class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(m_strLabelRepairing), eUIState_Warning);
    kUIMec.iState = eUIState_Normal;
    kUIMec.eArmorType = kMec.m_eMecItem;
    kUIMec.bCanUpgrade = false;
    kUIMec.bCanRepair = false;
    kUIMec.arrPerkInfo.AddItem(GenerateMecWeaponDescription(eBaseArmor));

    return kUIMec;
}

// Updated version of GetMecCosts, which was hacked pretty heavily by LW 1.0 to support item repairs
simulated function array<TLabeledText> GetRepairCosts(int iBaseArmorId, bool bIsRepairAll)
{
    local array<TLabeledText> arrCosts;
    local TLabeledText kResourceText;
    local LWCE_TItem kBaseArmor;
    local LWCE_XGStorage kStorage;
    local int iAlloyCost, iEleriumCost, iMeldCost, iMoneyCost, iHours, Index;

    kStorage = `LWCE_STORAGE;

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(MiracleWorkers)))
    {
        if (!bIsRepairAll)
        {
            iHours = CYBERNETICSLAB().GetHoursToRepairMec(EItemType(iBaseArmorId)) / 24; // TODO
            kResourceText.StrValue = string(iHours);
            kResourceText.strLabel = m_strLabelDays;
            kResourceText.iState = eUIState_Normal;
            arrCosts.AddItem(kResourceText);
        }

        return arrCosts;
    }

    if (bIsRepairAll)
    {
        // Sum up costs across all damaged items
        for (Index = 0; Index < kStorage.m_arrCEDamagedItems.Length; Index++)
        {
            kBaseArmor = `LWCE_ITEM(kStorage.m_arrCEDamagedItems[Index].iItemId);

            iAlloyCost   += int(float(kBaseArmor.kCost.iAlloys)  * CYBERNETICSLAB().m_fMecRepairCostMod) * kStorage.m_arrCEDamagedItems[Index].iQuantity;
            iEleriumCost += int(float(kBaseArmor.kCost.iElerium) * CYBERNETICSLAB().m_fMecRepairCostMod) * kStorage.m_arrCEDamagedItems[Index].iQuantity;
            iMeldCost    += int(float(kBaseArmor.kCost.iMeld)    * CYBERNETICSLAB().m_fMecRepairCostMod) * kStorage.m_arrCEDamagedItems[Index].iQuantity;
            iMoneyCost   += int(float(kBaseArmor.kCost.iCash)    * CYBERNETICSLAB().m_fMecRepairCostMod) * kStorage.m_arrCEDamagedItems[Index].iQuantity;
        }
    }
    else
    {
        // Just get costs for the requested item
        kBaseArmor = `LWCE_ITEM(iBaseArmorId);

        iAlloyCost   = int(float(kBaseArmor.kCost.iAlloys)  * CYBERNETICSLAB().m_fMecRepairCostMod);
        iEleriumCost = int(float(kBaseArmor.kCost.iElerium) * CYBERNETICSLAB().m_fMecRepairCostMod);
        iMeldCost    = int(float(kBaseArmor.kCost.iMeld)    * CYBERNETICSLAB().m_fMecRepairCostMod);
        iMoneyCost   = int(float(kBaseArmor.kCost.iCash)    * CYBERNETICSLAB().m_fMecRepairCostMod);
    }

    if (iMoneyCost > 0)
    {
        kResourceText.StrValue = ConvertCashToString(iMoneyCost);
        kResourceText.iState = iMoneyCost <= GetResource(eResource_Money) ? eUIState_Cash : eUIState_Bad;
        arrCosts.AddItem(kResourceText);
    }

    if (iMeldCost > 0)
    {
        kResourceText.iState = iMeldCost <= GetResource(eResource_Meld) ? eUIState_Meld : eUIState_Bad;
        kResourceText.StrValue = string(iMeldCost);
        kResourceText.strLabel = "#MELDTAG";
        arrCosts.AddItem(kResourceText);
    }

    if (iEleriumCost > 0)
    {
        kResourceText.iState = iEleriumCost <= GetResource(eResource_Elerium) ? eUIState_Normal : eUIState_Bad;
        kResourceText.StrValue = string(iEleriumCost);
        kResourceText.strLabel = GetResourceLabel(eResource_Elerium);
        arrCosts.AddItem(kResourceText);
    }

    if (iAlloyCost > 0)
    {
        kResourceText.iState = iAlloyCost <= GetResource(eResource_Alloys) ? eUIState_Normal : eUIState_Bad;
        kResourceText.StrValue = string(iAlloyCost);
        kResourceText.strLabel = GetResourceLabel(eResource_Alloys);
        arrCosts.AddItem(kResourceText);
    }

    if (!bIsRepairAll)
    {
        iHours = CYBERNETICSLAB().GetHoursToRepairMec(EItemType(iBaseArmorId)) / 24;
        kResourceText.StrValue = string(iHours);
        kResourceText.strLabel = m_strLabelDays;
        kResourceText.iState = eUIState_Normal;
        arrCosts.AddItem(kResourceText);
    }

    return arrCosts;
}

simulated function RepairAll()
{
    local int Index, iCount;
    local LWCE_XGStorage kStorage;

    kStorage = `LWCE_STORAGE;

    for (Index = 0; Index < kStorage.m_arrCEDamagedItems.Length; Index++)
    {
        iCount = kStorage.m_arrCEDamagedItems[Index].iQuantity;

        while (iCount > 0)
        {
            CYBERNETICSLAB().AddMecForRepair(EItemType(kStorage.m_arrCEDamagedItems[Index].iItemId));
            iCount--;
        }
    }

    UpdateView();
}