class XGInterceptionEngagementUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EIEngagementView
{
    eIntEngagementView_Engagement,
    eIntEngagementView_Result,
    eIntEngagementView_MAX
};

enum EInterceptionEngagementFX
{
    eInterceptionEngagementFX_AlienDetection,
    eInterceptionEngagementFX_AlienSweepHit,
    eInterceptionEngagementFX_InterceptorLaunch,
    eInterceptionEngagementFX_InterceptorEngage,
    eInterceptionEngagementFX_InterceptorAttack,
    eInterceptionEngagementFX_InterceptorHit,
    eInterceptionEngagementFX_InterceptorUFODefeat,
    eInterceptionEngagementFX_InterceptorUFOGotAway,
    eInterceptionEngagementFX_SkyRangerLaunch,
    eInterceptionEngagementFX_SkyRangerArrive,
    eInterceptionEngagementFX_MAX
};

var TImage m_imgUFO;
var TButtonText m_btDisengageHelp;
var TButtonText m_btExitHelp;
var bool m_bHPWarning;
var bool m_bFirstFire;
var XGInterceptionEngagement m_kInterceptionEngagement;
var const localized string m_strLabelDisengage;
var const localized string m_strLabelLeaveReport;
var private float m_fEnemyEscapeWarningTimer;

function Init(int iView){}
function PostInit(XGInterception kXGInterception){}
function bool IsShortDistanceWeapon(int iWeapon){}
function OnEngagementOver(){}
function OnResultLeave(){}
function VOCloseDistance(){}
function VOInRange(){}
function SFXFire(int iWeaponType){}
function SFXShipHit(XGShip kShip, int iDamage){}
function SFXShipDestroyed(XGShip kShip){}
function SFXEnemyEscapeTimerUpdated(float newTimeRemaining){}
function Abort(){}


DefaultProperties
{
}
