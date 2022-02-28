class LWCE_XGLoadoutMgr extends Object
    abstract;

static function ApplyInventory(XGUnit kUnit, optional bool bLoadFromCheckpoint = false)
{
    local TLoadout Loadout;
    local int iType;

    iType = kUnit.GetCharacter().m_kChar.iType;

    // XCOM soldiers and EXALT units
    if ( iType == eChar_Soldier || (iType >= 24 && iType <= 31) )
    {
        ConvertTInventoryToSoldierLoadout(kUnit.GetCharacter().m_kChar, kUnit.GetCharacter().m_kChar.kInventory, Loadout);

        if (kUnit.GetCharacter().HasUpgrade(ePerk_FieldMedic) && !kUnit.IsAugmented())
        {
            Loadout.Items[eSlot_RightChest] = eItem_Medikit;
        }
    }
    else if (iType == eChar_Tank)
    {
        ConvertTInventoryToTankLoadout(kUnit.GetCharacter().m_kChar.kInventory, Loadout);
    }
    else
    {
        ConvertTInventoryToAlienLoadout(kUnit.GetCharacter().m_kChar, kUnit.GetCharacter().m_kChar.kInventory, Loadout);
    }

    ApplyLoadout(kUnit, Loadout, bLoadFromCheckpoint);
}

static function ApplyLoadout(XGUnit kUnit, TLoadout kLoad, bool bLoadFromCheckpoint)
{
    local XGInventoryItem kItem;
    local XGLoadoutInstances kLoadoutInstances;
    local int I, J;

    kLoadoutInstances = `WORLDINFO.Spawn(class'XGLoadoutInstances', kUnit.Owner);
    kLoadoutInstances.m_iNumItems = 0;
    kLoadoutInstances.m_iNumBackpackItems = 0;

    // When spawning weapons, we overwrite the field m_strUIImage and use it to store the weapon's ID. The weapon
    // itself can only store an EItemType, which won't work for modding. This field is never read directly by the game;
    // its default value is read only. This makes it safe for us to overwrite.

    for (I = 0; I < eSlot_MAX; I++)
    {
        if (I == eSlot_RearBackPack)
        {
            for (J = 0; J < kLoad.Backpack.Length; J++)
            {
                if (kLoad.Backpack[J] != 0)
                {
                    kItem = `WORLDINFO.Spawn(class<XGWeapon>(class'LWCE_XGItemLibrary'.static.GetItem(kLoad.Backpack[J])), kUnit.Owner);
                    kItem.m_strUIImage = string(kLoad.Backpack[J]); // Store item ID
                    XGWeapon(kItem).ApplyAmmoCost(kLoad.Backpack[J]);
                    kItem.Init();
                    kLoadoutInstances.m_aBackpackItems[J] = kItem;
                    ++kLoadoutInstances.m_iNumBackpackItems;
                }
            }
        }
        else if (kLoad.Items[I] != 0)
        {
            kItem = `WORLDINFO.Spawn(class<XGWeapon>(class'LWCE_XGItemLibrary'.static.GetItem(kLoad.Items[I])), kUnit.Owner);
            kItem.m_strUIImage = string(kLoad.Items[I]); // Store item ID
            XGWeapon(kItem).ApplyAmmoCost(kLoad.Items[I]);
            kItem.Init();
            kLoadoutInstances.m_aItems[I] = kItem;
            ++kLoadoutInstances.m_iNumItems;
        }
    }

    kUnit.ApplyLoadout(kLoadoutInstances, bLoadFromCheckpoint);
}

static function ConvertTInventoryToAlienLoadout(TCharacter kChar, TInventory kInventory, out TLoadout Loadout)
{
    local int I;

    if (kInventory.iPistol != 0)
    {
        Loadout.Items[eSlot_RightForearm] = kInventory.iPistol;
    }

    for (I = 0; I < kInventory.iNumLargeItems; I++)
    {
        if (I == 0)
        {
            Loadout.Items[eSlot_RightHand] = kInventory.arrLargeItems[I];
        }
        else
        {
            Loadout.Items[eSlot_LeftHand] = kInventory.arrLargeItems[I];
        }
    }

    for (I = 0; I < kInventory.iNumSmallItems; I++)
    {
        if (I == 0)
        {
            Loadout.Items[eSlot_LeftThigh] = kInventory.arrSmallItems[I];
        }
    }

    if (`GAMECORE.CharacterIsPsionic(kChar) && `GAMECORE.TInventoryCustomItemsFind(kInventory, eItem_PsiAmp) == INDEX_NONE)
    {
        `GAMECORE.TInventoryCustomItemsAddItem(kInventory, eItem_PsiAmp);
    }

    for (I = 0; I < kInventory.iNumCustomItems; I++)
    {
        if (kInventory.arrCustomItems[I] == eItem_PsiAmp)
        {
            Loadout.Items[eSlot_PsiSource] = eItem_PsiAmp;
        }

        // Acid Spit
        if (kInventory.arrCustomItems[I] == eItem_Plague)
        {
            Loadout.Items[eSlot_Head] = eItem_Plague;
        }

        // This used to be eItem_SectopodArm, now it maps to Assault Carbine (so, probably unused)
        if (kInventory.arrCustomItems[I] == `LW_ITEM_ID(AssaultCarbine))
        {
            Loadout.Items[eSlot_LeftHand] = `LW_ITEM_ID(AssaultCarbine);
        }
    }
}

