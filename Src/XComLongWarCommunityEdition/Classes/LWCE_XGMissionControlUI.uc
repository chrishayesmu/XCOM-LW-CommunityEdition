class LWCE_XGMissionControlUI extends XGMissionControlUI;

function AddNotice(EGeoscapeAlert eNotice, optional int iData1, optional int iData2, optional int iData3)
{
    local TMCNotice kNotice;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kNotice.fTimer = 6.0;

    switch (eNotice)
    {
        case eGA_NewItemBuilt:
            Sound().PlaySFX(SNDLIB().SFX_Notify_ItemBuilt);
            kTag.IntValue0 = iData2;
            kTag.StrValue0 = `LWCE_ITEM(iData1).strName;
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelItemBuilt);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_FacilityGear;
            break;
        case 54: // Item repairs completed
            kTag.StrValue0 = `LWCE_ITEM(iData1, eTransaction_Sell).strName;
            kNotice.txtNotice.StrValue = class'XComLocalizer'.static.ExpandString(m_strSpeakSatDestroyed);
            kNotice.txtNotice.iState = eUIState_Warning;
            kNotice.imgNotice.iImage = eImage_FacilityGear;
            break;
        default:
            super.AddNotice(eNotice, iData1, iData2, iData3);
            return;
    }

    Mod_AddNotice(kNotice);
}

function Mod_AddNotice(TMCNotice kNotice)
{
    if (m_arrNotices.Length == 0)
    {
        m_arrNotices.AddItem(kNotice);
        UpdateView();
    }
    else
    {
        if (m_arrNotices.Length <= 3)
        {
            m_arrNotices.InsertItem(0, kNotice);
            UpdateView();
        }
    }
}

