class LWCE_XGFacility_Lockers extends XGFacility_Lockers
    dependson(LWCETypes);

struct LWCE_TLockerItem
{
    var name ItemName;
    var int iQuantity;
    var bool bTechLocked;
    var bool bClassLocked;
};

function bool ApplySoldierLoadout(XGStrategySoldier kSoldier, TInventory kInventory)
{
    `LWCE_LOG_DEPRECATED_CLS(ApplySoldierLoadout);

    return false;
}

function bool LWCE_ApplySoldierLoadout(XGStrategySoldier kSoldier, LWCE_TInventory kInventory)
{
    local int I;

    UnequipArmor(kSoldier);

    if (kInventory.nmArmor != '')
    {
        LWCE_EquipArmor(kSoldier, kInventory.nmArmor);
    }

    // TODO: change this to look up class definition
    if (kInventory.nmPistol != '' && LWCE_XGStrategySoldier(kSoldier).LWCE_GetClass() != eSC_HeavyWeapons)
    {
        LWCE_EquipPistol(kSoldier, kInventory.nmPistol);
    }

    for (I = 0; I < kInventory.arrLargeItems.Length; I++)
    {
        LWCE_EquipLargeItem(kSoldier, kInventory.arrLargeItems[I], I);
    }

    for (I = 0; I < kInventory.arrSmallItems.Length; I++)
    {
        LWCE_EquipSmallItem(kSoldier, kInventory.arrSmallItems[I], I);
    }

    for (I = 0; I < kInventory.arrCustomItems.Length; I++)
    {
        LWCE_EquipCustomItem(kSoldier, kInventory.arrCustomItems[I], I);
    }

    return true;
}

function bool ApplyTankLoadout(XGStrategySoldier kTank, TInventory kInventory)
{
    `LWCE_LOG_DEPRECATED_CLS(ApplyTankLoadout);

    return false;
}

function bool LWCE_ApplyTankLoadout(XGStrategySoldier kTank, LWCE_TInventory kInventory)
{
    local int I;

    UnequipArmor(kTank);

    `LWCE_LOG_CLS("LWCE_ApplyTankLoadout: kInventory.nmArmor = " $ kInventory.nmArmor);
    if (kInventory.nmArmor != '')
    {
        LWCE_EquipArmor(kTank, kInventory.nmArmor);
    }

    for (I = 0; I < kInventory.arrLargeItems.Length; I++)
    {
        LWCE_EquipLargeItem(kTank, kInventory.arrLargeItems[I], I);
    }

    // TODO: do this in the LWCE-equivalent struct
    kTank.m_kSoldier.kClass.eWeaponType = eWP_Integrated;

    return true;
}

function bool EquipArmor(XGStrategySoldier kSoldier, int iArmor)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipArmor);

    return false;
}

function bool LWCE_EquipArmor(XGStrategySoldier kSoldier, name nmArmor)
{
    local LWCEArmorTemplate kArmor;
    local LWCE_XGStorage kStorage;
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_TInventory kOldInventory;
    local int iItem;

    kStorage = LWCE_XGStorage(STORAGE());
    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    if (kStorage.LWCE_GetNumItemsAvailable(nmArmor) <= 0)
    {
        `LWCE_LOG_CLS("Not enough items available for armor " $ nmArmor);
        return false;
    }

    if (kCESoldier.m_kCEChar.kInventory.nmArmor == nmArmor)
    {
        return false;
    }

    kOldInventory = kCESoldier.LWCE_GetInventory();
    UnequipArmor(kCESoldier);

    if (nmArmor == '')
    {
        return true;
    }

    kCESoldier.m_bForcePawnUpdateOnLoadoutChange = nmArmor != kOldInventory.nmArmor;
    kStorage.LWCE_ClaimItem(nmArmor, kCESoldier);
    kCESoldier.m_kCEChar.kInventory.nmArmor = nmArmor;

    if (kCESoldier.GetStatus() == eStatus_Healing || kCESoldier.GetStatus() == /* fatigued? */ 8)
    {
        kCESoldier.m_kCEBackedUpLoadout.nmArmor = nmArmor;
    }

    kArmor = LWCEArmorTemplate(`LWCE_ITEM(kCESoldier.m_kCEChar.kInventory.nmArmor));

    if (kArmor.HasArmorProperty(eAP_Grapple))
    {
        class'LWCEInventoryUtils'.static.AddCustomItem(kCESoldier.m_kCEChar.kInventory, 'Item_Grapple');

        if (kCESoldier.GetStatus() == eStatus_Healing || kCESoldier.GetStatus() == /* fatigued? */ 8)
        {
            class'LWCEInventoryUtils'.static.AddCustomItem(kCESoldier.m_kCEBackedUpLoadout, 'Item_Grapple');
        }
    }

    class'LWCEInventoryUtils'.static.AddLargeItemSlots(kCESoldier.m_kCEChar.kInventory, kArmor.GetLargeInventorySlots(kCESoldier));
    class'LWCEInventoryUtils'.static.AddSmallItemSlots(kCESoldier.m_kCEChar.kInventory, kArmor.GetSmallInventorySlots(kCESoldier));

    LWCE_EquipPistol(kCESoldier, kOldInventory.nmPistol);

    // Equip as much of the previous inventory as we can; the new armor may not fit as many items
    for (iItem = 0; iItem < kCESoldier.m_kCEChar.kInventory.arrLargeItems.Length; iItem++)
    {
        if (iItem == kOldInventory.arrLargeItems.Length)
        {
            break;
        }

        LWCE_EquipLargeItem(kCESoldier, kOldInventory.arrLargeItems[iItem], iItem);
    }

    for (iItem = 0; iItem < kCESoldier.m_kCEChar.kInventory.arrSmallItems.Length; iItem++)
    {
        if (iItem == kOldInventory.arrSmallItems.Length)
        {
            break;
        }

        LWCE_EquipSmallItem(kCESoldier, kOldInventory.arrSmallItems[iItem], iItem);
    }

    // When swapping from no MEC suit to MEC suit, make sure we have a gun equipped
    if (kOldInventory.nmArmor == 'Item_BaseAugments')
    {
        if (kOldInventory.arrLargeItems.Length == 0 || kOldInventory.arrLargeItems[0] == '')
        {
            LWCE_EquipLargeItem(kSoldier, `LWCE_STORAGE.LWCE_GetInfinitePrimary(kCESoldier), 0);
        }
    }

    return true;
}

