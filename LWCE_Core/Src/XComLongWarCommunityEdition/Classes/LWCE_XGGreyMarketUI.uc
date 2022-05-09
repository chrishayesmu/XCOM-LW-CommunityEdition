class LWCE_XGGreyMarketUI extends XGGreyMarketUI;

var array<LWCE_TItem> m_arrCEItems;

function AddSpecialItemsToList(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(AddSpecialItemsToList);
}

function LWCE_AddSpecialItemsToList(int iItemId)
{
    if (STORAGE().GetNumItemsAvailable(iItemId) > 0)
    {
        m_arrCEItems.AddItem(`LWCE_ITEM(iItemId));
        m_arrItemList.Add(1);
    }
}

function BuildItemList()
{
    m_arrCEItems = `LWCE_STORAGE.LWCE_GetItemsInCategory(eItemCat_All, eTransaction_Sell);
    m_arrCEItems.Sort(SortItems);

    m_arrItemList.Remove(0, m_arrItemList.Length);
    m_arrItemList.Add(m_arrCEItems.Length);

    LWCE_AddSpecialItemsToList(`LW_ITEM_ID(OutsiderShard));
    LWCE_AddSpecialItemsToList(`LW_ITEM_ID(SkeletonKey));
    LWCE_AddSpecialItemsToList(`LW_ITEM_ID(HyperwaveBeacon));
    LWCE_AddSpecialItemsToList(`LW_ITEM_ID(EtherealDevice));

    BuildItemProperties();

    m_iTotal = 0;
    m_iHighlight = 0;
}

function BuildItemProperties()
{
    local int Index, iItemId, iTechId;

    for (Index = 0; Index < m_arrCEItems.Length; Index++)
    {
        iItemId = m_arrCEItems[Index].iItemId;
        iTechId = `LWCE_TECHTREE.LWCE_GetResultingTech(iItemId);

        if (iTechId != 0 && !LABS().IsResearched(iTechId))
        {
            m_arrItemList[Index].txtResearchStatus.StrValue = m_strNotResearched;
            m_arrItemList[Index].txtResearchStatus.iState = eUIState_Warning;
            m_arrItemList[Index].bNotResearched = true;
        }

        m_arrItemList[Index].bCanBeSold = ITEMTREE().CanBeSold(iItemId);

        if (iItemId == eItem_AlienAlloys || iItemId == eItem_Elerium115 || iItemId == eItem_WeaponFragment)
        {
            m_arrItemList[Index].bBulk = true;
        }
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

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordGreyMarketSale());
    }

    AddResource(eResource_Money, m_iTotal);
    STAT_AddStat(eRecap_GreyMarketFunding, m_iTotal);

    for (iItem = 0; iItem < m_arrItemList.Length; iItem++)
    {
        if (m_arrItemList[iItem].iSelling > 0)
        {
            STORAGE().RemoveItem(m_arrCEItems[iItem].iItemId, m_arrItemList[iItem].iSelling);
        }
    }

    BuildItemList();
    UpdateView();
    Sound().PlaySFX(SNDLIB().SFX_UI_CashReceived);
}

function OnSellItem()
{
    local int iNumInStorage;

    iNumInStorage = STORAGE().GetNumItemsAvailable(m_arrCEItems[m_iHighlight].iItemId);

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
    local string OutputString;
    local int iItem;

    OutputString = GEOSCAPE().m_kDateTime.GetDateString() @ GEOSCAPE().m_kDateTime.GetTimeString() @ ": Sold alien techology to the highest bidder: \n" $ "########################################################\n";

    for (iItem = 0; iItem < m_arrItemList.Length; iItem++)
    {
        if (m_arrItemList[iItem].iSelling > 0)
        {
            OutputString = OutputString $ m_arrCEItems[iItem].strName $ " x" $ string(m_arrItemList[iItem].iSelling) $ "\n";
        }
    }

    OutputString = OutputString $ "########################################################\n";
    return OutputString;
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

function int SortItems(LWCE_TItem kItem1, LWCE_TItem kItem2)
{
    // LWCE issue #16: Items are sorted by category: alien artifacts first, then corpses/captives,
    // then equipment. Within each category, items are sorted by name.
    if (kItem1.iCategory == kItem2.iCategory)
    {
        if (kItem1.strName > kItem2.strName)
        {
            return -1;
        }
    }

    if (kItem1.iCategory == eItemCat_Alien)
    {
        return 0;
    }

    if (kItem2.iCategory == eItemCat_Alien)
    {
        return -1;
    }

    if (kItem1.iCategory == eItemCat_Corpses)
    {
        return 0;
    }

    if (kItem2.iCategory == eItemCat_Corpses)
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
    local int iItemId;
    local LWCE_TItem kItem;
    local TGMSummary kSummary;

    iItemId = m_arrCEItems[m_iHighlight].iItemId;
    kItem = `LWCE_ITEM(iItemId, eTransaction_Sell);

    kSummary.imgItem.strPath = kItem.ImagePath;
    kSummary.txtName.StrValue = kItem.strName;
    kSummary.txtName.iState = eUIState_Highlight;
    kSummary.txtSummary.StrValue = kItem.strBriefSummary;

    m_kItemSummary = kSummary;
}

function UpdateList()
{
    local int iItem, iCreditTotal, iQuantity;
    local string strTemp;
    local int iItemId;

    m_iTotal = 0;

    for (iItem = 0; iItem < m_arrCEItems.Length; iItem++)
    {
        m_arrItemList[iItem].btxtToSell.iButton = 10;
        m_arrItemList[iItem].btxtToStorage.iButton = 9;

        iItemId = m_arrCEItems[iItem].iItemId;
        iQuantity = STORAGE().GetNumItemsAvailable(iItemId) - m_arrItemList[iItem].iSelling;
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