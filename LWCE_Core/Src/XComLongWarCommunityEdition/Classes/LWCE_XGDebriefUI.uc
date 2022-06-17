class LWCE_XGDebriefUI extends XGDebriefUI;

struct LWCE_TSoldierDebriefItem
{
    var TImage imgSoldier;
    var TImage imgFlag;
    var TText txtName;
    var TText txtStatus;
    var TLabeledText txtMissions;
    var TLabeledText txtKills;
    var EUIState eState;
    var TSoldierPromotionItem kPromotion;
    var int iSoldierClassId;
    var int iSoldierRank;
    var bool m_bWasPromoted;
    var bool m_bPsiPromoted;
    var bool m_bIsPsiSoldier;
    var bool m_bHasGeneMod;
    var bool m_isDead;
    var bool m_bHasPerksToAssign;
    var bool m_bIsTank;
};

struct LWCE_TCovertOpDebrief
{
    var TText txtTitle;
    var TText txtSubTitle;
    var TText txtFeedback;
    var TText txtClueTitle;
    var TText txtClueBody;
    var LWCE_TSoldierDebriefItem covertSoldier;
    var bool bSuccessful;
};

struct LWCE_TSoldierDebrief
{
    var TText txtOpName;
    var TText txtTitle;
    var TButtonText txtHireOption;
    var array<LWCE_TSoldierDebriefItem> arrItems;
    var bool bHireHighlighted;
    var int iHighlighted;
};

var LWCE_TCovertOpDebrief m_kCECovertOpDebrief;
var LWCE_TSoldierDebrief m_kCESoldierDebrief;

function Init(int iView)
{
    m_kSkyranger = HANGAR().m_kSkyranger;
    m_bFirstTime = m_kSkyranger.m_bReturnedFromFirstMission;

    if (m_kSkyranger.m_bExtendSquadForHQAssault)
    {
        m_kSkyranger.m_bExtendSquadForHQAssault = false;
        m_kSkyranger.m_bReinforcementsForHQAssault = false;

        if (STAT_GetStat(22) == 1)
        {
            PRES().PlayCinematic(eCinematic_HQAssault_Win);
        }
    }
    else
    {
        PRES().PlayCinematic(eCinematic_DropshipLand);
    }

    PRES().CAMLookAtNamedLocation("Cargo");

    m_kCESoldierDebrief.iHighlighted = BARRACKS().m_aLastMissionSoldiers.Length + 1;
    m_kScienceDebrief.iHighlighted = 1;

    BuildSoldierUI();
    GoToView(eDebriefView_Soldiers);
    PlayOpenSound();
}

