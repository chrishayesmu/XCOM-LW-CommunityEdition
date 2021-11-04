class UITacticalHUD_ObjectivesList extends UI_FxsPanel;
//complete stub

struct UIObjective
{
    var string strId;
    var string strTitle;
    var string strDesc;
    var bool bShowCheckmark;
    var bool bIsCompleted;
    var bool bIsFailed;
    var int iPriority;
};
var bool bNeedsSorting;
var bool bWaitingForObjectiveLoad;
var const localized string m_strObjectivesListTitle;
var array<string> PendingObjectiveCompleteEvents;
var array<string> PendingObjectiveFailedEvents;
var array<UIObjective> PendingObjectives;
var array<UIObjective> ActiveObjectives;

simulated function AddObjective(string objectiveID, string Title, string Description, bool showCheckmark, optional int Priority=-1){}
simulated function CompleteObjective(string objectiveID){}
simulated function FailObjective(string objectiveID){}
simulated function RemoveObjective(string objectiveID){}
simulated function RemoveAllObjectives(){}
simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function SortObjectives(){}
simulated function int SortUIObjectives(UIObjective A, UIObjective B){}
simulated function int GetObjectiveIndex(string Id, array<UIObjective> arr){}
simulated function bool HasHints(array<UIObjective> arr){}
function AS_SetTitle(string Title){}
function AS_AddObjective(string Id, string Title, string Description, bool showCheckmark, optional int queuePos=-1){}
function AS_CompleteObjective(string Id){}
function AS_FailObjective(string Id){}
function AS_RemoveObjective(string Id){}
function AS_SetSortedList(array<string> arr){}

DefaultProperties
{
}
