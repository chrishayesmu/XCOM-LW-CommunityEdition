class LWCEEventManager extends Object;

struct EventListener
{
	// The unique ID of the event this listener is interested in receiving notification for.
	var Name EventID;

	// The object that is registered for this event.
	var Object SourceObject;

	// IF non-null, contains a data object that was provided when the event listener registered.
	var Object CallbackData;

	// The priority given to this event listener (relative to all other listeners for the same event).
	// Determines the order in which event listeners are processed. Higher values are processed first.
	var int Priority;

	// If true, this Event Listener needs to persist across Tactical-Strategy transitions.
	var bool bIsPersistent;

	// The delegate to be called when this event is activated.
	var delegate<OnEventDelegate> EventDelegate;
};

var private array<EventListener> m_arrListeners;

delegate OnEventDelegate(Object EventData, Object EventSource, Name EventID, Object CallbackData);

function RegisterForEvent(Object SourceObj, name EventID, delegate<OnEventDelegate> NewDelegate, optional int Priority = 50, optional bool bIsPersistent = false, optional Object CallbackData = none)
{
    local EventListener kEventListener;

    kEventListener.SourceObject = SourceObj;
    kEventListener.EventID = EventID;
    kEventListener.EventDelegate = NewDelegate;
    kEventListener.Priority = Priority;
    kEventListener.bIsPersistent = bIsPersistent;
    kEventListener.CallbackData = CallbackData;

    m_arrListeners.AddItem(kEventListener);
}

function TriggerEvent(Name EventID, optional Object EventData, optional Object EventSource)
{
    local delegate<OnEventDelegate> EventDelFn;
    local array<EventListener> arrEligibleListeners;
    local int Index;

    // First, work out the relative order to execute event listeners in
    for (Index = 0; Index < m_arrListeners.Length; Index++)
    {
        if (m_arrListeners[Index].EventID == EventID)
        {
            InsertListenerInPriorityOrder(Index, arrEligibleListeners);
        }
    }

    // Now go through and run the listeners
    for (Index = 0; Index < arrEligibleListeners.Length; Index++)
    {
        EventDelFn = arrEligibleListeners[Index].EventDelegate;
        EventDelFn(EventData, EventSource, EventID, arrEligibleListeners[Index].CallbackData);
    }

    // When the game world is about to change, unregister everything
    if (EventID == 'TacticalGameEnding')
    {
        UnregisterAllListeners();
    }
}

/// <summary>
/// Immediately unregisters all listeners from the event manager. Should be called when transitioning game worlds,
/// or else the event manager may hold references to stale Actors and cause the game to crash.
/// </summary>
function UnregisterAllListeners()
{
    `LWCE_LOG_CLS("Unregistering all event listeners..");

    m_arrListeners.Length = 0;
}

function UnregisterObjectFromAllEvents(Object SourceObj)
{
    local int Index;

    for (Index = m_arrListeners.Length - 1; Index >= 0; Index--)
    {
        if (m_arrListeners[Index].SourceObject == SourceObj)
        {
            m_arrListeners.Remove(Index, 1);
        }
    }
}

private function InsertListenerInPriorityOrder(int iListenerIndex, out array<EventListener> Listeners)
{
    local int Index;
    local bool bAdded;

    // Look for the first position where this listener would fit
    for (Index = 0; Index < Listeners.Length; Index++)
    {
        if (m_arrListeners[iListenerIndex].Priority >= Listeners[Index].Priority)
        {
            Listeners.InsertItem(Index, m_arrListeners[iListenerIndex]);
            bAdded = true;
            break;
        }
    }

    if (!bAdded)
    {
        Listeners.AddItem(m_arrListeners[iListenerIndex]);
    }
}