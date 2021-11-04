class Highlander_XGEngineeringUI extends XGEngineeringUI
    dependson(HighlanderTypes);

function TTableMenuOption BuildQueueItem(int iQueueSlot)
{
    local TTableMenuOption kOption;
    local TItemProject kProject;
    local TFoundryProject kFProject;

    if (ENGINEERING().m_arrQueue[iQueueSlot].bItem)
    {
        kProject = ENGINEERING().m_arrItemProjects[ENGINEERING().m_arrQueue[iQueueSlot].iIndex];

        kOption.arrStrings.AddItem("");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(string(kProject.iQuantity - kProject.iQuantityLeft) $ "/" $ string(kProject.iQuantity));
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(((Item(kProject.eItem).strName @ "(") $ string(kProject.iQuantity)) $ ")");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(ENGINEERING().GetETAString(kProject));

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
        kFProject = ENGINEERING().m_arrFoundryProjects[ENGINEERING().m_arrQueue[iQueueSlot].iIndex];

        kOption.arrStrings.AddItem("");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem("---");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(m_strFoundryPrefix @ `HL_FTECH(kFProject.eTech).strName);
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(ENGINEERING().GetFoundryETAString(kFProject));

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
    local EItemType itm;
    local TShivAbility kShivAbility;

    if (m_iCurrentView == eEngView_Build)
    {
        if (m_kTable.arrTabText[m_kTable.m_iCurrentTab].StrValue == m_strCatWeapons || m_kTable.arrTabText[m_kTable.m_iCurrentTab].StrValue == m_strCatArmor)
        {
            itm = EItemType(m_kTable.arrSummaries[m_iCurrentSelection].ItemType);

            if (`GAMECORE.ItemIsAccessory(itm))
            {
                kItemCard = class'XGItemCards'.static.BuildEquippableItemCard(itm);
                kItemCard.m_iCharges = ENGINEERINGUIGetItemCharges(itm, false, true);
                return kItemCard;
            }
            else
            {
                return class'XGItemCards'.static.BuildItemCard(itm);
            }
        }
        else if (m_kTable.arrTabText[m_kTable.m_iCurrentTab].StrValue == m_strCatVehicles)
        {
            itm = EItemType(m_kTable.arrSummaries[m_iCurrentSelection].ItemType);

            switch (itm)
            {
                case eItem_IntConsumable_Dodge:
                case eItem_IntConsumable_Boost:
                case eItem_IntConsumable_Hit:
                    kItemCard.m_type = eItemCard_InterceptorConsumable;
                    kItemCard.m_strFlavorText = m_kTable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue;
                    kItemCard.m_strName = Item(m_kTable.arrSummaries[m_iCurrentSelection].ItemType).strName;
                    break;
                case eItem_Satellite:
                    kItemCard.m_type = eItemCard_Satellite;
                    kItemCard.m_strFlavorText = m_kTable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue;
                    kItemCard.m_strName = Item(m_kTable.arrSummaries[m_iCurrentSelection].ItemType).strName;
                    break;
                case eItem_SHIV:
                case eItem_SHIV_Alloy:
                case eItem_SHIV_Hover:
                    kItemCard.m_type = eItemCard_SHIV;
                    kItemCard.m_strShivWeapon = class'XLocalizedData'.default.m_aItemNames[STORAGE().GetShivWeapon()];

                    switch (itm)
                    {
                        case eItem_SHIV_Alloy:
                            kShivAbility.iAbilityID = eAbility_TakeCover;
                            kShivAbility.strName = m_strShivCoverName;
                            kShivAbility.strDesc = m_strShivCoverDesc;
                            kItemCard.m_abilitiesShiv.AddItem(kShivAbility);
                            break;
                        case eItem_SHIV_Hover:
                            kShivAbility.iAbilityID = eAbility_Fly;
                            kShivAbility.strName = m_strShivFlyName;
                            kShivAbility.strDesc = m_strShivFlyDesc;
                            kItemCard.m_abilitiesShiv.AddItem(kShivAbility);
                            break;
                        default:
                            if (ENGINEERING().IsFoundryTechResearched(eFoundry_SHIVSuppression))
                            {
                                kShivAbility.iAbilityID = eAbility_ShotSuppress;
                                kShivAbility.strName = m_strShivSuppressName;
                                kShivAbility.strDesc = m_strShivSuppressDesc;
                                kItemCard.m_abilitiesShiv.AddItem(kShivAbility);
                            }

                            kItemCard.m_strFlavorText = class'XComLocalizer'.static.ExpandString(class'XLocalizedData'.default.m_aItemTacticalText[itm]);
                            kItemCard.m_strName = Item(itm).strName;
                            break;
                }
                // FIXME: possible bug - EItemType 116 is Stingray Missiles and should probably be here
                case eItem_PhoenixCannon:
                case eItem_AvalancheMissiles:
                case eItem_LaserCannon:
                case eItem_PlasmaCannon:
                case eItem_EMPCannon:
                case eItem_FusionCannon:
                    kItemCard = class'XGHangarUI'.static.BuildShipWeaponCard(itm);
                    break;
                default:
                    itm = EItemType(m_kTable.arrSummaries[m_iCurrentSelection].ItemType);

                    if (`GAMECORE.ItemIsAccessory(itm))
                    {
                        kItemCard = class'XGItemCards'.static.BuildEquippableItemCard(itm);
                        kItemCard.m_iCharges = ENGINEERINGUIGetItemCharges(itm, false, true);
                    }
                    else
                    {
                        return class'XGItemCards'.static.BuildItemCard(itm);
                    }
            }
        }
    }

    return kItemCard;
}