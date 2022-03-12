class LWCE_XGFacility_Lockers extends XGFacility_Lockers
    dependson(LWCETypes);

function bool EquipArmor(XGStrategySoldier kSoldier, int iArmor)
{
    local TInventory kOldInventory;
    local int iItem;

    if (STORAGE().GetNumItemsAvailable(iArmor) <= 0)
    {
        return false;
    }

    if (kSoldier.m_kChar.kInventory.iArmor == iArmor)
    {
        return false;
    }

    kOldInventory = kSoldier.GetInventory();
    UnequipArmor(kSoldier);

    if (iArmor == 0)
    {
        return true;
    }

    kSoldier.m_bForcePawnUpdateOnLoadoutChange = iArmor != kOldInventory.iArmor;
    STORAGE().ClaimItem(iArmor, kSoldier);
    kSoldier.m_kChar.kInventory.iArmor = iArmor;

    if (kSoldier.GetStatus() == eStatus_Healing || kSoldier.GetStatus() == /* fatigued? */ 8)
    {
        kSoldier.m_kBackedUpLoadout.iArmor = iArmor;
    }

    if (`GAMECORE.ArmorHasProperty(kSoldier.m_kChar.kInventory.iArmor, eAP_Grapple))
    {
        `GAMECORE.TInventoryCustomItemsAddItem(kSoldier.m_kChar.kInventory, `LW_ITEM_ID(Grapple));

        if (kSoldier.GetStatus() == eStatus_Healing || kSoldier.GetStatus() == /* fatigued? */ 8)
        {
            `GAMECORE.TInventoryCustomItemsAddItem(kSoldier.m_kBackedUpLoadout, `LW_ITEM_ID(Grapple));
        }
    }

    TACTICAL().TInventoryLargeItemsAdd(kSoldier.m_kChar.kInventory, GetLargeInventorySlots(kSoldier, iArmor));
    TACTICAL().TInventorySmallItemsAdd(kSoldier.m_kChar.kInventory, GetSmallInventorySlots(kSoldier, iArmor));
    EquipPistol(kSoldier, kOldInventory.iPistol);

    for (iItem = 0; iItem < kSoldier.m_kChar.kInventory.iNumLargeItems; iItem++)
    {
        if (iItem == kOldInventory.iNumLargeItems)
        {
            break;
        }

        EquipLargeItem(kSoldier, kOldInventory.arrLargeItems[iItem], iItem);
    }

    for (iItem = 0; iItem < kSoldier.m_kChar.kInventory.iNumSmallItems; iItem++)
    {
        if (iItem == kOldInventory.iNumSmallItems)
        {
            break;
        }

        EquipSmallItem(kSoldier, kOldInventory.arrSmallItems[iItem], iItem);
    }

    if (kOldInventory.iArmor == eItem_MecCivvies)
    {
        if (kOldInventory.arrLargeItems[0] == 0)
        {
            EquipLargeItem(kSoldier, `LWCE_STORAGE.LWCE_GetInfinitePrimary(kSoldier), 0);
        }
    }

    return true;
}

function TLockerItem GetLockerItem(EInventorySlot eSlotType, out TItem kItem, XGStrategySoldier kSoldier)
{
    local TLockerItem kLockerItem;

    `LWCE_LOG_DEPRECATED_CLS(GetLockerItem);

    return kLockerItem;
}

function TLockerItem LWCE_GetLockerItem(EInventorySlot eSlotType, out LWCE_TItem kItem, XGStrategySoldier kSoldier)
{
    local LWCE_XGStorage kStorage;
    local TLockerItem kLockerItem;

    kStorage = `LWCE_STORAGE;

    kLockerItem.iItem = kItem.iItemId;
    kLockerItem.iQuantity = kStorage.GetNumItemsAvailable(kItem.iItemId);
    kLockerItem.bTechLocked = LWCE_IsTechLocked(kItem, kSoldier);

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
                kLockerItem.bClassLocked = !kStorage.LWCE_IsClassEquippable(kSoldier.m_kSoldier.kClass.eWeaponType, kItem.iItemId);
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
            kLockerItem.bClassLocked = !kStorage.LWCE_IsClassEquippable(kSoldier.m_kSoldier.kClass.eWeaponType, kItem.iItemId);
        }
    }

    return kLockerItem;
}

