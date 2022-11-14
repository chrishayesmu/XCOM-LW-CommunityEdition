class LWCE_XGLoadoutMgr extends Object
    abstract;

static function ApplyInventory(XGUnit kUnit, optional bool bLoadFromCheckpoint = false)
{
    local LWCE_XGUnit kCEUnit;
    local LWCE_TLoadout Loadout;
    local int iType;

    `LWCE_LOG_CLS("ApplyInventory begin");

    kCEUnit = LWCE_XGUnit(kUnit);
    iType = kCEUnit.m_kCEChar.iCharacterType;

    // XCOM soldiers and EXALT units
    if ( iType == eChar_Soldier || (iType >= 24 && iType <= 31) )
    {
        LWCE_ConvertTInventoryToSoldierLoadout(kCEUnit.m_kCEChar, kCEUnit.m_kCEChar.kInventory, Loadout);

        if (kCEUnit.HasPerk(`LW_PERK_ID(FieldMedic)) && !kCEUnit.IsAugmented())
        {
            Loadout.Items[eSlot_RightChest] = 'Item_Medikit';
        }
    }
    else if (iType == eChar_Tank)
    {
        LWCE_ConvertTInventoryToTankLoadout(kCEUnit.m_kCEChar.kInventory, Loadout);
    }
    else
    {
        LWCE_ConvertTInventoryToAlienLoadout(kCEUnit.m_kCEChar, kCEUnit.m_kCEChar.kInventory, Loadout);
    }

    LWCE_ApplyLoadout(kCEUnit, Loadout, bLoadFromCheckpoint);
    `LWCE_LOG_CLS("ApplyInventory end");
}

static function ApplyLoadout(XGUnit kUnit, TLoadout kLoad, bool bLoadFromCheckpoint)
{
    `LWCE_LOG_DEPRECATED_CLS(ApplyLoadout);
}

static function LWCE_ApplyLoadout(XGUnit kUnit, LWCE_TLoadout kLoad, bool bLoadFromCheckpoint)
{
    local LWCE_XGTacticalGameCore kGameCore;
    local XGInventoryItem kItem;
    local XGLoadoutInstances kLoadoutInstances;
    local int I, J;

    `LWCE_LOG_CLS("LWCE_ApplyLoadout begin");

    kGameCore = `LWCE_GAMECORE;

    kLoadoutInstances = `WORLDINFO.Spawn(class'XGLoadoutInstances', kUnit.Owner);
    kLoadoutInstances.m_iNumItems = 0;
    kLoadoutInstances.m_iNumBackpackItems = 0;

    // When spawning weapons, we overwrite the field m_strUIImage and use it to store the weapon's name. The weapon
    // itself can only store an EItemType, which won't work for modding. This field is never read directly by the game;
    // its default value is read only. This makes it safe for us to overwrite.

    for (I = 0; I < eSlot_MAX; I++)
    {
        if (I == eSlot_RearBackPack)
        {
            for (J = 0; J < kLoad.Backpack.Length; J++)
            {
                if (kLoad.Backpack[J] != '')
                {
                    kGameCore.nmItemToCreate = kLoad.Backpack[J];
                    kItem = `WORLDINFO.Spawn(class'LWCE_XGWeapon', kUnit.Owner);
                    LWCE_XGWeapon(kItem).InitFromTemplate(kLoad.Backpack[J]);

                    kLoadoutInstances.m_aBackpackItems[J] = kItem;
                    kLoadoutInstances.m_iNumBackpackItems++;
                }
            }
        }
        else if (kLoad.Items[I] != '')
        {
            kGameCore.nmItemToCreate = kLoad.Items[I];
            kItem = `WORLDINFO.Spawn(class'LWCE_XGWeapon', kUnit.Owner);
            LWCE_XGWeapon(kItem).InitFromTemplate(kLoad.Items[I]);

            kLoadoutInstances.m_aItems[I] = kItem;
            kLoadoutInstances.m_iNumItems++;
        }
    }

    kUnit.ApplyLoadout(kLoadoutInstances, bLoadFromCheckpoint);

    `LWCE_LOG_CLS("LWCE_ApplyLoadout end");
}

