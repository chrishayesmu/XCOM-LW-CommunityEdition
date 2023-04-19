class LWCEEventListenerTemplate extends LWCEDataTemplate
    config(Unused) // required because parent has PerObjectConfig set, else game crashes
    dependson(LWCEEventManager);

/// <summary>
/// Internal struct for this class. See AddEvent for info on class usage.
/// </summary>
struct EventRegistration
{
	var Name EventID;

	var int Priority;

	var delegate<LWCEEventManager.OnEventDelegate> EventDelegate;
};

var bool bRegisterInStrategy; // If true, all listeners in this template will register at the start of the strategy game.
var bool bRegisterInTactical; // If true, all listeners in this template will register at the start of the tactical game.

var privatewrite array<EventRegistration> m_arrEventRegistrations;

function AddEvent(name EventID, delegate<LWCEEventManager.OnEventDelegate> NewDelegate, optional int Priority = 50)
{
    local EventRegistration kEventReg;

    kEventReg.EventID = EventID;
    kEventReg.Priority = Priority;
    kEventReg.EventDelegate = NewDelegate;

    m_arrEventRegistrations.AddItem(kEventReg);
}

function RegisterAllEvents()
{
    local LWCEEventManager kEventMgr;
    local int Index;

    kEventMgr = `LWCE_EVENT_MGR;

    for (Index = 0; Index < m_arrEventRegistrations.Length; Index++)
    {
        kEventMgr.RegisterForEvent(self, m_arrEventRegistrations[Index].EventID, m_arrEventRegistrations[Index].EventDelegate, m_arrEventRegistrations[Index].Priority);
    }
}

function UnregisterFromAllEvents()
{
    `LWCE_EVENT_MGR.UnregisterObjectFromAllEvents(self);
}