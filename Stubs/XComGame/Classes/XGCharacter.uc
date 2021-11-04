class XGCharacter extends Actor
	abstract
	native(Unit)
	dependsOn(XGTacticalGameCoreNativeBase);
//complete stub

struct CheckpointRecord
{
    var TCharacter m_kChar;
    var int m_iMaxMoves;
    var int m_iMaxUseAbilities;
    var XGGameData.EPawnType m_eType;
    var XGSquad m_kSquad;
};

var TCharacter m_kChar;
var repnotify string ReplicatedTCharacter_strName;
var repnotify int ReplicatedTCharacter_iType;
var repnotify TInventory ReplicatedTCharacter_kInventory;
var repnotify int ReplicatedTCharacter_aUpgrades[EPerkType];
var repnotify int ReplicatedTCharacter_iNumUpgrades;
var int m_iNumUpgradesReplicated;
var repnotify int ReplicatedTCharacter_aAbilities[EAbility];
var repnotify int ReplicatedTCharacter_aProperties[ECharacterProperty];
var repnotify int ReplicatedTCharacter_aStats[ECharacterStat];
var repnotify int ReplicatedTCharacter_aTraversals[ETraversalType];
var repnotify ESoldierClass ReplicatedTCharacter_eClass;
var EPawnType m_eType;
var repnotify bool ReplicatedTCharacter_bHasPsiGift;
var bool m_bCanOpenWindowsAndDoors;
var bool m_bSafeNameGenerated;
var bool m_bShouldUseSafeName;
var bool m_bCheckedUseSafeName;
var repnotify float ReplicatedTCharacter_fBioElectricParticleScale;
var int aAbilities[8];
var int m_iMaxMoves;
var int m_iMaxUseAbilities;
var XGSquad m_kSquad;
var XGUnit m_kUnit;
var class<XComUnitPawn> m_kUnitPawnClassToSpawn;
var string m_strSafeCharacterName;
var string m_strSafeCharacterFullName;
var string m_strSafeCharacterFirstName;
var string m_strSafeCharacterLastName;
var string m_strSafeCharacterNickname;

simulated event ReplicatedEvent(name VarName){}
function ApplyCheckpointRecord(){}
function class<XComUnitPawn> GetPawnClass(){}
function TCharacter GetTCharacterFromPawnType(EPawnType inputPawnType){}
function InitTCharacter(){}
function SetTCharacter(TCharacter kTChar){}
event ReplicateTCharacterProperties_Upgrades(){}
function ReplicateTCharacterProperties(){}
function InitAbilities(){}
function XComUnitPawn GetPawnArchetype(){}
simulated function int GetCharMaxStat(XGTacticalGameCoreData.ECharacterStat eStat){}
simulated function int GetCharMaxPathLength(){}
simulated function int GetCharMaxOffense(){}
simulated function int GetCharMaxHP(){}
simulated function int GetCharMaxFlightFuel(){}
simulated function int GetCharMaxDefense(){}
simulated function int GetCharMaxStrength(){}
simulated function int GetCharMaxShieldHP(){}
simulated function float GetCharBioElectricParticleScaling(){}
simulated function bool CanGainXP(){}
simulated function bool HasUpgrade(int iUpgrade){}
simulated function bool HasAnyGeneMod(){}
simulated function bool IsInitialReplicationComplete(){}
function GivePerk(int iPerk){}
simulated function string GetName(){}
simulated function string GetFullName(){}
simulated function string GetFirstName(){}
simulated function string GetLastName(){}
simulated function string GetNickname(){}
simulated function bool HasSafeName(){}
simulated function SetSafeCharacterNameStrings(string strFirstName, string strLastName, optional string strNickName){}
simulated function bool ShouldUseSafeName(optional bool bOverride){}
simulated function SetShouldUseSafeName(bool bUseSafeName){}
simulated function bool ShouldGenerateSafeNames(){}
simulated event string SafeGetCharacterName(){}
simulated event string SafeGetCharacterFullName(){}
simulated event string SafeGetCharacterFirstName(){}
simulated event string SafeGetCharacterLastName(){}
simulated event string SafeGetCharacterNickname(){}