function bool EquipCustomItem(XGStrategySoldier kSoldier, int iItem, int iSlot)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipCustomItem);

    return false;
}

function bool LWCE_EquipCustomItem(XGStrategySoldier kSoldier, name ItemName, int iSlot)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (kStorage.LWCE_GetNumItemsAvailable(ItemName) <= 0)
    {
        return false;
    }

    // TODO: not sure why this doesn't have the same check as EquipLarge/EquipSmall, to see if the item in the slot
    // is already the requested item

    UnequipCustomItem(kCESoldier, iSlot);
    kStorage.LWCE_ClaimItem(ItemName, kCESoldier);
    class'LWCEInventoryUtils'.static.SetCustomItem(kCESoldier.m_kCEChar.kInventory, iSlot, ItemName);

    return true;
}

function bool EquipLargeItem(XGStrategySoldier kSoldier, int iItem, int iSlot)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipLargeItem);

    return false;
}

function bool LWCE_EquipLargeItem(XGStrategySoldier kSoldier, name ItemName, int iSlot)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (kStorage.LWCE_GetNumItemsAvailable(ItemName) <= 0)
    {
        return false;
    }

    if (iSlot < kCESoldier.m_kCEChar.kInventory.arrLargeItems.Length && kCESoldier.m_kCEChar.kInventory.arrLargeItems[iSlot] == ItemName)
    {
        return false;
    }

    UnequipLargeItem(kCESoldier, iSlot);
    kStorage.LWCE_ClaimItem(ItemName, kCESoldier);
    class'LWCEInventoryUtils'.static.SetLargeItem(kCESoldier.m_kCEChar.kInventory, iSlot, ItemName);

    if (kCESoldier.GetStatus() == eStatus_Healing || kCESoldier.GetStatus() == /* fatigued */ 8)
    {
        class'LWCEInventoryUtils'.static.SetLargeItem(kCESoldier.m_kCEBackedUpLoadout, iSlot, ItemName);
    }

    return true;
}

function bool EquipPistol(XGStrategySoldier kSoldier, int iPistol)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipPistol);

    return false;
}

