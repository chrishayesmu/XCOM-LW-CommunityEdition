class Highlander_XGAbilityTree extends XGAbilityTree;

simulated function bool HasAutopsyTechForChar(int iCharType)
{
    local Highlander_XGDropshipCargoInfo kCargo;
    local HL_TTech kTech;

    // Hard-coded character types that don't need to be autopsied
    if (iCharType == eChar_Zombie ||
        iCharType == eChar_Outsider ||
        iCharType == eChar_ExaltOperative ||
        iCharType == eChar_ExaltSniper ||
        iCharType == eChar_ExaltHeavy ||
        iCharType == eChar_ExaltMedic ||
        iCharType == eChar_ExaltEliteOperative ||
        iCharType == eChar_ExaltEliteSniper ||
        iCharType == eChar_ExaltEliteHeavy ||
        iCharType == eChar_ExaltEliteMedic)
    {
        return true;
    }

    kCargo = Highlander_XGDropshipCargoInfo(`BATTLE.m_kDesc.m_kDropShipCargoInfo);

    if (kCargo == none)
    {
        `HL_LOG_CLS("ERROR: could not find Highlander_XGDropshipCargoInfo in the current battle! Falling back on native HasAutopsyTechForChar.");
        return super.HasAutopsyTechForChar(iCharType);
    }

    foreach kCargo.m_arrHLTechHistory(kTech)
    {
        if (kTech.bIsAutopsy && kTech.iSubjectCharacterId == iCharType)
        {
            return true;
        }
    }

    return false;
}