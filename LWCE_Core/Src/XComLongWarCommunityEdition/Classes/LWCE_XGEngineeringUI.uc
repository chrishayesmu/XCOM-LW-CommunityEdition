class LWCE_XGEngineeringUI extends XGEngineeringUI
    dependson(LWCETypes);

struct LWCE_TEngItemTable
{
    var TTableMenu mnuItems;
    var array<LWCE_TObjectSummary> arrSummaries;
    var array<name> arrTabs;
    var array<TText> arrTabText;
    var int m_iCurrentTab;
};

var LWCE_TEngItemTable m_kCETable;

function TTableMenuOption BuildItem(TItem kItem)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildItem);
    return super.BuildItem(kItem);
}

function TTableMenuOption LWCE_BuildItem(LWCEItemTemplate kItem)
{
    local TTableMenuOption kOption;
    local int iCategory, iNumItems, iState;
    local string strCategory;

    for (iCategory = 0; iCategory < m_kCETable.mnuItems.arrCategories.Length; iCategory++)
    {
        iState = eUIState_Normal;
        strCategory = "";

        switch (m_kCETable.mnuItems.arrCategories[iCategory])
        {
            case 2:
                strCategory = kItem.strName;
                iState = eUIState_Normal;

                if (kItem.IsPriority())
                {
                    strCategory @= "-" @ m_strPriority;
                    iState = eUIState_Good;
                }

                break;
            case 4:
                iNumItems = LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable(kItem.GetItemName());

                if (iNumItems > 0)
                {
                    strCategory = string(iNumItems);
                }
                else
                {
                    strCategory = "";
                }

                break;
            case 8:
                if (kItem.kCost.iElerium > 0)
                {
                    strCategory = string(kItem.kCost.iElerium);

                    if (m_iCurrentView == eEngView_Build && kItem.kCost.iElerium > GetResource(eResource_Elerium))
                    {
                        iState = eUIState_Bad;
                    }
                    else
                    {
                        iState = GetResourceUIState(eResource_Elerium);
                    }
                }

                break;
            case 7:
                if (kItem.kCost.iAlloys > 0)
                {
                    strCategory = string(kItem.kCost.iAlloys);

                    if (m_iCurrentView == eEngView_Build && kItem.kCost.iAlloys > (GetResource(eResource_Alloys)))
                    {
                        iState = eUIState_Bad;
                    }
                    else
                    {
                        iState = GetResourceUIState(eResource_Alloys);
                    }
                }

                break;
            case 6:
                if (kItem.kCost.iCash != 0)
                {
                    strCategory = ConvertCashToString(kItem.kCost.iCash);

                    if (m_iCurrentView == eEngView_Build && kItem.kCost.iCash > (GetResource(eResource_Money)))
                    {
                        iState = eUIState_Bad;
                    }
                    else
                    {
                        iState = GetResourceUIState(eResource_Money);
                    }
                }

                break;
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

function TObjectSummary BuildSummary(TItem kItem)
{
    local TObjectSummary kSummary;

    `LWCE_LOG_DEPRECATED_CLS(BuildSummary);

    return kSummary;
}

function LWCE_TObjectSummary LWCE_BuildSummary(LWCEItemTemplate kItem)
{
    local LWCE_TObjectSummary kSummary;

    kSummary.imgObject.strPath = kItem.ImagePath;
    kSummary.txtSummary.StrValue = kItem.strBriefSummary;
    kSummary.txtRequirementsLabel.StrValue = m_strBuildCost;
    kSummary.ItemType = kItem.GetItemName();
    kSummary.bCanAfford = `LWCE_ENGINEERING.LWCE_GetItemCostSummary(kSummary.kCost, kItem.GetItemName(), 1,, false);

    return kSummary;
}

function TTableMenuOption BuildQueueItem(int iQueueSlot)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local TTableMenuOption kOption;
    local LWCE_TItemProject kProject;
    local LWCE_TFoundryProject kFProject;

    kEngineering = `LWCE_ENGINEERING;

    if (kEngineering.m_arrQueue[iQueueSlot].bItem)
    {
        kProject = kEngineering.m_arrCEItemProjects[kEngineering.m_arrQueue[iQueueSlot].iIndex];

        kOption.arrStrings.AddItem("");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(string(kProject.iQuantity - kProject.iQuantityLeft) $ "/" $ string(kProject.iQuantity));
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(`LWCE_ITEM(kProject.ItemName).strName @ "(" $ string(kProject.iQuantity) $ ")");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(kEngineering.LWCE_GetETAString(kProject));

        if (kProject.iEngineers > 0)
        {
            kOption.arrStates.AddItem(eUIState_Warning);
        }
        else
        {
            kOption.arrStates.AddItem(eUIState_Bad);
        }
    }
    else
    {
        kFProject = kEngineering.m_arrCEFoundryProjects[kEngineering.m_arrQueue[iQueueSlot].iIndex];

        kOption.arrStrings.AddItem("");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem("---");
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(m_strFoundryPrefix @ `LWCE_FTECH(kFProject.ProjectName).strName);
        kOption.arrStates.AddItem(eUIState_Normal);

        kOption.arrStrings.AddItem(kEngineering.LWCE_GetFoundryETAString(kFProject));

        if (kFProject.iEngineers > 0)
        {
            kOption.arrStates.AddItem(eUIState_Warning);
        }
        else
        {
            kOption.arrStates.AddItem(eUIState_Bad);
        }
    }

    return kOption;
}

function TItemCard ENGINEERINGUIGetItemCard()
{
    local TItemCard kItemCard;

    `LWCE_LOG_DEPRECATED_CLS(ENGINEERINGUIGetItemCard);

    return kItemCard;
}

function LWCE_TItemCard LWCE_ENGINEERINGUIGetItemCard()
{
    local name ItemName;
    local LWCEItemTemplate kItem;
    local LWCE_TItemCard kItemCard;
    local TShivAbility kShivAbility;

    if (m_iCurrentView == eEngView_Build)
    {
        if (m_kCETable.arrTabText[m_kCETable.m_iCurrentTab].StrValue == m_strCatWeapons || m_kCETable.arrTabText[m_kCETable.m_iCurrentTab].StrValue == m_strCatArmor)
        {
            ItemName = m_kCETable.arrSummaries[m_iCurrentSelection].ItemType;
            return class'LWCE_XGItemCards'.static.BuildItemCard(ItemName);
        }
        else if (m_kCETable.arrTabText[m_kCETable.m_iCurrentTab].StrValue == m_strCatVehicles)
        {
            ItemName = m_kCETable.arrSummaries[m_iCurrentSelection].ItemType;
            kItem = `LWCE_ITEM(ItemName);
            kItemCard.ItemName = ItemName;

            switch (ItemName)
            {
                case 'Item_DefenseMatrix':
                case 'Item_UFOTracking':
                case 'Item_UplinkTargeting':
                    kItemCard.iCardType = eItemCard_InterceptorConsumable;
                    kItemCard.strFlavorText = m_kCETable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue;
                    kItemCard.strName = kItem.strName;
                    break;
                case 'Item_Satellite':
                    kItemCard.iCardType = eItemCard_Satellite;
                    kItemCard.strFlavorText = m_kCETable.arrSummaries[m_iCurrentSelection].txtSummary.StrValue;
                    kItemCard.strName = kItem.strName;
                    break;
                case 'Item_SHIV':
                case 'Item_SHIVAlloy':
                case 'Item_SHIVHover':
                    kItemCard.iCardType = eItemCard_SHIV;
                    kItemCard.strShivWeapon = class'XLocalizedData'.default.m_aItemNames[STORAGE().GetShivWeapon()];

                    switch (ItemName)
                    {
                        case 'Item_SHIVAlloy':
                            kShivAbility.iAbilityID = eAbility_TakeCover;
                            kShivAbility.strName = m_strShivCoverName;
                            kShivAbility.strDesc = m_strShivCoverDesc;

                            kItemCard.arrAbilitiesShiv.AddItem(kShivAbility);
                            break;
                        case 'Item_SHIVHover':
                            kShivAbility.iAbilityID = eAbility_Fly;
                            kShivAbility.strName = m_strShivFlyName;
                            kShivAbility.strDesc = m_strShivFlyDesc;

                            kItemCard.arrAbilitiesShiv.AddItem(kShivAbility);
                            break;
                    }

                    if (`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_SHIVSuppression'))
                    {
                        kShivAbility.iAbilityID = eAbility_ShotSuppress;
                        kShivAbility.strName = m_strShivSuppressName;
                        kShivAbility.strDesc = m_strShivSuppressDesc;

                        kItemCard.arrAbilitiesShiv.AddItem(kShivAbility);
                    }

                    kItemCard.strFlavorText = class'XComLocalizer'.static.ExpandString(kItem.strTacticalText);
                    kItemCard.strName = kItem.strName;
                    break;
                case 'Item_AvalancheMissiles':
                case 'Item_EMPCannon':
                case 'Item_FusionCannon':
                case 'Item_LaserCannon':
                case 'Item_PhoenixCannon':
                case 'Item_PlasmaCannon':
                case 'Item_StingrayMissiles':
                    kItemCard = class'LWCE_XGHangarUI'.static.LWCE_BuildShipWeaponCard(ItemName);
                    break;
                default:
                    ItemName = m_kCETable.arrSummaries[m_iCurrentSelection].ItemType;
                    return class'LWCE_XGItemCards'.static.BuildItemCard(ItemName);
            }
        }
    }

    return kItemCard;
}

function int ENGINEERINGUIGetItemCharges(EItemType eItem, optional bool bForce1_for_NonGrenades = false, optional bool bForItemCardDisplay = false)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function ENGINEERINGUIGetItemCharges was called. This needs to be replaced with LWCEEquipmentTemplate.GetClipSize. Stack trace follows.");
    ScriptTrace();

    return 0;
}

