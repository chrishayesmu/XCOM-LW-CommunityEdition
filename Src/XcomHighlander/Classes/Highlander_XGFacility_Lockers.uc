class Highlander_XGFacility_Lockers extends XGFacility_Lockers
    dependson(HighlanderTypes);

function TLockerItem GetLockerItem(EInventorySlot eSlotType, out TItem kItem, XGStrategySoldier kSoldier)
{
    local TLockerItem kLockerItem;

    `HL_LOG_DEPRECATED_CLS(GetLockerItem);

    return kLockerItem;
}

function TLockerItem HL_GetLockerItem(EInventorySlot eSlotType, out HL_TItem kItem, XGStrategySoldier kSoldier)
{
    local Highlander_XGStorage kStorage;
    local TLockerItem kLockerItem;

    kStorage = `HL_STORAGE;

    kLockerItem.iItem = kItem.iItemId;
    kLockerItem.iQuantity = kStorage.GetNumItemsAvailable(kItem.iItemId);
    kLockerItem.bTechLocked = HL_IsTechLocked(kItem, kSoldier);

    if (eSlotType == eInvSlot_Armor)
    {
        if (BARRACKS().m_kVolunteer == kSoldier || kSoldier.IsATank())
        {
            kLockerItem.bClassLocked = true;
        }
        else
        {
            kLockerItem.bClassLocked = TACTICAL().ArmorHasProperty(kItem.iItemId, eAP_Psi) && !kSoldier.HasPsiGift();

            if (kLockerItem.bClassLocked)
            {
                kLockerItem.eClassLock = eSC_Psi;
            }
            else
            {
                kLockerItem.bClassLocked = !kStorage.HL_IsClassEquippable(kSoldier.m_kSoldier.kClass.eWeaponType, kItem.iItemId);
            }
        }
    }
    else
    {
        if (TACTICAL().WeaponHasProperty(kItem.iItemId, eWP_Psionic))
        {
            kLockerItem.bClassLocked = !kSoldier.HasPsiGift();
        }

        if (kLockerItem.bClassLocked)
        {
            kLockerItem.eClassLock = eSC_Psi;
        }
        else
        {
            kLockerItem.bClassLocked = !kStorage.HL_IsClassEquippable(kSoldier.m_kSoldier.kClass.eWeaponType, kItem.iItemId);
        }
    }

    return kLockerItem;
}

