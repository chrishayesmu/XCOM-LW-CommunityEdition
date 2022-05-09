class LWCE_UIUnitGermanMode_PerkList extends UIUnitGermanMode_PerkList;

simulated function PrepareData(EPerkBuffCategory eBuffCategory, string listTitle, array<int> perkArray, XGUnit kUnit)
{
    local int I;
    local LWCE_TPerk kPerk;
    local LWCE_XComPerkManager kPerksMgr;
    local UIPerkData perkData;

    kPerksMgr = LWCE_XComPerkManager(XComTacticalController(controllerRef).PERKS());
    m_strTitle = listTitle;
    m_arrPerkData.Length = 0;

    for (I = 0; I < perkArray.Length; I++)
    {
        kPerk = kPerksMgr.LWCE_GetPerk(perkArray[I]);

        if (!kPerk.bShowPerk)
        {
            continue;
        }

        perkData.strName = kPerksMgr.GetPerkName(kPerk.iPerkId, eBuffCategory);
        perkData.strDescription = kPerksMgr.GetDynamicPerkDescription(kPerk.iPerkId, LWCE_XGUnit(kUnit), eBuffCategory);
        perkData.strIcon = kPerk.Icon;
        perkData.buffCategory = eBuffCategory;

        m_arrPerkData.AddItem(perkData);
    }

    m_arrPerkData.Sort(SortPerks);
}

protected function int SortPerks(UIPerkData kPerkA, UIPerkData kPerkB)
{
    // Sort by perk name in ascending order
    return kPerkB.strName < kPerkA.strName ? -1 : 0;
}