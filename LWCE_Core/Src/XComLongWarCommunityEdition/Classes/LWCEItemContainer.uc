class LWCEItemContainer extends Actor
    dependson(LWCETypes);

struct CheckpointRecord
{
    var array<LWCE_TItemQuantity> m_arrEntries;
};

var array<LWCE_TItemQuantity> m_arrEntries;

/// <summary>
/// Adjusts the quantity stored for the given ID by iQuantity. If no entry exists for this ID,
/// one will be created with the quantity equal to iQuantity.
/// </summary>
/// <param name="bDeleteIfAllRemoved">If true, and modifying the entry brings its quantity to 0 or lower, the entry is removed.</param>
function AdjustQuantity(name ItemName, int iQuantity, optional bool bDeleteIfAllRemoved = true)
{
    local int Index;
    local LWCE_TItemQuantity kItemQuantity;

    Index = m_arrEntries.Find('ItemName', ItemName);

    if (Index == INDEX_NONE)
    {
        if (iQuantity > 0)
        {
            kItemQuantity.ItemName = ItemName;
            kItemQuantity.iQuantity = iQuantity;

            Index = m_arrEntries.Length;
            m_arrEntries.AddItem(kItemQuantity);
        }
    }
    else
    {
        m_arrEntries[Index].iQuantity += iQuantity;
    }

    if (Index != INDEX_NONE && m_arrEntries[Index].iQuantity <= 0 && bDeleteIfAllRemoved)
    {
        m_arrEntries.Remove(Index, 1);
    }
}

/// <summary>
/// Deletes all entries, providing an empty container.
/// </summary>
function Clear()
{
    m_arrEntries.Remove(0, m_arrEntries.Length);
}

/// <summary>
/// Transforms this object into a copy of the provided container.
/// </summary>
function CopyFrom(LWCEItemContainer Other)
{
    local int Index;

    m_arrEntries.Add(Other.m_arrEntries.Length);
    Clear();

    for (Index = 0; Index < Other.m_arrEntries.Length; Index++)
    {
        m_arrEntries[Index] = Other.m_arrEntries[Index];
    }
}

/// <summary>
/// Deletes the entry with the given ID, if one exists.
/// </summary>
function Delete(name ItemName)
{
    local int Index;

    Index = m_arrEntries.Find('ItemName', ItemName);

    if (Index != INDEX_NONE)
    {
        m_arrEntries.Remove(Index, 1);
    }
}

/// <summary>
/// Returns the entry with the given ID, if one exists; otherwise returns an entry with quantity 0.
/// Bear in mind that the entry will be a copy, and modifications to it are not reflected in this container.
/// </summary>
function LWCE_TItemQuantity Get(name ItemName, optional out int Index)
{
    local LWCE_TItemQuantity kItemQuantity;

    Index = m_arrEntries.Find('ItemName', ItemName);

    if (Index == INDEX_NONE)
    {
        kItemQuantity.ItemName = ItemName;
        kItemQuantity.iQuantity = 0;

        return kItemQuantity;
    }

    return m_arrEntries[Index];
}

/// <summary>
/// Returns whether this container has an entry for the given item, regardless of the associated quantity.
/// </summary>
function bool HasEntry(name ItemName)
{
    return m_arrEntries.Find('ItemName', ItemName) != INDEX_NONE;
}

/// <summary>
/// Returns whether this container has an entry for the given item with a quantity other than zero.
/// </summary>
function bool HasNonzeroEntry(name ItemName)
{
    return Get(ItemName).iQuantity != 0;
}

/// <summary>
/// Sets the quantity for the given item, adding an entry if one does not exist.
/// </summary>
function Set(name ItemName, int iQuantity)
{
    local int Index;
    local LWCE_TItemQuantity kItemQuantity;

    Index = m_arrEntries.Find('ItemName', ItemName);

    if (Index == INDEX_NONE)
    {
        if (iQuantity > 0)
        {
            kItemQuantity.ItemName = ItemName;
            kItemQuantity.iQuantity = iQuantity;

            m_arrEntries.AddItem(kItemQuantity);
        }
    }
    else
    {
        m_arrEntries[Index].iQuantity = iQuantity;
    }
}