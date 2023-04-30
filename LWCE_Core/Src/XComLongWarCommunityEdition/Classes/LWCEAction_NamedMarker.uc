/// <summary>
/// A simple action which does no actual visualization, but helps to mark portions of the vis tree
/// in such a way that other actions know where to insert themselves.
/// </summary>
class LWCEAction_NamedMarker extends LWCEAction;

var name MarkerName;

simulated state Executing
{
Begin:
`if(`notdefined(FINAL_RELEASE))
    if (MarkerName == '')
    {
        `LWCE_LOG_CLS("ERROR: " $ default.Class $ " was executed in the vis tree, but has no MarkerName set!");
    }
`endif

    `LWCE_LOG_CLS("Completing action immediately");
	CompleteAction();
}