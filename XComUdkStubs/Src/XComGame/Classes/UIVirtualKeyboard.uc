class UIVirtualKeyboard extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var protected string m_kLayoutRegular;
var protected string m_kLayoutShift;
var protected string m_kLayoutShiftDisplay;
var protected string m_kLayoutAltGr;
var string m_sTitle;
var string m_sDefault;

delegate delActionAccept(string userInput)
{
}

delegate delActionCancel()
{
}

defaultproperties
{
    s_package="/ package/gfxVirtualKeyboard/VirtualKeyboard"
    s_screenId="gfxVirtualKeyboard"
    e_InputState=eInputState_Evaluate
    s_name="theVirtualKeyboard"
}