class XGTechTree extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

var array<TTech> m_arrTechs;
var array<TFoundryTech> m_arrFoundryTechs;
var array<TOTSTech> m_arrOTSTechs;
var array<TGameObjective> m_arrObjectives;
var array<TSubObjective> m_arrSubObjectives;
var array<TResearchCredit> m_arrResearchCredits;
var array<TGeneModTech> m_arrGeneModTechs;
var const localized string m_strNeedOTSPrereqs;
var const localized string m_strNeedOTSSquadSizeI;

function Init(){}
function int TechCost(int iExpectedScientists){}
function BuildResearchCredits(){}
function BuildTechs(){}
function BuildGeneTechs(){}
function int WFragment(int iInput){}
function GetXenoCost(out TResearchCost kCost){}
function GetPlasmaCost(ETechType eTech, out TResearchCost kCost){}
function string GetBriefSummary(int iSubject, out string strReport, out string strCustomResults, out TResearchCost kCost, out string strCodename){}
function bool HasPrereqs(int iTech){}
function BuildFoundryTechs(){}
function string GetBriefFoundrySummary(int iSubject){}
function bool HasFoundryPrereqs(int iFoundryTech){}
function bool HasTechPrequisites(int iTech){}
function bool HasItemPrequisites(int iTech){}
function BalanceTechs(){}
function BuildTech(int iTech, int iHours, optional bool bCustomReqs, optional EItemType eItemReq, optional ETechType eTechReq, optional int iImage, optional EResearchCredits eCreditGranted){}
function BuildResearchCredit(EResearchCredits eType, int iBonus, int iImage){}
function TResearchCredit GetResearchCredit(EResearchCredits eCredit){}
function BuildGeneModTech(EGeneModTech GeneTech, ETechType TechReq, int hours, int MeldCost, int CashCost, EPerkType Perk){}
function TGeneModTech GetGeneTech(EGeneModTech TECH){}
function TGeneModTech GetGeneTechForPerk(EPerkType Perk){}
function int FoundryDaysToHours(int iDays, int iEngineers){}
function BalanceFoundry(){}
function BuildFoundryTech(EFoundryTech eTech, int iDays, int iEngineers, optional int iCash, optional int iElerium, optional int iAlloys, optional ETechType iTechReq, optional EItemType eItemReq, optional int iImage){}
function BuildFoundryItemCost(int iTech, out TFoundryTech kTech){}
function TTech GetTech(int iTechType, optional bool bAdjustHours){}
function ETechType GetResultingTech(EItemType eItem){}
function int GetCreditAdjustedTechHours(int iTech, int iHours, bool bFoundry){}
function bool CreditAppliesToTech(EResearchCredits eCredit, ETechType eTech){}
function bool CreditAppliesToFoundryTech(EResearchCredits eCredit, EFoundryTech eTech){}
function TFoundryTech GetFoundryTech(int iFoundryTechType, optional bool bRushResearch){}
function TOTSTech GetOTSTech(int iOTSTechType){}
function array<TFoundryTech> GetAvailableFoundryTechs(){}
function array<TFoundryTech> GetCompletedFoundryTechs(){}
function bool CheckForSkunkworks(){}
function string GetArchive(int iSubject){}
function array<int> GetFacilityResults(int iTech){}
function array<int> GetItemResults(int iTech){}
function array<int> GetGeneResults(ETechType eTech){}
function array<int> GetFoundryResults(ETechType eTech){}
function int OTSRank(){}
function BuildOTSTechs(){}
function string GetBriefOTSSummary(int iSubject){}
function bool HasOTSPrereqs(int iOTSTech, out string strHelp){}
function BalanceOTS(){}
function BuildOTSTech(EOTSTech eTech, int iRankRequired, optional int iCash, optional int iComboCount, optional int iComboType, optional int iImage){}
function array<TOTSTech> GetAvailableOTSTechs(){}
function ApplyOTSTech(EOTSTech eTech){}
function BuildObjectives(){}
function TSubObjective GetSubObjective(ESubObjective eSubObj){}
function TGameObjective GetTObjective(EGameObjective eObj){}