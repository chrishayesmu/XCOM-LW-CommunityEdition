class UIFontTest extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var protected int m_iCurrentSelection;
var const localized string m_sLettersLower;
var const localized string m_sLettersUpper;
var const localized string m_sNumbers;
var const localized string m_sSymbols;
var const localized string m_sExtra;

defaultproperties
{
    s_package="/ package/gfxTestFont/TestFont"
    s_screenId="gfxTestFont"
    e_InputState=eInputState_Consume
    s_name="theFontHarness"
}