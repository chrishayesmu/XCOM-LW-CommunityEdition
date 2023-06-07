/// <summary>
/// Base class of all visualization actions in LWCE. LWCEAction is inspired heavily by XCOM 2's LWCEAction class.
/// The visualization system in LWCE is handled as a directed acyclic graph (DAG), though it is referred to as a
/// tree throughout the code and documentation, to match the terminology used in XCOM 2. See the documentation
/// for LWCEVisualizationManager for more details.
///
/// An LWCEAction represents a single building block of the visualization system. This could be animating a unit
/// pawn, e.g. to shoot or to move; or updating unit flags to reflect the current game state; or showing flyover
/// text when an ability activates, etc.
///
/// Any given action is either the root of its visualization tree, or it has one or more parent nodes which it depends
/// on. An action will not begin executing until it has received signals from all of its parents (except for the root vis
/// node, which will begin when the LWCEVisualizationManager signals it). These signals can be event IDs using LWCE's event
/// system; if so, the event IDs to look for must be populated in the InputEventIDs field. Alternatively, the signal from
/// a parent can be that the parent action has completed. Only one signal is needed from each parent, regardless of how many
/// signals that parent might emit. Following these rules, it is not uncommon for a parent action and its child to be
/// executing simultaneously.
///
/// Actions can also be interrupted by their children, such as when a unit is moving but is interrupted by an overwatch shot.
/// When that occurs, actions are responsible for resuming from the interrupt afterwards, if possible.
/// </summary>
class LWCEAction extends Actor
    dependson(LWCEVisualizationManager);

/// <summary>
/// A simple struct which tracks the events received from a specific parent action.
/// </summary>
struct native EventWrapper
{
	var LWCEAction Parent;
	var array<name> Events;
};

var array<EventWrapper> ReceivedEvents;   // Tracks the events received from parents so far
var array<name> InputEventIDs;            // Which event IDs this action is listening for from its parent actions
var VisualizationActionMetadata Metadata; // Metadata provided when creating the action, to help it visualize properly

var LWCEAction TreeRoot;			 // Tracks the root of the tree that this node is attached to
var array<LWCEAction> ParentActions; // The actions which must provide signals before this action can execute
var array<LWCEAction> ChildActions;  // The actions which are waiting on this node as a parent

var protectedwrite int ExecutingTime;  // How long the action has been in the 'Executing' state
var protectedwrite int TimeoutSeconds; // How long this action can spend in 'Executing' state before it is considered to have errored

var protectedwrite LWCEVisualizationManager m_kVisMgr;

var privatewrite bool bCompleted;   // If true, this action is done executing
var privatewrite bool bInterrupted; // If true, this action is currently interrupted by a child action

static function LWCEAction CreateInVisualizationTree(out VisualizationActionMetadata ActionMetadata,
										  		     optional bool ReparentChildren = false,
										  	         optional LWCEAction Parent,
										  		     optional array<LWCEAction> AdditionalParents)
{
    local LWCEAction AddAction;

    AddAction = CreateAction();
    AddActionToVisualizationTree(AddAction, ActionMetadata, ReparentChildren, Parent, AdditionalParents);

    return AddAction;
}

static function LWCEAction CreateAction(optional Actor SpawnOwner)
{
    local LWCEAction AddAction;

	AddAction = class'WorldInfo'.static.GetWorldInfo().Spawn(default.Class, SpawnOwner);
    AddAction.SubscribeToInputEvents();

    return AddAction;
}

static function LWCEAction AddActionToVisualizationTree(LWCEAction AddAction,
                                                        out VisualizationActionMetadata ActionMetadata,
													    optional bool ReparentChildren = false,
													    optional LWCEAction Parent,
													    optional array<LWCEAction> AdditionalParents)
{
	local LWCEVisualizationManager VisMgr;

    VisMgr = `LWCE_VIS_MGR;

    ActionMetadata.LastActionAdded = AddAction;
    AddAction.Metadata = ActionMetadata;

    // Hook this action into the currently-building visualization tree
	VisMgr.ConnectAction(AddAction, VisMgr.BuildVisTree, Parent, ReparentChildren, AdditionalParents);

    return AddAction;
}

/// <summary>
/// Initializes the action. Called immediately before the action begins to execute.
/// </summary>
function Init()
{
    m_kVisMgr = `LWCE_VIS_MGR;
}