function TSoldierDebriefItem BuildSoldierOption(XGStrategySoldier kSoldier)
{
    local TSoldierDebriefItem kBlank;

    `LWCE_LOG_DEPRECATED_CLS(BuildSoldierOption);

    return kBlank;
}

function LWCE_TSoldierDebriefItem LWCE_BuildSoldierOption(XGStrategySoldier kSoldier)
{
    local LWCE_TSoldierDebriefItem kItem;

    kItem.txtName.StrValue = kSoldier.GetName(eNameType_FullNick);
    kItem.txtName.iState = eUIState_Warning;

    if (kSoldier.m_kSoldier.kAppearance.iGender == eGender_Female)
    {
        kItem.imgSoldier.iImage = eImage_MugshotFemale;
    }
    else
    {
        kItem.imgSoldier.iImage = eImage_MugshotMale;
    }

    kItem.imgFlag.strPath = class'UIScreen'.static.GetFlagPath(kSoldier.GetCountry());
    kItem.m_bIsTank = kSoldier.IsATank();
    kItem.iSoldierClassId = LWCE_XGStrategySoldier(kSoldier).LWCE_GetClass();

    kItem.txtStatus.StrValue = kSoldier.GetStatusString();
    kItem.txtStatus.iState = kSoldier.GetStatusUIState();

    kItem.txtMissions.strLabel = m_strLabelMissions;
    kItem.txtMissions.StrValue = string(kSoldier.GetNumMissions());
    kItem.txtMissions.iState = eUIState_Bad;

    kItem.txtKills.strLabel = m_strLabelKills;
    kItem.txtKills.StrValue = string(kSoldier.GetNumKills());
    kItem.txtKills.iState = eUIState_Bad;

    if (kSoldier.IsDead())
    {
        kItem.eState = eUIState_Disabled;

        if (kItem.m_bIsTank)
        {
            kItem.iSoldierRank = kSoldier.GetSHIVRank();
        }
        else
        {
            kItem.iSoldierRank = kSoldier.GetRank();
        }

        kItem.m_isDead = true;
    }
    else if (kSoldier.IsReadyToLevelUp() || (kSoldier.HasPsiGift() && kSoldier.IsReadyToPsiLevelUp()) )
    {
        LWCE_BuildSoldierPromotion(kSoldier, kItem.kPromotion, kItem);
        kItem.eState = eUIState_Good;
        BARRACKS().ReorderRanks();
        kItem.iSoldierClassId = 0; // TODO: this might be fake from a decompilation error
    }
    else
    {
        kItem.m_bHasGeneMod = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(LWCE_XGStrategySoldier(kSoldier).m_kCEChar);
        kItem.m_bIsPsiSoldier = kSoldier.m_kChar.bHasPsiGift;

        if (kItem.m_bIsTank)
        {
            kItem.iSoldierRank = kSoldier.GetSHIVRank();
        }
        else
        {
            kItem.iSoldierRank = kSoldier.GetRank();
        }
    }

    return kItem;
}

function BuildSoldierPromotion(XGStrategySoldier kSoldier, out TSoldierPromotionItem kPromotionUI, out TSoldierDebriefItem kItem)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildSoldierPromotion);
}

function LWCE_BuildSoldierPromotion(XGStrategySoldier kSoldier, out TSoldierPromotionItem kPromotionUI, out LWCE_TSoldierDebriefItem kItem)
{
    local string strNickName;
    local bool classAssigned, gotNickname;
    local XGParamTag kTag;
    local LWCE_XGStrategySoldier kCESoldier;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    kTag = new class'XGParamTag';
    kItem.m_bHasPerksToAssign = false;
    kItem.m_bIsPsiSoldier = kSoldier.m_kChar.bHasPsiGift;
    kItem.m_bHasGeneMod = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kCESoldier.m_kCEChar);

    if (kCESoldier.IsReadyToLevelUp())
    {
        strNickName = kCESoldier.GetName(eNameType_Nick);

        if (kCESoldier.GetRank() == 0)
        {
            classAssigned = true;
        }

        if (ISCONTROLLED() && BARRACKS().m_iHighestRank == 0)
        {
            kCESoldier.LWCE_LevelUp(eSC_HeavyWeapons);
        }
        else
        {
            kCESoldier.LWCE_LevelUp();
        }

        gotNickname = kCESoldier.GetName(eNameType_Nick) != strNickName;

        if (gotNickname)
        {
            kTag.StrValue0 = kCESoldier.GetName(eNameType_Nick);
            kPromotionUI.txtNickname.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strEarnedNickName, kTag);
            kPromotionUI.txtNickname.iState = eUIState_Nickname;
        }

        if (classAssigned)
        {
            kTag.StrValue0 = kCESoldier.GetClassName();
            kPromotionUI.txtClassPromotion.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strClassAssigned, kTag);
        }

        kItem.m_bWasPromoted = true;
        kItem.m_bHasPerksToAssign = true;
    }
    else
    {
        kItem.m_bWasPromoted = false;
    }

    LWCE_UpdateSoldierUIData(kCESoldier, kPromotionUI, kItem);
}

function BuildSoldierUI()
{
    local int iSoldier, iNumSoldierOptions;
    local XGFacility_Barracks kBarracks;

    kBarracks = BARRACKS();
    iNumSoldierOptions = kBarracks.m_aLastMissionSoldiers.Length;

    for (iSoldier = 0; iSoldier < iNumSoldierOptions; iSoldier++)
    {
        m_kCESoldierDebrief.arrItems.AddItem(LWCE_BuildSoldierOption(kBarracks.m_aLastMissionSoldiers[iSoldier]));
    }

    if (ITEMTREE().CanFacilityBeBuilt(eFacility_OTS))
    {
        UnlockFacility(eFacility_OTS);
    }

    RefreshSoldierUIPerks();
}

function bool CheckForMatinee()
{
    local LWCE_XGHeadquarters kHQ;

    kHQ = `LWCE_HQ;

    if (m_bPlayedMatinee)
    {
        return false;
    }

    if (m_bFirstTime)
    {
        PRES().UINarrative(`XComNarrativeMoment("TP_SurvivorReturns_02"),, PostFirstTimeMatinee);
        m_bPlayedMatinee = true;
        return true;
    }
    else if (kHQ.m_kCELastCargoArtifacts.HasNonzeroEntry(`LW_ITEM_ID(OutsiderShard)))
    {
        PRES().UINarrative(`XComNarrativeMoment("AlienCode"),, PostShardMatinee);
        STAT_SetStat(eRecap_ObjCollectShards, Game().GetDays());
        m_bPlayedMatinee = true;
        return true;
    }
    else if (kHQ.m_kCELastCargoArtifacts.HasNonzeroEntry(`LW_ITEM_ID(HyperwaveBeacon)) && STAT_GetStat(eRecap_ObjAssaultBase) == 0)
    {
        PRES().UINarrative(`XComNarrativeMoment("HyperWaveRetrieved"),, PostHyperwaveMatinee);
        STAT_SetStat(eRecap_ObjAssaultBase, STAT_GetStat(eRecap_Days));
        m_bPlayedMatinee = true;
        return true;
    }
    else if (kHQ.m_kCELastCargoArtifacts.HasNonzeroEntry(`LW_ITEM_ID(EtherealDevice)))
    {
        PRES().UINarrative(`XComNarrativeMoment("PsiLinkRecovered"),, PostPsiLinkMatinee);
        STAT_SetStat(eRecap_ObjRecoverPsiLink, Game().GetDays());
        m_bPlayedMatinee = true;
        return true;
    }

    return false;
}

/// <summary>
/// In base Enemy Within, this function would check for newly-awardable medals earned during the mission.
/// In Long War, it has been rewritten to show a list of items that were lost or damaged instead. In LWCE,
/// that functionality is in UpdateEngineeringDebrief, and this function is deprecated.
/// </summary>
function CheckForMedals()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(CheckForMedals);
}

function int GetUnlockItem(out TTech kTech)
{
    `LWCE_LOG_DEPRECATED_CLS(GetUnlockItem);
    return 0;
}

function int LWCE_GetUnlockItem(out LWCE_TTech kTech)
{
    local int I, iItemId;
    local LWCE_XGHeadquarters kHQ;

    kHQ = `LWCE_HQ;

    for (I = 0; I < kTech.kPrereqs.arrItemReqs.Length; I++)
    {
        iItemId = kTech.kPrereqs.arrItemReqs[I];

        if (kHQ.m_kCELastCargoArtifacts.HasNonzeroEntry(iItemId))
        {
            return kTech.kPrereqs.arrItemReqs[I];
        }
    }

    if (kTech.kCost.arrItems.Length > 0)
    {
        for (I = 0; I < kTech.kCost.arrItems.Length; I++)
        {
            iItemId = kTech.kCost.arrItems[I].iItemId;

            if (kHQ.m_kCELastCargoArtifacts.HasNonzeroEntry(iItemId))
            {
                return iItemId;
            }
        }
    }
    else if (kTech.iTechId == `LW_TECH_ID(AdvancedBodyArmor))
    {
        return kTech.iTechId;
    }
    else if (kTech.iTechId == `LW_TECH_ID(Xenobiology))
    {
        return eItem_SectoidCorpse;
    }
    else if (LABS().IsInterrogationTech(kTech.iTechId))
    {
        // TODO: not sure how correct this is, since nothing ever seems to clear out this array
        return kHQ.m_arrCELastCaptives[0];
    }

    return 0;
}

function bool IsAdvanceHighlighted()
{
    switch (m_iCurrentView)
    {
        case eDebriefView_Soldiers:
            return m_kCESoldierDebrief.iHighlighted == (BARRACKS().m_aLastMissionSoldiers.Length + 1);
        case eDebriefView_Science:
            return m_kScienceDebrief.iHighlighted == 1;
        default:
            return true;
    }
}

function OnExit()
{
    local TMissionReward kEmptyReward;

    `LWCE_LABS.m_arrCEMissionResults.Remove(0, `LWCE_LABS.m_arrCEMissionResults.Length);
    HQ().m_kLastReward = kEmptyReward;

    Sound().PlayMusic(Game().GetActMusic());
    PRES().PopState();
    PlayCloseSound();

    XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).DoRemoteEvent('SituationRoom_FundingCouncil_Off');
    class'SeqEvent_HQUnits'.static.PlayRoomSequence("Barracks");

    if (ISCONTROLLED())
    {
        if (!SETUPMGR().IsInState('Base4_MissionControl'))
        {
            XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetAutosaveMgr().DoAutosave(Game().m_bIronMan);
        }
    }
    else
    {
        XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetAutosaveMgr().DoAutosave(Game().m_bIronMan);
    }

    if (IsViewValid(eDebriefView_Council))
    {
        Narrative(`XComNarrativeMoment("FCRClosed"));
    }

    if (EXALT().m_bCellClearedPostCombat)
    {
        if (EXALT().m_bFirstCellClearedPostCombat)
        {
            Narrative(`XComNarrativeMomentEW("FirstCellRemoved"));
            EXALT().m_bFirstCellClearedPostCombat = false;
        }
        else
        {
            Narrative(`XComNarrativeMomentEW("Robo_NewClue"));
        }
    }

    if (HQ().m_kLastResult.bSuccess && HQ().m_kLastResult.eType == eMission_ExaltRaid)
    {
        Narrative(`XComNarrativeMomentEW("EXALTHQ_Success"));
    }

    BARRACKS().m_aLastMissionSoldiers.Remove(0, BARRACKS().m_aLastMissionSoldiers.Length);

    if (World().m_kFundingCouncil.m_bPlayAnnetteMusing)
    {
        switch (World().m_kFundingCouncil.m_iNextAnnetteMusing)
        {
            case 1:
                Narrative(`XComNarrativeMomentEW("AnnetteStoryMusingI"));
                break;
            case 2:
                Narrative(`XComNarrativeMomentEW("AnnetteStoryMusingII"));
                break;
            case 3:
                Narrative(`XComNarrativeMomentEW("AnnetteStoryMusingIV"));
                break;
        }
    }

    PRES().m_kStrategyHUD.m_kMenu.Show();
}