function OnItemTableOption(int iOption)
{
    local array<LWCEItemTemplate> arrItems;

    arrItems = `LWCE_ENGINEERING.LWCE_GetItemsByCategory(m_kCETable.arrTabs[m_kCETable.m_iCurrentTab], GetCurrentTransactionType());
    arrItems.Sort(LWCE_SortItems);

    if (m_iCurrentView == eEngView_Build)
    {
        m_bManufacturing = true;
        `LWCE_HQPRES.LWCE_UIManufactureItem(arrItems[iOption].GetItemName());
        m_bItemBuilt = true;
    }
}

function OnNextTab()
{
    local int iTab, iNextTab;

    for (iTab = m_kCETable.m_iCurrentTab + 1; iTab < m_kCETable.m_iCurrentTab + 1 + m_kCETable.arrTabs.Length; iTab++)
    {
        iNextTab = iTab % m_kCETable.arrTabs.Length;

        if (m_kCETable.arrTabText[iNextTab].iState != eUIState_Disabled)
        {
            `LWCE_LOG_CLS("OnNextTab: iTab = " $ iTab $ ", iNextTab = " $ iNextTab);
            m_kCETable.m_iCurrentTab = iNextTab;
            break;
        }
    }

    UpdateView();
    PlaySmallOpenSound();
}

function OnPreviousTab()
{
    local int iTab, iNextTab;

    for (iTab = m_kCETable.m_iCurrentTab - 1 + m_kCETable.arrTabs.Length; iTab >= m_kCETable.m_iCurrentTab; iTab--)
    {
        iNextTab = iTab % m_kCETable.arrTabs.Length;

        if (m_kCETable.arrTabText[iNextTab].iState != eUIState_Disabled)
        {
            `LWCE_LOG_CLS("OnPreviousTab: iTab = " $ iTab $ ", iNextTab = " $ iNextTab);
            m_kCETable.m_iCurrentTab = iNextTab;
            break;
        }
    }

    UpdateView();
    PlaySmallOpenSound();
}

