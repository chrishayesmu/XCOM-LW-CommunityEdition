/// <summary>
/// TODO
/// </summary>
class LWCEVisualizationManager extends Actor;

struct VisualizationActionMetadata
{
	var Actor VisualizeActor;							// A visualizer to associate with the action
	var init array<Actor> AdditionalVisualizeActors;	// A list of additional visualization actors the associated LWCEAction is controlling

	var LWCEAction LastActionAdded; // For convenience, to easily chain together actions while building visualization
};

var protectedwrite LWCEAction ActiveVisTree; // Action tree which is currently being visualized. Do not modify!
var LWCEAction BuildVisTree; // Action tree which is being built

function bool AreAllActiveVisActionsComplete()
{
    local int I, J;
    local array<LWCEAction> Nodes, NextNodes;

    Nodes.AddItem(ActiveVisTree);

    while (Nodes.Length > 0)
    {
        for (I = 0; I < Nodes.Length; I++)
        {
            if (!Nodes[I].IsComplete())
            {
                return false;
            }

            for (J = 0; J < Nodes[I].ChildActions.Length; J++)
            {
                NextNodes.AddItem(Nodes[I].ChildActions[J]);
            }
        }

        Nodes = NextNodes;
        NextNodes.Length = 0;
    }

    return true;
}

/// <summary>
/// Connects the provided action into the visualization tree. If no parent is provided, it will be added immediately below the tree's root.
/// </summary>
/// <param name="ActionToConnect">The action which will be newly added to the vis tree.</param>
/// <param name="UseTree">Which vis tree to connect into; this should almost always be the BuildVisTree in this class.</param>
/// <param name="Parent">The action which will become the parent to our newly added action.</param>
/// <param name="ReparentChildren">If true, all children of Parent will be moved to be children of ActionToConnect instead.</param>
/// <param name="AdditionalParents">Extra actions which should be parents to ActionToConnect. Unlike the Parent argument, their children will never be reparented.</param>
function ConnectAction(LWCEAction ActionToConnect, LWCEAction UseTree, LWCEAction Parent, bool ReparentChildren = false, optional array<LWCEAction> AdditionalParents)
{
    local int Index;

    ActionToConnect.TreeRoot = UseTree;

    if (Parent != none)
    {
        ConnectNodes(Parent, ActionToConnect, ReparentChildren);
    }
    else
    {
        ConnectNodes(UseTree, ActionToConnect, ReparentChildren);
    }

    for (Index = 0; Index < AdditionalParents.Length; Index++)
    {
        // Never reparent the children in the AdditionalParents param, only the primary parent
        ConnectNodes(AdditionalParents[Index], ActionToConnect, /* ReparentChildren */ false);
    }
}

simulated function DrawDebugLabel(Canvas kCanvas)
{
    if (`LWCE_CHEATMGR_TAC.bDebugVanillaAnims)
    {
        DebugDrawVanillaAnims(kCanvas);
    }

    if (`LWCE_CHEATMGR_TAC.bDebugVisualization)
    {
        DebugDrawVisualization(kCanvas);
    }
}

private function ConnectNodes(LWCEAction Parent, LWCEAction Child, bool ReparentChildren)
{
    local int Index;

    if (ReparentChildren)
    {
        for (Index = 0; Index < Parent.ChildActions.Length; Index++)
        {
            if (Parent.ChildActions[Index] == Child)
            {
                // Don't try to reparent an action to itself
                continue;
            }

            Parent.ChildActions[Index].ParentActions.RemoveItem(Parent);
            ConnectNodes(Child, Parent.ChildActions[Index], /* ReparentChildren */ false);
        }

        Parent.ChildActions.Length = 0;
    }

    if (Parent.ChildActions.Find(Child) == INDEX_NONE)
    {
        Parent.ChildActions.AddItem(Child);
    }

    if (Child.ParentActions.Find(Parent) == INDEX_NONE)
    {
        Child.ParentActions.AddItem(Parent);
    }
}

