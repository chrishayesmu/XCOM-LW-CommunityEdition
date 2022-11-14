class LWCEInventoryUtils extends Object
    abstract;

/// <summary>
/// Retrieves all of the items equipped in the given inventory, except for the armor.
/// </summary>
static function array<name> GetAllBackpackItems(const LWCE_TInventory kInventory)
{
    local array<name> arrBackpackItems;
    local int Index;

    for (Index = 0; Index < kInventory.arrLargeItems.Length; Index++)
    {
        arrBackpackItems.AddItem(kInventory.arrLargeItems[Index]);
    }

    for (Index = 0; Index < kInventory.arrSmallItems.Length; Index++)
    {
        arrBackpackItems.AddItem(kInventory.arrSmallItems[Index]);
    }

    if (kInventory.nmPistol != '')
    {
        arrBackpackItems.AddItem(kInventory.nmPistol);
    }

    return arrBackpackItems;
}

/// <summary>
/// Checks if the given inventory contains a specified item in any of its slots.
/// </summary>
static function bool HasItemOfName(const LWCE_TInventory kInventory, name ItemName)
{
    local int Index;

    if (kInventory.nmPistol == ItemName || kInventory.nmArmor == ItemName)
    {
        return true;
    }

    for (Index = 0; Index < kInventory.arrLargeItems.Length; Index++)
    {
        if (kInventory.arrLargeItems[Index] == ItemName)
        {
            return true;
        }
    }

    for (Index = 0; Index < kInventory.arrSmallItems.Length; Index++)
    {
        if (kInventory.arrSmallItems[Index] == ItemName)
        {
            return true;
        }
    }

    for (Index = 0; Index < kInventory.arrCustomItems.Length; Index++)
    {
        if (kInventory.arrCustomItems[Index] == ItemName)
        {
            return true;
        }
    }

    return false;
}

/// <summary>
/// Adds a space in the inventory for a custom item, and puts the given item in that space.
/// </summary>
static function AddCustomItem(out LWCE_TInventory kInventory, name ItemName)
{
    kInventory.arrCustomItems.AddItem(ItemName);
}

/// <summary>
/// Adds a space in the inventory for a large item, and puts the given item in that space.
/// </summary>
static function AddLargeItem(out LWCE_TInventory kInventory, name ItemName)
{
    kInventory.arrLargeItems.AddItem(ItemName);
}

/// <summary>
/// Adds a space in the inventory for a small item, and puts the given item in that space.
/// </summary>
static function AddSmallItem(out LWCE_TInventory kInventory, name ItemName)
{
    kInventory.arrSmallItems.AddItem(ItemName);
}

/// <summary>
/// Adds the specified number of custom slots to the inventory. The slots will be empty.
/// </summary>
static function AddCustomItemSlots(out LWCE_TInventory kInventory, int iCount)
{
    kInventory.arrCustomItems.Add(iCount);
}

/// <summary>
/// Adds the specified number of large slots to the inventory. The slots will be empty.
/// </summary>
static function AddLargeItemSlots(out LWCE_TInventory kInventory, int iCount)
{
    kInventory.arrLargeItems.Add(iCount);
}

/// <summary>
/// Adds the specified number of small slots to the inventory. The slots will be empty.
/// </summary>
static function AddSmallItemSlots(out LWCE_TInventory kInventory, int iCount)
{
    kInventory.arrSmallItems.Add(iCount);
}

/// <summary>
/// Removes all custom item slots from the inventory.
/// </summary>
static function ClearCustomItems(out LWCE_TInventory kInventory)
{
    kInventory.arrCustomItems.Remove(0, kInventory.arrCustomItems.Length);
}

/// <summary>
/// Removes all large item slots from the inventory.
/// </summary>
static function ClearLargeItems(out LWCE_TInventory kInventory)
{
    kInventory.arrLargeItems.Remove(0, kInventory.arrLargeItems.Length);
}

/// <summary>
/// Removes all small item slots from the inventory.
/// </summary>
static function ClearSmallItems(out LWCE_TInventory kInventory)
{
    kInventory.arrSmallItems.Remove(0, kInventory.arrSmallItems.Length);
}

/// <summary>
/// Removes all instances of the given item name from the inventory's custom items.
/// </summary>
static function RemoveCustomItem(out LWCE_TInventory kInventory, name ItemName)
{
    local int Index;

    Index = kInventory.arrCustomItems.Find(ItemName);

    while (Index != INDEX_NONE)
    {
        kInventory.arrCustomItems.Remove(Index, 1);
        Index = kInventory.arrCustomItems.Find(ItemName);
    }
}

/// <summary>
/// Removes iCount custom item slots from the inventory, starting from the slot at Index.
/// </summary>
static function RemoveCustomItemSlots(out LWCE_TInventory kInventory, int Index, int iCount)
{
    kInventory.arrCustomItems.Remove(Index, iCount);
}

/// <summary>
/// Removes iCount large item slots from the inventory, starting from the slot at Index.
/// </summary>
static function RemoveLargeItemSlots(out LWCE_TInventory kInventory, int Index, int iCount)
{
    kInventory.arrLargeItems.Remove(Index, iCount);
}

/// <summary>
/// Removes iCount small item slots from the inventory, starting from the slot at Index.
/// </summary>
static function RemoveSmallItemSlots(out LWCE_TInventory kInventory, int Index, int iCount)
{
    kInventory.arrSmallItems.Remove(Index, iCount);
}

/// <summary>
/// Sets the custom item at iSlot to be ItemName. If the inventory doesn't have enough custom
/// item slots, it will be expanded to fit the requested slot index.
/// </summary>
static function SetCustomItem(out LWCE_TInventory kInventory, int iSlot, name ItemName)
{
    if (iSlot >= kInventory.arrCustomItems.Length)
    {
        kInventory.arrCustomItems.Add(iSlot - kInventory.arrCustomItems.Length + 1);
    }

    kInventory.arrCustomItems[iSlot] = ItemName;
}

/// <summary>
/// Sets the large item at iSlot to be ItemName. If the inventory doesn't have enough large
/// item slots, it will be expanded to fit the requested slot index.
/// </summary>
static function SetLargeItem(out LWCE_TInventory kInventory, int iSlot, name ItemName)
{
    if (iSlot >= kInventory.arrLargeItems.Length)
    {
        kInventory.arrLargeItems.Add(iSlot - kInventory.arrLargeItems.Length + 1);
    }

    kInventory.arrLargeItems[iSlot] = ItemName;
}

/// <summary>
/// Sets the small item at iSlot to be ItemName. If the inventory doesn't have enough small
/// item slots, it will be expanded to fit the requested slot index.
/// </summary>
static function SetSmallItem(out LWCE_TInventory kInventory, int iSlot, name ItemName)
{
    if (iSlot >= kInventory.arrSmallItems.Length)
    {
        kInventory.arrSmallItems.Add(iSlot - kInventory.arrSmallItems.Length + 1);
    }

    kInventory.arrSmallItems[iSlot] = ItemName;
}