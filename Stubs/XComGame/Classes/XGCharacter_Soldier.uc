class XGCharacter_Soldier extends XGCharacter
	native(Unit);
//complete stub
struct native DecalParameters
{
    var Vector kAngles;
    var float fWidth;
    var float fHeight;
    var float fAlpha;
};

struct native DecalParametersCopy
{
    var float kAnglesX;
    var float kAnglesY;
    var float kAnglesZ;
    var float fWidth;
    var float fHeight;
    var float fAlpha;
};

struct native CharacterParameters
{
    var int iShape;
    var int iFacialHairMask;
    var LinearColor cEyeColor;
    var LinearColor cHairColor;
    var LinearColor cSkinColor;
    var float fEyebrowOffsetX;
    var float fEyebrowOffsetY;
    var float fEyebrowInvScale;
    var float fEyebrowRotation;
    var bool bGlasses;
    var bool bHeadband;
    var int iArmsClothedM;
    var int iArmsBareM;
    var int iGlovesM;
    var int iShoulderPadsM;
    var int iKneePadsM;
    var int iBootsM;
    var int iPouches;
    var int iChestPatch;
    var int iAccessories;
    var int iTattoos;
    var DecalParameters Decals[2];
};

struct native CharacterParametersCopy
{
    var int iShape;
    var int iFacialHairMask;
    var float cEyeColorR;
    var float cEyeColorG;
    var float cEyeColorB;
    var float cEyeColorA;
    var float cHairColorR;
    var float cHairColorG;
    var float cHairColorB;
    var float cHairColorA;
    var float cSkinColorR;
    var float cSkinColorG;
    var float cSkinColorB;
    var float cSkinColorA;
    var bool bGlasses;
    var bool bHeadband;
    var int iArmsClothedM;
    var int iArmsBareM;
    var int iGlovesM;
    var int iShoulderPadsM;
    var int iKneePadsM;
    var int iBootsM;
    var int iPouches;
    var int iChestPatch;
    var int iAccessories;
    var int iTattoos;
    var DecalParametersCopy Decals[2];
};

struct CheckpointRecord_XGCharacter_Soldier extends CheckpointRecord
{
    var TSoldier m_kSoldier;
    var CharacterParametersCopy m_kCCParams;
};

var TSoldier m_kSoldier;
var repnotify string ReplicatedTSoldier_strFirstName;
var repnotify string ReplicatedTSoldier_strLastName;
var repnotify string ReplicatedTSoldier_strNickName;
var repnotify int ReplicatedTSoldier_iRank;
var repnotify int ReplicatedTSoldier_iPsiRank;
var repnotify int ReplicatedTSoldier_iCountry;
var repnotify int ReplicatedTSoldier_iXP;
var repnotify int ReplicatedTSoldier_iPsiXP;
var repnotify int ReplicatedTSoldier_iNumKills;
var repnotify TAppearance ReplicatedTSoldier_kAppearance;
var CharacterParametersCopy m_kCCParams;

simulated event ReplicatedEvent(name VarName){}
simulated function string ToString_ClassAndRankStatInfo(){}
function UpgradeStatsBasedOnClassAndRank(){}
function class<XComUnitPawn> GetPawnClass(){}
function CharacterParameters GetCharacterCreationParams(){}
function SetCharacterCreationParams(CharacterParameters kCC){}
simulated function SetTSoldier(TSoldier kSoldier){}
simulated function string GetName(){}
simulated function string GetFullName(){}
simulated function string GetFirstName(){}
simulated function string GetLastName(){}
simulated function string GetNickname(){}
simulated function SetName(string firstName, string lastName, string NickName){}
simulated function SetSafeCharacterNameStrings(string strFirstName, string strLastName, optional string strNickName){}
function bool LeveledUp(){}
function SetPsiRank(XGTacticalGameCoreNativeBase.EPsiRanks newRank){}
function AddPsiXP(int iXP){}
function SetPsiXP(int iXP){}
function int GetPsiXP(){}
function AddXP(int iXP){}
function SetXP(int iXP){}
function int GetXP(){}
function AddKills(int iNumKills){}

defaultproperties
{
    m_eType=ePawnType_Male_1_Kevlar
    m_kUnitPawnClassToSpawn=class'XComMaleLevelIMedium'
}