function OnQueueOption(int iOption)
{
    local int iProjectIndex;

    PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
    GoToView(eEngView_MainMenu);

    m_bManufacturing = true;
    iProjectIndex = ENGINEERING().m_arrQueue[iOption].iIndex;

    if (ENGINEERING().m_arrQueue[iOption].bItem)
    {
        `LWCE_HQPRES.LWCE_UIManufactureItem(`LWCE_ENGINEERING.m_arrCEItemProjects[iProjectIndex].ItemName, iProjectIndex);
    }
    else
    {
        `LWCE_HQPRES.LWCE_UIManufactureFoundry(`LWCE_ENGINEERING.m_arrCEFoundryProjects[iProjectIndex].ProjectName, iProjectIndex);
    }
}

function OnTab(int iTab)
{
    `LWCE_LOG_CLS("OnTab: " $ iTab);

    if (m_kCETable.arrTabText[iTab].iState != eUIState_Disabled)
    {
        m_kCETable.m_iCurrentTab = iTab;
    }

    UpdateView();
    PlaySmallOpenSound();
}

function int SortItems(TItem kItem1, TItem kItem2)
{
    `LWCE_LOG_DEPRECATED_CLS(SortItems);
    return 0;
}

function int LWCE_SortItems(LWCEItemTemplate kItem1, LWCEItemTemplate kItem2)
{
    // Default LW 1.0 sorts by many different criteria depending on category, none of which are very transparent to the player.
    // We just sort priority items at the top, then sort by name.

    if (kItem1.IsPriority())
    {
        return 0;
    }

    if (kItem2.IsPriority())
    {
        return -1;
    }

    if (kItem1.strName <= kItem2.strName)
    {
        return 0;
    }
    else
    {
        return -1;
    }
}

