class XComPerkManager extends Actor
    native
    dependson(XGTacticalGameCoreNativeBase)
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

enum EPerkCategory
{
    ePerkCat_Passive,
    ePerkCat_Active,
    ePerkCat_MAX
};

enum EPerkBuffCategory
{
    ePerkBuff_Passive,
    ePerkBuff_Bonus,
    ePerkBuff_Penalty,
    ePerkBuff_MAX
};

struct native TSoldierPerkTree
{
    var ESoldierClass SoldierType;
    var EPerkType Squaddie;
    var EPerkType Corporal1;
    var EPerkType Corporal2;
    var EPerkType Sergeant1;
    var EPerkType Sergeant2;
    var EPerkType Lieutenant1;
    var EPerkType Lieutenant2;
    var EPerkType Captain1;
    var EPerkType Captain2;
    var EPerkType Major;
    var EPerkType Colonel1;
    var EPerkType Colonel2;
};

struct native TPsiPerkTree
{
    var EPerkType Rank1;
    var EPerkType Rank2a;
    var EPerkType Rank2b;
    var EPerkType Rank3a;
    var EPerkType Rank3b;
};

struct native TGeneModTree
{
    var EPerkType Chest1;
    var EPerkType Chest2;
    var EPerkType Brain1;
    var EPerkType Brain2;
    var EPerkType Eyes1;
    var EPerkType Eyes2;
    var EPerkType Skin1;
    var EPerkType Skin2;
    var EPerkType Legs1;
    var EPerkType Legs2;
};

struct native TPerk
{
    var string strName[EPerkBuffCategory];
    var string strDescription[EPerkBuffCategory];
    var int iPerk;
    var int iCategory;
    var string strImage;
    var bool bShowPerk;
};

var config array<config TSoldierPerkTree> SoldierPerkTrees;
var config TPsiPerkTree PsiPerkTree;
var config TGeneModTree GeneModPerkTree;
var private config array<config EPerkType> RandomPerks;
var private array<TPerk> m_arrPerks;
var const localized string m_strBonusTxt[EPerkType];
var const localized string m_strPenaltyTxt[EPerkType];
var const localized string m_strPassiveTxt[EPerkType];
var const localized string m_strBonusTitle[EPerkType];
var const localized string m_strPenaltyTitle[EPerkType];
var const localized string m_strPassiveTitle[EPerkType];
var const localized string m_strBattleFatigueSecondWave;
var privatewrite bool m_bInitialized;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}