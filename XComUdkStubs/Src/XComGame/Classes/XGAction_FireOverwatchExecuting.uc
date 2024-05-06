class XGAction_FireOverwatchExecuting extends XGAction_FireImmediate
    notplaceable
    hidecategories(Navigation);

var XGUnit m_kFirstOverwatcher;
var XGUnit m_kPreviousOverwatcher;
var Vector vAutoZoomLookAtCenter;
var XGAction_Fire m_kTargetFireAction;
var bool m_bCloseCombatShot;
var const localized string m_strReactionFire;
var const localized string m_strAlienReactionFire;