function array<TLockerItem> GetLockerItems(int iSlotType, int iSlotIndex, XGStrategySoldier kSoldier)
{
    local Highlander_XGStorage kStorage;
    local array<HL_TItem> arrItems;
    local array<TLockerItem> arrLockerItems;
    local TLockerItem kLockerItem;
    local bool bDisplayItem;
    local int I, iItemId;

    kStorage = `HL_STORAGE;

    if (iSlotType == eInvSlot_Armor)
    {
        arrItems = kStorage.HL_GetItemsInCategory(eItemCat_Armor, 0);
    }
    else
    {
        arrItems = kStorage.HL_GetItemsInCategory( (kSoldier.IsAugmented() || kSoldier.IsATank()) ? eItemCat_Vehicles : eItemCat_Weapons, 0);
    }

    for (I = 0; I < arrItems.Length; I++)
    {
        iItemId = arrItems[I].iItemId;
        bDisplayItem = true;

        switch (iSlotType)
        {
            case eInvSlot_Armor:
                if (TACTICAL().ArmorHasProperty(iItemId, eAP_Tank))
                {
                    if (!kSoldier.IsATank())
                    {
                        bDisplayItem = false;
                    }
                }
                else
                {
                    if (kSoldier.IsATank())
                    {
                        bDisplayItem = false;
                    }
                }

                if (TACTICAL().ArmorHasProperty(iItemId, eAP_MEC))
                {
                    if (!kSoldier.IsAugmented())
                    {
                        bDisplayItem = false;
                    }
                }
                else
                {
                    if (kSoldier.IsAugmented())
                    {
                        bDisplayItem = false;
                    }
                }

                break;
            case eInvSlot_Pistol:
                if (!TACTICAL().WeaponHasProperty(iItemId, eWP_Pistol))
                {
                    bDisplayItem = false;
                }

                break;
            case eInvSlot_Large:
                if (TACTICAL().GetTWeapon(iItemId).iSize != 1)
                {
                    bDisplayItem = false;
                }

                if (TACTICAL().WeaponHasProperty(iItemId, eWP_Integrated))
                {
                    if (!kSoldier.IsATank())
                    {
                        bDisplayItem = false;
                    }
                }

                if (kSoldier.IsAugmented())
                {
                    if (!TACTICAL().WeaponHasProperty(iItemId, eWP_Mec))
                    {
                        bDisplayItem = false;
                    }

                    if (iSlotIndex == 0)
                    {
                        if (TACTICAL().WeaponHasProperty(iItemId, eWP_Secondary))
                        {
                            bDisplayItem = false;
                        }
                    }
                    else
                    {
                        if (!TACTICAL().WeaponHasProperty(iItemId, eWP_Secondary))
                        {
                            bDisplayItem = false;
                        }
                    }
                }
                else
                {
                    if (TACTICAL().WeaponHasProperty(iItemId, eWP_Mec))
                    {
                        bDisplayItem = false;
                    }

                    if (TACTICAL().WeaponHasAbility(iItemId, eWP_CantReact))
                    {
                        if (iSlotIndex == 0)
                        {
                            bDisplayItem = false;
                        }
                    }

                    if (!TACTICAL().WeaponHasAbility(iItemId, eWP_CantReact))
                    {
                        if (iSlotIndex == 1)
                        {
                            bDisplayItem = false;
                        }
                    }
                }

                break;
            case eInvSlot_Small:
                if (TACTICAL().GetTWeapon(iItemId).iSize != 0)
                {
                    bDisplayItem = false;
                }

                if (kSoldier.IsATank())
                {
                    if (!TACTICAL().WeaponHasProperty(iItemId, eWP_Integrated))
                    {
                        bDisplayItem = false;
                    }
                }

                if (kSoldier.IsAugmented())
                {
                    if (!TACTICAL().WeaponHasProperty(iItemId, eWP_Mec))
                    {
                        bDisplayItem = false;
                    }
                }

                if (TACTICAL().WeaponHasProperty(iItemId, eWP_Pistol))
                {
                    bDisplayItem = false;
                }

                if (iItemId == `LW_ITEM_ID(SkeletonKey))
                {
                    bDisplayItem = false;
                }

                break;
        }

        if (bDisplayItem)
        {
            kLockerItem = HL_GetLockerItem(EInventorySlot(iSlotType), arrItems[I], kSoldier);

            if (kLockerItem.bClassLocked || kLockerItem.bTechLocked)
            {
                arrLockerItems.AddItem(kLockerItem);
            }
            else
            {
                arrLockerItems.InsertItem(0, kLockerItem);
            }
        }
    }

    return arrLockerItems;
}

function bool IsTechLocked(out TItem kItem, XGStrategySoldier kSoldier)
{
    `HL_LOG_DEPRECATED_CLS(IsTechLocked);

    return true;
}

function bool HL_IsTechLocked(out HL_TItem kItem, XGStrategySoldier kSoldier)
{
    local bool bNoWeaponsTech;
    local int iTechReq;

    bNoWeaponsTech = false;

    if (XComCheatManager(GetALocalPlayerController().CheatManager) != none)
    {
        bNoWeaponsTech = XComCheatManager(GetALocalPlayerController().CheatManager).m_bNoWeaponsTech;
    }

    if (bNoWeaponsTech)
    {
        return false;
    }

    if (kSoldier.IsASuperSoldier())
    {
        return false;
    }

    if (kItem.iItemId == `LW_ITEM_ID(AlienGrenade))
    {
        return !ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienGrenades));
    }

    foreach kItem.kPrereqs.arrTechReqs(iTechReq)
    {
        if (!LABS().IsResearched(iTechReq))
        {
            return true;
        }
    }

    return false;
}