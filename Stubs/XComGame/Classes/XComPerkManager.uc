class XComPerkManager extends Actor
	native
	notplaceable
	config(GameCore)
	DependsOn(XGTacticalGameCoreNativeBase);
//complete stub

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
    var int SoldierType;
    var int Squaddie;
    var int Corporal1;
    var int Corporal2;
    var int Sergeant1;
    var int Sergeant2;
    var int Lieutenant1;
    var int Lieutenant2;
    var int Captain1;
    var int Captain2;
    var int Major;
    var int Colonel1;
    var int Colonel2;
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
var config array<config EPerkType> RandomPerks;
var array<TPerk> m_arrPerks;
var const localized string m_strBonusTxt[255];
var const localized string m_strPenaltyTxt[255];
var const localized string m_strPassiveTxt[255];
var const localized string m_strBonusTitle[255];
var const localized string m_strPenaltyTitle[255];
var const localized string m_strPassiveTitle[255];
var const localized string m_strBattleFatigueSecondWave;
var bool m_bInitialized;

native simulated function SetPerkStrings(int iPerk);
simulated function Init(){}
simulated function int GetNumPerks(){}
simulated function BuildPerkTables(){}
simulated function array<int> GetPsiPerks(){}
simulated function BuildPerk(int iPerk, int iCategory, string strImage, optional bool bShowPerk=true){}
simulated function TPerk GetPerk(int iPerk){}
simulated function string GetPerkName(int iPerk, optional XComPerkManager.EPerkBuffCategory perkCategory){}
simulated function string GetPerkImage(int iPerk){}
function EPerkType GetPerkInTree(ESoldierClass soldierClass, int branch, int Option, optional bool bIsPsiTree){}
function EPerkType GetPerkInTreePsi(int branch, int Option){}
function EPerkType GetPerkInGeneModTree(int branch, int Option){}
function EPerkType GetOppositeGeneModPerk(EPerkType Perk){}
static function EPerkType GetMecPerkForClass(ESoldierClass eSoldier){}
function ESoldierClass GetClassFromMecPerk(EPerkType ePerk){}
function GivePerk(XGUnit kUnit, int iPerk){}
static simulated function bool HasAnyGeneMod(int Upgrades[EPerkType]){}
static simulated function int NumGeneMods(int Upgrades[EPerkType]){}
simulated function bool IsFixedPerk(EPerkType Perk){}
simulated function EPerkType GetRandomPerk(){}
native static simulated function EPerkType GetPerkFromAbility(EAbility Ability);
simulated function string GetBriefSummary(int iPerk){}
simulated function string GetBonusTitle(int iPerk){}
simulated function string GetPenaltyTitle(int iPerk){}