function OnPromoteCovertOperative()
{
    local XGStrategySoldier kCovertOp;

    kCovertOp = BARRACKS().m_kLastMissionCovertOperative;

    if (m_kCECovertOpDebrief.covertSoldier.m_bWasPromoted)
    {
        PRES().UISoldier(kCovertOp, eSoldierView_Promotion, true, true);
        PlayOpenSound();
    }
    else if (m_kCECovertOpDebrief.covertSoldier.m_bPsiPromoted)
    {
        PRES().UISoldier(kCovertOp, eSoldierView_PsiPromotion, true, true);
        PlayOpenSound();
    }
}

function OnScrollUp()
{
    local array<int> arrOptions;
    local int iHighlight;

    if (m_iCurrentView == eDebriefView_Soldiers)
    {
        arrOptions = GetSoldierOptions();
        iHighlight = arrOptions.Find(m_kCESoldierDebrief.iHighlighted);

        if (iHighlight != -1)
        {
            m_kCESoldierDebrief.iHighlighted = arrOptions[((iHighlight - 1) + arrOptions.Length) % arrOptions.Length];
        }
        else
        {
            m_kCESoldierDebrief.iHighlighted = arrOptions[0];
        }
    }

    UpdateView();
}

function OnScrollDown()
{
    local array<int> arrOptions;
    local int iHighlight;

    if (m_iCurrentView == eDebriefView_Soldiers)
    {
        arrOptions = GetSoldierOptions();
        iHighlight = arrOptions.Find(m_kCESoldierDebrief.iHighlighted);

        if (iHighlight != -1)
        {
            m_kCESoldierDebrief.iHighlighted = arrOptions[(iHighlight + 1) % arrOptions.Length];
        }
        else
        {
            m_kCESoldierDebrief.iHighlighted = arrOptions[0];
        }
    }

    UpdateView();
}

