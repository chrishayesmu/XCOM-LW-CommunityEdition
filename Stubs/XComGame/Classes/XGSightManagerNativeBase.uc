class XGSightManagerNativeBase extends Actor
    native(Core)
	dependson(XGTacticalGameCoreData);
//complete stub

const SIGHT_MGR_MAX_VISIBLE_ENEMIES = 16;
const SIGHT_MGR_MAX_VISIBLE_CIVILIANS = 32;

enum EEnemyReveal
{
    eER_FirstTimeCharacter,
    eER_FirstTimeUnit,
    eER_AlreadySeen,
    eER_MAX
};

struct CheckpointRecord
{
    var XGPlayer m_kPlayer;
};

var init array<init XGUnit> m_arrVisibleEnemies;
var init array<init XGUnit> m_arrVisibleCivilians;
var repnotify const XGUnitNativeBase m_arrVisibleEnemiesReplicated[16];
var const int m_iNumVisibleEnemiesReplicated;
var repnotify const XGUnitNativeBase m_arrVisibleCiviliansReplicated[32];
var const int m_iNumVisibleCiviliansReplicated;
var repnotify XGPlayer m_kPlayer;
var bool m_bCanSeeAllEnemies;

simulated event ReplicatedEvent(name VarName){}
function ClearAllVisibilityArrays(){}
private native final function AddVisibleEnemyReplicated(XGUnitNativeBase kEnemy);

protected function ClearVisibleEnemies()
{
    m_arrVisibleEnemies.Remove(0, m_arrVisibleEnemies.Length);
    ClearVisibleEnemiesReplicated();
}

// Export UXGSightManagerNativeBase::execClearVisibleEnemiesReplicated(FFrame&, void* const)
private native final function ClearVisibleEnemiesReplicated();

// Export UXGSightManagerNativeBase::execRemoveVisibleEnemyReplicated(FFrame&, void* const)
private native final function RemoveVisibleEnemyReplicated(XGUnitNativeBase kEnemy);

// Export UXGSightManagerNativeBase::execCheckVisibleEnemies(FFrame&, void* const)
native function CheckVisibleEnemies(out array<XGUnit> visEnemies, XGUnitNativeBase kEnemy, XGUnitNativeBase kViewer);

// Export UXGSightManagerNativeBase::execAddVisibleCivilianReplicated(FFrame&, void* const)
private native final function AddVisibleCivilianReplicated(XGUnitNativeBase kCivilian);
protected function ClearVisibleCivilians(){}
// Export UXGSightManagerNativeBase::execClearVisibleCiviliansReplicated(FFrame&, void* const)
private native final function ClearVisibleCiviliansReplicated();

// Export UXGSightManagerNativeBase::execRemoveVisibleCivilianReplicated(FFrame&, void* const)
native final function RemoveVisibleCivilianReplicated(XGUnitNativeBase kEnemy);
simulated function RevealEnemyUnit(XGUnit kUnit, XGUnit kEnemy, XGSightManagerNativeBase.EEnemyReveal eRevealType){}
simulated function HideEnemyUnit(XGUnit kEnemy){};
simulated function OnEnemyRemoval(XGUnit kEnemy){}
simulated event bool AddVisibleEnemy(XGUnitNativeBase kViewer, XGUnit kOther){}
simulated event AddVisibleFriend(XGUnitNativeBase kViewer, XGUnit kOther){}
simulated event AddVisibleCivilian(XGUnitNativeBase kViewer, XGUnit kOther){}
simulated event RemoveVisibleEnemy(XGUnitNativeBase kViewer, XGUnit kOther){}
simulated event RemoveVisibleFriend(XGUnitNativeBase kViewer, XGUnit kOther){}
simulated event RemoveVisibleCivilian(XGUnitNativeBase kViewer, XGUnit kOther){}
// Export UXGSightManagerNativeBase::execCheckTeamVisibility(FFrame&, void* const)
native simulated function CheckTeamVisibility();

// Export UXGSightManagerNativeBase::execCheckUnitVisibilityBioElectricSkin(FFrame&, void* const)
native simulated function CheckUnitVisibilityBioElectricSkin(XGUnitNativeBase kUnit);

// Export UXGSightManagerNativeBase::execCheckUnitVisibilityBattleScannerStealth(FFrame&, void* const)
native simulated function CheckUnitVisibilityBattleScannerStealth(XGUnitNativeBase kUnit);
simulated event Tick(float fDeltaT){}
native simulated function RecalculateVisible();


DefaultProperties
{
}