static function ConvertTInventoryToAlienLoadout(TCharacter kChar, TInventory kInventory, out TLoadout Loadout)
{
    `LWCE_LOG_DEPRECATED_CLS(ConvertTInventoryToAlienLoadout);
}

static function LWCE_ConvertTInventoryToAlienLoadout(LWCE_TCharacter kChar, LWCE_TInventory kInventory, out LWCE_TLoadout Loadout)
{
    local int I;

    if (kInventory.nmPistol != '')
    {
        Loadout.Items[eSlot_RightForearm] = kInventory.nmPistol;
    }

    for (I = 0; I < kInventory.arrLargeItems.Length; I++)
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

    for (I = 0; I < kInventory.arrSmallItems.Length; I++)
    {
        if (I == 0)
        {
            Loadout.Items[eSlot_LeftThigh] = kInventory.arrSmallItems[I];
        }
    }

    if (`LWCE_GAMECORE.LWCE_CharacterIsPsionic(kChar) && !class'LWCEInventoryUtils'.static.HasItemOfName(kInventory, 'Item_PsiAmp'))
    {
        class'LWCEInventoryUtils'.static.AddCustomItem(kInventory, 'Item_PsiAmp');
    }

    for (I = 0; I < kInventory.arrCustomItems.Length; I++)
    {
        if (kInventory.arrCustomItems[I] == 'Item_PsiAmp')
        {
            Loadout.Items[eSlot_PsiSource] = 'Item_PsiAmp';
        }

        // Acid Spit
        if (kInventory.arrCustomItems[I] == 'Item_Plague')
        {
            Loadout.Items[eSlot_Head] = 'Item_Plague';
        }

        // This used to be eItem_SectopodArm, now it maps to Assault Carbine (so, probably unused)
        if (kInventory.arrCustomItems[I] == 'Item_AssaultCarbine')
        {
            Loadout.Items[eSlot_LeftHand] = 'Item_AssaultCarbine';
        }
    }
}

