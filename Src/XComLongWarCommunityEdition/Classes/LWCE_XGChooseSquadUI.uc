class LWCE_XGChooseSquadUI extends XGChooseSquadUI;

function TSoldierLoadout BuildLoadout(XGStrategySoldier kSoldier, int iDropshipIndex)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local TSoldierLoadout kLoadout;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    kLoadout.txtName.StrValue = kSoldier.GetName(7);
    kLoadout.imgFlag.strPath = class'UIScreen'.static.GetFlagPath(kSoldier.m_kSoldier.iCountry);
    kLoadout.txtNickname.StrValue = kSoldier.GetNickname();
    kLoadout.txtNickname.iState = eUIState_Nickname;
    kLoadout.ClassType = kCESoldier.m_kCEChar.iClassId;
    kLoadout.txtClass.StrValue = kSoldier.GetClassName();

    if (kSoldier.IsAugmented())
    {
        if (kSoldier.m_kChar.kInventory.arrLargeItems[1] != 0)
        {
            kLoadout.item1 = kSoldier.m_kChar.kInventory.arrLargeItems[1];
        }

        if (kSoldier.m_kChar.kInventory.arrLargeItems[2] != 0)
        {
            kLoadout.item2 = kSoldier.m_kChar.kInventory.arrLargeItems[2];
        }

        if (kSoldier.m_kChar.kInventory.arrLargeItems[3] != 0)
        {
            kLoadout.item1 = (kSoldier.m_kChar.kInventory.arrLargeItems[3] << 8) | kLoadout.item1;
        }

        if (kSoldier.m_kChar.kInventory.arrSmallItems[0] != 0)
        {
            kLoadout.item2 = (kSoldier.m_kChar.kInventory.arrSmallItems[0] << 8) | kLoadout.item2;
        }
    }
    else
    {
        if (kSoldier.m_kChar.kInventory.arrSmallItems[0] != 0)
        {
            kLoadout.item1 = kSoldier.m_kChar.kInventory.arrSmallItems[0];
        }

        if (kSoldier.m_kChar.kInventory.arrSmallItems[1] != 0)
        {
            kLoadout.item2 = kSoldier.m_kChar.kInventory.arrSmallItems[1];
        }

        if (kSoldier.m_kChar.kInventory.arrSmallItems[2] != 0)
        {
            kLoadout.item1 = (kSoldier.m_kChar.kInventory.arrSmallItems[2] << 8) | kLoadout.item1;
        }

        if (kSoldier.m_kChar.kInventory.arrSmallItems[3] != 0)
        {
            kLoadout.item2 = (kSoldier.m_kChar.kInventory.arrSmallItems[3] << 8) | kLoadout.item2;
        }
    }

    kLoadout.iDropshipIndex = iDropshipIndex;
    kLoadout.bPromotable = kSoldier.HasAvailablePerksToAssign();
    kLoadout.bIsPsiSoldier = kSoldier.m_kChar.bHasPsiGift;
    kLoadout.bHasGeneMod = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kCESoldier.m_kCEChar);

    if (kLoadout.bPromotable)
    {
        kLoadout.iUIStatus = 3;
    }
    else
    {
        kLoadout.iUIStatus = 0;
    }

    return kLoadout;
}