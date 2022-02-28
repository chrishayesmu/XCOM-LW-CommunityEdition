class LWCE_XGManufacturingUI extends XGManufacturingUI;

var LWCE_TItemProject m_kCEItemProject;

function DirectInitialize()
{
    local bool bInstaBuild;
    local int iMaxEngineers, iView;
    local LWCE_TFoundryTech kFTech;
    local LWCE_TItem kItem;

    PlayOpenSound();

    iView = m_iCurrentView;
    m_imgBG.iImage = eImage_OldManufacture;
    m_bCanRush = true;
    m_arrButtons.Add(4);
    m_iHighlightedButton = 1;

    if (iView == eManView_Item || m_kCEItemProject.iItemId != 0)
    {
        kItem = `LWCE_ITEM(m_kCEItemProject.iItemId);

        if (m_kCEItemProject.iIndex == -1)
        {
            m_kCEItemProject.iQuantity = 1;
            m_kCEItemProject.iQuantityLeft = 1;
            m_kCEItemProject.iHoursLeft = kItem.iHours;
            m_kCEItemProject.bNotify = m_kCEItemProject.iHoursLeft != 0;

            iMaxEngineers = kItem.iMaxEngineers;
            iMaxEngineers *= float(m_kCEItemProject.iQuantity);
            m_kCEItemProject.iEngineers = iMaxEngineers;
            m_iAddedEngineers = m_kCEItemProject.iEngineers;
            m_kCEItemProject.iMaxEngineers = iMaxEngineers;
        }
        else
        {
            m_kCEItemProject = `LWCE_ENGINEERING.LWCE_GetItemProject(m_kCEItemProject.iIndex);
            m_bCanCancel = true;
            m_bCanRush = false;
            ReleaseItemFunds();
        }

        if (m_bCanRush && kItem.iCategory < 0)
        {
            m_bCanRush = false;
        }

        if (m_bCanRush && m_kCEItemProject.iHoursLeft == 0)
        {
            m_bCanRush = false;
        }

        iView = eManView_Item;
    }
    else if (iView == eManView_Foundry || m_kFoundProject.eTech != 0)
    {
        if (m_kFoundProject.iIndex != -1)
        {
            m_kFoundProject = ENGINEERING().GetFoundryProject(m_kFoundProject.iIndex);
            m_bCanCancel = true;
            ReleaseFoundryFunds();
            m_bCanRush = false;
        }
        else
        {
            kFTech = `LWCE_FTECH(m_kFoundProject.eTech);
            m_kFoundProject.iHoursLeft = kFTech.iHours;
            m_kFoundProject.iMaxEngineers = kFTech.iEngineers;
            m_kFoundProject.iEngineers = m_kFoundProject.iMaxEngineers;
            m_iAddedEngineers = m_kFoundProject.iEngineers;
            m_kFoundProject.bNotify = true;
        }

        iView = eManView_Foundry;
    }
    else
    {
        if (m_kFProject.iIndex != -1)
        {
            m_kFProject = ENGINEERING().GetFacilityProject(m_kFProject.X, m_kFProject.Y);
            m_bCanCancel = true;
            m_bCanRush = false;
            ReleaseFacilityFunds();
        }
        else
        {
            bInstaBuild = false;

            if (XComCheatManager(GetALocalPlayerController().CheatManager) != none)
            {
                bInstaBuild = XComCheatManager(GetALocalPlayerController().CheatManager).m_bStrategyAllFacilitiesInstaBuild;
            }

            if (bInstaBuild)
            {
                m_kFProject.iHoursLeft = 0;
            }
            else
            {
                m_kFProject.iHoursLeft = Facility(m_kFProject.eFacility).iTime;
            }

            m_kFProject.bNotify = true;
        }

        iView = eManView_Facility;
    }

    m_bAllowDeleteOrder = false;
    GoToView(iView);
}

function bool IsNewProject()
{
    switch (m_iCurrentView)
    {
        case eManView_Item:
            return m_kCEItemProject.iIndex == -1;
        case eManView_Facility:
            return m_kFProject.iIndex == -1;
        case eManView_Foundry:
            return m_kFoundProject.iIndex == -1;
        default:
            return false;
    }
}

function OnIncrease()
{
    if (!IsNewProject())
    {
        PlayBadSound();
        return;
    }

    // Can't build multiple satellites at once with Diminishing Returns on, since the cost increases each time
    if (m_iCurrentView == eManView_Item && m_bCanAfford && !(m_kCEItemProject.iItemId == `LW_ITEM_ID(Satellite) && IsOptionEnabled(`LW_SECOND_WAVE_ID(DiminishingReturns))))
    {
        m_kCEItemProject.iQuantity += 1;
        m_kCEItemProject.iQuantityLeft += 1;
        UpdateView();
    }
    else
    {
        PlayBadSound();
    }
}

function OnDecrease()
{
    if (!IsNewProject())
    {
        PlayBadSound();
        return;
    }

    if (m_iCurrentView == eManView_Item)
    {
        if (m_kCEItemProject.iQuantityLeft > 1)
        {
            m_kCEItemProject.iQuantity -= 1;
            m_kCEItemProject.iQuantityLeft -= 1;
            UpdateView();
        }
        else
        {
            PlayBadSound();
        }
    }
    else
    {
        PlayBadSound();
    }
}

function OnSubmitOrder()
{
    if (m_bCanAfford)
    {
        switch (m_iCurrentView)
        {
            case eManView_Item:
                if (m_kCEItemProject.iQuantityLeft == 0)
                {
                    OnCancelOrder();
                }
                else if (IsNewProject())
                {
                    `LWCE_ENGINEERING.LWCE_AddItemProject(m_kCEItemProject);
                }
                else
                {
                    `LWCE_ENGINEERING.LWCE_ModifyItemProject(m_kCEItemProject);
                }

                Sound().PlaySFX(SNDLIB().SFX_UI_ItemStarted);

                break;
            case eManView_Facility:
                if (IsNewProject())
                {
                    ENGINEERING().AddFacilityProject(m_kFProject);
                    ENGINEERING().m_bFacilityBuilt = true;
                }
                else
                {
                    ENGINEERING().ModifyFacilityProject(m_kFProject);
                }

                Sound().PlaySFX(SNDLIB().SFX_UI_FacilityStarted);

                break;
            case eManView_Foundry:
                if (IsNewProject())
                {
                    ENGINEERING().AddFoundryProject(m_kFoundProject);
                }
                else
                {
                    ENGINEERING().ModifyFoundryProject(m_kFoundProject);
                }

                Sound().PlaySFX(SNDLIB().SFX_UI_ItemStarted);

                break;
        }

        OnExitScreen();
    }
    else
    {
        PlayBadSound();
    }
}

function OnToggleNotify()
{
    switch (m_iCurrentView)
    {
        case eManView_Item:
            m_kCEItemProject.bNotify = !m_kCEItemProject.bNotify;
            break;
        case eManView_Facility:
            m_kFProject.bNotify = !m_kFProject.bNotify;
            break;
        case eManView_Foundry:
            m_kFoundProject.bNotify = !m_kFoundProject.bNotify;
            break;
    }

    UpdateView();
}

function OnToggleRush()
{
    if (m_bCanRush)
    {
        switch (m_iCurrentView)
        {
            case eManView_Item:
                m_kCEItemProject.bRush = !m_kCEItemProject.bRush;

                if (m_kCEItemProject.bRush)
                {
                    PlaySmallOpenSound();
                }
                else
                {
                    PlaySmallCloseSound();
                }

                break;
            case eManView_Facility:
                m_kFProject.bRush = !m_kFProject.bRush;

                if (m_kFProject.bRush)
                {
                    PlaySmallOpenSound();
                }
                else
                {
                    PlaySmallCloseSound();
                }

                break;
            case eManView_Foundry:
                m_kFoundProject.bRush = !m_kFoundProject.bRush;

                if (m_kFoundProject.bRush)
                {
                    PlaySmallOpenSound();
                }
                else
                {
                    PlaySmallCloseSound();
                }

                break;
        }

        UpdateView();
    }
    else
    {
        PlayBadSound();
    }
}

function ReleaseItemFunds()
{
    if (m_kCEItemProject.kOriginalCost.iCash != 0)
    {
        ENGINEERING().RefundCost(m_kCEItemProject.kOriginalCost);
    }
    else
    {
        ENGINEERING().RefundCost(`LWCE_ENGINEERING.LWCE_GetItemProjectCost(m_kCEItemProject.iItemId, m_kCEItemProject.iQuantityLeft, m_kCEItemProject.bRush));
    }
}

