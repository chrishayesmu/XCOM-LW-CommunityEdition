class HighlanderItemContainer extends Actor
    dependson(HighlanderTypes);

struct CheckpointRecord
{
    var array<HL_TItemQuantity> m_arrEntries;
};

var array<HL_TItemQuantity> m_arrEntries;

/// <summary>
/// Adjusts the quantity stored for the given ID by iQuantity. If no entry exists for this ID,
/// one will be created with the quantity equal to iQuantity.
/// </summary>
/// <param name="bDeleteIfAllRemoved">If true, and modifying the entry brings its quantity to 0 or lower, the entry is removed.</param>
function AdjustQuantity(int Id, int iQuantity, optional bool bDeleteIfAllRemoved = true)
{
    local int Index;
    local HL_TItemQuantity kItemQuantity;

    `HL_LOG_CLS("Adjusting Id " $ Id $ " by " $ iQuantity);

    Index = m_arrEntries.Find('iItemId', Id);

    if (Index == INDEX_NONE)
    {
        if (iQuantity > 0)
        {
            kItemQuantity.iItemId = Id;
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
    `HL_LOG_CLS("Clearing container");
    m_arrEntries.Remove(0, m_arrEntries.Length);
}

/// <summary>
/// Transforms this object into a copy of the provided container.
/// </summary>
function CopyFrom(HighlanderItemContainer Other)
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
function Delete(int Id)
{
    local int Index;

    `HL_LOG_CLS("Deleting Id " $ Id);
    Index = m_arrEntries.Find('iItemId', Id);

    if (Index != INDEX_NONE)
    {
        m_arrEntries.Remove(Index, 1);
    }
}

/// <summary>
/// Returns the entry with the given ID, if one exists; otherwise returns an entry with quantity 0.
/// Bear in mind that the entry will be a copy, and modifications to it are not reflected in this container.
/// </summary>
function HL_TItemQuantity Get(int Id, optional out int Index)
{
    local HL_TItemQuantity kItemQuantity;

    Index = m_arrEntries.Find('iItemId', Id);

    if (Index == INDEX_NONE)
    {
        kItemQuantity.iItemId = Id;
        kItemQuantity.iQuantity = 0;

        return kItemQuantity;
    }

    return m_arrEntries[Index];
}

/// <summary>
/// Returns whether this container has an entry for the given ID, regardless of the associated quantity.
/// </summary>
function bool HasEntry(int Id)
{
    return m_arrEntries.Find('iItemId', Id) != INDEX_NONE;
}

/// <summary>
/// Returns whether this container has an entry for the given ID with a quantity other than zero.
/// </summary>
function bool HasNonzeroEntry(int Id)
{
    return Get(Id).iQuantity != 0;
}

/// <summary>
/// Sets the quantity for the entry with the given ID, adding an entry if one does not exist.
/// </summary>
function Set(int Id, int iQuantity)
{
    local int Index;
    local HL_TItemQuantity kItemQuantity;

    `HL_LOG_CLS("Setting Id " $ Id $ " to " $ iQuantity);
    Index = m_arrEntries.Find('iItemId', Id);

    if (Index == INDEX_NONE)
    {
        if (iQuantity > 0)
        {
            kItemQuantity.iItemId = Id;
            kItemQuantity.iQuantity = iQuantity;

            m_arrEntries.AddItem(kItemQuantity);
        }
    }
    else
    {
        m_arrEntries[Index].iQuantity = iQuantity;
    }
}