static function ConvertTInventoryToSoldierLoadout(TCharacter kChar, TInventory kInventory, out TLoadout Loadout)
{
    `LWCE_LOG_DEPRECATED_CLS(ConvertTInventoryToSoldierLoadout);
}

static function LWCE_ConvertTInventoryToSoldierLoadout(LWCE_TCharacter kChar, LWCE_TInventory kInventory, out LWCE_TLoadout Loadout)
{
    local int I, iForcedInBackpack;
    local ELocation eEquipLocation;
    local LWCEArmorTemplate kArmor;
    local LWCEWeaponTemplate kWeapon;

    kArmor = `LWCE_ARMOR(kInventory.nmArmor);

    if (kArmor.HasArmorProperty(eAP_Grapple))
    {
        Loadout.Items[eSlot_Grapple] = 'Item_Grapple';
    }

    Loadout.Items[eSlot_RightThigh] = kInventory.nmPistol;

    for (I = 0; I < kInventory.arrLargeItems.Length; I++)
    {
        if (kChar.bIsAugmented)
        {
            kWeapon = `LWCE_WEAPON(kInventory.arrLargeItems[I]);
            eEquipLocation = kWeapon.eEquipLocation != eSlot_None ? kWeapon.eEquipLocation : class'LWCE_XGWeapon'.default.m_eEquipLocation;
            Loadout.Items[eEquipLocation] = kInventory.arrLargeItems[I];
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

    for (I = 0; I < kInventory.arrSmallItems.Length; I++)
    {
        kWeapon = `LWCE_WEAPON(kInventory.arrSmallItems[I]);

        if (kWeapon != none && kWeapon.HasWeaponProperty(eWP_Backpack))
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

    if ( (`LWCE_GAMECORE.LWCE_CharacterIsPsionic(kChar) || kArmor.HasArmorProperty(eAP_Psi) ) && kInventory.arrCustomItems.Find('Item_PsiAmp') == INDEX_NONE)
    {
        kInventory.arrCustomItems.AddItem('Item_PsiAmp');
    }

    for (I = 0; I < kInventory.arrCustomItems.Length; I++)
    {
        if (kInventory.arrCustomItems[I] == 'Item_PsiAmp')
        {
            Loadout.Items[eSlot_PsiSource] = 'Item_PsiAmp';
        }

        if (kInventory.arrCustomItems[I] == 'Item_Plague')
        {
            Loadout.Items[eSlot_Head] = 'Item_Plague';
        }

        // TODO: no idea why this has its own logic, probably not necessary
        if (kInventory.arrCustomItems[I] == 'Item_AssaultCarbine')
        {
            Loadout.Items[eSlot_LeftHand] = 'Item_AssaultCarbine';
        }
    }
}

static function ConvertTInventoryToTankLoadout(TInventory kInventory, out TLoadout Loadout)
{
    `LWCE_LOG_DEPRECATED_CLS(ConvertTInventoryToTankLoadout);
}

static function LWCE_ConvertTInventoryToTankLoadout(LWCE_TInventory kInventory, out LWCE_TLoadout Loadout)
{
    Loadout.Items[eSlot_RightHand] = kInventory.arrLargeItems[0];
}

static function EquipUnit(XGUnit kUnit, optional ELoadoutTypes eLoadoutType = eLoadout_Invalid)
{
    local int Index;
    local name ItemName;
    local LoadoutTemplate Loadout;
    local LWCE_TInventory kInventory;

    `LWCE_LOG_CLS("EquipUnit: begin. kUnit = " $ kUnit $ ", eLoadoutType = " $ eLoadoutType);

    if (eLoadoutType != eLoadout_Invalid)
    {
        // TODO: handle loadouts our own way so that modded items can be used (character templates?)
        class'XGLoadoutMgr'.static.GetLoadoutTemplate(eLoadoutType, Loadout);

        kInventory.nmArmor = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(Loadout.Inventory.iArmor);
        kInventory.nmPistol = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(Loadout.Inventory.iPistol);

        if (kInventory.nmPistol == 'Item_AlienPistol')
        {
            switch (eLoadoutType)
            {
                case eLoadout_Sectoid:
                case eLoadout_Sectoid_Commander:
                    kInventory.nmPistol = 'Item_AlienPistol_Sectoid';
                    break;
                case eLoadout_Seeker:
                    kInventory.nmPistol = 'Item_AlienPistol_Seeker';
                    break;
            }
        }

        `LWCE_LOG_CLS("kInventory.nmArmor = " $ kInventory.nmArmor $ ", kInventory.nmPistol = " $ kInventory.nmPistol $ ", arrLargeItems[0] = " $ Loadout.Inventory.arrLargeItems[0]);

        // Map each integer item from the native function into its LWCE name
        for (Index = 0; Index < Loadout.Inventory.iNumLargeItems; Index++)
        {
            ItemName = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(Loadout.Inventory.arrLargeItems[Index]);

            // In LWCE, the basic items refer to the alien artifacts that XCOM recovers from captures. The actual
            // equippable items have their own names per-alien, so we need to map them.
            // TODO: these are all temporary until loadouts are being handled in LWCE directly
            if (ItemName == 'Item_AlienCarbine')
            {
                switch (eLoadoutType)
                {
                    case eLoadout_Floater:
                        ItemName = 'Item_AlienCarbine__Floater';
                        break;
                    case eLoadout_Muton:
                        ItemName = 'Item_AlienCarbine__Muton';
                        break;
                    case eLoadout_ThinMan:
                        ItemName = 'Item_AlienCarbine__ThinMan';
                        break;
                    case eLoadout_Outsider:
                        ItemName = 'Item_AlienCarbine__Outsider';
                        break;
                }
            }
            else if (ItemName == 'Item_AlienHeavyWeapon')
            {
                ItemName = 'Item_AlienHeavyWeapon_MutonElite';
            }
            else if (ItemName == 'Item_AlienRifle')
            {
                switch (eLoadoutType)
                {
                    case eLoadout_Floater_Heavy:
                        ItemName = 'Item_AlienRifle_HeavyFloater';
                        break;
                    case eLoadout_Muton:
                        ItemName = 'Item_AlienRifle_Muton';
                        break;
                }
            }
            else if (ItemName == 'Item_AssaultRifle')
            {
                ItemName = 'Item_AssaultRifle_Exalt';
            }
            else if (ItemName == 'Item_Autolaser')
            {
                ItemName = 'Item_Autolaser_Exalt';
            }
            else if (ItemName == 'Item_LaserRifle')
            {
                ItemName = 'Item_LaserRifle_Exalt';
            }
            else if (ItemName == 'Item_LaserSniperRifle')
            {
                ItemName = 'Item_LaserSniperRifle_Exalt';
            }
            else if (ItemName == 'Item_SAW')
            {
                ItemName = 'Item_SAW_Exalt';
            }
            else if (ItemName == 'Item_SniperRifle')
            {
                ItemName = 'Item_SniperRifle_Exalt';
            }

            class'LWCEInventoryUtils'.static.AddLargeItem(kInventory, ItemName);

            `LWCE_LOG_CLS("Large item " $ Index $ ": " $ ItemName);
        }

        for (Index = 0; Index < Loadout.Inventory.iNumSmallItems; Index++)
        {
            ItemName = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(Loadout.Inventory.arrSmallItems[Index]);

            if (ItemName == 'Item_AlienGrenade')
            {
                switch (eLoadoutType)
                {
                    case eLoadout_Floater_Heavy:
                        ItemName = 'Item_AlienGrenade_HeavyFloater';
                        break;
                    case eLoadout_Muton:
                        ItemName = 'Item_AlienGrenade_Muton';
                        break;
                    case eLoadout_Cyberdisc:
                        ItemName = 'Item_AlienGrenade_Cyberdisc';
                        break;
                }
            }

            class'LWCEInventoryUtils'.static.AddSmallItem(kInventory, ItemName);

            `LWCE_LOG_CLS("Small item " $ Index $ ": " $ ItemName);
        }

        for (Index = 0; Index < Loadout.Inventory.iNumCustomItems; Index++)
        {
            ItemName = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(Loadout.Inventory.arrCustomItems[Index]);
            class'LWCEInventoryUtils'.static.AddCustomItem(kInventory, ItemName);

            `LWCE_LOG_CLS("Custom item " $ Index $ ": " $ ItemName);
        }

        LWCE_XGUnit(kUnit).m_kCEChar.kInventory = kInventory;
    }

    ApplyInventory(kUnit);

    `LWCE_LOG_CLS("EquipUnit: end");
}