function array<TLockerItem> GetLockerItems(int iSlotType, int iSlotIndex, XGStrategySoldier kSoldier)
{
    local LWCE_XGTacticalGameCore kTacGameCore;
    local LWCE_XGStorage kStorage;
    local array<LWCE_TItem> arrItems;
    local array<TLockerItem> arrLockerItems;
    local TLockerItem kLockerItem;
    local bool bDisplayItem;
    local int I, iItemId;

    kTacGameCore = `LWCE_GAMECORE;
    kStorage = `LWCE_STORAGE;

    if (iSlotType == eInvSlot_Armor)
    {
        arrItems = kStorage.LWCE_GetItemsInCategory(eItemCat_Armor, 0);
    }
    else
    {
        arrItems = kStorage.LWCE_GetItemsInCategory( (kSoldier.IsAugmented() || kSoldier.IsATank()) ? eItemCat_Vehicles : eItemCat_Weapons, 0);
    }

    for (I = 0; I < arrItems.Length; I++)
    {
        iItemId = arrItems[I].iItemId;
        bDisplayItem = true;

        switch (iSlotType)
        {
            case eInvSlot_Armor:
                if (kTacGameCore.ArmorHasProperty(iItemId, eAP_Tank))
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

                if (kTacGameCore.ArmorHasProperty(iItemId, eAP_MEC))
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
                if (!kTacGameCore.WeaponHasProperty(iItemId, eWP_Pistol))
                {
                    bDisplayItem = false;
                }

                break;
            case eInvSlot_Large:
                if (kTacGameCore.LWCE_GetTWeapon(iItemId).iSize != 1)
                {
                    bDisplayItem = false;
                }

                if (kTacGameCore.WeaponHasProperty(iItemId, eWP_Integrated))
                {
                    if (!kSoldier.IsATank())
                    {
                        bDisplayItem = false;
                    }
                }

                if (kSoldier.IsAugmented())
                {
                    if (!kTacGameCore.WeaponHasProperty(iItemId, eWP_Mec))
                    {
                        bDisplayItem = false;
                    }

                    if (iSlotIndex == 0)
                    {
                        if (kTacGameCore.WeaponHasProperty(iItemId, eWP_Secondary))
                        {
                            bDisplayItem = false;
                        }
                    }
                    else
                    {
                        if (!kTacGameCore.WeaponHasProperty(iItemId, eWP_Secondary))
                        {
                            bDisplayItem = false;
                        }
                    }
                }
                else
                {
                    if (kTacGameCore.WeaponHasProperty(iItemId, eWP_Mec))
                    {
                        bDisplayItem = false;
                    }

                    if (kTacGameCore.WeaponHasAbility(iItemId, eWP_CantReact))
                    {
                        if (iSlotIndex == 0)
                        {
                            bDisplayItem = false;
                        }
                    }

                    if (!kTacGameCore.WeaponHasAbility(iItemId, eWP_CantReact))
                    {
                        if (iSlotIndex == 1)
                        {
                            bDisplayItem = false;
                        }
                    }
                }

                break;
            case eInvSlot_Small:
                if (kTacGameCore.LWCE_GetTWeapon(iItemId).iSize != 0)
                {
                    bDisplayItem = false;
                }

                if (kSoldier.IsATank())
                {
                    if (!kTacGameCore.WeaponHasProperty(iItemId, eWP_Integrated))
                    {
                        bDisplayItem = false;
                    }
                }

                if (kSoldier.IsAugmented())
                {
                    if (!kTacGameCore.WeaponHasProperty(iItemId, eWP_Mec))
                    {
                        bDisplayItem = false;
                    }
                }

                if (kTacGameCore.WeaponHasProperty(iItemId, eWP_Pistol))
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
            kLockerItem = LWCE_GetLockerItem(EInventorySlot(iSlotType), arrItems[I], kSoldier);

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
    `LWCE_LOG_DEPRECATED_CLS(IsTechLocked);

    return true;
}

function bool LWCE_IsTechLocked(out LWCE_TItem kItem, XGStrategySoldier kSoldier)
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