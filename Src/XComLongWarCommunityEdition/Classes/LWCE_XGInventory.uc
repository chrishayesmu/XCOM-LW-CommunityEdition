class LWCE_XGInventory extends XGInventory;

function ApplyInventoryOnLoad()
{
    local int I, J;
    local XGInventoryItem kItem;
    local XGWeapon ActiveWeapon;
    local XComWeapon kWeapon;
    local array<XGWeapon> Weapons;

    `LWCE_LOG_CLS("ApplyInventoryOnLoad");

    for (I = 0; I < 26; I++)
    {
        `LWCE_LOG_CLS("Outer loop");
        for (J = 0; J < GetNumberOfItemsInSlot(ELocation(I)); J++)
        {
            `LWCE_LOG_CLS("Inner loop");
            kItem = GetItemByIndexInSlot(J, ELocation(I));
            `LWCE_LOG_CLS("After GetItemByIndexInSlot");

            if (kItem != none)
            {
                `LWCE_LOG_CLS("Init: kItem = " $ kItem);
                kItem.Init();
                `LWCE_LOG_CLS("CreateEntity");
                kItem.m_kEntity = kItem.CreateEntity();
                ActiveWeapon = XGWeapon(kItem);

                if (ActiveWeapon != none)
                {
                    kWeapon = XComWeapon(kItem.m_kEntity);
                    `LWCE_LOG_CLS("GetPawn");
                    kWeapon.m_kPawn = m_kOwner.GetPawn();
                    kWeapon.Instigator = kWeapon.m_kPawn;
                    `LWCE_LOG_CLS("UpdateMeshMaterials");
                    kWeapon.m_kPawn.UpdateMeshMaterials(kWeapon.Mesh);
                    `LWCE_LOG_CLS("PresAddItem");
                    PresAddItem(kItem);
                }
            }
        }
    }

    `LWCE_LOG_CLS("GetPrimaryItemInSlot 1");
    ActiveWeapon = XGWeapon(GetPrimaryItemInSlot(m_ActiveWeaponLoc));

    if (ActiveWeapon == none && m_kOwner.GetPawn().IsA('XComSectopod'))
    {
        if (!m_kOwner.IsApplyingAbility(65))
        {
            ActiveWeapon = XGWeapon(GetPrimaryItemInSlot(eSlot_ChestCannon));

            if (ActiveWeapon == none)
            {
                ActiveWeapon = XGWeapon(GetPrimaryItemInSlot(eSlot_RightBack));
            }
        }
        else
        {
            ActiveWeapon = XGWeapon(GetPrimaryItemInSlot(eSlot_LeftThigh));
        }
    }

    if (m_kOwner.GetCharacter().m_kChar.iType == eChar_Soldier && m_kOwner.GetCharacter().m_kChar.eClass == eSC_Mec)
    {
        GetLargeItems(Weapons);

        for (I = 0; I < Weapons.Length; I++)
        {
            EquipItem(Weapons[I], true, true);
        }

        SetActiveWeapon(Weapons[0]);
    }
    else if (ActiveWeapon != none)
    {
        `LWCE_LOG_CLS("EquipItem 1");
        EquipItem(ActiveWeapon, true, true);
    }
    else
    {
        `LWCE_LOG_CLS("EquipItem 2");
        EquipItem(m_kPrimaryWeapon, true, true);
    }

    `LWCE_LOG_CLS("CalculateWeaponToEquip");
    CalculateWeaponToEquip();

    if (m_kOwner.GetPawn().IsA('XComHumanPawn') && !m_kOwner.IsCivilian())
    {
        `LWCE_LOG_CLS("AttachKit");
        XComHumanPawn(m_kOwner.GetPawn()).AttachKit();
    }
}

simulated function DetermineEngagementRange()
{
    local float fRange;
    local int I;
    local XGWeapon kWeapon;

    m_fModifiableEngagementRange = 0.0;
    m_fFixedEngagementRange = 0.0;
    m_fGrenadeEngagementRange = 0.0;

    for (I = 0; I < eSlot_MAX; I++)
    {
        kWeapon = XGWeapon(GetItem(ELocation(I)));

        if (kWeapon != none && kWeapon.GetRemainingAmmo() > 0 && !kWeapon.IsOverheated())
        {
            if (kWeapon == GetActiveWeapon() || !kWeapon.CanBeStartingWeapon())
            {
                fRange = class'LWCE_XGWeapon_Extensions'.static.LongRange(kWeapon);

                if (kWeapon.IsGrenade())
                {
                    if (fRange > m_fGrenadeEngagementRange)
                    {
                        m_fGrenadeEngagementRange = fRange;
                    }
                }
                else if (kWeapon.bIsFixedRange)
                {
                    if (fRange > m_fFixedEngagementRange)
                    {
                        m_fFixedEngagementRange = fRange;
                    }
                }
                else if (fRange > m_fModifiableEngagementRange)
                {
                    m_fModifiableEngagementRange = fRange;
                }
            }
        }
    }
}

simulated function int GetNumItems(EItemType eItem)
{
    // Since this is forwards-compatible, no need to deprecate the base function
    return LWCE_GetNumItems(eItem);
}

simulated function int LWCE_GetNumItems(int iItemId)
{
    local int I, J, Num;
    local ELocation eLoc;

    for (I = 0; I < eSlot_MAX; I++)
    {
        eLoc = ELocation(I);

        for (J = 0; J < GetNumberOfItemsInSlot(eLoc); J++)
        {
            if (GetItemByIndexInSlot(J, eLoc) != none && GetItemByIndexInSlot(J, eLoc).GameplayType() == iItemId)
            {
                ++Num;
            }
        }
    }

    return Num;
}

simulated function bool HasItemOfType(EItemType anItemType)
{
    // Since this is forwards-compatible, no need to deprecate the base function
    return LWCE_HasItemOfType(anItemType);
}

simulated function bool LWCE_HasItemOfType(int iItemId)
{
    // TODO: needs extra testing, not clear if this native function will work properly with modded items
    return FindItemByEnum(iItemId) != none;
}

simulated function XGInventoryItem SearchForItemByEnumInSlot(ELocation Slot, EItemType eCompareType, optional out int iSearchIndex)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(SearchForItemByEnumInSlot);
    return super.SearchForItemByEnumInSlot(Slot, eCompareType, iSearchIndex);
}