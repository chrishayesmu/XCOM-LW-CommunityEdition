class UIDebugMenu extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

enum eDebugCategory
{
    eDebug_AI,
    eDebug_Strategy,
    eDebug_CursorMode,
    eDebug_Gameplay,
    eDebug_List,
    eDebug_Misc,
    eDebug_Show,
    eDebug_Stat,
    eDebug_Toggle,
    eDebug_UI,
    eDebug_ViewMode,
    eDebug_Total,
    eDebug_MAX
};

struct DebugCommand
{
    var string DebugCommand;
    var string helpText;
};

struct DebugCommandList
{
    var eDebugCategory cat;
    var array<DebugCommand> Commands;
};

var protected int m_iCurCommandSelection;
var protected int m_iCurCategorySelection;
var protected bool m_bCategoriesFocused;
var bool m_bEnabled;
var string categoryNames[eDebugCategory];
var array<DebugCommandList> debugCategories;

defaultproperties
{
    categoryNames[0]="AI"
    categoryNames[1]="Base (Strategy)"
    categoryNames[2]="Cursor Mode"
    categoryNames[3]="Gameplay (Tactical)"
    categoryNames[4]="Lists Show/Hide"
    categoryNames[5]="Misc"
    categoryNames[6]="Show commands"
    categoryNames[7]="Stats"
    categoryNames[8]="Toggles"
    categoryNames[9]="User Interface"
    categoryNames[10]="View Modes"
    s_package="/ package/gfxDebugMenu/DebugMenu"
    s_screenId="gfxDebugMenu"
    e_InputState=eInputState_Consume
    s_name="theDebugMenu"
}