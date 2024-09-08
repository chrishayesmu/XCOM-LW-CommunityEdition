class LWCE_XGWorldReportUI extends XGWorldReportUI;

function BuildActivityText(out TWRHeader kHeader)
{
    local LWCE_XGWorld kWorld;
    local TText txtActivity;

    kWorld = LWCE_XGWorld(WORLD());

    if (kWorld.m_kCECouncil.kSummary.iAlienBasesAssaulted > 0)
    {
        txtActivity.StrValue = m_strLabelBaseAssaulted;
        txtActivity.iState = eUIState_Good;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iCouncilMissionsCompleted > 0)
    {
        txtActivity.StrValue = m_strLabelFCMissions @ kWorld.m_kCECouncil.kSummary.iCouncilMissionsCompleted;
        txtActivity.iState = eUIState_Good;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iUFOsShotdown > 0)
    {
        txtActivity.StrValue = m_strLabelUFOShotDown @ kWorld.m_kCECouncil.kSummary.iUFOsShotdown;
        txtActivity.iState = eUIState_Good;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iTerrorThwarted > 0)
    {
        txtActivity.StrValue = m_strLabelTerrorStopped @ kWorld.m_kCECouncil.kSummary.iTerrorThwarted;
        txtActivity.iState = eUIState_Good;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iAbductionsThwarted > 0)
    {
        txtActivity.StrValue = m_strLabelAbductionsStopped @ kWorld.m_kCECouncil.kSummary.iAbductionsThwarted;
        txtActivity.iState = eUIState_Good;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iTerrorIgnored > 0)
    {
        txtActivity.StrValue = m_strLabelTerrorIgnored @ kWorld.m_kCECouncil.kSummary.iTerrorIgnored;
        txtActivity.iState = eUIState_Bad;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iTerrorFailed > 0)
    {
        txtActivity.StrValue = m_strLabelTerrorFailed @ kWorld.m_kCECouncil.kSummary.iTerrorFailed;
        txtActivity.iState = eUIState_Bad;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iAbductionsIgnored > 0)
    {
        txtActivity.StrValue = m_strLabelAbductionsIgnored @ kWorld.m_kCECouncil.kSummary.iAbductionsIgnored;
        txtActivity.iState = eUIState_Bad;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iAbductionsFailed > 0)
    {
        txtActivity.StrValue = m_strLabelAbductionsFailed @ kWorld.m_kCECouncil.kSummary.iAbductionsFailed;
        txtActivity.iState = eUIState_Bad;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iSatellitesLaunched > 0)
    {
        txtActivity.StrValue = m_strLabelSatellitesLaunched @ kWorld.m_kCECouncil.kSummary.iSatellitesLaunched;
        txtActivity.iState = eUIState_Good;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iTechsResearched > 0)
    {
        txtActivity.StrValue = m_strLabelResearchCompleted @ kWorld.m_kCECouncil.kSummary.iTechsResearched;
        txtActivity.iState = eUIState_Good;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iUFORaids > 0)
    {
        txtActivity.StrValue = m_strLabelUFORaided @ kWorld.m_kCECouncil.kSummary.iUFORaids;
        txtActivity.iState = eUIState_Good;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iSatellitesLost > 0)
    {
        txtActivity.StrValue = m_strLabelSatellitesLost @ kWorld.m_kCECouncil.kSummary.iSatellitesLost;
        txtActivity.iState = eUIState_Bad;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iUFOsEscaped > 0)
    {
        txtActivity.StrValue = m_strLabelUFOsEscaped @ kWorld.m_kCECouncil.kSummary.iUFOsEscaped;
        txtActivity.iState = eUIState_Bad;
        kHeader.arrActivity.AddItem(txtActivity);
    }

    if (kWorld.m_kCECouncil.kSummary.iMismanagedFunds > 0)
    {
        txtActivity.StrValue = m_strLabelMismanagedResources @ ConvertCashToString(GetResource(eResource_Money));
        txtActivity.iState = eUIState_Bad;
        kHeader.arrActivity.AddItem(txtActivity);
    }
}

