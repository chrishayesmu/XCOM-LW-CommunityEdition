class XComDirectedTacticalExperience extends Actor
    native(Level)
    placeable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord
{
    var array<string> PlaybackScript;
    var int CurrentSequence;
    var bool bEnabled;
    var bool m_bAllowFiring;
    var bool m_bAliensDealDamage;
    var array<int> m_arrButtonsBlocked;
    var bool m_bDisplayedOffscreenMessage;
};

var() bool bEnabled;
var bool m_bAllowFiring;
var bool m_bAliensDealDamage;
var bool m_bLoadedFromSaveEnabled;
var private bool m_bDisplayedOffscreenMessage;
var() array<string> PlaybackScript;
var int CurrentSequence;
var private transient int m_iInvalidClicks;
var private transient XGUnit m_kClickedUnit;
var private transient int m_iInvalidTurn;
var private transient Vector m_vCameraLookAt;
var int m_iNextSequenceOverride;
var array<int> m_arrButtonsBlocked;
var private transient float m_fTickTime;
var private transient XGUnit m_kPrevActiveUnit;

function ApplyCheckpointRecord(){}
function EnableDTE(){}
function DisableDTE(){}
event PostBeginPlay(){}
// Export UXComDirectedTacticalExperience::execDisableAllDTESequences(FFrame&, void* const)
native function DisableAllDTESequences();

// Export UXComDirectedTacticalExperience::execFindSubSequence(FFrame&, void* const)
native function Sequence FindSubSequence(string SubSequenceName);

// Export UXComDirectedTacticalExperience::execActivateSubSequence(FFrame&, void* const)
native function ActivateSubSequence(string SubSequenceName);

// Export UXComDirectedTacticalExperience::execDeactivateSubSequence(FFrame&, void* const)
native function DeactivateSubSequence(string SubSequenceName);

function bool MoveToNextSequence(){}
private final function OnDisabled(){}
function InvalidMovement(XGUnit ActiveUnit){}
function SetFiringIsAllowed(bool bAllowed){}
function SetAliensDealDamage(bool Damage){}
simulated function BlockButton(int Cmd){}
simulated function Unblockbutton(int Cmd){}
simulated function UnblockAllButtons(){}
simulated function bool ButtonIsBlocked(int Cmd){}
simulated function bool ShowShotHUD(){}
simulated function bool AllowSwapWeapons(){}
simulated function bool AllowCameraSpin(){}
simulated function bool AllowElevationChange(){}
simulated function bool AllowOverwatch(){}

state Enabled
{    
	event BeginState(name PreviousStateName){}
    event EndState(name NextStateName){}
    simulated function Tick(float fDeltaTime){}
}

state Disabled
{
	event BeginState(name PreviousStateName){}
}

state CameraLookAt
{}
