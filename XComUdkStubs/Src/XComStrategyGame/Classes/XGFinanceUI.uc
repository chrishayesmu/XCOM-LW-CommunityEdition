/*******************************************************************************
 * XGFinanceUI generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGFinanceUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EFinanceView
{
    eFinanceView_Main,
    eFinanceView_MAX
};

struct TFinanceSection
{
    var TLabeledText ltxtTitle;
    var array<TLabeledText> arrItems;
};

var TLabeledText m_ltxtNetIncome;
var TLabeledText m_ltxtTotalIncome;
var array<TFinanceSection> m_arrSections;
var const localized string m_strLabelNet;
var const localized string m_strLabelMonthlyGross;
var const localized string m_strLabelCashFlowTitle;
var const localized string m_strSalary;
var const localized string m_strCraftMaintenance;
var const localized string m_strFacilityMaintenance;