function BuildEventOptions()
{
    local int iEvent, iDays;
    local LWCE_TFoundryTech kFoundryTech;
    local LWCE_TTech kTech;
    local TMCEvent kOption;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    for (iEvent = 0; iEvent < m_kEvents.arrEvents.Length; iEvent++)
    {
        iDays = m_kEvents.arrEvents[iEvent].iHours / 24;

        if ((m_kEvents.arrEvents[iEvent].iHours % 24) > 0)
        {
            iDays += 1;
        }

        if (ISCONTROLLED() && m_kEvents.arrEvents[iEvent].EEvent == 0 && m_kEvents.arrEvents[iEvent].iData == 1)
        {
            iDays = (START_DAY + 7) - GEOSCAPE().m_kDateTime.GetDay();
        }

        if (iDays < 0)
        {
            iDays = 0;
        }

        switch (m_kEvents.arrEvents[iEvent].EEvent)
        {
            case eHQEvent_Research:
                kTech = `LWCE_TECH(m_kEvents.arrEvents[iEvent].iData);

                kOption.iEventType = eHQEvent_Research;
                kOption.iPriority = 5;
                kOption.imgOption.iImage = eImage_OldResearch;
                kOption.txtOption.StrValue = kTech.strName;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 200, 0, byte(175 / 3));
                break;
            case eHQEvent_ItemProject:
                kOption.iEventType = eHQEvent_ItemProject;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldManufacture;
                kOption.txtOption.StrValue = `LWCE_ITEM(m_kEvents.arrEvents[iEvent].iData).strName;

                if (m_kEvents.arrEvents[iEvent].iData2 > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ string(m_kEvents.arrEvents[iEvent].iData2) $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 100, 0, byte(175 / 3));
                break;
            case eHQEvent_Facility:
                kOption.iEventType = eHQEvent_Facility;
                kOption.iPriority = 3;
                kOption.imgOption.iImage = eImage_OldManufacture;
                kOption.txtOption.StrValue = Facility(m_kEvents.arrEvents[iEvent].iData).strName;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(100, 100, 100, byte(175 / 3));
                break;
            case eHQEvent_Foundry:
                kFoundryTech = `LWCE_FTECH(m_kEvents.arrEvents[iEvent].iData);

                kOption.iEventType = eHQEvent_Foundry;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = 106;
                kOption.txtOption.StrValue = kFoundryTech.strName;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 200, 0, byte(175 / 3));
                break;
            case eHQEvent_Hiring:
                kOption.iEventType = eHQEvent_Hiring;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strNewSoldierEvent;

                if (m_kEvents.arrEvents[iEvent].iData2 > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ string(m_kEvents.arrEvents[iEvent].iData2) $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_InterceptorOrdering:
                kTag.StrValue0 = Continent(m_kEvents.arrEvents[iEvent].iData).GetName();
                kOption.iEventType = eHQEvent_InterceptorOrdering;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldInterception;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNewInterceptors);

                if (m_kEvents.arrEvents[iEvent].iData2 > 1)
                {
                    kOption.txtOption.StrValue @= "(" $ string(m_kEvents.arrEvents[iEvent].iData2) $ ")";
                }

                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_SatOperational:
                kTag.StrValue0 = Country(m_kEvents.arrEvents[iEvent].iData).GetName();
                kOption.iEventType = eHQEvent_SatOperational;
                kOption.iPriority = 2;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelSatOperational);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_ShipTransfers:
                kTag.StrValue0 = Continent(m_kEvents.arrEvents[iEvent].iData).GetName();
                kOption.iEventType = eHQEvent_ShipTransfers;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldInterception;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelShipTransfer);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_FCRequest:
                kTag.StrValue0 = Continent(m_kEvents.arrEvents[iEvent].iData).GetName();
                kOption.iAdditionalData = m_kEvents.arrEvents[iEvent].iData;
                kOption.iEventType = eHQEvent_FCRequest;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldInterception;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCRequest);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_PsiTraining:
                kOption.iEventType = eHQEvent_PsiTraining;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strLabelPsiTesting;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));

                // I guess the PsiTraining event is also used for AI events? This code seems correct from the bytecode anyway
                if (XComHeadquartersCheatManager(GetALocalPlayerController().CheatManager) != none)
                {
                    if (XComHeadquartersCheatManager(GetALocalPlayerController().CheatManager).bDebugAIEvents)
                    {
                        if (m_kEvents.arrEvents[iEvent].iData != 0)
                        {
                            kOption.imgOption.iImage = 0;
                            switch (m_kEvents.arrEvents[iEvent].iData)
                            {
                                case 3:
                                    kOption.txtOption.StrValue = "UFO Crash in" @ Country(m_kEvents.arrEvents[iEvent].iData2).GetName();
                                    break;
                                case 12:
                                    kOption.txtOption.StrValue = "OVERSEER in" @ Country(m_kEvents.arrEvents[iEvent].iData2).GetName();
                                    break;
                                case 7:
                                    kOption.txtOption.StrValue = "Hunting Satellite in" @ Country(m_kEvents.arrEvents[iEvent].iData2).GetName();
                                    break;
                                case 4:
                                    kOption.txtOption.StrValue = "UFO Landing in" @ Country(m_kEvents.arrEvents[iEvent].iData2).GetName();
                                    break;
                                case 2:
                                    kOption.txtOption.StrValue = "Abduction in" @ Country(m_kEvents.arrEvents[iEvent].iData2).GetName();
                                    break;
                                case 9:
                                    kOption.txtOption.StrValue = "Terror in" @ Country(m_kEvents.arrEvents[iEvent].iData2).GetName();
                                    break;
                                case 11:
                                    kOption.txtOption.StrValue = "Funding Council Mission";
                                    break;
                            }
                        }
                    }
                }

                break;
            case eHQEvent_GeneModification:
                kOption.iEventType = eHQEvent_GeneModification;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strLabelGeneModification;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_CyberneticModification:
                kOption.iEventType = eHQEvent_CyberneticModification;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strLabelCyberneticModification;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_MecRepair:
                kTag.StrValue0 = Item(m_kEvents.arrEvents[iEvent].iData).strName;
                kOption.iEventType = eHQEvent_MecRepair;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldManufacture;
                kOption.txtOption.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelMecRepair);
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_EndOfMonth:
                kOption.iEventType = eHQEvent_EndOfMonth;
                kOption.iPriority = 4;
                kOption.imgOption.iImage = eImage_OldFunding;
                kOption.txtOption.StrValue = m_strLabelCouncilReport;
                kOption.txtOption.iState = eUIState_Warning;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(0, 0, 200, byte(175 / 3));
                break;
            case eHQEvent_CovertOperative:
                kOption.iEventType = eHQEvent_CovertOperative;
                kOption.iPriority = 2;
                kOption.imgOption.iImage = eImage_OldSoldier;
                kOption.txtOption.StrValue = m_strLabelCovertOperative;
                kOption.txtDays.StrValue = string(iDays);
                kOption.clrOption = MakeColor(200, 0, 200, byte(175 / 3));
                break;
        }

        m_kEvents.arrOptions.AddItem(kOption);
    }

    m_kEvents.iHighlight = -1;
}

event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}

function UpdateAlert()
{
    local LWCE_TFoundryTech kFoundryTech;
    local LWCE_TItem kItem;
    local LWCE_TTech kTech;
    local TGeoscapeAlert kGeoAlert;
    local TMCAlert kAlert;
    local TLabeledText txtLabel;
    local TText txtTemp;
    local XGShip_UFO kUFO;
    local TMenuOption kReply;
    local XGMission kMission;
    local XGShip_Dropship kSkyranger;
    local XGContinent kContinent;
    local XGParamTag kTag;
    local XGCountryTag kCountryTag;
    local XGStrategySoldier kSoldier;

    if (!GEOSCAPE().HasAlerts())
    {
        return;
    }

    kGeoAlert = GEOSCAPE().GetTopAlert();
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kCountryTag = new class'XGCountryTag';

    switch (kGeoAlert.eType)
    {
        case eGA_UFODetected:
            kUFO = AI().GetUFO(kGeoAlert.arrData[0]);

            if (kUFO.GetType() == eShip_UFOEthereal && !HQ().m_kMC.m_bDetectedOverseer)
            {
            }
            else
            {
                Sound().PlaySFX(SNDLIB().SFX_Alert_UFOContact);
            }

            Narrative(`XComNarrativeMoment("RoboHQ_ContactDetected"));

            kAlert.txtTitle.StrValue = m_strLabelRadarContact;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldAssault;

            txtLabel.strLabel = m_strLabelContact;
            txtLabel.StrValue = m_strLabelUFOPrefix $ string(kUFO.m_iCounter);
            txtLabel.iState = eUIState_Warning;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelLocation;
            txtLabel.StrValue = Country(kUFO.GetCountry()).GetName();
            txtLabel.StrValue $= kUFO.GetAltitudeString();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelSize;
            txtLabel.StrValue = kUFO.GetSizeString();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelUFOClass;

            if (GEOSCAPE().CanIdentifyCraft(kUFO.GetType()))
            {
                kAlert.imgAlert2.iImage = kUFO.m_kTShip.iImage;
                txtLabel.StrValue = kUFO.m_kTShip.strName;
                txtLabel.iState = eUIState_Highlight;
            }
            else
            {
                kAlert.imgAlert2.iImage = eImage_MCUFOScramble;
                txtLabel.StrValue = m_strLabelUnidentified;
                txtLabel.iState = eUIState_Bad;
            }
            kAlert.arrLabeledText.AddItem(txtLabel);

            if (HQ().IsHyperwaveActive())
            {
                txtLabel.strLabel = m_strLabelAlienObjective;
                txtLabel.StrValue = kUFO.m_kObjective.m_kTObjective.strName;
                kAlert.arrLabeledText.AddItem(txtLabel);
            }

            if (HANGAR().GetNumInterceptorsInRangeAndAvailable(kUFO) == 0)
            {
                kReply.strText = m_strLabelInterceptorsUnavailable;
                kReply.iState = eUIState_Disabled;
            }
            else
            {
                kReply.strText = m_strLabelScrambleInterceptors;
                kReply.iState = eUIState_Normal;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnoreContact;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kUFO.GetCoords());

            break;
        case eGA_UFOLanded:
            Sound().PlaySFX(SNDLIB().SFX_Alert_UFOLanded);

            kUFO = XGMission_UFOLanded(GEOSCAPE().GetMission(kGeoAlert.arrData[0])).kUFO;
            kMission = XGMission_UFOLanded(GEOSCAPE().GetMission(kGeoAlert.arrData[0]));

            if (kMission.m_kDesc.m_strMapName == "EWI_HQAssault_MP (Airbase Defense)")
            {
                kTag.StrValue0 = m_strLabelUFOPrefix $ string(kUFO.m_iCounter);
                kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelMissionCounter);
                kAlert.txtTitle.iState = eUIState_Warning;
                kAlert.imgAlert.iImage = eImage_OldUFO;

                txtLabel.strLabel = m_strLabelLocation;
                txtLabel.StrValue = kMission.GetLocationString();
                txtLabel.iState = eUIState_Highlight;
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelNoInterceptors;
                txtLabel.StrValue = string(HANGAR().GetNumInterceptors(kMission.m_iContinent)) @ m_strLabelNewHire;
                txtLabel.iState = eUIState_Warning;
                kAlert.arrLabeledText.AddItem(txtLabel);

                kAlert.imgAlert2.iImage = eImage_MCUFOLanded;
                txtLabel.strLabel = m_strLabelSignatureIdentified;
                txtLabel.iState = eUIState_Warning;
                txtLabel.StrValue = m_strLabelGeneModBody;
                txtLabel.iState = eUIState_Warning;
                kAlert.arrLabeledText.AddItem(txtLabel);

                if (HQ().IsHyperwaveActive())
                {
                    txtLabel.strLabel = m_strLabelAlienObjective;
                    txtLabel.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelMissionCounter);
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienCrewSize;
                    txtLabel.StrValue = string(kMission.GetEnemyCount());
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienSpecies;
                    txtLabel.StrValue = kMission.GetSpeciesList();
                    kAlert.arrLabeledText.AddItem(txtLabel);
                }

                PRES().CAMLookAtEarth(kMission.GetCoords());
            }
            else
            {
                kTag.StrValue0 = m_strLabelUFOPrefix $ string(kUFO.m_iCounter);
                kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelUFOHasLanded);
                kAlert.txtTitle.iState = eUIState_Warning;
                kAlert.imgAlert.iImage = eImage_OldUFO;
                txtLabel.strLabel = m_strLabelContact;
                txtLabel.StrValue = m_strLabelUFOPrefix $ string(kUFO.m_iCounter);
                txtLabel.iState = eUIState_Warning;
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelLocation;
                txtLabel.StrValue = kMission.GetLocationString();
                txtLabel.iState = eUIState_Highlight;
                kAlert.arrLabeledText.AddItem(txtLabel);

                kAlert.imgAlert2.iImage = eImage_MCUFOLanded;
                txtLabel.strLabel = m_strLabelUFOClass;
                txtLabel.iState = eUIState_Warning;

                if (GEOSCAPE().CanIdentifyCraft(kUFO.GetType()))
                {
                    txtLabel.StrValue = kUFO.m_kTShip.strName;
                    txtLabel.iState = eUIState_Highlight;
                }
                else
                {
                    txtLabel.StrValue = m_strLabelUnidentified;
                    txtLabel.iState = eUIState_Bad;
                }

                kAlert.arrLabeledText.AddItem(txtLabel);

                if (HQ().IsHyperwaveActive())
                {
                    txtLabel.strLabel = m_strLabelAlienObjective;
                    txtLabel.StrValue = kUFO.m_kObjective.m_kTObjective.strName;
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienCrewSize;
                    txtLabel.StrValue = string(kMission.GetEnemyCount());
                    kAlert.arrLabeledText.AddItem(txtLabel);

                    txtLabel.strLabel = m_strLabelAlienSpecies;
                    txtLabel.StrValue = kMission.GetSpeciesList();
                    kAlert.arrLabeledText.AddItem(txtLabel);

                }

                PRES().CAMLookAtEarth(kUFO.GetCoords());
            }

            kReply.strText = m_strLabelSendSkyranger;

            if (HANGAR().m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_UFOCrash:
            kMission = XGMission_UFOCrash(GEOSCAPE().GetMission(kGeoAlert.arrData[0]));
            kAlert.txtTitle.StrValue = m_strLabelUFOCrashSite;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldUFO;
            txtLabel.strLabel = m_strLabelContact;
            txtLabel.StrValue = m_strLabelUFOPrefix $ string(XGMission_UFOCrash(kMission).m_iCounter);
            txtLabel.iState = eUIState_Warning;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelLocation;
            txtLabel.StrValue = kMission.GetLocationString();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kAlert.imgAlert2.iImage = eImage_MCUFOCrash;
            txtLabel.strLabel = m_strLabelUFOClass;
            txtLabel.iState = eUIState_Warning;

            if (GEOSCAPE().CanIdentifyCraft(EShipType(XGMission_UFOCrash(kMission).m_iUFOType)))
            {
                txtLabel.StrValue = ITEMTREE().GetShip(EShipType(XGMission_UFOCrash(kMission).m_iUFOType)).strName;
                txtLabel.iState = eUIState_Highlight;
            }
            else
            {
                txtLabel.StrValue = m_strLabelUnidentified;
                txtLabel.iState = eUIState_Bad;
            }

            kAlert.arrLabeledText.AddItem(txtLabel);

            if (HQ().IsHyperwaveActive())
            {
                txtLabel.strLabel = m_strLabelAlienObjective;
                txtLabel.StrValue = XGMission_UFOCrash(kMission).m_kUFOObjective.strName;
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelAlienCrewSize;
                txtLabel.StrValue = string(kMission.GetEnemyCount());
                kAlert.arrLabeledText.AddItem(txtLabel);

                txtLabel.strLabel = m_strLabelAlienSpecies;
                txtLabel.StrValue = kMission.GetSpeciesList();
                kAlert.arrLabeledText.AddItem(txtLabel);
            }

            kReply.strText = m_strLabelSendSkyranger;

            if (HANGAR().m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);
            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;

            if (ISCONTROLLED())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case eGA_UFOLost:
            Sound().PlaySFX(SNDLIB().SFX_Alert_UFOLost);

            kAlert.txtTitle.StrValue = (m_strLabelContactLost @ m_strLabelUFOPrefix) $ string(kGeoAlert.arrData[0]);
            kAlert.txtTitle.iState = eUIState_Warning;

            txtTemp.StrValue = m_strLabelLostContactRequestOrder;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelRecallInterceptors;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_SatelliteDestroyed:
            Sound().PlaySFX(SNDLIB().SFX_Alert_SatelliteLost);

            kContinent = Continent(Country(kGeoAlert.arrData[0]).GetContinent());

            kAlert.txtTitle.StrValue = m_strLabelStatCountryDestroyed;
            kAlert.txtTitle.iState = eUIState_Warning;

            kTag.StrValue0 = Country(kGeoAlert.arrData[0]).GetNameWithArticle();
            kTag.StrValue1 = kContinent.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelLostSatFundingSuspending);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kTag.StrValue0 = kContinent.GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strPanicIncrease);
            txtTemp.iState = eUIState_Bad;
            kAlert.arrText.AddItem(txtTemp);

            if (kContinent.GetNumSatellites() == kContinent.m_arrSatBonuses.Length - 1 && kContinent.GetID() != HQ().m_iContinent)
            {
                kTag.StrValue0 = kContinent.GetBonus().strTitle;
                txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelBonusLost);
                txtTemp.iState = eUIState_Bad;
                kAlert.arrText.AddItem(txtTemp);
            }

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(Country(kGeoAlert.arrData[0]).GetCoords());

            break;
        case eGA_FCMissionActivity:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            txtTemp.StrValue = m_strLabelFCPresenceRequest;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_ExaltMissionActivity:
            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0]);
            kCountryTag.kCountry = Country(kGeoAlert.arrData[0]);

            kAlert.txtTitle.StrValue = m_strLabelExaltActivityTitle;
            kAlert.txtTitle.iState = eUIState_Warning;

            txtTemp.StrValue = m_strLabelExaltActivitySubtitles[kGeoAlert.arrData[1]];
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = Country(kGeoAlert.arrData[0]).GetNameWithArticle();
            kAlert.arrText.AddItem(txtTemp);

            m_eCountryFromExaltSelection = kGeoAlert.arrData[0];
            txtTemp.StrValue = m_arrExaltReasons[kGeoAlert.arrData[1]];

            if (kGeoAlert.arrData[1] == 1)
            {
                kTag.StrValue0 = class'UIUtilities'.static.GetHTMLColoredText(ConvertCashToString(kGeoAlert.arrData[2]), 6);
                txtTemp.StrValue = class'XComLocalizer'.static.ExpandStringByTag(txtTemp.StrValue, kCountryTag) $ "\n\n";
            }

            txtTemp.StrValue $= m_strLabelExaltActivityBody;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = string(Country(kGeoAlert.arrData[0]).GetPanicBlocks());
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = string(kGeoAlert.arrData[1]);
            kAlert.arrText.AddItem(txtTemp);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[1];

            kReply.strText = m_strLabelExaltSelSitRoom;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelExaltSelNotNow;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            GEOSCAPE().ShowHoloEarth();
            GEOSCAPE().Pause();
            PRES().CAMLookAtEarth(Country(kGeoAlert.arrData[0]).GetCoords());
            GEOSCAPE().PulseCountry(ECountry(kMission.GetCountry()), MakeColor(192, 0, 0, 255), MakeColor(255, 128, 0, 255), 0.750);

            break;
        case eGA_ExaltResearchHack:
            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0]);
            kCountryTag.kCountry = Country(kGeoAlert.arrData[0]);

            kAlert.txtTitle.StrValue = m_strLabelExaltActivityTitle;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = kGeoAlert.arrData[1];

            txtTemp.StrValue = m_strLabelExaltActivitySubtitles[kGeoAlert.arrData[1]];
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = m_arrExaltReasons[kGeoAlert.arrData[1]];
            kTag.IntValue0 = kGeoAlert.arrData[2] + kGeoAlert.arrData[3];
            kTag.IntValue1 = kGeoAlert.arrData[3];
            kTag.IntValue2 = kGeoAlert.arrData[2] / 24;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandStringByTag(txtTemp.StrValue, kCountryTag);
            kAlert.arrText.AddItem(txtTemp);

            kTag.IntValue0 = HQ().GetNumFacilities(eFacility_ScienceLab);
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelResearchHackNumLabs);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = "";
            kAlert.arrText.AddItem(txtTemp);

            txtLabel.strLabel = m_strLabelResearchHackTimeLost;

            if ((kGeoAlert.arrData[2] + kGeoAlert.arrData[3]) < 24)
            {
                txtLabel.StrValue = string(kGeoAlert.arrData[2] + kGeoAlert.arrData[3]);

                if (GetLanguage() == "KOR" || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetHoursString(kGeoAlert.arrData[2] + kGeoAlert.arrData[3]);
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetHoursString(kGeoAlert.arrData[2] + kGeoAlert.arrData[3]);
                }
            }
            else
            {
                txtLabel.StrValue = string((kGeoAlert.arrData[2] + kGeoAlert.arrData[3]) / 24);

                if ((GetLanguage() == "KOR") || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetDaysString(kGeoAlert.arrData[2] + (kGeoAlert.arrData[3] / 24));
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetDaysString((kGeoAlert.arrData[2] + kGeoAlert.arrData[3]) / 24);
                }
            }

            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelResearchHackDataBackup;
            txtLabel.StrValue = string(HQ().GetNumFacilities(eFacility_ScienceLab) * 20) $ "%";
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelResearchHackTotalTimeLost;

            if (kGeoAlert.arrData[2] < 24)
            {
                txtLabel.StrValue = string(kGeoAlert.arrData[2]);

                if ((GetLanguage() == "KOR") || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetHoursString(kGeoAlert.arrData[2] + kGeoAlert.arrData[3]);
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetHoursString(kGeoAlert.arrData[2] + kGeoAlert.arrData[3]);
                }
            }
            else
            {
                txtLabel.StrValue = string(kGeoAlert.arrData[2] / 24);

                if ((GetLanguage() == "KOR") || GetLanguage() == "JPN")
                {
                    txtLabel.StrValue $= class'UIUtilities'.static.GetDaysString(kGeoAlert.arrData[2] + (kGeoAlert.arrData[3] / 24));
                }
                else
                {
                    txtLabel.StrValue @= class'UIUtilities'.static.GetDaysString((kGeoAlert.arrData[2] + kGeoAlert.arrData[3]) / 24);
                }
            }

            kAlert.arrLabeledText.AddItem(txtLabel);

            kReply.strText = m_strLabelExaltSelSitRoom;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelExaltSelNotNow;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            GEOSCAPE().ShowHoloEarth();
            GEOSCAPE().Pause();
            PRES().CAMLookAtEarth(Country(kGeoAlert.arrData[0]).GetCoords());
            GEOSCAPE().PulseCountry(ECountry(kMission.GetCountry()), MakeColor(192, 0, 0, 255), MakeColor(255, 128, 0, 255), 0.750);

            break;
        case eGA_ExaltAlert:
            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0]);
            kAlert.txtTitle.StrValue = m_strLabelExaltAlertTitle;

            txtTemp.StrValue = m_strLabelExaltAlertBody;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelExaltAlertSendSquad;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelExaltAlertNotNow;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_FCActivity:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;
            txtTemp.StrValue = m_strLabelFCPresenceRequest;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_FCJetTransfer:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            kTag.StrValue0 = Country(kGeoAlert.arrData[0]).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCFinishedJetTransfer);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_FCSatCountry:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            kTag.StrValue0 = Country(kGeoAlert.arrData[0]).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCFinishedSatCountry);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_FCExpiredRequest:
            kAlert.txtTitle.StrValue = m_strLabelIncFCCom;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            kTag.StrValue0 = Country(kGeoAlert.arrData[0]).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFCRequestExpired);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_ModalNotify:
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.txtTitle.StrValue = m_strLabelPriorityAlert;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_XComBadge;
            kAlert.imgAlert2.iImage = eImage_XComBadge;

            txtTemp.StrValue = m_strLabelCommanderUrgentNews;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            PRES().Speak(m_strSpeakIncTransmission, 6);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelGoSituationRoom;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_DropArrive:
            Sound().PlaySFX(SNDLIB().SFX_Alert_DropArrive);
            kAlert.txtTitle.StrValue = m_strLabelVisualContact;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldAssault;
            kAlert.imgAlert2.iImage = eImage_MCUFOCrash;

            kSkyranger = HANGAR().m_kSkyranger;
            kTag.StrValue0 = kSkyranger.GetCallsign();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strSkyRangerArrivedSite);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelBeginAssault;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            if (ISCONTROLLED())
            {
                kReply.iState = eUIState_Disabled;
            }

            kReply.strText = m_strLabelReturnToBase;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kSkyranger.m_kMission.GetCoords());

            break;
        case eGA_Abduction:
            Sound().PlaySFX(SNDLIB().SFX_Alert_Abduction);

            kAlert.txtTitle.StrValue = m_strLabelAbductionsReported;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldTerror;
            kReply.strText = m_strLabelViewAbductionSites;

            if (HANGAR().m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;

            if (ISCONTROLLED())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            m_bNarrFilteringAbduction = true;

            break;
        case eGA_Terror:
            Sound().PlaySFX(SNDLIB().SFX_Alert_Terror);

            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0]);

            txtLabel.strLabel = m_strLabelTerrorCity;
            txtLabel.StrValue = kMission.GetCity().GetName();
            kAlert.arrLabeledText.AddItem(txtLabel);

            kAlert.iNumber = Country(kMission.GetCountry()).GetPanicBlocks();
            txtLabel.strLabel = m_strLabelPanicLevel;
            kAlert.arrLabeledText.AddItem(txtLabel);

            txtLabel.strLabel = m_strLabelDifficulty;
            txtLabel.StrValue = GetMissionDiffString(eMissionDiff_VeryHard);
            kAlert.arrLabeledText.AddItem(txtLabel);

            kReply.strText = m_strLabelSendSkyranger;

            if (HANGAR().m_kSkyranger.IsFlying())
            {
                kReply.iState = eUIState_Disabled;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case eGA_FCMission:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);

            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0]);

            kAlert.txtTitle.StrValue = m_strLabelFCMission @ XGMission_FundingCouncil(kMission).m_kTMission.strName;
            kAlert.txtTitle.iState = eUIState_Warning;
            kAlert.imgAlert.iImage = eImage_OldFunding;

            txtTemp.StrValue = m_strLabelLocation @ kMission.GetLocationString();
            txtTemp.iState = eUIState_Normal;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelSendSkyranger;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelIgnore;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case eGA_SecretPact:
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[0];
            kAlert.iNumber = World().m_iNumCountriesLost;

            txtLabel.strLabel = Country(kGeoAlert.arrData[0]).GetName();
            txtLabel.StrValue = m_strLabelCountrySignedPactLabel;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = Country(kGeoAlert.arrData[0]).GetName();
            kTag.StrValue1 = Continent(Country(kGeoAlert.arrData[0]).GetContinent()).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelCountryCountLeave);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = m_strLabelDoomTrackerTitle;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_CountryPanic:
            Sound().PlaySFX(SNDLIB().SFX_Alert_PanicRising);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[0];
            kTag.StrValue0 = Country(kGeoAlert.arrData[0]).GetName();
            kAlert.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelPanicCountry);
            kAlert.txtTitle.iState = eUIState_Bad;

            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelPanicCountryLeave);
            txtTemp.iState = eUIState_Bad;
            kAlert.arrText.AddItem(txtTemp);

            kAlert.iNumber = Country(kGeoAlert.arrData[0]).GetPanicBlocks();
            txtTemp.StrValue = m_strLabelPanicLevel;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(Country(kGeoAlert.arrData[0]).GetCoords());

            break;
        case eGA_AlienBase:
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0]);

            kAlert.txtTitle.StrValue = m_strLabelAssaultAlienBase;
            kAlert.txtTitle.iState = eUIState_Bad;
            kAlert.imgAlert.iImage = eImage_AlienBase;
            kAlert.imgAlert2.iImage = eImage_None;
            kReply.iState = eUIState_Normal;

            if (STORAGE().GetNumItemsAvailable(eItem_Skeleton_Key) == 0)
            {
                txtTemp.StrValue = m_strLabelSkeletonKey;
                txtTemp.iState = eUIState_Bad;
                kAlert.arrText.AddItem(txtTemp);
                kReply.iState = eUIState_Disabled;
            }

            txtLabel.strLabel = m_strLabelLocation;
            txtLabel.StrValue = Country(kMission.GetCountry()).GetName();
            txtLabel.iState = eUIState_Highlight;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kReply.strText = m_strLabelAssault;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strlabelWait;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case eGA_Temple:
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kMission = GEOSCAPE().GetMission(kGeoAlert.arrData[0]);

            kAlert.txtTitle.StrValue = m_strLabelAssaultTempleShip;
            kAlert.txtTitle.iState = eUIState_Bad;
            kAlert.imgAlert.iImage = eImage_AlienBase;
            kAlert.imgAlert2.iImage = eImage_None;

            txtTemp.StrValue = m_strLabelTempleShip;
            txtTemp.iState = eUIState_Bad;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelAssault;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strlabelWait;
            kReply.iState = eUIState_Normal;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            PRES().CAMLookAtEarth(kMission.GetCoords());

            break;
        case eGA_PayDay:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FundingCouncil);
            GEOSCAPE().ClearTopAlert();

            if (!GEOSCAPE().HasAlerts())
            {
                GoToView(eMCView_MainMenu);
            }

            if (GEOSCAPE().IsScanning())
            {
                OnCancelScan();
            }

            PRES().UIWorldReport();

            break;
        case eGA_ResearchCompleted:
            Sound().PlaySFX(SNDLIB().SFX_Alert_ResearchComplete);

            kTech = `LWCE_TECH(kGeoAlert.arrData[0]);

            kAlert.txtTitle.StrValue = kTech.strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.strPath = kTech.ImagePath;

            kTag.StrValue0 = kTech.strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelTechResearchComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelAssignNewResearch;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;

            if (ISCONTROLLED())
            {
                kReply.iState = eUIState_Disabled;
            }
            else
            {
                kReply.iState = eUIState_Normal;
            }

            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_ItemProjectCompleted:
            Sound().PlaySFX(SNDLIB().SFX_Alert_ItemProjectComplete);
            kItem = `LWCE_ITEM(kGeoAlert.arrData[0]);

            kAlert.txtTitle.StrValue = kItem.strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.strPath = kItem.ImagePath;

            kTag.StrValue0 = kItem.strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelManufactureItemComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            if (ENGINEERING().HasRebate())
            {
                if (ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2]].iAlloys > 0 || ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2]].iElerium > 0)
                {
                    txtTemp.StrValue = m_strLabelWorkshopRebate;
                    txtTemp.iState = eUIState_Warning;
                    kAlert.arrText.AddItem(txtTemp);

                    if (ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2]].iAlloys > 0)
                    {
                        txtTemp.StrValue = string(ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2]].iAlloys) @ (GetResourceLabel(eResource_Alloys));
                        txtTemp.iState = eUIState_Alloys;
                        kAlert.arrText.AddItem(txtTemp);
                    }

                    if (ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2]].iElerium > 0)
                    {
                        txtTemp.StrValue = string(ENGINEERING().m_arrOldRebates[kGeoAlert.arrData[2]].iElerium) @ (GetResourceLabel(eResource_Elerium));
                        txtTemp.iState = eUIState_Elerium;
                        kAlert.arrText.AddItem(txtTemp);
                    }
                }
            }

            kReply.strText = m_strLabelAssignNewProjects;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_NewFacilityBuilt:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FacilityComplete);
            FacilityNarrative(EFacilityType(kGeoAlert.arrData[0]));

            if (kGeoAlert.arrData[0] != eFacility_AccessLift)
            {
                if (HQ().m_arrFacilityBinks[kGeoAlert.arrData[0]] == 0)
                {
                    HQ().m_arrFacilityBinks[kGeoAlert.arrData[0]] = 1;
                    PRES().PlayCinematic(eCinematic_FacilityReward, kGeoAlert.arrData[0]);
                }
            }

            kAlert.txtTitle.StrValue = Facility(kGeoAlert.arrData[0]).strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = Facility(kGeoAlert.arrData[0]).iImage;

            kTag.StrValue0 = Facility(kGeoAlert.arrData[0]).strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelConstructItemFacilityComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelAssignNewConstruction;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_Augmentation:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FacilityComplete);

            kAlert.txtTitle.StrValue = m_strLabelAugmentTitle;
            kAlert.txtTitle.iState = eUIState_Normal;

            kSoldier = BARRACKS().GetSoldierByID(kGeoAlert.arrData[0]);
            kTag.StrValue0 = kSoldier.GetName(eNameType_RankFull);
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelAugmentBody);
            txtTemp.iState = eUIState_Normal;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelGotoBuildMec;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_FoundryProjectCompleted:
            Sound().PlaySFX(SNDLIB().SFX_Alert_FoundryProjectComplete);

            kFoundryTech = `LWCE_FTECH(kGeoAlert.arrData[0]);

            kAlert.txtTitle.StrValue = kFoundryTech.strName;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.strPath = kFoundryTech.ImagePath;

            kTag.StrValue0 = kFoundryTech.strName;
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelFoundryItemComplete);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelAssignNewProjects;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);
            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_PsiTraining:
            Sound().PlaySFX(SNDLIB().SFX_Alert_PsiTrainingComplete);

            kAlert.txtTitle.StrValue = m_strLabelMessageFromPsiLabs;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = eImage_OldSoldier;
            kAlert.imgAlert2.iImage = eImage_Soldier;

            txtTemp.StrValue = m_strLabelPsionicTestingRoundComplete;
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelViewResults;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            if (!PSILABS().m_bSubjectZeroCinematic)
            {
                kReply.strText = m_strLabelCarryOn;
                kAlert.mnuReplies.arrOptions.AddItem(kReply);
            }

            break;
        case eGA_NewSoldiers:
            Sound().PlaySFX(SNDLIB().SFX_Notify_SoldiersArrived);
            kAlert.txtTitle.StrValue = m_strLabelMessageFormBarracks;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = eImage_OldSoldier;
            kAlert.imgAlert2.iImage = eImage_Soldier;

            kTag.IntValue0 = kGeoAlert.arrData[0];
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNumRookiesArrived);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelVisitBarracks;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_NewEngineers:
            Sound().PlaySFX(SNDLIB().SFX_Notify_SoldiersArrived);

            kAlert.txtTitle.StrValue = m_strLabelMessageFromEngineering;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = eImage_OldManufacture;
            kAlert.imgAlert2.iImage = eImage_Engineer;

            kTag.IntValue0 = kGeoAlert.arrData[0];
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNumEngineersArrived);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelVisitEngineering;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_NewScientists:
            Sound().PlaySFX(SNDLIB().SFX_Notify_SoldiersArrived);

            kAlert.txtTitle.StrValue = m_strLabelMessageFromLabs;
            kAlert.txtTitle.iState = eUIState_Good;
            kAlert.imgAlert.iImage = eImage_OldResearch;
            kAlert.imgAlert2.iImage = eImage_Scientist;

            kTag.IntValue0 = kGeoAlert.arrData[0];
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelNumScientistsArrived);
            txtTemp.iState = eUIState_Highlight;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelVisitLabs;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            kReply.strText = m_strLabelCarryOn;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_ExaltRaidFailCountry:
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[0];
            kAlert.iNumber = World().m_iNumCountriesLost;

            txtLabel.strLabel = Country(kGeoAlert.arrData[0]).GetName();
            txtLabel.StrValue = m_strLabelExaltRaidCountryFailSubtitle;
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = Country(kGeoAlert.arrData[0]).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidCountryFailLeft);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = m_strLabelDoomTrackerTitle;
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case eGA_ExaltRaidFailContinent:
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = kGeoAlert.arrData[0];

            txtLabel.strLabel = m_strLabelExaltRaidContinentFailTitle;
            txtLabel.StrValue = "";
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = Country(kGeoAlert.arrData[0]).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidContinentFailDesc);
            kAlert.arrText.AddItem(txtTemp);

            txtTemp.StrValue = "";
            kAlert.arrText.AddItem(txtTemp);

            kTag.StrValue0 = string(kGeoAlert.arrData[1]);
            kTag.StrValue1 = Continent(Country(kGeoAlert.arrData[0]).GetContinent()).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidContinentFailPanic);
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case 53: // Air base defense lost
            Sound().PlaySFX(SNDLIB().SFX_Alert_UrgentMessage);

            kAlert.imgAlert.iImage = Continent(kGeoAlert.arrData[0]).GetRandomCouncilCountry();

            txtLabel.strLabel = "";
            txtLabel.StrValue = "";
            kAlert.arrLabeledText.AddItem(txtLabel);

            kTag.StrValue0 = Continent(kGeoAlert.arrData[0]).GetName();
            txtTemp.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelExaltRaidContinentFailSubtitle);
            kAlert.arrText.AddItem(txtTemp);

            kReply.strText = m_strLabelOk;
            kAlert.mnuReplies.arrOptions.AddItem(kReply);

            break;
        case class'LWCE_XGGeoscape'.const.MOD_ALERT_TYPE:
            HandleModAlert(kGeoAlert, kAlert);
            break;
        default:
            // For unrecognized alerts, just get rid of them
            GEOSCAPE().ClearTopAlert();

            if (GEOSCAPE().HasAlerts())
            {
                UpdateView();
            }

            break;
    }

    m_kCurrentAlert = kAlert;
    m_kCurrentAlert.iAlertType = kGeoAlert.eType;
}

protected function HandleModAlert(TGeoscapeAlert kGeoAlert, out TMCAlert kAlert)
{
    local LWCE_XGGeoscape kGeoscape;
    local LWCE_TModAlert kModAlert;

    kGeoscape = `LWCE_GEOSCAPE;

    if (kGeoscape.arrModAlerts.Length == 0)
    {
        return;
    }

    kModAlert = kGeoscape.arrModAlerts[0];
    kGeoscape.arrModAlerts.Remove(0, 1);

    `LWCE_MOD_LOADER.PopulateAlert(kModAlert.iAlertId, kGeoAlert, kAlert);
}