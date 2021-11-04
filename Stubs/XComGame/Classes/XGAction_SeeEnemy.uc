class XGAction_SeeEnemy extends XGAction
	notplaceable
	hidecategories(Navigation);
//complete stub

var XGUnit m_kEnemy;
var XGCameraView m_kSavedView;
var XGCameraView m_kEnemyView;
var XGCameraView_Cinematic m_kRevealView;
var int m_iPrevEnemyMovementIndex;

function bool Init(XGUnit kUnit, XGUnit kEnemy){}

simulated state Executing
{
	function EnemyCam(){}
	function LookAt(){}
	function RevealUndramatic(){}
	function RevealCam(){}
}
