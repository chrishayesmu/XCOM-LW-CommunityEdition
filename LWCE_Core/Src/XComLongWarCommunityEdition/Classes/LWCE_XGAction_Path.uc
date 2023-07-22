// TODO: get rid of this whole class and consider migrating its functionality into the replacement LWCEAction
// (but probably don't, it can be its own mod)
class LWCE_XGAction_Path extends XGAction_Path;

function bool Init(XGUnit kUnit)
{
    super.Init(kUnit);

    // Need to update the grid state immediately to avoid any flickering as we change units
    UpdateShowFullTacticalGrid();

    return true;
}

simulated function UpdateShowFullTacticalGrid()
{
    local PlayerController kPC;
    local XComPathingPawn kPawn;

    if (!m_bOwnedByLocalPlayer || m_kPlayerControllerOwner == none || !m_kPlayerControllerOwner.IsMouseActive())
    {
        return;
    }

    kPawn = GetPathPawn();
    kPC = m_kCursor.GetALocalPlayerController();

    if ( `LWCE_CHEATMGR_TAC.bDisplayMovementGrid || (kPC != none && XComTacticalInput(kPC.PlayerInput) != none && XComTacticalInput(kPC.PlayerInput).m_fRightMouseHoldTime >= 0.20) )
    {
        kPawn.SetShowFullTacticalGrid(true);
    }
    else
    {
        kPawn.SetShowFullTacticalGrid(false);
    }
}

simulated event Destroyed()
{
    super.Destroyed();
}

simulated event DoPathingTick(float DeltaTime)
{
    super.DoPathingTick(DeltaTime);
}

simulated state ExecutingSchedule
{
    simulated event BeginState(name nmPrevState)
    {
        super.BeginState(nmPrevState);
    }

    simulated event EndState(name nmNextState)
    {
        super.EndState(nmNextState);
    }
}