function UpdateHeader()
{
    local LWCE_XGStorage kStorage;
    local TEngHeader kHeader;

    kStorage = LWCE_XGStorage(STORAGE());

    switch (m_iCurrentView)
    {
        case eEngView_MainMenu:
            kHeader.txtTitle.StrValue = m_strHeaderEngineering;
            break;
        case eEngView_Build:
            if (m_kCETable.arrTabText.Length > 0)
            {
                kHeader.txtTitle.StrValue = m_strHeaderBuildItems @ m_kCETable.arrTabText[m_kCETable.m_iCurrentTab].StrValue;
            }

            break;
    }

    kHeader.txtEngineers = GetResourceText(eResource_Engineers);
    kHeader.txtCash = GetResourceText(eResource_Money);

    if (kStorage.LWCE_EverHadItem('Item_Elerium'))
    {
        kHeader.txtElerium = GetResourceText(eResource_Elerium);
    }

    if (kStorage.LWCE_EverHadItem('Item_AlienAlloy'))
    {
        kHeader.txtAlloys = GetResourceText(eResource_Alloys);
    }

    m_kHeader = kHeader;
}

function UpdateItemTable()
{
    local int iTab, iItem;
    local LWCE_XGFacility_Engineering kEngineering;
    local array<LWCEItemTemplate> arrItems;
    local TTableMenuOption kOption;
    local LWCE_TObjectSummary kSummary;

    kEngineering = `LWCE_ENGINEERING;

    UpdateTabs();
    m_kCETable.arrSummaries.Remove(0, m_kCETable.arrSummaries.Length);

    for (iTab = 0; iTab < m_kCETable.arrTabs.Length; iTab++)
    {
        arrItems = kEngineering.LWCE_GetItemsByCategory(m_kCETable.arrTabs[iTab], GetCurrentTransactionType());
        arrItems.Sort(LWCE_SortItems);

        if (arrItems.Length == 0)
        {
            m_kCETable.arrTabText[iTab].iState = eUIState_Disabled;
        }
        else
        {
            m_kCETable.arrTabText[iTab].iState = eUIState_Normal;
        }

        // If the active tab is disabled due to lack of entries, move to the next one
        if (m_kCETable.m_iCurrentTab == iTab && m_kCETable.arrTabText[m_kCETable.m_iCurrentTab].iState == eUIState_Disabled)
        {
            m_kCETable.m_iCurrentTab = (m_kCETable.m_iCurrentTab + 1) % m_kCETable.arrTabs.Length;
        }

        if (iTab == m_kCETable.m_iCurrentTab)
        {
            m_kHeader.txtTitle.StrValue = m_strHeaderBuildItems @ m_kCETable.arrTabText[iTab].StrValue;
            m_kCETable.arrTabText[iTab].iState = eUIState_Highlight;

            for (iItem = 0; iItem < arrItems.Length; iItem++)
            {
                kOption = LWCE_BuildItem(arrItems[iItem]);
                kSummary = LWCE_BuildSummary(arrItems[iItem]);

                if (!kSummary.bCanAfford)
                {
                    kOption.strHelp = kSummary.kCost.strHelp;
                    kOption.iState = eUIState_Disabled;
                }

                m_kCETable.mnuItems.arrOptions.AddItem(kOption);
                m_kCETable.arrSummaries.AddItem(kSummary);
            }
        }
    }
}

function UpdateTabs()
{
    local int iTab;
    local TTableMenu kMenu;

    m_kCETable.arrTabs.Remove(0, m_kCETable.arrTabs.Length);

    if (m_iCurrentView == eEngView_Build)
    {
        m_kCETable.arrTabs.AddItem('Weapon');
        m_kCETable.arrTabs.AddItem('Armor');
        m_kCETable.arrTabs.AddItem('Vehicle');

        kMenu.arrCategories.AddItem(2);
        kMenu.arrCategories.AddItem(4);
    }

    kMenu.kHeader.arrStrings = GetHeaderStrings(kMenu.arrCategories);
    kMenu.kHeader.arrStates = GetHeaderStates(kMenu.arrCategories);
    m_kCETable.arrTabText.Remove(0, m_kCETable.arrTabText.Length);
    m_kCETable.arrTabText.Add(m_kCETable.arrTabs.Length);

    for (iTab = 0; iTab < m_kCETable.arrTabs.Length; iTab++)
    {
        switch (m_kCETable.arrTabs[iTab])
        {
            case 'All':
                m_kCETable.arrTabText[iTab].StrValue = m_strCatAll;
                break;
            case 'Weapon':
                m_kCETable.arrTabText[iTab].StrValue = m_strCatWeapons;
                break;
            case 'Armor':
                m_kCETable.arrTabText[iTab].StrValue = m_strCatArmor;
                break;
            case 'Vehicle':
                m_kCETable.arrTabText[iTab].StrValue = m_strCatVehicles;
                break;
            case 'AlienArtifact':
                m_kCETable.arrTabText[iTab].StrValue = m_strCatAlien;
                break;
        }
    }

    m_kCETable.mnuItems = kMenu;
}

function UpdateView()
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGStorage kStorage;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kLabs = LWCE_XGFacility_Labs(LABS());
    kStorage = LWCE_XGStorage(STORAGE());

    UpdateHeader();
    UpdateQueue();

    switch (m_iCurrentView)
    {
        case eEngView_MainMenu:
            UpdateMainMenu();
            break;
        case eEngView_Build:
            UpdateItemTable();
            break;
        case eEngView_EditQueue:
            UpdateEditQueue();
            break;
    }

    super(XGScreenMgr).UpdateView();

    if (kStorage.LWCE_EverHadItem('Item_SkeletonKey') && Narrative(`XComNarrativeMoment("AlienCodeRevealed_LeadOut_CE")))
    {
        return;
    }

    if (kEngineering.m_bStartedFoundryProject)
    {
        kEngineering.m_bStartedFoundryProject = false;
        Narrative(`XComNarrativeMoment("FoundryProjectSelected"));
        return;
    }

    if (m_iCurrentView == eEngView_MainMenu)
    {
        if (Narrative(`XComNarrativeMoment("FirstEngineering")))
        {
            return;
        }

        if (kLabs.LWCE_IsResearched('Tech_AlienOperations') && !kStorage.LWCE_EverHadItem('Item_SkeletonKey'))
        {
            if (Narrative(`XComNarrativeMoment("UrgeBuildBasePassKey")))
            {
                return;
            }
        }

        if (kStorage.LWCE_EverHadItem('Item_Firestorm'))
        {
            if (Narrative(`XComNarrativeMoment("FirestormBuilt_LeadOut_CE")))
            {
                return;
            }
        }

        if (Game().GetNumMissionsTaken(eMission_TerrorSite) > 0)
        {
            if (Narrative(`XComNarrativeMoment("FirstTerrorMission_LeadOut_CE")))
            {
                return;
            }
        }

        if (BARRACKS().GetNumPsiSoldiers() > 0)
        {
            if (Narrative(`XComNarrativeMoment("PsionicsDiscovered_LeadOut_CE")))
            {
                return;
            }
        }

        if (kEngineering.m_bGivenEngineers)
        {
            kEngineering.m_bGivenEngineers = false;
            kEngineering.ResetRequestCounter();

            if (Narrative(`XComNarrativeMoment("EngineeringHasEngineers")))
            {
                return;
            }
        }

        if (kEngineering.NeedsEngineers())
        {
            if (Narrative(`XComNarrativeMoment("EngineeringNeedEngineers")))
            {
                return;
            }
        }

        if (kStorage.GetResource(eResource_Meld) > 150 && !HQ().m_bUrgedEWFacility)
        {
            if (!HQ().HasFacility(eFacility_CyberneticsLab) && !HQ().HasFacility(eFacility_GeneticsLab) && !kEngineering.IsBuildingFacility(eFacility_CyberneticsLab) && !kEngineering.IsBuildingFacility(eFacility_GeneticsLab))
            {
                if (Narrative(`XComNarrativeMomentEW("Urge_LabFacility")))
                {
                    HQ().m_bUrgedEWFacility = true;
                    return;
                }
            }
        }

        if (kEngineering.UrgeBuildMEC())
        {
            if (Narrative(`XComNarrativeMomentEW("Urge_BuildMEC")))
            {
                return;
            }
        }

        if (Narrative(kEngineering.GetMusing()))
        {
            return;
        }

        if (!HQ().HasFacility(eFacility_Foundry) && kLabs.LWCE_IsResearched('Tech_ExperimentalWarfare') && AI().GetMonth() >= 2)
        {
            if (Narrative(`XComNarrativeMoment("UrgeFoundry")))
            {
                return;
            }
        }

        if (kLabs.LWCE_IsResearched('Tech_AlienCommandAndControl') && GOLLOP() == none)
        {
            Narrative(`XComNarrativeMoment("GollopUnlock"));
            return;
        }
    }
}