static function ConvertTInventoryToSoldierLoadout(TCharacter kChar, TInventory kInventory, out TLoadout Loadout)
{
    local int I, iForcedInBackpack;
    local class<XGWeapon> LargeItem_WeaponClass;

    if (`GAMECORE.ArmorHasProperty(kInventory.iArmor, eAP_Grapple))
    {
        Loadout.Items[eSlot_Grapple] = eItem_Grapple;
    }

    Loadout.Items[eSlot_RightThigh] = kInventory.iPistol;

    for (I = 0; I < kInventory.iNumLargeItems; I++)
    {
        if (kChar.eClass == 6)
        {
            LargeItem_WeaponClass = class<XGWeapon>(class'LWCE_XGItemLibrary'.static.GetItem(kInventory.arrLargeItems[I]));
            Loadout.Items[LargeItem_WeaponClass.default.m_eEquipLocation] = kInventory.arrLargeItems[I];
        }
        else if (I == 0)
        {
            Loadout.Items[eSlot_RightBack] = kInventory.arrLargeItems[I];
        }
        else if (I == 1)
        {
            Loadout.Items[eSlot_LeftBack] = kInventory.arrLargeItems[I];
        }
    }

    iForcedInBackpack = 0;

    for (I = 0; I < kInventory.iNumSmallItems; I++)
    {
        if (`GAMECORE.WeaponHasProperty(kInventory.arrSmallItems[I], eWP_Backpack))
        {
            Loadout.Backpack.AddItem(kInventory.arrSmallItems[I]);
            ++iForcedInBackpack;
        }
        else if (I - iForcedInBackpack == 0)
        {
            Loadout.Items[eSlot_LeftThigh] = kInventory.arrSmallItems[I];
        }
        else if (I - iForcedInBackpack == 1)
        {
            Loadout.Items[eSlot_RightChest] = kInventory.arrSmallItems[I];
        }
        else if (I - iForcedInBackpack == 2)
        {
            Loadout.Items[eSlot_LeftBelt] = kInventory.arrSmallItems[I];
        }
    }

    if ( (`GAMECORE.CharacterIsPsionic(kChar) || `GAMECORE.ArmorHasProperty(kInventory.iArmor, eAP_Psi) ) && `GAMECORE.TInventoryCustomItemsFind(kInventory, eItem_PsiAmp) == INDEX_NONE)
    {
        `GAMECORE.TInventoryCustomItemsAddItem(kInventory, eItem_PsiAmp);
    }

    for (I = 0; I < kInventory.iNumCustomItems; I++)
    {
        if (kInventory.arrCustomItems[I] == eItem_PsiAmp)
        {
            Loadout.Items[eSlot_PsiSource] = eItem_PsiAmp;
        }

        if (kInventory.arrCustomItems[I] == eItem_Plague)
        {
            Loadout.Items[eSlot_Head] = eItem_Plague;
        }

        if (kInventory.arrCustomItems[I] == `LW_ITEM_ID(AssaultCarbine))
        {
            Loadout.Items[eSlot_LeftHand] = `LW_ITEM_ID(AssaultCarbine);
        }
    }
}

static function ConvertTInventoryToTankLoadout(TInventory kInventory, out TLoadout Loadout)
{
    Loadout.Items[eSlot_RightHand] = kInventory.arrLargeItems[0];
}