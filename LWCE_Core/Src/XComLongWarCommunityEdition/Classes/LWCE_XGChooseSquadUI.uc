class LWCE_XGChooseSquadUI extends XGChooseSquadUI;

struct LWCE_TSoldierLoadout
{
    var TText txtName;
    var TText txtNickname;
    var TText txtClass;
    var int ClassType;
    var array<name> arrLargeItems;
    var array<name> arrSmallItems;
    var TImage imgFlag;
    var int iUIStatus;
    var int iDropshipIndex;
    var bool bPromotable;
    var bool bIsPsiSoldier;
    var bool bHasGeneMod;
};

var array<LWCE_TSoldierLoadout> m_arrCESoldiers;

function bool AreAnyChosenMecsWearingCivvies()
{
    local XGStrategySoldier kSoldier;

    foreach HANGAR().m_kSkyranger.m_arrSoldiers(kSoldier)
    {
        if (LWCE_XGStrategySoldier(kSoldier).m_kCEChar.kInventory.nmArmor == 'Item_BaseAugments')
        {
            return true;
        }
    }

    return false;
}

function TSoldierLoadout BuildLoadout(XGStrategySoldier kSoldier, int iDropshipIndex)
{
    local TSoldierLoadout kLoadout;

    `LWCE_LOG_DEPRECATED_CLS(BuildLoadout);

    return kLoadout;
}

function LWCE_TSoldierLoadout LWCE_BuildLoadout(XGStrategySoldier kSoldier, int iDropshipIndex)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_TSoldierLoadout kLoadout;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    kLoadout.txtName.StrValue = kCESoldier.GetName(7);
    kLoadout.imgFlag.strPath = class'UIScreen'.static.GetFlagPath(kCESoldier.m_kCESoldier.iCountry);
    kLoadout.txtNickname.StrValue = kCESoldier.GetNickname();
    kLoadout.txtNickname.iState = eUIState_Nickname;
    kLoadout.ClassType = kCESoldier.m_kCEChar.iClassId;
    kLoadout.txtClass.StrValue = kCESoldier.GetClassName();

    kLoadout.arrLargeItems = kCESoldier.m_kCEChar.kInventory.arrLargeItems;
    kLoadout.arrSmallItems = kCESoldier.m_kCEChar.kInventory.arrSmallItems;

    kLoadout.iDropshipIndex = iDropshipIndex;
    kLoadout.bPromotable = kCESoldier.HasAvailablePerksToAssign();
    kLoadout.bIsPsiSoldier = kCESoldier.m_kCEChar.bHasPsiGift;
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

function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local TTableMenuOption kOption;
    local int iCategory;
    local string strCategory;
    local int iState;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    switch (kCESoldier.GetStatus())
    {
        case eStatus_OnMission:
            kOption.iState = eUIState_Highlight;
            break;
        case eStatus_Active:
        case 8: // fatigued
            kOption.iState = eUIState_Good;
            break;
        default:
            kOption.iState = eUIState_Bad;
    }

    for (iCategory = 0; iCategory < arrCategories.Length; iCategory++)
    {
        iState = 0;
        strCategory = "";

        switch (arrCategories[iCategory])
        {
            case 0:
                strCategory = string(kCESoldier.m_kCESoldier.iCountry);
                break;
            case 1:
                strCategory = string(kCESoldier.GetRank());
                break;
            case 2:
                strCategory = string(kCESoldier.GetEnergy());
                break;
            case 3:
                strCategory = kCESoldier.GetClassName();
                break;
            case 4:
                strCategory = kCESoldier.GetName(8);
                break;
            case 5:
                strCategory = kCESoldier.GetName(eNameType_Last);
                break;
            case 6:
                strCategory = kCESoldier.GetName(eNameType_Nick);
                break;
            case 7:
                strCategory = kCESoldier.GetStatusString();
                iState = kCESoldier.GetStatusUIState();
                break;
            case 8:
                if (kCESoldier.HasAvailablePerksToAssign())
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 10:
                if (kCESoldier.m_kChar.bHasPsiGift)
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 11:
                if (class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kCESoldier.m_kCEChar))
                {
                    iState = eUIState_Disabled;
                }
                else
                {
                    iState = eUIState_Normal;
                }

                break;
            case 13:
                iState = kCESoldier.GetSHIVRank();
                break;
            case 12:
                strCategory = class'UIUtilities'.static.GetMedalLabels(kCESoldier.m_arrMedals);
                break;
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

function bool OnUnloadSoldier(int iSoldier, int SlotIdx)
{
    local XGShip_Dropship kSkyranger;

    kSkyranger = m_kMission.GetAssignedSkyranger();

    if (iSoldier >= 0 && iSoldier < kSkyranger.m_arrSoldiers.Length)
    {
        if (LWCE_XGStrategySoldier(kSkyranger.m_arrSoldiers[iSoldier]).m_kCESoldier.iPsiRank == 7)
        {
            PlayBadSound();
            return false;
        }

        if (!BARRACKS().UnloadSoldierFromSlot(kSkyranger.m_arrSoldiers[iSoldier], SlotIdx, kSkyranger))
        {
            PlayBadSound();
            return false;
        }

        UpdateView();
        return true;
    }

    return false;
}

function UpdateSquad()
{
    local int iSoldier;
    local array<LWCE_TSoldierLoadout> arrLoadouts;
    local LWCE_XGShip_Dropship kSkyranger;

    kSkyranger = LWCE_XGShip_Dropship(m_kMission.GetAssignedSkyranger());
    PRES().UILoadAnimation(true);
    PRES().SubscribeToUIUpdate(CheckSoldiersLoaded);

    for (iSoldier = 0; iSoldier < kSkyranger.m_arrSoldiers.Length; iSoldier++)
    {
        if (kSkyranger.m_arrSoldiers[iSoldier] != none)
        {
            arrLoadouts.AddItem(LWCE_BuildLoadout(kSkyranger.m_arrSoldiers[iSoldier], iSoldier));
        }
    }

    m_arrCESoldiers = arrLoadouts;

    if (m_arrCESoldiers.Length == 0)
    {
        m_iHighlightedSoldier = -1;
    }
    else if (m_iHighlightedSoldier >= m_arrCESoldiers.Length || m_iHighlightedSoldier < 0)
    {
        m_iHighlightedSoldier = 0;
    }
}