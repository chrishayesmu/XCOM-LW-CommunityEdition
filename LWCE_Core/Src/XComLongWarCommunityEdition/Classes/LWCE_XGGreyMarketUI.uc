class LWCE_XGGreyMarketUI extends XGGreyMarketUI;

var array<LWCEItemTemplate> m_arrCEItems;

function AddSpecialItemsToList(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(AddSpecialItemsToList);
}

function LWCE_AddSpecialItemsToList(name ItemName)
{
    if (LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable(ItemName) > 0)
    {
        m_arrCEItems.AddItem(`LWCE_ITEM(ItemName));
        m_arrItemList.Add(1);
    }
}

function BuildItemList()
{
    m_arrCEItems = LWCE_XGStorage(STORAGE()).LWCE_GetItemsInCategory('All', eTransaction_Sell);
    m_arrCEItems.Sort(SortItems);

    m_arrItemList.Remove(0, m_arrItemList.Length);
    m_arrItemList.Add(m_arrCEItems.Length);

    LWCE_AddSpecialItemsToList('Item_OutsiderShard');
    LWCE_AddSpecialItemsToList('Item_SkeletonKey');
    LWCE_AddSpecialItemsToList('Item_HyperwaveBeacon');
    LWCE_AddSpecialItemsToList('Item_EtherealDevice');

    BuildItemProperties();

    m_iTotal = 0;
    m_iHighlight = 0;
}

function BuildItemProperties()
{
    local name ItemName, TechName;
    local int Index;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGTechTree kTechTree;

    kLabs = LWCE_XGFacility_Labs(LABS());
    kTechTree = LWCE_XGTechTree(TECHTREE());

    for (Index = 0; Index < m_arrCEItems.Length; Index++)
    {
        ItemName = m_arrCEItems[Index].GetItemName();
        TechName = kTechTree.LWCE_GetResultingTech(ItemName);

        if (TechName != '' && !kLabs.LWCE_IsResearched(TechName))
        {
            m_arrItemList[Index].txtResearchStatus.StrValue = m_strNotResearched;
            m_arrItemList[Index].txtResearchStatus.iState = eUIState_Warning;
            m_arrItemList[Index].bNotResearched = true;
        }

        m_arrItemList[Index].bCanBeSold = m_arrCEItems[Index].CanBeSold();
    }
}

function OnCompleteTransaction()
{
    local int iItem;

    if (m_kBuyButton.eState == eUIState_Disabled)
    {
        PlayBadSound();
        return;
    }

    AddResource(eResource_Money, m_iTotal);
    STAT_AddStat(eRecap_GreyMarketFunding, m_iTotal);

    for (iItem = 0; iItem < m_arrItemList.Length; iItem++)
    {
        if (m_arrItemList[iItem].iSelling > 0)
        {
            LWCE_XGStorage(STORAGE()).LWCE_RemoveItem(m_arrCEItems[iItem].GetItemName(), m_arrItemList[iItem].iSelling);
        }
    }

    BuildItemList();
    UpdateView();
    Sound().PlaySFX(SNDLIB().SFX_UI_CashReceived);
}

function OnSellItem()
{
    local int iNumInStorage;

    iNumInStorage = LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable(m_arrCEItems[m_iHighlight].GetItemName());

    if (m_arrItemList[m_iHighlight].bCanBeSold && iNumInStorage > m_arrItemList[m_iHighlight].iSelling)
    {
        m_arrItemList[m_iHighlight].iSelling += 1;

        UpdateView();
        PlayGoodSound();

        if (m_arrItemList[m_iHighlight].bNotResearched && !LABS().m_bGreyWarning)
        {
            Narrative(`XComNarrativeMoment("GreyMarketNotResearched"));
            LABS().m_bGreyWarning = true;
        }
    }
    else
    {
        PlayBadSound();
    }
}

function string RecordGreyMarketSale()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordGreyMarketSale);

    return "";
}

function SetHighlighted(optional int Target = -1)
{
    if (Target <= m_arrCEItems.Length - 1 && Target > -1)
    {
        m_iHighlight = Target;
        UpdateView();
        PlayScrollSound();
    }
    else
    {
        PlayBadSound();
    }
}

