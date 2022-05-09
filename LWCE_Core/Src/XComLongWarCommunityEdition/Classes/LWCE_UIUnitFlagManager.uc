class LWCE_UIUnitFlagManager extends UIUnitFlagManager;

simulated function AddFlag(XGUnit kUnit)
{
    local UIUnitFlag kFlag;
    local ASValue myValue;
    local array<ASValue> myArray;
    local int I;

    for (I = 0; I < m_arrFlags.Length; I++)
    {
        if (m_arrFlags[I].m_kUnit == kUnit)
        {
            return;
        }
    }

    if (kUnit.Role == ROLE_Authority)
    {
        ++ kUnit.m_iAddUnitFlag;
        kUnit.bNetDirty = true;
    }

    kFlag = Spawn(class'LWCE_UIUnitFlag', self);
    kFlag.Init(controllerRef, manager, self, kUnit);
    m_arrFlags.AddItem(kFlag);

    myValue.Type = AS_String;
    myValue.S = string(kFlag.s_name);
    myArray.AddItem(myValue);

    myValue.Type = AS_Boolean;
    myValue.B = kFlag.m_bIsFriendly;
    myArray.AddItem(myValue);

    Invoke("AddFlag", myArray);
}

simulated function LWCE_UIUnitFlag GetFlagForUnit(XGUnit kUnit)
{
    local UIUnitFlag kFlag;

    foreach m_arrFlags(kFlag)
    {
        if (kFlag.m_kUnit == kUnit)
        {
            return LWCE_UIUnitFlag(kFlag);
        }
    }

    return none;
}