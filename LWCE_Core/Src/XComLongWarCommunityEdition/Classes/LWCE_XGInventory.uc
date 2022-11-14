class LWCE_XGInventory extends XGInventory;

simulated function bool AddItem(XGInventoryItem kItem, ELocation eLoc, optional bool bMultipleItems = false)
{
    local LWCE_XGWeapon kWeapon;

    if (!super.AddItem(kItem, eLoc, bMultipleItems))
    {
        return false;
    }

    // The inventory normally updates the secondary weapon on its own, but it seems to rely on
    // XGWeapon.m_kTWeapon, which we aren't using in LWCE. We thus have to update the secondary ourselves.

    kWeapon = LWCE_XGWeapon(kItem);

    if (m_kSecondaryWeapon == none && kWeapon != none && (kWeapon.HasProperty(eWP_Pistol) || kWeapon.HasProperty(eWP_Secondary)))
    {
        m_kSecondaryWeapon = kWeapon;
    }

    return true;
}

function ApplyInventoryOnLoad()
{
    local int I, J;
    local XGInventoryItem kItem;
    local XGWeapon ActiveWeapon;
    local XComWeapon kWeapon;
    local array<XGWeapon> Weapons;

    for (I = 0; I < 26; I++)
    {
        for (J = 0; J < GetNumberOfItemsInSlot(ELocation(I)); J++)
        {
            kItem = GetItemByIndexInSlot(J, ELocation(I));

            if (kItem != none)
            {
                kItem.Init();
                kItem.m_kEntity = kItem.CreateEntity();
                ActiveWeapon = XGWeapon(kItem);

                if (ActiveWeapon != none)
                {
                    kWeapon = XComWeapon(kItem.m_kEntity);
                    kWeapon.m_kPawn = m_kOwner.GetPawn();
                    kWeapon.Instigator = kWeapon.m_kPawn;
                    kWeapon.m_kPawn.UpdateMeshMaterials(kWeapon.Mesh);

                    PresAddItem(kItem);
                }
            }
        }
    }

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
        EquipItem(ActiveWeapon, true, true);
    }
    else
    {
        EquipItem(m_kPrimaryWeapon, true, true);
    }

    CalculateWeaponToEquip();

    if (m_kOwner.GetPawn().IsA('XComHumanPawn') && !m_kOwner.IsCivilian())
    {
        XComHumanPawn(m_kOwner.GetPawn()).AttachKit();
    }
}