function RefreshSoldierUIPerks()
{
    local int Index;
    local XGFacility_Barracks kBarracks;
    local XGStrategySoldier kSoldier;
    local LWCE_TSoldierDebriefItem kItem;

    kBarracks = BARRACKS();

    for (Index = 0; Index < kBarracks.m_aLastMissionSoldiers.Length; Index++)
    {
        kSoldier = kBarracks.m_aLastMissionSoldiers[Index];
        kItem = m_kCESoldierDebrief.arrItems[Index];
        LWCE_UpdateSoldierUIData(kSoldier, kItem.kPromotion, kItem);
        m_kCESoldierDebrief.arrItems[Index] = kItem;
    }
}

function UpdateCovertOpDebrief()
{
    local XGParamTag kTag;

    kTag = new class'XGParamTag';
    m_kCECovertOpDebrief.txtTitle.StrValue = m_strCovertOpTitle;
    m_kCECovertOpDebrief.txtTitle.iState = eUIState_Normal;
    m_kCECovertOpDebrief.covertSoldier = LWCE_BuildSoldierOption(BARRACKS().m_kLastMissionCovertOperative);

    if (HQ().m_kLastResult.bSuccess)
    {
        m_kCECovertOpDebrief.txtSubTitle.StrValue = m_strCovertOpSubTitleSuccess;
        m_kCECovertOpDebrief.txtSubTitle.iState = eUIState_Good;

        m_kCECovertOpDebrief.txtClueTitle.StrValue = m_strCovertOpClueTitle;
        m_kCECovertOpDebrief.txtClueTitle.iState = eUIState_Good;

        m_kCECovertOpDebrief.txtClueBody.StrValue = EXALT().GetCurrentClueDescription();
        m_kCECovertOpDebrief.txtClueBody.iState = eUIState_Good;

        kTag.StrValue0 = ConvertCashToString(HQ().m_kLastReward.iCredits);
        m_kCECovertOpDebrief.txtFeedback.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strCovertOpFeedbackSuccess, kTag);
        m_kCECovertOpDebrief.txtFeedback.iState = eUIState_Good;

        if (!Country(HQ().m_kLastResult.iCountryTarget).LeftXCom())
        {
            kTag.StrValue0 = Country(HQ().m_kLastResult.iCountryTarget).GetName();
            m_kCECovertOpDebrief.txtFeedback.StrValue $= "\n" $ class'XComLocalizer'.static.ExpandStringByTag(m_strCovertOpFeedbackPanicReduction, kTag);
        }

        if (HQ().m_kLastResult.bAllPointsHeld && HQ().m_kLastResult.eType == eMission_CaptureAndHold)
        {
            m_kCECovertOpDebrief.txtFeedback.StrValue $= "\n" $ m_strCovertOpFeedbackAllPointsCaptured;
        }

        if (EXALT().GetNumCountriesNotRuledOutByClues() == 1)
        {
            XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).UnlockAchievement(AT_WhereInTheWorld);
        }
    }
    else
    {
        m_kCECovertOpDebrief.txtSubTitle.StrValue = m_strCovertOpSubTitleFailure;
        m_kCECovertOpDebrief.txtSubTitle.iState = eUIState_Bad;

        m_kCECovertOpDebrief.txtFeedback.StrValue = m_strCovertOpFeedbackFailure;
        m_kCECovertOpDebrief.txtFeedback.iState = eUIState_Bad;

        m_kCECovertOpDebrief.txtClueTitle.StrValue = "";
        m_kCECovertOpDebrief.txtClueTitle.iState = eUIState_Bad;

        m_kCECovertOpDebrief.txtClueBody.StrValue = "";
        m_kCECovertOpDebrief.txtClueBody.iState = eUIState_Bad;
    }
}

