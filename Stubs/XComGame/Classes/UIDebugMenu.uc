class UIDebugMenu extends UI_FxsScreen;
//complete stub

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
    var UIDebugMenu.eDebugCategory cat;
    var array<DebugCommand> Commands;
};

var protected int m_iCurCommandSelection;
var protected int m_iCurCategorySelection;
var protected bool m_bCategoriesFocused;
var bool m_bEnabled;
var string categoryNames[eDebugCategory];
var array<DebugCommandList> debugCategories;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function Lower(){}
simulated function bool OnUnrealCommand(int ucmd, int Actionmask){}
simulated function OnUAccept(){}
simulated function OnUCancel(){}
simulated function OnUDPadUp(){}
simulated function OnUDPadDown(){}
simulated function OnToggleFocus(){}
simulated function SetSelected(int iTarget){}
simulated function int GetSelected(){}
simulated function BuildMenu(){}
simulated function AddCategory(int Id, string cat){}
simulated function AddCommand(int Id, string Command, string Help){}
simulated function SetCategory(int Id){}
simulated function SetSubMenuFocused(bool Focus){}
simulated function SetMapName(string sName){}
