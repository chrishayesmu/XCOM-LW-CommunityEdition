class UITacticalHUD_ObjectivesList extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

struct UIObjective
{
    var string strId;
    var string strTitle;
    var string strDesc;
    var bool bShowCheckmark;
    var bool bIsCompleted;
    var bool bIsFailed;
    var int iPriority;

    structdefaultproperties
    {
        iPriority=-1
    }
};

var bool bNeedsSorting;
var bool bWaitingForObjectiveLoad;
var const localized string m_strObjectivesListTitle;
var array<string> PendingObjectiveCompleteEvents;
var array<string> PendingObjectiveFailedEvents;
var array<UIObjective> PendingObjectives;
var array<UIObjective> ActiveObjectives;

defaultproperties
{
    s_name="theObjectivesList"
}