function TWRContinent BuildContinentReport(XGContinent kContinent)
{
    local LWCEBonusTemplate kBonusTemplate;
    local TWRContinent kUI;
    local int iCountry;
    local TLabeledText ltxtSpecialists;
    local LWCE_XGContinent kCEContinent;
    local LWCE_XGCountry kCountry;

    kCEContinent = LWCE_XGContinent(kContinent);

    kUI.txtName.StrValue = kCEContinent.GetName();
    ltxtSpecialists = GetSpecialistsText(kCEContinent.GetScientists(), kCEContinent.GetEngineers());
    kUI.txtSpecialists.StrValue = ltxtSpecialists.StrValue;
    kUI.txtSpecialists.iState = ltxtSpecialists.iState;

    if (kCEContinent.HasBonus())
    {
        kBonusTemplate = `LWCE_BONUS(kCEContinent.LWCE_GetBonus());

        kUI.txtBonus.StrValue = kBonusTemplate.strName;
        kUI.txtBonus.iState = eUIState_Warning;
    }

    for (iCountry = 0; iCountry < kCEContinent.m_arrCECountries.Length; iCountry++)
    {
        kCountry = `LWCE_XGCOUNTRY(kCEContinent.m_arrCECountries[iCountry]);

        if (!kCountry.IsCouncilMember())
        {
            continue;
        }

        kUI.arrCountries.AddItem(BuildCountryReport(kCountry));
    }

    return kUI;
}

function TText GetGradeText()
{
    local TText txtGrade;
    local EMonthlyGrade eGrade;

    eGrade = LWCE_XGWorld(World()).m_kCECouncil.eGrade;
    txtGrade.StrValue = m_arrGradeNames[eGrade];

    switch (eGrade)
    {
        case eGrade_A:
            txtGrade.iState = eUIState_Good;
            break;
        case eGrade_B:
            txtGrade.iState = eUIState_Good;
            break;
        case eGrade_C:
            txtGrade.iState = eUIState_Warning;
            break;
        case eGrade_D:
            txtGrade.iState = eUIState_Bad;
            break;
        case eGrade_F:
            txtGrade.iState = eUIState_Bad;
            break;
    }

    return txtGrade;
}

function UpdateContinents()
{
    local LWCE_XGWorld kWorld;
    local XGContinent kContinent;
    local int iContinent;

    kWorld = LWCE_XGWorld(WORLD());

    for (iContinent = 0; iContinent < kWorld.m_arrContinents.Length; iContinent++)
    {
        kContinent = kWorld.m_arrContinents[iContinent];
        m_arrContinents.AddItem(BuildContinentReport(kContinent));
    }
}