function int SortItems(LWCEItemTemplate kItem1, LWCEItemTemplate kItem2)
{
    // LWCE issue #16: Items are sorted by category: alien artifacts first, then corpses/captives,
    // then equipment. Within each category, items are sorted by name.
    if (kItem1.nmCategory == kItem2.nmCategory)
    {
        if (kItem1.strName > kItem2.strName)
        {
            return -1;
        }
    }

    if (kItem1.nmCategory == 'AlienArtifact')
    {
        return 0;
    }

    if (kItem2.nmCategory == 'AlienArtifact')
    {
        return -1;
    }

    if (kItem1.nmCategory == 'Corpse')
    {
        return 0;
    }

    if (kItem2.nmCategory == 'Corpse')
    {
        return -1;
    }

    if (kItem1.nmCategory == 'Captive')
    {
        return 0;
    }

    if (kItem2.nmCategory == 'Captive')
    {
        return -1;
    }

    if (kItem1.strName > kItem2.strName)
    {
        return -1;
    }

    return 0;
}

function UpdateItem()
{
    local name ItemName;
    local LWCEItemTemplate kItem;
    local TGMSummary kSummary;

    ItemName = m_arrCEItems[m_iHighlight].GetItemName();
    kItem = `LWCE_ITEM(ItemName);

    kSummary.imgItem.strPath = kItem.ImagePath;
    kSummary.txtName.StrValue = kItem.strName;
    kSummary.txtName.iState = eUIState_Highlight;
    kSummary.txtSummary.StrValue = kItem.strBriefSummary;

    m_kItemSummary = kSummary;
}

function UpdateList()
{
    local LWCE_XGStorage kStorage;
    local int iItem, iCreditTotal, iQuantity;
    local string strTemp;
    local name ItemName;

    kStorage = LWCE_XGStorage(STORAGE());

    m_iTotal = 0;

    for (iItem = 0; iItem < m_arrCEItems.Length; iItem++)
    {
        m_arrItemList[iItem].btxtToSell.iButton = 10;
        m_arrItemList[iItem].btxtToStorage.iButton = 9;

        ItemName = m_arrCEItems[iItem].GetItemName();
        iQuantity = kStorage.LWCE_GetNumItemsAvailable(ItemName) - m_arrItemList[iItem].iSelling;
        m_arrItemList[iItem].txtItemName.StrValue = m_arrCEItems[iItem].strName;

        if (m_arrItemList[iItem].txtItemName.StrValue == "")
        {
            m_arrItemList[iItem].txtItemName.StrValue = "MISSING NAME: iItem =" @ string(iItem);
        }

        m_arrItemList[iItem].txtItemName.iState = eUIState_Highlight;

        if (m_arrItemList[iItem].bCanBeSold)
        {
            m_arrItemList[iItem].txtItemPrice.StrValue = ConvertCashToString(m_arrCEItems[iItem].kCost.iCash);
            m_arrItemList[iItem].txtItemPrice.iState = eUIState_Cash;
        }

        if (iQuantity > 0)
        {
            strTemp = string(iQuantity);
        }
        else
        {
            strTemp = "-";
        }

        m_arrItemList[iItem].txtNumInStorage.StrValue = strTemp;
        m_arrItemList[iItem].txtNumInStorage.iState = eUIState_Highlight;

        if (m_arrItemList[iItem].bCanBeSold)
        {
            if (m_arrItemList[iItem].iSelling > 0)
            {
                iCreditTotal = m_arrItemList[iItem].iSelling * m_arrCEItems[iItem].kCost.iCash;

                m_arrItemList[iItem].txtNumForSale.StrValue = string(m_arrItemList[iItem].iSelling);
                m_arrItemList[iItem].txtNumForSale.iState = eUIState_Highlight;

                m_arrItemList[iItem].txtCredits.StrValue = ConvertCashToString(iCreditTotal);
                m_arrItemList[iItem].txtCredits.iState = eUIState_Cash;

                m_iTotal += iCreditTotal;
            }
            else
            {
                m_arrItemList[iItem].txtNumForSale.StrValue = "-";
                m_arrItemList[iItem].txtNumForSale.iState = eUIState_Highlight;

                m_arrItemList[iItem].txtCredits.StrValue = "";
            }
        }
    }

    UpdateBuyButton(m_iTotal > 0);
    UpdateListHeader();
}