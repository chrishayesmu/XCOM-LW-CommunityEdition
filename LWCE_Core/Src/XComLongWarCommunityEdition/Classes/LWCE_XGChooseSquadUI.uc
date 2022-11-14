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
    kLoadout.imgFlag.strPath = class'UIScreen'.static.GetFlagPath(kCESoldier.m_kSoldier.iCountry);
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