private function DebugDrawVanillaAnims(Canvas kCanvas)
{
    local int Index;
    local AnimNodeSequence kAnim;
    local XGAction kAction;
    local LWCE_XGUnit kActiveUnit;
    local Vector vDrawPos;

    kActiveUnit = LWCE_XGUnit(XComTacticalController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController()).GetActiveUnit());
    vDrawPos = vect(25.0f, 25.0f, 0.0f);

    // If LWCE vis debug is also occurring, shift this debug to the side to make room
    if (`LWCE_CHEATMGR_TAC.bDebugVisualization)
    {
        vDrawPos.X += 125.0f;
    }

    kCanvas.SetPos(vDrawPos.X, vDrawPos.Y += 15);
    kCanvas.SetDrawColor(255, 255, 255);
    kCanvas.DrawText("[Vanilla Animations]");

    if (kActiveUnit != none)
    {
        kAnim = AnimNodeSequence(kActiveUnit.m_kPawn.MovementNode.Children[eMoveType_Anim].Anim);

        kCanvas.SetPos(vDrawPos.X, vDrawPos.Y += 15);
        kCanvas.DrawText("Active unit: " $ kActiveUnit.m_kCharacter.GetFullName());

        // Movement anim name: color green if playing
        if (kActiveUnit.m_kPawn.MovementNode.ActiveChildIndex == eMoveType_Anim)
        {
            kCanvas.SetDrawColor(0, 255, 0);
            kCanvas.SetPos(vDrawPos.X, vDrawPos.Y += 15);
            kCanvas.DrawText("Movement anim: " $ kAnim.AnimSeqName);

            kCanvas.SetDrawColor(255, 255, 255); // restore color
        }

        kCanvas.SetPos(vDrawPos.X, vDrawPos.Y += 15);
        kCanvas.DrawText(kActiveUnit.m_kActionQueue.m_arrActions.Length $ " action(s) queued");

        vDrawPos.X += 25;

        for (Index = 0; Index < kActiveUnit.m_kActionQueue.m_arrActions.Length; Index++)
        {
            kCanvas.SetPos(vDrawPos.X, vDrawPos.Y += 15);
            kCanvas.DrawText("[" $ Index $ "]: " $ kActiveUnit.m_kActionQueue.m_arrActions[Index].Class);
        }
    }
}

private function DebugDrawVisualization(Canvas kCanvas)
{

}

private function DestroyVisTree(LWCEAction TreeRoot)
{
    local int I, J;
    local array<LWCEAction> Nodes, NextNodes;

    Nodes.AddItem(TreeRoot);

    while (Nodes.Length > 0)
    {
        for (I = 0; I < Nodes.Length; I++)
        {
            if (Nodes[I] == none)
            {
                continue;
            }

            for (J = 0; J < Nodes[I].ChildActions.Length; J++)
            {
                NextNodes.AddItem(Nodes[I].ChildActions[J]);
            }

            Nodes[I].Destroy();
        }

        Nodes = NextNodes;
        NextNodes.Length = 0;
    }
}

private function bool IsBuildVisTreePendingExecution()
{
    return BuildVisTree != none && BuildVisTree.ChildActions.Length > 0;
}

private function SetUpBuildVisTree()
{
`if (`notdefined(FINAL_RELEASE))
    if (BuildVisTree != none)
    {
        `LWCE_LOG_CLS("ERROR: SetUpBuildVisTree called while there's still a BuildVisTree: " $ BuildVisTree);
        return;
    }
`endif

    // Use a simple marker as the build root. This lets multiple top-level actions run in parallel, and makes it easy
    // to identify the root if needed.
    BuildVisTree = class'LWCEAction_NamedMarker'.static.CreateAction();
    BuildVisTree.TreeRoot = BuildVisTree;
    LWCEAction_NamedMarker(BuildVisTree).MarkerName = 'VisTreeRoot';
}

// Idle state: check if there's pending visualization to execute, and change states if so
auto state Idle
{
    event BeginState(name PreviousStateName)
    {
        `LWCE_LOG_CLS("BeginState: Idle (coming from state " $ PreviousStateName $ ")");

        if (BuildVisTree == none)
        {
            SetUpBuildVisTree();
        }

        `LWCE_EVENT_MGR.TriggerEvent('VisualizationIdle', self, self);
    }

    event Tick(float fDeltaT)
    {
        // If a tree has built and we're not visualizing right now, use that tree. We can
        // trust that it's not still building because none of our logic is multi-threaded.
        if (ActiveVisTree == none && IsBuildVisTreePendingExecution())
        {
            `LWCE_LOG_CLS("Flipping build tree to active tree");
            ActiveVisTree = BuildVisTree;

            // Set up a new tree that the next visualization sequences can build on
            BuildVisTree = none;
            SetUpBuildVisTree();
        }

        // TODO add a check that vis is enabled (e.g. pause menu not open)
		if (ActiveVisTree != none)
		{
            `LWCE_LOG_CLS("Found an active tree to visualize, moving to state ExecutingVisualization");
			GotoState('ExecutingVisualization');
		}

        super.Tick(fDeltaT);
    }
}

state ExecutingVisualization
{
    event BeginState(name PreviousStateName)
	{
        // Kick off the root element of the vis tree
        if (ActiveVisTree != none && ActiveVisTree.IsReadyToExecute())
        {
            `LWCE_LOG_CLS("Starting active vis tree at root " $ ActiveVisTree);
            ActiveVisTree.Init();
		    ActiveVisTree.GotoState('Executing');
        }
	}

    event Tick(float fDeltaT)
    {
        if (AreAllActiveVisActionsComplete())
        {
            `LWCE_LOG_CLS("All active vis actions complete; moving back to idle");

            // Clear out the vis tree so we can move on to the next one
            // TODO: actions are actors, so we need to destroy them before moving on
            DestroyVisTree(ActiveVisTree);
            ActiveVisTree = none;
            GotoState('Idle');
        }

        super.Tick(fDeltaT);
    }
}