function RestoreItemFunds()
{
    if (m_kCEItemProject.iIndex != -1)
    {
        ENGINEERING().RestoreItemFunds(m_kCEItemProject.iIndex);
    }
}

function UpdateManufactureFoundry()
{
    local TManWidget kWidget;
    local LWCE_TFoundryTech kTech;
    local XGParamTag kTag;

    kTech = `LWCE_FTECH(m_kFoundProject.eTech);
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    kWidget.txtTitle.StrValue = kTech.strName;
    kWidget.txtTitle.iState = eUIState_Warning;
    kWidget.imgItem.strPath = kTech.ImagePath;

    kWidget.txtItemInfoButton.iButton = eButton_Back;
    kWidget.txtItemInfoButton.StrValue = m_strLabelProjectInfo;

    kTag.IntValue0 = ENGINEERING().GetFoundryCounter(m_kFoundProject);
    kWidget.txtProjDuration.strLabel = m_strLabelTimeToComplete;
    kWidget.txtProjDuration.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strETADays, kTag);
    kWidget.txtProjDuration.iState = eUIState_Warning;

    kWidget.txtEngineers.StrValue = string(m_kFoundProject.iMaxEngineers);
    kWidget.txtEngineersLabel.StrValue = m_strLabelEngineersAssigned;
    kWidget.txtEngHelp.iButton = eButton_RBumper;
    kWidget.txtEngHelp.StrValue = m_strHelpAdjust;

    kWidget.txtResourcesLabel.StrValue = m_strLabelProjectCost;
    kWidget.txtResourcesLabel.iState = eUIState_Warning;

    m_bCanAfford = ENGINEERING().GetFoundryCostSummary(kWidget.kCost, m_kFoundProject.eTech, m_kFoundProject.Brush);

    if (!m_bCanAfford)
    {
        kWidget.txtProblem.iState = eUIState_Bad;
        kWidget.txtProblem.StrValue = kWidget.kCost.strHelp;
        kWidget.txtProjDuration.iState = eUIState_Bad;
        kWidget.txtResourcesLabel.iState = eUIState_Bad;
    }

    if (m_bCanRush)
    {
        kWidget.txtNotifyButton.iButton = eButton_Y;
        kWidget.txtNotifyButton.StrValue = m_strLabelRushBuild;

        if (m_kFoundProject.Brush)
        {
            kWidget.txtNotifyButton.StrValue @= m_strLabelYES;
            kWidget.txtNotifyButton.iState = eUIState_Warning;
        }
        else
        {
            kWidget.txtNotifyButton.StrValue @= m_strLabelNO;
            kWidget.txtNotifyButton.iState = eUIState_Normal;
        }
    }

    if (IsNewProject() && ENGINEERING().GetNumEngineersAvailable() < m_kFoundProject.iMaxEngineers)
    {
        kWidget.txtEngineers.iState = eUIState_Bad;
        kWidget.txtEngineersLabel.iState = eUIState_Bad;
        kWidget.txtProblem.iState = eUIState_Bad;
        kWidget.txtProblem.StrValue = m_strErrEngineers;
        kWidget.txtQuantity.iState = eUIState_Bad;
        kWidget.txtResourcesLabel.iState = eUIState_Bad;
    }
    else if (!m_bCanAfford)
    {
        kWidget.txtProblem.StrValue = "";
    }

    kWidget.txtNotesLabel.StrValue = m_strLabelNotes;
    kWidget.txtNotesLabel.iState = eUIState_Normal;

    if (m_kFoundProject.iEngineers == 0)
    {
        kWidget.txtNotes.StrValue @= m_strNoteFoundryStalled;
        kWidget.txtNotes.iState = eUIState_Normal;
    }

    kWidget.arrButtons.Add(4);
    UpdateManButtons(kWidget);
    m_kWidget = kWidget;
}

function UpdateManufactureItem()
{
    local LWCE_XGFacility_Engineering kEngineering;
    local TManWidget kWidget;
    local LWCE_TItem kItem;
    local int iSatCap;

    kEngineering = `LWCE_ENGINEERING;
    kItem = `LWCE_ITEM(m_kCEItemProject.iItemId);

    kWidget.txtTitle.StrValue = kItem.strName;
    kWidget.txtTitle.iState = eUIState_Warning;
    kWidget.imgItem.strPath = kItem.ImagePath;

    kWidget.txtItemInfoButton.iButton = eButton_Back;
    kWidget.txtItemInfoButton.StrValue = m_strLabelItemInfo;

    kWidget.txtQuantity.StrValue = string(m_kCEItemProject.iQuantityLeft);
    kWidget.txtQuantityLabel.StrValue = m_strLabelQuantity;
    kWidget.txtQuantityHelp.iButton = eButton_Up;
    kWidget.txtQuantityHelp.StrValue = m_strHelpAdjust;
    kWidget.txtProjDuration.strLabel = m_strLabelProjectDuration;

    if (m_kCEItemProject.iHoursLeft == 0)
    {
        kWidget.txtProjDuration.StrValue = m_strLabelImmediate;
    }
    else
    {
        kWidget.txtProjDuration.StrValue = kEngineering.LWCE_GetETAString(m_kCEItemProject);
    }

    kWidget.txtProjDuration.iState = eUIState_Warning;
    kWidget.bCanAdjustQuantity = m_kCEItemProject.iItemId != eItem_Skeleton_Key;
    kWidget.txtEngineers.StrValue = string(m_kCEItemProject.iMaxEngineers);
    kWidget.txtEngineersLabel.StrValue = m_strLabelEngineersAssigned;
    kWidget.txtEngHelp.iButton = eButton_RBumper;
    kWidget.txtEngHelp.StrValue = m_strHelpAdjust;
    kWidget.txtResourcesLabel.StrValue = m_strLabelProjectCost;
    kWidget.txtResourcesLabel.iState = eUIState_Warning;

    m_bCanAfford = kEngineering.LWCE_GetItemCostSummary(kWidget.kCost, m_kCEItemProject.iItemId, m_kCEItemProject.iQuantityLeft, m_kCEItemProject.bRush, false, m_kCEItemProject.iIndex);

    if (!m_bCanAfford)
    {
        kWidget.txtProblem.iState = eUIState_Bad;
        kWidget.txtProblem.StrValue = kWidget.kCost.strHelp;
        kWidget.txtQuantity.iState = eUIState_Bad;
        kWidget.txtResourcesLabel.iState = eUIState_Bad;
    }

    if (IsNewProject() && kEngineering.GetNumEngineersAvailable() < m_kCEItemProject.iMaxEngineers)
    {
        kWidget.txtEngineers.iState = eUIState_Bad;
        kWidget.txtEngineersLabel.iState = eUIState_Bad;
        kWidget.txtProblem.iState = eUIState_Bad;
        kWidget.txtProblem.StrValue = m_strErrEngineers;
        kWidget.txtQuantity.iState = eUIState_Bad;
        kWidget.txtResourcesLabel.iState = eUIState_Bad;
    }
    else if (!m_bCanAfford)
    {
        kWidget.txtProblem.StrValue = "";
    }

    kWidget.txtNotesLabel.StrValue = m_strLabelNotes;
    kWidget.txtNotesLabel.iState = eUIState_Normal;

    if (kItem.iCategory == eItemCat_Weapons && kItem.iItemId != eItem_Skeleton_Key)
    {
        if (TACTICAL().WeaponHasProperty(kItem.iItemId, eWP_AnyClass))
        {
            kWidget.txtNotes.StrValue @= m_strNoteWeaponAllSoldiers;
        }
    }

    if (kItem.iItemId == eItem_Firestorm)
    {
        if (HANGAR().GetFreeHangerSpots(HQ().GetContinent()) < m_kCEItemProject.iQuantity)
        {
            m_bCanAfford = false;
            kWidget.txtProblem.iState = eUIState_Bad;
            kWidget.txtProblem.StrValue = m_strNoteInsufficientBays;
            kWidget.txtQuantity.iState = eUIState_Bad;
            kWidget.txtResourcesLabel.iState = eUIState_Bad;
        }
    }
    else if (kItem.iItemId == eItem_Satellite)
    {
        iSatCap = HQ().m_arrSatellites.Length;
        iSatCap += STORAGE().GetNumItemsAvailable(eItem_Satellite);
        iSatCap += kEngineering.GetNumSatellitesBuilding();

        // If this is a new project, count the requested quantity towards the cap
        if (m_kCEItemProject.iIndex == -1)
        {
            iSatCap += m_kCEItemProject.iQuantity;
        }

        if (HQ().GetSatelliteLimit() < iSatCap)
        {
            kWidget.txtNotes.StrValue = m_strSatCapacity;
            kWidget.txtNotes.iState = eUIState_Bad;
        }
    }
    else if (m_kCEItemProject.iEngineers == 0)
    {
        kWidget.txtNotes.StrValue @= m_strNoteBuildStalled;
        kWidget.txtNotes.iState = eUIState_Normal;
    }

    if (m_bCanRush)
    {
        kWidget.txtNotifyButton.iButton = eButton_Y;
        kWidget.txtNotifyButton.StrValue = m_strLabelRushBuild;

        if (m_kCEItemProject.bRush)
        {
            kWidget.txtNotifyButton.StrValue @= m_strLabelYES;
            kWidget.txtNotifyButton.iState = eUIState_Normal;
        }
        else
        {
            kWidget.txtNotifyButton.StrValue @= m_strLabelNO;
            kWidget.txtNotifyButton.iState = eUIState_Normal;
        }
    }

    if (kWidget.txtNotes.StrValue == "")
    {
        kWidget.txtNotes.StrValue = m_strHelp;
    }

    kWidget.arrButtons.Add(4);
    UpdateManButtons(kWidget);
    m_kWidget = kWidget;
}

function UpdateView()
{
    UpdateHeader();

    switch (m_iCurrentView)
    {
        case eManView_Item:
            UpdateManufactureItem();
            break;
        case eManView_Facility:
            UpdateManufactureFacility();
            break;
        case eManView_Foundry:
            UpdateManufactureFoundry();
            break;
    }

    super(XGScreenMgr).UpdateView();

    // If building a satellite without sufficient capacity to launch it, trigger a narrative moment to inform the player
    // LWCE issue #3: this narrative triggers without considering whether your current satellite capacity is sufficient
    // to cover every country, in which case you're just building backup satellites.
    if (m_iCurrentView == eManView_Item && m_kCEItemProject.iItemId == eItem_Satellite)
    {
        if ( !m_bSatCapacity
          && HQ().GetSatelliteLimit() < GetTotalNumberOfCouncilCountries()
          && HQ().GetSatelliteLimit() <= (HQ().m_arrSatellites.Length + STORAGE().GetNumItemsAvailable(eItem_Satellite))
          && !(ENGINEERING().IsBuildingFacility(eFacility_SmallRadar) || ENGINEERING().IsBuildingFacility(eFacility_LargeRadar)) )
        {
            m_bSatCapacity = true;
            Narrative(`XComNarrativeMoment("UrgeUplink"));
        }
    }
}

private function int GetTotalNumberOfCouncilCountries()
{
    local int Total;
    local XGCountry kCountry;

    foreach World().m_arrCountries(kCountry)
    {
        if (kCountry.IsCouncilMember())
        {
            Total++;
        }
    }

    return Total;
}