function UpdateDefections()
{
    local int iCountry;
    local TWRDefections kUI;
    local string strCountries, strTemp;
    local XGParamTag kTag;
    local LWCE_XGWorld kWorld;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kWorld = LWCE_XGWorld(WORLD());

    for (iCountry = 0; iCountry < GetNumDefections(); iCountry++)
    {
        if (strCountries != "")
        {
            if (iCountry == GetNumDefections() - 1)
            {
                strCountries @= m_strAndAppend $ " ";
            }
            else
            {
                strCountries $= ", ";
            }
        }

        strCountries $= `LWCE_XGCOUNTRY(kWorld.m_kCECouncil.arrLeavingCountries[iCountry]).GetName();
    }

    kTag.StrValue0 = strCountries;

    if (GetNumDefections() > 1)
    {
        strTemp = class'XComLocalizer'.static.ExpandString(m_strManyWithdrawn);
    }
    else
    {
        strTemp = class'XComLocalizer'.static.ExpandString(m_strOneWithdrawn);
    }

    kUI.txtDefections.StrValue = strTemp;
    kUI.txtDefections.iState = eUIState_Bad;

    m_kDefections = kUI;
}

function UpdateHeader()
{
    local LWCE_XGWorld kWorld;
    local TWRHeader kHeader;
    local int iMonth;

    kWorld = LWCE_XGWorld(WORLD());

    kHeader.txtTitle.StrValue = m_strLabelMonthlyReport;
    kHeader.txtTitle.iState = eUIState_Highlight;

    kHeader.txtFeedback.StrValue = kWorld.m_kCECouncil.strSummary;
    kHeader.txtFeedback.iState = eUIState_Warning;

    iMonth = GEOSCAPE().m_kDateTime.GetMonth() - 1;

    if (iMonth <= 0)
    {
        iMonth = 12;
    }

    kHeader.txtMonth.StrValue = GEOSCAPE().m_kDateTime.GetMonthString(iMonth);
    kHeader.txtMonth.iState = eUIState_Highlight;

    kHeader.txtYear.StrValue = string(GEOSCAPE().m_kDateTime.GetYear());
    kHeader.txtYear.iState = eUIState_Highlight;

    kHeader.ltxtFunding.strLabel = m_strLabelFundingAwarded;
    kHeader.ltxtFunding.StrValue = "+" $ ConvertCashToString(kWorld.m_kCECouncil.iFunding);
    kHeader.ltxtFunding.iState = eUIState_Cash;

    kHeader.ltxtSpecialists = GetSpecialistsText(kWorld.m_kCECouncil.iScientists, kWorld.m_kCECouncil.iEngineers);

    kHeader.txtGrade = GetGradeText();

    kHeader.txtGradeLabel.StrValue = m_strLabelMilitaryGrade;
    kHeader.txtGradeLabel.iState = kHeader.txtGrade.iState;

    kHeader.txtActivityLabel.StrValue = m_strLabelXComActivity;

    BuildActivityText(kHeader);
    m_kHeader = kHeader;
}

function UpdateView()
{
    local XComNarrativeMoment Narr;
    local int iLostCountries;

    switch (m_iCurrentView)
    {
        case eWRView_Link:
            UpdateLink();
            break;
        case eWRView_Defections:
            UpdateDefections();
            break;
        case eWRView_Summary:
            UpdateHeader();
            UpdateContinents();
            break;
    }

    super.UpdateView();

    if (m_iCurrentView == eWRView_Link)
    {
        Narrative(`XComNarrativeMoment("RoboHQ_IncomingTransmission"));
    }
    else if (m_iCurrentView == eWRView_Defections)
    {
        iLostCountries = World().GetNumDefectors();

        if (iLostCountries < LOSE_CONDITION_NUM_DESERTERS)
        {
            if (GetNumDefections() == 1)
            {
                Narrative(`XComNarrativeMoment("FCLeadInMemberLeaves_OnlyOne"));
            }
            else
            {
                Narrative(`XComNarrativeMoment("FCLeadInMemberLeaves_Multiple"));
            }

            if (World().m_kCouncil.eGrade >= 2)
            {
                if (iLostCountries <= 2)
                {
                    Narrative(`XComNarrativeMoment("FCLeadOutDisappointed"));
                }
                else if (iLostCountries <= 5)
                {
                    Narrative(`XComNarrativeMoment("FCLeadOutConcerned"));
                }
                else
                {
                    Narrative(`XComNarrativeMoment("FCLeadOutKnifeEdge"));
                }
            }
        }
    }
    else if (m_iCurrentView == eWRView_Summary)
    {
        if (!m_bReportDialogue)
        {
            switch (LWCE_XGWorld(World()).m_kCECouncil.eGrade)
            {
                case 0:
                    Narr = `XComNarrativeMoment("FCReportA");
                    break;
                case 1:
                    Narr = `XComNarrativeMoment("FCReportB");
                    break;
                case 2:
                    Narr = `XComNarrativeMoment("FCReportC");
                    break;
                case 3:
                    Narr = `XComNarrativeMoment("FCReportD");
                    break;
                case 4:
                    Narr = `XComNarrativeMoment("FCReportF");
                    break;
            }

            Narrative(Narr);
            m_bReportDialogue = true;
        }
    }
}