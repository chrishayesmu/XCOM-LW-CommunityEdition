class UIInterceptionEngagement extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface)
	dependson(XGInterceptionEngagement);

const SHOT_DURATION = 0.3f;
const MISS_DURATION_EXTENSION = 0.3f;
const ALIEN_SHIP_ID = 0;
const PLAYER_SHIP_ID = 1;

enum eMoveEventType
{
    eUFO_Escape,
    ePlayer_CloseDistance,
    eMoveEventType_MAX
};

enum eGameResult
{
    eUFO_Escaped,
    eUFO_Destroyed,
    ePlayer_Aborted,
    ePlayer_Destroyed,
    eGameResult_MAX
};

enum eDisplayEffectType
{
    eEnhancedAccuracy,
    eDodgeHits,
    eTrack,
    eDisplayEffectType_MAX
};

enum eAbilityStates
{
    eAbilityState_Available,
    eAbilityState_Active,
    eAbilityState_Disabled,
    eAbilityState_Unavailable,
    eAbilityState_MAX
};

struct TAttack
{
    var int iSourceShip;
    var int iTargetShip;
    var int iWeapon;
    var int iDamage;
    var float fDuration;
    var bool bHit;

    structdefaultproperties
    {
        iSourceShip=0
        iTargetShip=0
        iWeapon=0
        iDamage=0
        fDuration=0.0
        bHit=false
    }
};

struct TDamageData
{
    var int iShip;
    var int iDamage;
    var int iBulletID;
    var float fTime;

    structdefaultproperties
    {
        iShip=0
        iDamage=0
        iBulletID=0
        fTime=0.0
    }
};

var const localized string m_strEstablishingLinkLabel;
var const localized string m_strPlayerDamageLabel;
var const localized string m_strLeaveReportButtonLabel;
var const localized string m_strAbortMission;
var const localized string m_strAbortingMission;
var const localized string m_strAbortedMission;
var const localized string m_strDodgeAbility;
var const localized string m_strAimAbility;
var const localized string m_strTrackAbility;
var const localized string m_strTrackingText;
var const localized string m_strEscapeTimerTitle;
var const localized string m_strResult_UFOCrashed;
var const localized string m_strResult_UFODestroyed;
var const localized string m_strResult_UFOEscaped;
var const localized string m_strResult_UFODisengaged;
var const localized string m_strReport_NoDamage;
var const localized string m_strReport_LightDamage;
var const localized string m_strReport_HeavyDamage;
var const localized string m_strReport_SevereDamage;
var const localized string m_strReport_ShotDown;
var const localized string m_strReport_Title;
var const localized string m_strReport_Subtitle;
var const localized string m_strTimeSufixSymbol;
var const localized string m_strAbilityDescriptions[eDisplayEffectType];
var float INTRO_SEQUENCE_DELAY;
var string m_strCameraTag;
var name DisplayTag;
var float m_fPlaybackTimeElapsed;
var float m_fEnemyEscapeTimer;
var float m_fTotalBattleLength;
var float m_fTrackingTimer;
var int m_iTenthsOfSecondCounter;
var int m_iInterceptorPlaybackIndex;
var int m_iUFOPlaybackIndex;
var int m_iBulletIndex;
var int m_iLastDodgeBulletIndex;
var bool m_bPendingDisengage;
var bool m_bViewingResults;
var bool m_DataInitialized;
var bool m_bIntroSequenceComplete;
var float m_fIntroSequenceTimer;
var array<TDamageData> m_akDamageInformation;
var int m_iDamageDataIndex;
var int m_iView;
var XGInterceptionEngagementUI m_kMgr;
var XGInterception m_kXGInterception;

simulated function XGInterceptionEngagementUI GetMgr(){}
simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, XGInterception kXGInterception){}
simulated function OnInit(){}
function OnFlashCommand(string Cmd, string Arg){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function ActivateDodgeAbility(){}
simulated function ActivateAimAbility(){}
simulated function ActivateTrackAbility(){}
simulated event Tick(float fDeltaT){}
simulated function Playback(float fDeltaT){}
simulated function int GetWeaponType(CombatExchange kCombatExchange){}
simulated function UpdateEnemyEscapeTimer(float fDeltaT){}
simulated function ShowResultScreen(){}
final simulated function SetConsumablesState(optional int stateOverride){}
simulated function TryAbort(){}
simulated function bool MayDisengage(){}
simulated function string GetAbilityDescription(UIInterceptionEngagement.eDisplayEffectType Type){}
function AS_AttackEvent(int sourceShip, int targetShip, int WeaponType, int weaponID, int Damage, float attackDuration, bool Hit){}
function AS_MovementEvent(int sourceShip, int moveType, float moveDuration){}
function AS_DisplayEffectEvent(int effectType, string effectDescription, optional bool Enabled, optional int effectData){}
function AS_InitializeData(int playerShipType, int enemyShipType, string damageLabel, string establishingLinkLabel){}
function AS_BeginIntroSequence(optional string trackingText){}
function AS_SetHP(int targetShip, int newHP, bool initialization, optional int weaponID){}
function AS_SetShipType(int targetShip, int Type){}
function AS_SetResultsTitleLabels(string Title, string subtitle){}
function AS_ShowResults(string report, int battleResult, string leaveReportButtonLabel){}
function AS_SetAbortLabel(string Label){}
function AS_SetEnemyEscapeTimerLabels(string Title, string secondsSufix){}
function AS_SetAbortButtonText(string txt){}
function AS_SetDodgeButton(string buttonLabel, optional int abilityState){}
function AS_SetTrackButton(string buttonLabel, string trackingText, optional int abilityState){}
function AS_SetAimButton(string buttonLabel, optional int abilityState){}
function int AS_MayDisengage(){}
function AS_SetEnemyEscapeTimer(int TimeLeft){}
function AS_SetTrackingLabelText(string txt){   }
function GoToView(int iView){}
event Destroyed(){}
function UnlockItems(array<TItemUnlock> arrUnlocks){}
function UnlockItem(TItemUnlock kUnlock){}

