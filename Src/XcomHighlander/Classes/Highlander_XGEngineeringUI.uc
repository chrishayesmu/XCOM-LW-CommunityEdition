class Highlander_XGEngineeringUI extends XGEngineeringUI
    dependson(HighlanderTypes);

function TTableMenuOption BuildItem(TItem kItem)
{
    `HL_LOG_DEPRECATED_CLS(BuildItem);
    return super.BuildItem(kItem);
}

function TTableMenuOption HL_BuildItem(HL_TItem kItem)
{
    local Highlander_XGFacility_Engineering kEngineering;
    local TTableMenuOption kOption;
    local int iCategory, iNumItems, iState;
    local string strCategory;

    kEngineering = `HL_ENGINEERING;

    for (iCategory = 0; iCategory < m_kTable.mnuItems.arrCategories.Length; iCategory++)
    {
        iState = eUIState_Normal;
        strCategory = "";

        switch (m_kTable.mnuItems.arrCategories[iCategory])
        {
            case 2:
                strCategory = kItem.strName;
                iState = eUIState_Normal;

                if (kEngineering.HL_IsPriorityItem(kItem.iItemId))
                {
                    strCategory @= "-" @ m_strPriority;
                    iState = eUIState_Good;
                }

                break;
            case 4:
                iNumItems = STORAGE().GetNumItemsAvailable(kItem.iItemId);
                if (iNumItems > 0)
                {
                    strCategory = string(iNumItems);
                }
                else
                {
                    strCategory = "";
                }

                break;
            case 8:
                if (kItem.kCost.iElerium > 0)
                {
                    strCategory = string(kItem.kCost.iElerium);

                    if (m_iCurrentView == eEngView_Build && kItem.kCost.iElerium > GetResource(eResource_Elerium))
                    {
                        iState = eUIState_Bad;
                    }
                    else
                    {
                        iState = GetResourceUIState(eResource_Elerium);
                    }
                }

                break;
            case 7:
                if (kItem.kCost.iAlloys > 0)
                {
                    strCategory = string(kItem.kCost.iAlloys);

                    if (m_iCurrentView == eEngView_Build && kItem.kCost.iAlloys > (GetResource(eResource_Alloys)))
                    {
                        iState = eUIState_Bad;
                    }
                    else
                    {
                        iState = GetResourceUIState(eResource_Alloys);
                    }
                }

                break;
            case 6:
                if (kItem.kCost.iCash != 0)
                {
                    strCategory = ConvertCashToString(kItem.kCost.iCash);

                    if (m_iCurrentView == eEngView_Build && kItem.kCost.iCash > (GetResource(eResource_Money)))
                    {
                        iState = eUIState_Bad;
                    }
                    else
                    {
                        iState = GetResourceUIState(eResource_Money);
                    }
                }

                break;
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

function TObjectSummary BuildSummary(TItem kItem)
{
    local TObjectSummary kSummary;

    `HL_LOG_DEPRECATED_CLS(BuildSummary);

    return kSummary;
}

function TObjectSummary HL_BuildSummary(HL_TItem kItem)
{
    local TObjectSummary kSummary;

    kSummary.imgObject.strPath = kItem.ImagePath;
    kSummary.txtSummary.StrValue = kItem.strBriefSummary;
    kSummary.txtRequirementsLabel.StrValue = m_strBuildCost;
    kSummary.ItemType = kItem.iItemId;
    kSummary.bCanAfford = `HL_ENGINEERING.HL_GetItemCostSummary(kSummary.kCost, kItem.iItemId, 1,, false);
    return kSummary;
}

function TTableMenuOption BuildQueueItem(int iQueueSlot)
{
    local Highlander_XGFacility_Engineering kEngineering;
    local TTableMenuOption kOption;
    local HL_TItemProject kProject;
    local TFoundryProject kFProject;

    kEngineering = `HL_ENGINEERING;

    if (kEngineering.m_arrQueue[iQueueSlot].bItem)
    {
        kProject = kEngineering.m_arrHLItemProjects[kEngineering.m_arrQueue[iQueueSlot].iIndex];

        kOption.arrStrings.AddItem("");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(string(kProject.iQuantity - kProject.iQuantityLeft) $ "/" $ string(kProject.iQuantity));
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(`HL_ITEM(kProject.iItemId).strName @ "(" $ string(kProject.iQuantity) $ ")");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(kEngineering.HL_GetETAString(kProject));

        if (kProject.iEngineers > 0)
        {
            kOption.arrStates.AddItem(eUIState_Warning);
        }
        else
        {
            kOption.arrStates.AddItem(eUIState_Bad);
        }
    }
    else
    {
        kFProject = kEngineering.m_arrFoundryProjects[kEngineering.m_arrQueue[iQueueSlot].iIndex];

        kOption.arrStrings.AddItem("");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem("---");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(m_strFoundryPrefix @ `HL_FTECH(kFProject.eTech).strName);
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(kEngineering.GetFoundryETAString(kFProject));

        if (kFProject.iEngineers > 0)
        {
            kOption.arrStates.AddItem(eUIState_Warning);
        }
        else
        {
            kOption.arrStates.AddItem(eUIState_Bad);
        }
    }

    return kOption;
}

function TItemCard ENGINEERINGUIGetItemCard()
{
    local TItemCard kItemCard;

    `HL_LOG_DEPRECATED_CLS(ENGINEERINGUIGetItemCard);

    return kItemCard;
}

function HL_TItemCard HL_ENGINEERINGUIGetItemCard()
{
    local int iItemId;
    local HL_TItem kItem;
    local HL_TItemCard kItemCard;
    local TShivAbility kShivAbility;

    if (m_iCurrentView == eEngView_Build)
    {
        if (m_kTable.arrTabText[m_kTable.m_iCurrentTab].StrValue == m_strCatWeapons || m_kTable.arrTabText[m_kTable.m_iCurrentTab].StrValue == m_strCatArmor)
        {
            iItemId = m_kTable.arrSummaries[m_iCurrentSelection].ItemType;

            if (`GAMECORE.ItemIsAccessory(iItemId))
            {
                kItemCard = class'Highlander_XGItemCards'.static.BuildEquippableItemCard(iItemId);
                kItemCard.iCharges = HL_ENGINEERINGUIGetItemCharges(iItemId);
                return kItemCard;
            }
            else
            {
                return class'Highlander_XGItemCards'.static.BuildItemCard(iItemId);
            }
        }
        else if (m_kTable.arrTabText[m_kTable.m_iCurrentTab].StrValue == m_strCatVehicles)
        {
            iItemId = m_kTable.arrSummaries[m_iCurrentSelection].ItemType;
            kItem = `HL_ITEM(iItemId);
            kItemCard.iItemId = iItemId;

            switch (iItemId)
            {
                case eItem_IntConsumable_Dodge:
                case eItem_IntConsumable_Boost:
                case eItem_IntConsumable_Hit:
                    kItemCard.iCardType = eItemCard_InterceptorConsumable;
                    kItemCard.strFlavorText = m_kTable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue;
                    kItemCard.strName = kItem.strName;
                    break;
                case eItem_Satellite:
                    kItemCard.iCardType = eItemCard_Satellite;
                    kItemCard.strFlavorText = m_kTable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue;
                    kItemCard.strName = kItem.strName;
                    break;
                case eItem_SHIV:
                case eItem_SHIV_Alloy:
                case eItem_SHIV_Hover:
                    kItemCard.iCardType = eItemCard_SHIV;
                    kItemCard.strShivWeapon = class'XLocalizedData'.default.m_aItemNames[STORAGE().GetShivWeapon()];

                    switch (iItemId)
                    {
                        case eItem_SHIV_Alloy:
                            kShivAbility.iAbilityID = eAbility_TakeCover;
                            kShivAbility.strName = m_strShivCoverName;
                            kShivAbility.strDesc = m_strShivCoverDesc;
                            kItemCard.arrAbilitiesShiv.AddItem(kShivAbility);
                            break;
                        case eItem_SHIV_Hover:
                            kShivAbility.iAbilityID = eAbility_Fly;
                            kShivAbility.strName = m_strShivFlyName;
                            kShivAbility.strDesc = m_strShivFlyDesc;
                            kItemCard.arrAbilitiesShiv.AddItem(kShivAbility);
                            break;
                    }

                    if (ENGINEERING().IsFoundryTechResearched(eFoundry_SHIVSuppression))
                    {
                        kShivAbility.iAbilityID = eAbility_ShotSuppress;
                        kShivAbility.strName = m_strShivSuppressName;
                        kShivAbility.strDesc = m_strShivSuppressDesc;
                        kItemCard.arrAbilitiesShiv.AddItem(kShivAbility);
                    }

                    kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(kItem.strTacticalText);
                    kItemCard.strName = kItem.strName;
                    break;
                // FIXME: possible bug - EItemType 116 is Stingray Missiles and should probably be here
                case eItem_PhoenixCannon:
                case eItem_AvalancheMissiles:
                case eItem_LaserCannon:
                case eItem_PlasmaCannon:
                case eItem_EMPCannon:
                case eItem_FusionCannon:
                    kItemCard = class'Highlander_XGHangarUI'.static.HL_BuildShipWeaponCard(iItemId);
                    break;
                default:
                    iItemId = m_kTable.arrSummaries[m_iCurrentSelection].ItemType;

                    if (`GAMECORE.ItemIsAccessory(iItemId))
                    {
                        kItemCard = class'Highlander_XGItemCards'.static.BuildEquippableItemCard(iItemId);
                        kItemCard.iCharges = HL_ENGINEERINGUIGetItemCharges(iItemId);
                    }
                    else
                    {
                        return class'Highlander_XGItemCards'.static.BuildItemCard(iItemId);
                    }
            }
        }
    }

    return kItemCard;
}

function int ENGINEERINGUIGetItemCharges(EItemType eItem, optional bool bForce1_for_NonGrenades = false, optional bool bForItemCardDisplay = false)
{
    `HL_LOG_DEPRECATED_CLS(ENGINEERINGUIGetItemCharges);
    return 0;
}

function int HL_ENGINEERINGUIGetItemCharges(int iItemId)
{
    return `HL_ITEM(iItemId).iBaseCharges;
}

function OnItemTableOption(int iOption)
{
    local array<HL_TItem> arrItems;

    arrItems = `HL_ENGINEERING.HL_GetItemsByCategory(m_kTable.arrTabs[m_kTable.m_iCurrentTab], GetCurrentTransactionType());
    arrItems.Sort(HL_SortItems);

    if (m_iCurrentView == eEngView_Build)
    {
        m_bManufacturing = true;
        `HL_HQPRES.HL_UIManufactureItem(arrItems[iOption].iItemId);
        m_bItemBuilt = true;
    }
}

function OnQueueOption(int iOption)
{
    local int iProjectIndex;

    PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
    GoToView(eEngView_MainMenu);

    m_bManufacturing = true;
    iProjectIndex = ENGINEERING().m_arrQueue[iOption].iIndex;

    if (ENGINEERING().m_arrQueue[iOption].bItem)
    {
        `HL_HQPRES.HL_UIManufactureItem(`HL_ENGINEERING.m_arrHLItemProjects[iProjectIndex].iItemId, iProjectIndex);
    }
    else
    {
        PRES().UIManufactureFoundry(ENGINEERING().m_arrFoundryProjects[iProjectIndex].eTech, iProjectIndex);
    }
}

function int SortItems(TItem kItem1, TItem kItem2)
{
    `HL_LOG_DEPRECATED_CLS(SortItems);
    return 0;
}

function int HL_SortItems(HL_TItem kItem1, HL_TItem kItem2)
{
    local Highlander_XGFacility_Engineering kEngineering;

    kEngineering = `HL_ENGINEERING;

    // TODO: there's a good QoL opportunity in the future here, by either making the sort less confusing or
    // expanding the UI to include filters or more tabs
    if (kEngineering.HL_IsPriorityItem(kItem1.iItemId))
    {
        return 0;
    }

    if (kEngineering.HL_IsPriorityItem(kItem2.iItemId))
    {
        return -1;
    }

    if (kItem1.iCategory == eItemCat_Weapons)
    {
        if (ITEMTREE().IsLargeWeapon(kItem1.iItemId))
        {
            if (!ITEMTREE().IsLargeWeapon(kItem2.iItemId))
            {
                return 0;
            }
            else
            {
                if (kItem1.strName < kItem2.strName)
                {
                    return 0;
                }
                else
                {
                    return -1;
                }
            }
        }

        if (ITEMTREE().IsLargeWeapon(kItem2.iItemId))
        {
            return -1;
        }

        if (ITEMTREE().IsSmallWeapon(kItem1.iItemId))
        {
            if (!ITEMTREE().IsSmallWeapon(kItem2.iItemId))
            {
                return 0;
            }
            else
            {
                if (kItem1.strName < kItem2.strName)
                {
                    return 0;
                }
                else
                {
                    return -1;
                }
            }
        }

        if (ITEMTREE().IsSmallWeapon(kItem2.iItemId))
        {
            return -1;
        }

        if (kItem1.strName < kItem2.strName)
        {
            return 0;
        }
        else
        {
            return -1;
        }
    }

    if (kItem1.iCategory == eItemCat_Armor)
    {
        if (kItem1.strName < kItem2.strName)
        {
            return 0;
        }
        else
        {
            return -1;
        }
    }

    if (kItem1.iCategory == eItemCat_Vehicles)
    {
        // Firestorm is always at the top of the list
        if (kItem1.iItemId == `LW_ITEM_ID(Firestorm))
        {
            return 0;
        }

        if (kItem2.iItemId == `LW_ITEM_ID(Firestorm))
        {
            return -1;
        }

        if (IsVehicle(kItem1.iItemId))
        {
            if (!IsVehicle(kItem2.iItemId))
            {
                return 0;
            }
            else
            {
                if (kItem1.strName < kItem2.strName)
                {
                    return 0;
                }
                else
                {
                    return -1;
                }
            }
        }

        if (IsVehicle(kItem2.iItemId))
        {
            return -1;
        }

        if (IsVehicleWeapon(kItem1.iItemId))
        {
            if (!IsVehicleWeapon(kItem2.iItemId))
            {
                return 0;
            }
            else
            {
                if (kItem1.strName < kItem2.strName)
                {
                    return 0;
                }
                else
                {
                    return -1;
                }
            }
        }

        if (IsVehicleWeapon(kItem2.iItemId))
        {
            return -1;
        }

        if (kItem1.strName < kItem2.strName)
        {
            return 0;
        }
        else
        {
            return -1;
        }
    }

    return 0;
}

function UpdateHeader()
{
    local TEngHeader kHeader;

    switch (m_iCurrentView)
    {
        case eEngView_MainMenu:
            kHeader.txtTitle.StrValue = m_strHeaderEngineering;
            break;
        case eEngView_Build:
            if (m_kTable.arrTabText.Length > 0)
            {
                kHeader.txtTitle.StrValue = m_strHeaderBuildItems @ m_kTable.arrTabText[m_kTable.m_iCurrentTab].StrValue;
            }

            break;
    }

    kHeader.txtEngineers = GetResourceText(eResource_Engineers);
    kHeader.txtCash = GetResourceText(eResource_Money);

    if (STORAGE().EverHadItem(`LW_ITEM_ID(Elerium)))
    {
        kHeader.txtElerium = GetResourceText(eResource_Elerium);
    }

    if (STORAGE().EverHadItem(`LW_ITEM_ID(AlienAlloy)))
    {
        kHeader.txtAlloys = GetResourceText(eResource_Alloys);
    }

    m_kHeader = kHeader;
}

function UpdateItemTable()
{
    local int iTab, iItem;
    local Highlander_XGFacility_Engineering kEngineering;
    local array<HL_TItem> arrItems;
    local TTableMenuOption kOption;
    local TObjectSummary kSummary;

    kEngineering = `HL_ENGINEERING;

    UpdateTabs();
    m_kTable.arrSummaries.Remove(0, m_kTable.arrSummaries.Length);

    for (iTab = 0; iTab < m_kTable.arrTabs.Length; iTab++)
    {
        // TODO: might be a minor optimization to make here by only loading one tab's items at a time, if needed
        arrItems = kEngineering.HL_GetItemsByCategory(m_kTable.arrTabs[iTab], GetCurrentTransactionType());
        arrItems.Sort(HL_SortItems);

        if (arrItems.Length == 0)
        {
            m_kTable.arrTabText[iTab].iState = eUIState_Disabled;
        }
        else
        {
            m_kTable.arrTabText[iTab].iState = eUIState_Normal;
        }

        if (m_kTable.m_iCurrentTab == iTab && m_kTable.arrTabText[m_kTable.m_iCurrentTab].iState == eUIState_Disabled)
        {
            // Not sure what this is, probably byproduct of bytecode manipulation
            ++ m_kTable.m_iCurrentTab % m_kTable.arrTabs.Length;
        }

        if (iTab == m_kTable.m_iCurrentTab)
        {
            m_kHeader.txtTitle.StrValue = m_strHeaderBuildItems @ m_kTable.arrTabText[iTab].StrValue;
            m_kTable.arrTabText[iTab].iState = eUIState_Highlight;

            for (iItem = 0; iItem < arrItems.Length; iItem++)
            {
                kOption = HL_BuildItem(arrItems[iItem]);
                kSummary = HL_BuildSummary(arrItems[iItem]);

                if (!kSummary.bCanAfford)
                {
                    kOption.strHelp = kSummary.kCost.strHelp;
                    kOption.iState = eUIState_Disabled;
                }

                m_kTable.mnuItems.arrOptions.AddItem(kOption);
                m_kTable.arrSummaries.AddItem(kSummary);
            }
        }
    }
}