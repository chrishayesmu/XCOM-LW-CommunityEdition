class Highlander_XGGreyMarketUI extends XGGreyMarketUI;

var array<HL_TItem> m_arrHLItems;

function AddSpecialItemsToList(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(AddSpecialItemsToList);
}

function HL_AddSpecialItemsToList(int iItemId)
{
    if (STORAGE().GetNumItemsAvailable(iItemId) > 0)
    {
        m_arrHLItems.AddItem(`HL_ITEM(iItemId));
        m_arrItemList.Add(1);
    }
}

function BuildItemList()
{
    m_arrHLItems = `HL_STORAGE.HL_GetItemsInCategory(eItemCat_All, eTransaction_Sell);
    m_arrHLItems.Sort(SortItems);

    m_arrItemList.Remove(0, m_arrItemList.Length);
    m_arrItemList.Add(m_arrHLItems.Length);

    HL_AddSpecialItemsToList(`LW_ITEM_ID(OutsiderShard));
    HL_AddSpecialItemsToList(`LW_ITEM_ID(SkeletonKey));
    HL_AddSpecialItemsToList(`LW_ITEM_ID(HyperwaveBeacon));
    HL_AddSpecialItemsToList(`LW_ITEM_ID(EtherealDevice));

    BuildItemProperties();

    m_iTotal = 0;
    m_iHighlight = 0;
}

function BuildItemProperties()
{
    local int Index, iItemId, iTechId;

    for (Index = 0; Index < m_arrHLItems.Length; Index++)
    {
        iItemId = m_arrHLItems[Index].iItemId;
        iTechId = `HL_TECHTREE.HL_GetResultingTech(iItemId);

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
            STORAGE().RemoveItem(m_arrHLItems[iItem].iItemId, m_arrItemList[iItem].iSelling);
        }
    }

    BuildItemList();
    UpdateView();
    Sound().PlaySFX(SNDLIB().SFX_UI_CashReceived);
}

function OnSellItem()
{
    local int iNumInStorage;

    iNumInStorage = STORAGE().GetNumItemsAvailable(m_arrHLItems[m_iHighlight].iItemId);

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
            OutputString = OutputString $ m_arrHLItems[iItem].strName $ " x" $ string(m_arrItemList[iItem].iSelling) $ "\n";
        }
    }

    OutputString = OutputString $ "########################################################\n";
    return OutputString;
}

function SetHighlighted(optional int Target = -1)
{
    if (Target <= m_arrHLItems.Length - 1 && Target > -1)
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

function int SortItems(HL_TItem kItem1, HL_TItem kItem2)
{
    // Highlander issue #16: Items are sorted by category: alien artifacts first, then corpses/captives,
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
    local HL_TItem kItem;
    local TGMSummary kSummary;

    iItemId = m_arrHLItems[m_iHighlight].iItemId;
    kItem = `HL_ITEM(iItemId, eTransaction_Sell);

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

    for (iItem = 0; iItem < m_arrHLItems.Length; iItem++)
    {
        m_arrItemList[iItem].btxtToSell.iButton = 10;
        m_arrItemList[iItem].btxtToStorage.iButton = 9;

        iItemId = m_arrHLItems[iItem].iItemId;
        iQuantity = STORAGE().GetNumItemsAvailable(iItemId) - m_arrItemList[iItem].iSelling;
        m_arrItemList[iItem].txtItemName.StrValue = m_arrHLItems[iItem].strName;

        if (m_arrItemList[iItem].txtItemName.StrValue == "")
        {
            m_arrItemList[iItem].txtItemName.StrValue = "MISSING NAME: iItem =" @ string(iItem);
        }

        m_arrItemList[iItem].txtItemName.iState = eUIState_Highlight;

        if (m_arrItemList[iItem].bCanBeSold)
        {
            m_arrItemList[iItem].txtItemPrice.StrValue = ConvertCashToString(m_arrHLItems[iItem].kCost.iCash);
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
                iCreditTotal = m_arrItemList[iItem].iSelling * m_arrHLItems[iItem].kCost.iCash;

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