function CompleteAction()
{
    if (!bCompleted)
	{
		bCompleted = true;
		GotoState('Finished');

		`LWCE_EVENT_MGR.UnregisterObjectFromAllEvents(self);

        // EVENT: LWCEAction_Completed
        //
        // SUMMARY: This event is used by the visualization system to coordinate LWCEAction instances. It should
        //          generally not be used outside of this.
        //
        // DATA: LWCEAction - The action which is now completed.
        //
        // SOURCE: LWCEAction - The action which is now completed.
		`LWCE_EVENT_MGR.TriggerEvent('LWCEAction_Completed', self, self);
    }
    else
    {
        // Make sure we wind up in the right state
		GotoState('Finished');
    }
}

event Destroyed()
{
    `LWCE_EVENT_MGR.UnregisterObjectFromAllEvents(self);
}

function bool IsComplete()
{
    return bCompleted;
}

function bool IsExecuting()
{
    return IsInState('Executing');
}

function bool IsInterrupted()
{
    return bInterrupted;
}

function bool IsReadyToExecute()
{
    return IsInState('WaitingToStart') && ReceivedEvents.Length == ParentActions.Length;
}

function bool IsTimedOut()
{
    return TimeoutSeconds > 0.0f && ExecutingTime >= TimeoutSeconds;
}

/// <summary>
/// Checks whether the received event is valid for this action. Subclasses can override this function to
/// add custom logic when receiving parent action events.
/// </summary>
function bool AllowEvent(Object EventData, LWCEAction SourceAction, name EventID, Object CallbackData)
{
	return InputEventIDs.Find(EventID) != INDEX_NONE;
}

function OnParentEvent(Object EventData, Object EventSource, name EventID, Object CallbackData)
{
	local int Index;
	local EventWrapper NewEventWrapper;
	local LWCEAction SourceAction;

	SourceAction = LWCEAction(EventSource);

    `LWCE_LOG_CLS("Received event " $ EventID $ " from object " $ EventSource);

	if (ParentActions.Find(SourceAction) == INDEX_NONE)
    {
        return;
    }

    // Check if this is a valid event meant for us, in the context it was received. Complete events are always valid.
    if (!AllowEvent(EventData, SourceAction, EventID, CallbackData) && EventID != 'LWCEAction_Completed')
    {
        return;
    }

    Index = ReceivedEvents.Find('Parent', SourceAction);

    if (Index == INDEX_NONE)
    {
        NewEventWrapper.Parent = SourceAction;
        NewEventWrapper.Events.AddItem(EventID);
        ReceivedEvents.AddItem(NewEventWrapper);
    }
    else if (ReceivedEvents[Index].Events.Find(EventID) == INDEX_NONE)
    {
        ReceivedEvents[Index].Events.AddItem(EventID);
    }

    RespondToParentEventReceived(EventData, SourceAction, EventID, CallbackData);
}

/// <summary>
/// Called whenever a valid event is received from a parent action for the first time. Begins executing this action if
/// all parent dependencies are satisfied. Subclasses can override this to add more logic.
/// </summary>
function RespondToParentEventReceived(Object EventData, LWCEAction SourceAction, name EventID, Object CallbackData)
{
    if (IsReadyToExecute())
    {
        Init();

        // Make sure this action wasn't already force-completed by something (should we go to Finished then?)
        if (!bCompleted)
        {
            GotoState('Executing');
        }
    }
}

function bool ShouldPlayZipMode()
{
    // TODO: implement an EW equivalent of XCOM 2's zip mode
    return false;
}

protected function SubscribeToInputEvents()
{
    local int Index;
    local LWCEEventManager kEventMgr;

    kEventMgr = `LWCE_EVENT_MGR;

    // Always subscribe to the complete action
    kEventMgr.RegisterForEvent(self, 'LWCEAction_Completed', OnParentEvent);

    for (Index = 0; Index < InputEventIDs.Length; Index++)
    {
        kEventMgr.RegisterForEvent(self, InputEventIDs[Index], OnParentEvent);
    }
}

auto state WaitingToStart
{
}

state Executing
{
	simulated function BeginState(name PrevStateName)
    {
        ExecutingTime = 0.0f;
    }

    event Tick(float fDeltaT)
    {
        ExecutingTime += fDeltaT;
    }
}

state Finished
{
}

defaultproperties
{
    TimeoutSeconds = 10.0f
}