simulated function DetermineEngagementRange()
{
    local float fRange;
    local int I;
    local LWCEWeaponTemplate kWeaponTemplate;
    local XGWeapon kWeapon;

    m_fModifiableEngagementRange = 0.0;
    m_fFixedEngagementRange = 0.0;
    m_fGrenadeEngagementRange = 0.0;

    for (I = 0; I < eSlot_MAX; I++)
    {
        kWeapon = XGWeapon(GetItem(ELocation(I)));
        kWeaponTemplate =`LWCE_WEAPON_FROM_XG(kWeapon);

        if (kWeapon != none && kWeapon.GetRemainingAmmo() > 0)
        {
            if (kWeapon == GetActiveWeapon() || !kWeaponTemplate.HasWeaponProperty(eWP_Secondary))
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

simulated function XGInventoryItem FindItemByName(name ItemName)
{
    local int I, J;
    local ELocation eLoc;
    local XGInventoryItem kInvItem;

    for (I = 0; I < eSlot_MAX; I++)
    {
        eLoc = ELocation(I);

        for (J = 0; J < GetNumberOfItemsInSlot(eLoc); J++)
        {
            kInvItem = GetItemByIndexInSlot(J, eLoc);

            if (kInvItem != none && class'LWCE_XGWeapon_Extensions'.static.GetItemName(kInvItem) == ItemName)
            {
                return kInvItem;
            }
        }
    }

    return none;
}

simulated function int GetNumItems(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(GetNumItems);

    return -1;
}

simulated function int LWCE_GetNumItems(name ItemName)
{
    local int I, J, Num;
    local ELocation eLoc;
    local XGInventoryItem kInvItem;

    for (I = 0; I < eSlot_MAX; I++)
    {
        eLoc = ELocation(I);

        for (J = 0; J < GetNumberOfItemsInSlot(eLoc); J++)
        {
            kInvItem = GetItemByIndexInSlot(J, eLoc);

            if (kInvItem != none && class'LWCE_XGWeapon_Extensions'.static.GetItemName(kInvItem) == ItemName)
            {
                Num++;
            }
        }
    }

    return Num;
}

simulated function XGInventoryItem GetRearBackpackItem(EItemType eTypeRequested)
{
    `LWCE_LOG_DEPRECATED_CLS(GetRearBackpackItem);

    return none;
}

simulated function XGInventoryItem LWCE_GetRearBackpackItem(name ItemName)
{
    local XGInventoryItem kItem;
    local int I;

    for (I = 0; I < GetNumberOfItemsInSlot(eSlot_RearBackPack); I++)
    {
        kItem = GetItemByIndexInSlot(I, eSlot_RearBackPack);

        if (kItem != none && class'LWCE_XGWeapon_Extensions'.static.GetItemName(kItem) == ItemName)
        {
            return kItem;
        }
    }

    return none;
}

simulated function GetRearBackPackItemArray(out array<int> arrBackPackItemsReturned)
{
    `LWCE_LOG_DEPRECATED_CLS(GetRearBackPackItemArray);
}

simulated function LWCE_GetRearBackPackItemArray(out array<name> arrBackPackItemsReturned)
{
    local int I;
    local name ItemName;
    local XGInventoryItem kItem;

    arrBackPackItemsReturned.Length = 0;

    for (I = 0; I < GetNumberOfItemsInSlot(eSlot_RearBackPack); I++)
    {
        kItem = GetItemByIndexInSlot(I, eSlot_RearBackPack);

        if (kItem != none)
        {
            ItemName = class'LWCE_XGWeapon_Extensions'.static.GetItemName(kItem);
            arrBackPackItemsReturned.AddItem(ItemName);
        }
    }
}

simulated function XGWeapon GetSecondaryWeaponForUI()
{
    local LWCE_XGWeapon Weap;

    if (m_kPrimaryWeapon != none && !m_kPrimaryWeapon.HasProperty(eWP_Secondary))
    {
        Weap = LWCE_XGWeapon(m_kSecondaryWeapon);
    }
    else
    {
        Weap = LWCE_XGWeapon(m_kPrimaryWeapon);
    }

    if (Weap == none)
    {
        Weap = LWCE_XGWeapon(SearchForSecondaryWeapon());
    }

    if (Weap == none || Weap.m_TemplateName == 'Item_AcidSpit')
    {
        return none;
    }

    return Weap;
}

simulated function bool HasItemOfType(EItemType anItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(HasItemOfType);

    return false;
}

simulated function bool LWCE_HasItemOfType(name ItemName)
{
    local int Slot, Index;

    for (Slot = 0; Slot < eSlot_MAX; Slot++)
    {
        for (Index = 0; Index < m_arrStructSlots[Slot].m_iNumItems; Index++)
        {
            if (ItemName == class'LWCE_XGWeapon_Extensions'.static.GetItemName(m_arrStructSlots[Slot].m_arrItems[Index]))
            {
                return true;
            }
        }
    }

    return false;
}

simulated function PresEquip(XGInventoryItem kItem, bool bImmediate)
{
    local LWCEWeaponTemplate kWeapon;

    if (kItem.IsA('XGWeapon'))
    {
        kWeapon = `LWCE_WEAPON(class'LWCE_XGWeapon_Extensions'.static.GetItemName(kItem));

        m_kOwner.GetPawn().EquipWeapon(XComWeapon(kItem.m_kEntity), bImmediate, kWeapon.HasWeaponProperty(eWP_Backpack));
    }
}

simulated function XGInventoryItem SearchForItemByEnumInSlot(ELocation Slot, EItemType eCompareType, optional out int iSearchIndex)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(SearchForItemByEnumInSlot);
    return super.SearchForItemByEnumInSlot(Slot, eCompareType, iSearchIndex);
}