function bool LWCE_EquipPistol(XGStrategySoldier kSoldier, name PistolName)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (kSoldier.HasPerk(`LW_PERK_ID(FireRocket)))
    {
        return false;
    }

    if (kStorage.LWCE_GetNumItemsAvailable(PistolName) <= 0)
    {
        return false;
    }

    if (kCESoldier.m_kCEChar.kInventory.nmPistol == PistolName)
    {
        return false;
    }

    UnequipPistol(kCESoldier);
    kStorage.LWCE_ClaimItem(PistolName, kCESoldier);
    kCESoldier.m_kCEChar.kInventory.nmPistol = PistolName;

    if (kCESoldier.GetStatus() == eStatus_Healing || kCESoldier.GetStatus() == 8)
    {
        kCESoldier.m_kCEBackedUpLoadout.nmPistol = PistolName;
    }

    return true;
}

function bool EquipSmallItem(XGStrategySoldier kSoldier, int iItem, int iSlot)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipSmallItem);

    return false;
}

function bool LWCE_EquipSmallItem(XGStrategySoldier kSoldier, name ItemName, int iSlot)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (kStorage.LWCE_GetNumItemsAvailable(ItemName) <= 0)
    {
        return false;
    }

    if (iSlot < kCESoldier.m_kCEChar.kInventory.arrSmallItems.Length && kCESoldier.m_kCEChar.kInventory.arrSmallItems[iSlot] == ItemName)
    {
        return false;
    }

    UnequipSmallItem(kCESoldier, iSlot);
    kStorage.LWCE_ClaimItem(ItemName, kCESoldier);

    class'LWCEInventoryUtils'.static.SetSmallItem(kCESoldier.m_kCEChar.kInventory, iSlot, ItemName);

    if (kCESoldier.GetStatus() == eStatus_Healing || kCESoldier.GetStatus() == /* fatigued */ 8)
    {
        class'LWCEInventoryUtils'.static.SetSmallItem(kCESoldier.m_kCEBackedUpLoadout, iSlot, ItemName);
    }

    if (ItemName == 'Item_ArcThrower' && !HQ().HasFacility(eFacility_AlienContain))
    {
        m_bNarrArcWarning = true;
    }

    return true;
}

function TLockerItem GetLockerItem(EInventorySlot eSlotType, out TItem kItem, XGStrategySoldier kSoldier)
{
    local TLockerItem kLockerItem;

    `LWCE_LOG_DEPRECATED_CLS(GetLockerItem);

    return kLockerItem;
}

function LWCE_TLockerItem LWCE_GetLockerItem(EInventorySlot eSlotType, out LWCEItemTemplate kItem, XGStrategySoldier kSoldier)
{
    local LWCEArmorTemplate kArmor;
    local LWCEWeaponTemplate kWeapon;
    local LWCE_XGStorage kStorage;
    local LWCE_TLockerItem kBlankLockerItem, kLockerItem;

    kStorage = `LWCE_STORAGE;

    kLockerItem.ItemName = kItem.GetItemName();
    kLockerItem.iQuantity = kStorage.LWCE_GetNumItemsAvailable(kItem.GetItemName());
    kLockerItem.bTechLocked = LWCE_IsTechLocked(kItem, kSoldier);

    if (eSlotType == eInvSlot_Armor)
    {
        kArmor = LWCEArmorTemplate(kItem);

        if (kArmor == none)
        {
            `LWCE_LOG_CLS("ERROR: LWCE_GetLockerItem: slot type is eInvSlot_Armor but the provided template is not an armor template");
            return kBlankLockerItem;
        }

        if (BARRACKS().m_kVolunteer == kSoldier || kSoldier.IsATank())
        {
            kLockerItem.bClassLocked = true;
        }
        else
        {
            kLockerItem.bClassLocked = kArmor.HasArmorProperty(eAP_Psi) && !kSoldier.HasPsiGift();

            if (!kLockerItem.bClassLocked)
            {
                kLockerItem.bClassLocked = !kStorage.LWCE_IsClassEquippable(kSoldier.m_kSoldier.kClass.eWeaponType, kItem.GetItemName());
            }
        }
    }
    else
    {
        kWeapon = LWCEWeaponTemplate(kItem);

        if (kWeapon == none)
        {
            `LWCE_LOG_CLS("ERROR: LWCE_GetLockerItem: slot type is a weapon slot but the provided template is not a weapon template");
            return kBlankLockerItem;
        }

        if (kWeapon.HasWeaponProperty(eWP_Psionic))
        {
            kLockerItem.bClassLocked = !kSoldier.HasPsiGift();
        }

        if (!kLockerItem.bClassLocked)
        {
            kLockerItem.bClassLocked = !kStorage.LWCE_IsClassEquippable(kSoldier.m_kSoldier.kClass.eWeaponType, kItem.GetItemName());
        }
    }

    return kLockerItem;
}

function array<TLockerItem> GetLockerItems(int iSlotType, int iSlotIndex, XGStrategySoldier kSoldier)
{
    local array<TLockerItem> arrLockerItems;

    arrLockerItems.Length = 0;

    `LWCE_LOG_DEPRECATED_CLS(GetLockerItems);

    return arrLockerItems;
}

function array<LWCE_TLockerItem> LWCE_GetLockerItems(int iSlotType, int iSlotIndex, XGStrategySoldier kSoldier)
{
    local LWCE_XGStorage kStorage;
    local array<LWCEItemTemplate> arrItems;
    local array<LWCE_TLockerItem> arrLockerItems;
    local LWCEArmorTemplate kArmor;
    local LWCEWeaponTemplate kWeapon;
    local LWCE_TLockerItem kLockerItem;
    local bool bDisplayItem;
    local int I;
    local name ItemCategory, ItemName;

    kStorage = `LWCE_STORAGE;

    if (iSlotType == eInvSlot_Armor)
    {
        ItemCategory = 'Armor';
    }
    else if (kSoldier.IsAugmented() || kSoldier.IsATank())
    {
        ItemCategory = 'Vehicle';
    }
    else
    {
        ItemCategory = 'Weapon';
    }

    arrItems = kStorage.LWCE_GetItemsInCategory(ItemCategory, eTransaction_None);

    for (I = 0; I < arrItems.Length; I++)
    {
        ItemName = arrItems[I].GetItemName();
        bDisplayItem = true;

        // A lot of cases need one of these types so just cast them here
        kArmor = LWCEArmorTemplate(arrItems[I]);
        kWeapon = LWCEWeaponTemplate(arrItems[I]);

        switch (iSlotType)
        {
            case eInvSlot_Armor:
                if (kArmor.HasArmorProperty(eAP_Tank))
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

                if (kArmor.HasArmorProperty(eAP_MEC))
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

                // The armor slot isn't ever visible for covert operatives; hide their armor items so
                // they don't appear for regular soldiers
                if (kArmor.HasProperty('CovertOps'))
                {
                    bDisplayItem = false;
                }

                break;
            case eInvSlot_Pistol:
                if (!kWeapon.HasWeaponProperty(eWP_Pistol))
                {
                    bDisplayItem = false;
                }

                break;
            case eInvSlot_Large:
                if (kWeapon.IsSmall())
                {
                    bDisplayItem = false;
                }

                if (kWeapon.HasWeaponProperty(eWP_Integrated))
                {
                    if (!kSoldier.IsATank())
                    {
                        bDisplayItem = false;
                    }
                }

                if (kSoldier.IsAugmented())
                {
                    if (!kWeapon.HasWeaponProperty(eWP_Mec))
                    {
                        bDisplayItem = false;
                    }

                    if (iSlotIndex == 0)
                    {
                        if (kWeapon.HasWeaponProperty(eWP_Secondary))
                        {
                            bDisplayItem = false;
                        }
                    }
                    else
                    {
                        if (!kWeapon.HasWeaponProperty(eWP_Secondary))
                        {
                            bDisplayItem = false;
                        }
                    }
                }
                else
                {
                    if (kWeapon.HasWeaponProperty(eWP_Mec))
                    {
                        bDisplayItem = false;
                    }

                    if (kWeapon.HasAbility('FireRocket'))
                    {
                        if (iSlotIndex == 0)
                        {
                            bDisplayItem = false;
                        }
                    }

                    if (!kWeapon.HasAbility('FireRocket'))
                    {
                        if (iSlotIndex == 1)
                        {
                            bDisplayItem = false;
                        }
                    }
                }

                break;
            case eInvSlot_Small:
                if (!kWeapon.IsSmallItem())
                {
                    bDisplayItem = false;
                }

                if (kSoldier.IsATank() && !kWeapon.HasWeaponProperty(eWP_Integrated))
                {
                    bDisplayItem = false;
                }

                if (kSoldier.IsAugmented() && !kWeapon.HasWeaponProperty(eWP_Mec))
                {
                    bDisplayItem = false;
                }

                if (kWeapon.HasWeaponProperty(eWP_Pistol))
                {
                    bDisplayItem = false;
                }

                // TODO this can probably be deleted after template transition
                if (ItemName == 'Item_SkeletonKey')
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

function bool LWCE_IsTechLocked(out LWCEItemTemplate kItem, XGStrategySoldier kSoldier)
{
    if (XComCheatManager(GetALocalPlayerController().CheatManager) != none)
    {
        if (XComCheatManager(GetALocalPlayerController().CheatManager).m_bNoWeaponsTech)
        {
            return false;
        }
    }

    if (kSoldier.IsASuperSoldier())
    {
        return false;
    }

    return !`LWCE_HQ.ArePrereqsFulfilled(kItem.kPrereqs);
}

function UnequipArmor(XGStrategySoldier kSoldier)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;
    local int iItem;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (kCESoldier.m_kCEChar.kInventory.nmArmor != '')
    {
        if (`LWCE_ARMOR(kCESoldier.m_kCEChar.kInventory.nmArmor).HasArmorProperty(eAP_Grapple))
        {
            class'LWCEInventoryUtils'.static.RemoveCustomItem(kCESoldier.m_kCEChar.kInventory, 'Item_Grapple');
        }

        kStorage.LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.nmArmor, kCESoldier);
        kStorage.LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.nmPistol, kCESoldier);

        for (iItem = 0; iItem < kCESoldier.m_kCEChar.kInventory.arrLargeItems.Length; iItem++)
        {
            kStorage.LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.arrLargeItems[iItem], kCESoldier);
        }

        for (iItem = 0; iItem < kCESoldier.m_kCEChar.kInventory.arrSmallItems.Length; iItem++)
        {
            kStorage.LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.arrSmallItems[iItem], kCESoldier);
        }
    }

    kCESoldier.m_kCEChar.kInventory.nmArmor = '';
    kCESoldier.m_kCEChar.kInventory.nmPistol = '';

    class'LWCEInventoryUtils'.static.ClearLargeItems(kCESoldier.m_kCEChar.kInventory);
    class'LWCEInventoryUtils'.static.ClearSmallItems(kCESoldier.m_kCEChar.kInventory);
}

function bool UnequipCustomItem(XGStrategySoldier kSoldier, int iSlot)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (iSlot < kCESoldier.m_kCEChar.kInventory.arrCustomItems.Length && kCESoldier.m_kCEChar.kInventory.arrCustomItems[iSlot] != '')
    {
        kStorage.LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.arrCustomItems[iSlot], kCESoldier);
        class'LWCEInventoryUtils'.static.SetCustomItem(kCESoldier.m_kCEChar.kInventory, iSlot, '');
    }

    return true;
}

function bool UnequipLargeItem(XGStrategySoldier kSoldier, int iSlot)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (iSlot < kCESoldier.m_kCEChar.kInventory.arrLargeItems.Length && kCESoldier.m_kCEChar.kInventory.arrLargeItems[iSlot] != '')
    {
        kStorage.LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.arrLargeItems[iSlot], kCESoldier);
        class'LWCEInventoryUtils'.static.SetLargeItem(kCESoldier.m_kCEChar.kInventory, iSlot, '');
    }

    return true;
}

function bool UnequipPistol(XGStrategySoldier kSoldier)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (kCESoldier.m_kCEChar.kInventory.nmPistol != '')
    {
        kStorage.LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.nmPistol, kCESoldier);
        kCESoldier.m_kCEChar.kInventory.nmPistol = '';
    }

    return true;
}

function bool UnequipSmallItem(XGStrategySoldier kSoldier, int iSlot)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGStorage kStorage;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kStorage = LWCE_XGStorage(STORAGE());

    if (iSlot < kCESoldier.m_kCEChar.kInventory.arrSmallItems.Length && kCESoldier.m_kCEChar.kInventory.arrSmallItems[iSlot] != '')
    {
        kStorage.LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.arrSmallItems[iSlot], kCESoldier);
        class'LWCEInventoryUtils'.static.SetSmallItem(kCESoldier.m_kCEChar.kInventory, iSlot, '');

        if (kCESoldier.GetStatus() == eStatus_Healing || kCESoldier.GetStatus() == /* fatigued */ 8)
        {
            class'LWCEInventoryUtils'.static.SetSmallItem(kCESoldier.m_kCEBackedUpLoadout, iSlot, '');
        }
    }

    return true;
}