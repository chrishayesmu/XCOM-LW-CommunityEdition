class UISightlineHUD_SightlineContainer extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);
//complete stub

var XGUnit m_kTargetUnit;
var array<XGUnitNativeBase> m_arrEnemies;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateActiveUnit(){}
simulated function UpdateVisibleEnemies(){}
simulated function RefreshSelectedEnemy(){}
simulated function AS_SetVisibleEnemies(int iVisibleAliens){}
simulated function AS_SetFocusedEnemy(int TargetIndex, float fHitChance){}
simulated function AS_SetTargettedEnemy(int TargetIndex){}
simulated function AS_SetHuman(int TargetIndex){}
simulated function AS_SetExalt(int TargetIndex){}
simulated function AS_SetFlanked(int TargetIndex, bool isFlanked){}
simulated function AS_SetSquadSight(int TargetIndex){}
simulated function AS_AnchorToTopLeft(bool bAbsolute){}
simulated function AS_AnchorToBottomRight(){}
