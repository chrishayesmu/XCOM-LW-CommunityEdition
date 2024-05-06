class XGCharacter extends Actor
    abstract
    native(Unit)
    notplaceable
    hidecategories(Navigation);

const MAX_CHAR_ABILITIES = 8;

struct CheckpointRecord
{
    var TCharacter m_kChar;
    var int m_iMaxMoves;
    var int m_iMaxUseAbilities;
    var EPawnType m_eType;
    var XGSquad m_kSquad;
};

var TCharacter m_kChar;
var private repnotify string ReplicatedTCharacter_strName;
var private repnotify int ReplicatedTCharacter_iType;
var private repnotify TInventory ReplicatedTCharacter_kInventory;
var private repnotify int ReplicatedTCharacter_aUpgrades[EPerkType];
var privatewrite repnotify int ReplicatedTCharacter_iNumUpgrades;
var privatewrite int m_iNumUpgradesReplicated;
var private repnotify int ReplicatedTCharacter_aAbilities[EAbility];
var private repnotify int ReplicatedTCharacter_aProperties[ECharacterProperty];
var private repnotify int ReplicatedTCharacter_aStats[ECharacterStat];
var private repnotify int ReplicatedTCharacter_aTraversals[ETraversalType];
var private repnotify ESoldierClass ReplicatedTCharacter_eClass;
var EPawnType m_eType;
var private repnotify bool ReplicatedTCharacter_bHasPsiGift;
var bool m_bCanOpenWindowsAndDoors;
var protected bool m_bSafeNameGenerated;
var protected bool m_bShouldUseSafeName;
var protected bool m_bCheckedUseSafeName;
var private repnotify float ReplicatedTCharacter_fBioElectricParticleScale;
var int aAbilities[8];
var int m_iMaxMoves;
var int m_iMaxUseAbilities;
var XGSquad m_kSquad;
var XGUnit m_kUnit;
var class<XComUnitPawn> m_kUnitPawnClassToSpawn;
var protected string m_strSafeCharacterName;
var protected string m_strSafeCharacterFullName;
var protected string m_strSafeCharacterFirstName;
var protected string m_strSafeCharacterLastName;
var protected string m_strSafeCharacterNickname;

defaultproperties
{
    ReplicatedTCharacter_iNumUpgrades=-1
    m_bCanOpenWindowsAndDoors=true
    m_iMaxMoves=2
    m_iMaxUseAbilities=1
    RemoteRole=ROLE_SimulatedProxy
    bTickIsDisabled=true
    bAlwaysRelevant=true
}