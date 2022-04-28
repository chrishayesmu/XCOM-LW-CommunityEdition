class LWCE_XGCyberneticsUI extends XGCyberneticsUI;

// TODO: remove EItemType from everywhere in this class

function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int soldierListIndex)
{
    local TTableMenuOption kOption;
    local LWCE_XGStrategySoldier kCESoldier;
    local int iCategory;
    local string strCategory;
    local int iState;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    if (!kCESoldier.CanBeAugmented())
    {
        kOption.iState = eUIState_Disabled;
    }
    else
    {
        kOption.iState = eUIState_Good;
    }

    for (iCategory = 0; iCategory < arrCategories.Length; iCategory++)
    {
        iState = eUIState_Normal;
        strCategory = "";

        switch (arrCategories[iCategory])
        {
            case 7:
                if (kCESoldier.m_kCEChar.iClassId == 0 || kCESoldier.GetRank() < 2)
                {
                    strCategory = m_strRookieState;
                    iState = eUIState_Disabled;
                }
                else
                {
                    strCategory = kCESoldier.GetStatusString();
                    iState = kCESoldier.GetStatusUIState();
                }

                break;
            case 0:
                strCategory = string(kCESoldier.m_kSoldier.iCountry);
                break;
            case 1:
                strCategory = string(kCESoldier.GetRank());
                break;
            case 2:
                strCategory = string(kCESoldier.GetEnergy());
                break;
            case 3:
                strCategory = kCESoldier.GetClassName();
                break;
            case 4:
                strCategory = kCESoldier.GetName(8); // exp I think
                break;
            case 5:
                strCategory = kCESoldier.GetName(eNameType_Last);
                break;
            case 6:
                strCategory = kCESoldier.GetName(eNameType_Nick);
                break;
            case 8:
                if (kCESoldier.HasAvailablePerksToAssign())
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 9:
                if (kCESoldier.HasAvailablePerksToAssign(true))
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 10:
                if (kCESoldier.m_kChar.bHasPsiGift)
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 11:
                if (class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kCESoldier.m_kCEChar))
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 13:
                iState = kCESoldier.GetSHIVRank();
                break;
            case 12:
                strCategory = class'UIUtilities'.static.GetMedalLabels(kCESoldier.m_arrMedals);
                break;
            case 14:
                strCategory = string(soldierListIndex);
                break;
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

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
            iHours = CYBERNETICSLAB().GetHoursToRepairMec(EItemType(iBaseArmorId)) / 24;
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

function bool OnChooseSoldier(int iOption)
{
    local int soldierListIndex;

    if (m_kSoldierTable.mnuSoldiers.arrOptions[iOption].iState == eUIState_Good)
    {
        soldierListIndex = int(m_kSoldierTable.mnuSoldiers.arrOptions[iOption].arrStrings[14]);
        PRES().UISoldierAugmentation(BARRACKS().m_arrSoldiers[soldierListIndex]);
        PlayGoodSound();
        return true;
    }
    else
    {
        PlayBadSound();
        return false;
    }
}

function OnChooseSlot(int iSlot)
{
    if (iSlot < CYBERNETICSLAB().m_arrPatients.Length)
    {
        PlayBadSound();
    }
    else
    {
        GoToView(eCyberneticsLabView_Add);
        `HQPRES.UISoldierList(class'LWCE_UISoldierList_CyberneticsLab');
        PlayGoodSound();
    }
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