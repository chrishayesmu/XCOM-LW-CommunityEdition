class LWCE_UIModSettings extends UI_FxsScreen;
// NOTE: This class is not remotely finished and is just here as a placeholder for now

var const localized string m_strWindowTitle;

var privatewrite GFXObject m_kGfx;
var privatewrite array<UIWidgetHelper> m_arrWidgetHelpers;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager)
{
    BaseInit(_controllerRef, _manager);
    manager.LoadScreen(self);
    Show();
}

simulated function OnInit()
{
    local LWCEUIButton kButton;
    local LWCEUICheckbox kCheckbox;
    local LWCEUICombobox kCombobox;
    local LWCEUISlider kSlider;
    local int I;

    super.OnInit();

    m_kGfx = manager.GetVariableObject(string(GetMCPath()));

    for (I = 0; I < 5; I++)
    {
        m_arrWidgetHelpers.AddItem(Spawn(class'UIWidgetHelper', self));
        m_arrWidgetHelpers[I].s_name = "widgetHelper" $ string(I) $ ".";
    }

    // Hide tabs along the top, we don't use any
    m_kGfx.GetObject("buttonTab0").SetVisible(false);
    m_kGfx.GetObject("buttonTab1").SetVisible(false);
    m_kGfx.GetObject("buttonTab2").SetVisible(false);
    m_kGfx.GetObject("buttonTab3").SetVisible(false);
    m_kGfx.GetObject("buttonTab4").SetVisible(false);

    // Hide some buttons we don't use
    m_kGfx.GetObject("centerButton1").SetVisible(false);
    m_kGfx.GetObject("centerButton2").SetVisible(false);

    AS_SetTitle(m_strWindowTitle);
    AS_SetHelp(0, class'UIUtilities'.default.m_strGenericBack, class'UI_FxsGamepadIcons'.static.GetBackButtonIcon());
    AS_SetHelp(3, class'UIOptionsPCScreen'.default.m_strExitAndSaveSettings, "Icon_X_SQUARE");

    RefreshData();

    if (IsVisible())
    {
        Show();
    }

    // TODO: delete. Just some testing of UI utils for now.
    kButton = class'LWCEUIUtils'.static.CreateButton(m_kGfx, "lwceModButton");
    kButton.SetLabel("My Button");
    kButton.SetX(300);
    kButton.SetY(120);

    kCheckbox = class'LWCEUIUtils'.static.CreateCheckbox(m_kGfx, "lwceModCheckbox");
    kCheckbox.SetLabel("My Checkbox");
    kCheckbox.SetX(kButton.GetX());
    kCheckbox.SetY(240);

    kCombobox = class'LWCEUIUtils'.static.CreateCombobox(m_kGfx, "lwceModCombobox");
    kCombobox.SetButtonLabel("My Combobox");
    //kCombobox.SetButtonText("Item 0");
    kCombobox.SetX(kButton.GetX());
    kCombobox.SetY(360);

    kCombobox.ClearList();
    kCombobox.AddListItem(0, "Item 0");
    kCombobox.AddListItem(1, "Item 1");
    kCombobox.AddListItem(2, "Item 2");

    kCombobox.SetSelectedItem(0);
    kCombobox.Realize();

    kSlider = class'LWCEUIUtils'.static.CreateSlider(m_kGfx, "lwceModSlider");
    kSlider.SetLabel("My Slider");
    kSlider.SetX(kButton.GetX());
    kSlider.SetY(480);
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    local bool bHandled;
    local string strTargetName;

    bHandled = true;
    strTargetName = args[args.Length - 1];

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            if (strTargetName == "theBackButton")
            {
                ExitScreen();
            }

            break;
        default:
            bHandled = false;
            break;
    }

    return bHandled;
}

simulated function bool OnUnrealCommand(int Cmd, int Actionmask)
{
    local int I;

    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Actionmask))
    {
        return true;
    }

    for (I = 0; I < m_arrWidgetHelpers.Length; I++)
    {
        if (m_arrWidgetHelpers[I].OnUnrealCommand(Cmd, Actionmask))
        {
            return true;
        }
    }

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
        case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
            ExitScreen();
            break;
        default:
            break;
    }

    return true;
}

simulated function ExitScreen()
{
    AS_PrepClosing();

    controllerRef.m_Pres.PopState();
    PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
}

function RefreshData()
{
    AS_SelectTab(2);
}

simulated function AS_SetHelp(int Index, string Text, string buttonIcon)
{
    manager.ActionScriptVoid(string(screen.GetMCPath()) $ ".SetHelp");
}

simulated function AS_SetTitle(string Title)
{
    manager.ActionScriptVoid(string(GetMCPath()) $ ".SetTitle");
}

simulated function AS_SetTabTitle(int Index, string Title)
{
    manager.ActionScriptVoid(string(GetMCPath()) $ ".SetTabTitle");
}

simulated function AS_SetLanguageHint(string hint)
{
    manager.ActionScriptVoid(string(GetMCPath()) $ ".SetLangaugeHint");
}

simulated function AS_SelectTab(int Index)
{
    manager.ActionScriptVoid(string(GetMCPath()) $ ".SelectTab");
}

simulated function AS_SetGammaDirections(string Text)
{
    manager.ActionScriptVoid(string(GetMCPath()) $ ".SetGammaDirections");
}

simulated function AS_SetTabHelp(string str0, string str1)
{
    manager.ActionScriptVoid(string(GetMCPath()) $ ".SetTabHelp");
}

simulated function AS_PrepClosing()
{
    manager.ActionScriptVoid(string(GetMCPath()) $ ".PrepClosing");
}

defaultproperties
{
	s_package="/ package/gfxOptionsPCScreen/OptionsPCScreen"
	s_screenId="gfxOptionsPCScreen"
	s_name="theScreen"
    e_InputState=eInputState_Consume
}