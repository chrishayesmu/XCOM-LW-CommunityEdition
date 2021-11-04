class XGAnimalSightManager extends XGSightManager
    notplaceable
    hidecategories(Navigation);
//complete stub

simulated function UpdateVisibleFriendsForUnit(XGUnit kUnit, XGSquad kUnitSquad);

simulated function UpdateBuildingVisibility();

simulated function UpdateLootVisibility();

simulated function RevealEnemyUnit(XGUnit kUnit, XGUnit kEnemy, EEnemyReveal eRevealType);

simulated function HideEnemyUnit(XGUnit kEnemy);

simulated function UpdateAlienSenses(XGUnit kUnit, XGUnit kAlien, int iAlienIndex);