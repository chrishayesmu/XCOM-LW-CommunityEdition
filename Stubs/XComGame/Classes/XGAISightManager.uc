class XGAISightManager extends XGSightManager;

//complete stub

simulated function RevealEnemyUnit(XGUnit kUnit, XGUnit kEnemy, XGSightManagerNativeBase.EEnemyReveal eRevealType){}
simulated function HideEnemyUnit(XGUnit kEnemy);
function UpdateVisibilityForUnitEnemyPods(XGUnit kMover, array<XGUnit> arrUnitList){}
simulated function UpdateBuildingVisibility();
simulated function UpdateLootVisibility();

DefaultProperties
{
}