function UpdateEngineeringDebrief()
{
    local LWCE_XGStorage kStorage;
    local LWCE_TItem kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local TEngineeringDebriefItem kData;

    kStorage = `LWCE_STORAGE;

    m_kEngineeringDebrief.txtAdvisor.StrValue = m_sMedalUnlockTitle;
    m_kEngineeringDebrief.txtTitle.StrValue = m_sMedalAwardTitle;

    // In base Long War, items would naturally be sorted by item ID. In LWCE, we can sort
    // them however we want, but for now we just use the order they're inserted in.

    // Lost items are listed first
    foreach kStorage.m_arrCEItemsLostLastMission(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.iItemId);

        kData.txtItem.StrValue = kItemQuantity.iQuantity > 1 ? kItem.strNamePlural : kItem.strName;
        kData.txtBody.StrValue = string(kItemQuantity.iQuantity);
        kData.imgItem.strPath = kItem.ImagePath;

        m_kEngineeringDebrief.arrItems.AddItem(kData);
    }

    m_kEngineeringDebrief.iHighlighted = m_kEngineeringDebrief.arrItems.Length;

    // Now list damaged items
    foreach kStorage.m_arrCEItemsDamagedLastMission(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.iItemId);

        kData.txtItem.StrValue = kItemQuantity.iQuantity > 1 ? kItem.strNamePlural : kItem.strName;
        kData.txtBody.StrValue = string(kItemQuantity.iQuantity);
        kData.imgItem.strPath = kItem.ImagePath;

        m_kEngineeringDebrief.arrItems.AddItem(kData);
    }
}

function UpdateScienceDebrief()
{
    local TScienceDebrief kDebrief;
    local TScienceDebriefItem kDebriefItem;
    local TDebriefLootItem kLootItem;
    local LWCE_TItem kItem;
    local LWCE_TTech kTech;
    local TScienceProject kProjectUI;
    local TResearchProject kCurrentProject;
    local int iTech, iItem, eitm;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGHeadQuarters kHQ;

    kLabs = `LWCE_LABS;
    kHQ = `LWCE_HQ;

    PRES().CAMLookAtNamedLocation("Cargo", 0.0);

    kDebrief.txtOpName.StrValue = m_kSkyranger.m_strLastOpName;
    kDebrief.txtOpName.iState = eUIState_Warning;

    kDebrief.txtTitle.StrValue = m_strSalvageAnalysis;
    kDebrief.txtTitle.iState = eUIState_Highlight;

    kDebrief.imgAdvisor.iImage = eImage_ChiefScientist;
    kDebrief.txtAdvisor.StrValue = m_strChiefScientist;
    kDebrief.txtAdvisor.iState = eUIState_Warning;

    for (iTech = 0; iTech < kLabs.m_arrCEMissionResults.Length; iTech++)
    {
        if (kLabs.m_arrCEMissionResults[iTech].eAvailabilityState == eTechState_Available)
        {
            kTech = `LWCE_TECH(kLabs.m_arrCEMissionResults[iTech].iTechId);
            iItem = LWCE_GetUnlockItem(kTech);

            // Not sure how this bit works or how necessary it is
            if (iItem != 0)
            {
                kDebriefItem.imgTech.strPath = kTech.ImagePath;
            }
            else
            {
                kDebriefItem.imgTech.strPath = "";
            }

            kDebriefItem.txtTitle.StrValue = m_strNewResourceProject;
            kDebriefItem.txtTitle.iState = eUIState_Good;
            kDebriefItem.txtTech.StrValue = kTech.strName;
            kDebriefItem.txtTech.iState = eUIState_Highlight;
            kDebrief.arrItems.AddItem(kDebriefItem);

            if (kLabs.IsInterrogationTech(kLabs.m_arrCEMissionResults[iTech].iTechId))
            {
                kLabs.m_bNewCaptive = true;
            }
        }
    }

    kProjectUI.txtTitle.StrValue = m_strLabelCurrentResearch;
    kCurrentProject = kLabs.GetCurrentProject();

    if (kCurrentProject.iTech == 0)
    {
        kProjectUI.txtProject.StrValue = m_strLabelNone;
        kProjectUI.txtProject.iState = eUIState_Bad;
    }
    else
    {
        kTech = `LWCE_TECH(kCurrentProject.iTech);
        kProjectUI.txtProject.StrValue = kTech.strName;
        kProjectUI.txtProject.iState = eUIState_Highlight;
        kProjectUI.txtProgress = kLabs.GetCurrentProgressText();
    }

    kDebrief.kProject = kProjectUI;
    kDebrief.kProject.txtVisit.StrValue = m_strLabelVisitLabs;
    kDebrief.iHighlighted = m_kScienceDebrief.iHighlighted;

    if (kDebrief.iHighlighted == 0)
    {
        kDebrief.kProject.bVisitHighlighted = true;
    }

    kDebrief.txtLootTitle.StrValue = m_strLabelArtifactsRecovered;
    kDebrief.txtLootTitle.iState = eUIState_Warning;

    // First iterate and find "special" (aka story-critical) items
    for (iItem = 0; iItem < kHQ.m_kCELastCargoArtifacts.m_arrEntries.Length; iItem++)
    {
        if (kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iQuantity > 0 && IsSpecialLootItem(iItem))
        {
            kItem = `LWCE_ITEM(kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iItemId);

            kLootItem.imgItem.strPath = kItem.ImagePath;

            kLootItem.txtItem.StrValue = kItem.strName;
            kLootItem.txtItem.iState = eUIState_Highlight;

            kLootItem.txtQuantity.StrValue = string(kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iQuantity);
            kLootItem.txtQuantity.iState = eUIState_Highlight;

            kDebrief.arrLoot.AddItem(kLootItem);

            for (eitm = 0; eitm < kDebrief.arrItems.Length; eitm++)
            {
                if (kDebrief.arrItems[eitm].kDebriefLootItem.txtItem.StrValue == kLootItem.txtItem.StrValue)
                {
                    kDebrief.arrItems[eitm].kDebriefLootItem = kLootItem;
                }
            }
        }
    }

    // Then go through again for all the ordinary items
    for (iItem = 0; iItem < kHQ.m_kCELastCargoArtifacts.m_arrEntries.Length; iItem++)
    {
        if (kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iQuantity > 0 && !IsSpecialLootItem(iItem))
        {
            kItem = `LWCE_ITEM(kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iItemId);

            kLootItem.imgItem.strPath = kItem.ImagePath;

            kLootItem.txtItem.StrValue = kItem.strName;
            kLootItem.txtItem.iState = eUIState_Highlight;

            if (kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iItemId == `LW_ITEM_ID(Elerium))
            {
                if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienNucleonics)))
                {
                    kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iQuantity *= 1.20;
                }
            }

            if (kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iItemId == `LW_ITEM_ID(AlienAlloy))
            {
                if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienMetallurgy)))
                {
                    kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iQuantity *= 1.20;
                }
            }

            if (kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iItemId == `LW_ITEM_ID(WeaponFragment))
            {
                if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(ImprovedSalvage)))
                {
                    kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iQuantity *= 1.20;
                }
            }

            kLootItem.txtQuantity.StrValue = string(kHQ.m_kCELastCargoArtifacts.m_arrEntries[iItem].iQuantity);
            kLootItem.txtQuantity.iState = eUIState_Highlight;

            kDebrief.arrLoot.AddItem(kLootItem);

            for (eitm = 0; eitm < kDebrief.arrItems.Length; eitm++)
            {
                if (kDebrief.arrItems[eitm].kDebriefLootItem.txtItem.StrValue == kLootItem.txtItem.StrValue)
                {
                    kDebrief.arrItems[eitm].kDebriefLootItem = kLootItem;
                }
            }
        }
    }

    m_kScienceDebrief = kDebrief;
}

