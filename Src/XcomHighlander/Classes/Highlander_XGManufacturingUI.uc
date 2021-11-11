class Highlander_XGManufacturingUI extends XGManufacturingUI;

function DirectInitialize()
{
    local bool bInstaBuild;
    local int iMaxEngineers, iView;
    local HL_TFoundryTech kFTech;

    PlayOpenSound();
    iView = m_iCurrentView;
    m_imgBG.iImage = 220;
    m_bCanRush = true;
    m_arrButtons.Add(4);
    m_iHighlightedButton = 1;

    if (iView == eManView_Item || m_kIProject.eItem != 0)
    {
        if (m_kIProject.iIndex == -1)
        {
            m_kIProject.iQuantity = 1;
            m_kIProject.iQuantityLeft = 1;
            m_kIProject.iHoursLeft = Item(m_kIProject.eItem).iHours;
            m_kIProject.bNotify = m_kIProject.iHoursLeft != 0;

            iMaxEngineers = ITEMTREE().m_arrItems[m_kIProject.eItem].iMaxEngineers;
            iMaxEngineers *= float(m_kIProject.iQuantity);
            m_kIProject.iEngineers = iMaxEngineers;
            m_iAddedEngineers = m_kIProject.iEngineers;
            m_kIProject.iMaxEngineers = iMaxEngineers;
        }
        else
        {
            m_kIProject = ENGINEERING().GetItemProject(m_kIProject.iIndex);
            m_bCanCancel = true;
            m_bCanRush = false;
            ReleaseItemFunds();
        }

        if (m_bCanRush && Item(m_kIProject.eItem).iCategory < 0)
        {
            m_bCanRush = false;
        }

        if (m_bCanRush && m_kIProject.iHoursLeft == 0)
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
            kFTech = `HL_FTECH(m_kFoundProject.eTech);
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

function UpdateManufactureFoundry()
{
    local TManWidget kWidget;
    local HL_TFoundryTech kTech;
    local XGParamTag kTag;

    kTech = `HL_FTECH(m_kFoundProject.eTech);
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

    super.UpdateView();

    // If building a satellite without sufficient capacity to launch it, trigger a narrative moment to inform the player
    // Highlander issue #3: this narrative triggers without considering whether your current satellite capacity is sufficient
    // to cover every country, in which case you're just building backup satellites.
    if (m_iCurrentView == eManView_Item && m_kIProject.eItem == eItem_Satellite)
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