function UpdateSoldierDebrief()
{
    m_kCESoldierDebrief.txtOpName.StrValue = m_kSkyranger.m_strLastOpName;
    m_kCESoldierDebrief.txtOpName.iState = eUIState_Warning;
    m_kCESoldierDebrief.txtTitle.StrValue = m_strLabelAfterReport;
    m_kCESoldierDebrief.txtTitle.iState = eUIState_Bad;
}

simulated function UpdateSoldierUIData(XGStrategySoldier kSoldier, out TSoldierPromotionItem kPromotionUI, out TSoldierDebriefItem kItem)
{
    `LWCE_LOG_DEPRECATED_CLS(UpdateSoldierUIData);
}

simulated function LWCE_UpdateSoldierUIData(XGStrategySoldier kSoldier, out TSoldierPromotionItem kPromotionUI, out LWCE_TSoldierDebriefItem kItem)
{
    local string NickName;
    local XGParamTag kTag;
    local XGTacticalGameCore kGameCore;

    kGameCore = TACTICAL();
    kTag = new class'XGParamTag';

    kItem.m_bWasPromoted = false;
    kItem.m_bPsiPromoted = false;
    kPromotionUI.txtPromotion.StrValue = "";

    if (kSoldier.HasAvailablePerksToAssign(/* CheckForPsiPromotion */ false))
    {
        kItem.m_bWasPromoted = true;
        kItem.m_bPsiPromoted = false;
        kTag.StrValue1 = kSoldier.GetName(eNameType_Last);

        if (kSoldier.HasAnyMedal())
        {
            kTag.StrValue0 = kSoldier.GetName(eNameType_Rank) @ string(kSoldier.GetRank() - 3);
            kTag.StrValue2 = kSoldier.GetName(eNameType_Rank) @ string(kSoldier.GetRank() - 2);
        }
        else
        {
            kTag.StrValue0 = kGameCore.GetRankString(kSoldier.GetRank() - 1, true);
            kTag.StrValue2 = kGameCore.GetRankString(kSoldier.GetRank());
        }

        kPromotionUI.txtPromotion.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strRankNamePromoteRank, kTag);
        NickName = kSoldier.GetName(eNameType_Nick);

        if (kSoldier.HasAnyMedal())
        {
            kItem.txtName.StrValue = kSoldier.GetName(eNameType_FullNick);
        }
        else if (NickName == "")
        {
            kItem.txtName.StrValue = kGameCore.GetRankString(kSoldier.GetRank() - 1, true) @ kSoldier.GetName(eNameType_First) @ kSoldier.GetName(eNameType_Last);
        }
        else
        {
            kItem.txtName.StrValue = kGameCore.GetRankString(kSoldier.GetRank() - 1, true) @ kSoldier.GetName(eNameType_First) @ kSoldier.GetName(eNameType_Nick) @ kSoldier.GetName(eNameType_Last);
        }
    }
    else
    {
        kItem.txtName.StrValue = kSoldier.GetName(eNameType_FullNick);
    }

    kItem.iSoldierClassId = LWCE_XGStrategySoldier(kSoldier).LWCE_GetClass();

    if (kItem.m_bIsTank)
    {
        kItem.iSoldierRank = kSoldier.GetSHIVRank();
    }
    else
    {
        kItem.iSoldierRank = kSoldier.GetRank();
    }

    if (kSoldier.GetCurrentStat(eStat_HP) <= 0)
    {
        kItem.m_isDead = true;
    }
    else
    {
        kItem.m_isDead = false;
    }
}

function UpdateView()
{
    local LWCE_XGHeadquarters kHQ;
    local array<EXComSpeakerType> arrSpeakers;
    local bool bMeldWasPossible, bMeldWasRetrieved;

    kHQ = `LWCE_HQ;

    switch (m_iCurrentView)
    {
        case eDebriefView_Council:
            UpdateCouncilDebrief();
            break;
        case eDebriefView_Science:
            UpdateScienceDebrief();
            break;
        case eDebriefView_Engineering:
            UpdateEngineeringDebrief();
            break;
        case eDebriefView_Soldiers:
            UpdateSoldierDebrief();
            break;
        case eDebriefView_CovertOp:
            UpdateCovertOpDebrief();
            break;
    }

    super(XGScreenMgr).UpdateView();

    if (CheckForMatinee())
    {
        return;
    }

    if (m_iCurrentView == eDebriefView_Science)
    {
        Narrative(`XComNarrativeMoment("MissionUnload"));

        if (LABS().m_bNewCaptive)
        {
            Narrative(`XComNarrativeMoment("CongratsCaptive"));
            LABS().m_bNewCaptive = false;
        }
        else if (LABS().m_bCaptiveDied)
        {
            Narrative(`XComNarrativeMoment("CaptiveDied"));
            LABS().m_bCaptiveDied = false;
        }
    }
    else if (m_iCurrentView == eDebriefView_Soldiers && !ISCONTROLLED())
    {
        if (BARRACKS().m_eLastResult != eLastResult_None && BARRACKS().m_eLastResultSpeaker == eSpeaker_Skyranger)
        {
            arrSpeakers.AddItem(eSpeaker_Alpha);
            arrSpeakers.AddItem(eSpeaker_Engineer);
            arrSpeakers.AddItem(eSpeaker_Science);

            BARRACKS().m_eLastResultSpeaker = arrSpeakers[Rand(arrSpeakers.Length)];
            bMeldWasPossible = kHQ.m_kLastResult.eType == eMission_Abduction || kHQ.m_kLastResult.eType == eMission_Crash || kHQ.m_kLastResult.eType == eMission_LandedUFO;
            bMeldWasRetrieved = kHQ.m_kCELastCargoArtifacts.Get(`LW_ITEM_ID(Meld)).iQuantity > 0;

            switch (BARRACKS().m_eLastResultSpeaker)
            {
                case eSpeaker_Alpha:
                    if (BARRACKS().m_eLastResult == eLastResult_Bad)
                    {
                        Narrative(`XComNarrativeMoment("MCToughMission"));
                    }
                    else if (BARRACKS().m_eLastResult == eLastResult_Good)
                    {
                        Narrative(`XComNarrativeMoment("MCGreatMission"));
                    }

                    break;
                case eSpeaker_Engineer:
                    if (BARRACKS().m_eLastResult == eLastResult_Bad)
                    {
                        Narrative(`XComNarrativeMoment("EngineerToughMission"));
                    }
                    else if (BARRACKS().m_eLastResult == eLastResult_Good)
                    {
                        if (!bMeldWasRetrieved && bMeldWasPossible)
                        {
                            Narrative(`XComNarrativeMomentEW("EngineerGreatMission_GetMeld"));
                        }
                        else if (Rand(10) > 4 || !bMeldWasPossible)
                        {
                            Narrative(`XComNarrativeMoment("EngineerGreatMission"));
                        }
                        else
                        {
                            Narrative(`XComNarrativeMomentEW("EngineerGreatMission_GotMeld"));
                        }
                    }

                    break;
                case eSpeaker_Science:
                    if (BARRACKS().m_eLastResult == eLastResult_Bad)
                    {
                        Narrative(`XComNarrativeMoment("ScientistToughMission"));
                    }
                    else if (BARRACKS().m_eLastResult == eLastResult_Good)
                    {
                        if (!bMeldWasRetrieved && bMeldWasPossible)
                        {
                            Narrative(`XComNarrativeMomentEW("ScientistGreatMission_GetMeld"));
                        }
                        else if ((Rand(10) > 4) || !bMeldWasPossible)
                        {
                            Narrative(`XComNarrativeMoment("ScientistGreatMission"));
                        }
                        else
                        {
                            Narrative(`XComNarrativeMomentEW("ScientistGreatMission_GotMeld"));
                        }
                    }

                    break;
            }
        }
    }

    if (!kHQ.m_kLastResult.bSuccess)
    {
        Sound().PlayMusic(eMusic_YouLose);
    }
    else
    {
        Sound().PlayMusic(Game().GetActMusic());
    }

    PRES().m_kStrategyHUD.m_kEventList.Hide();
}