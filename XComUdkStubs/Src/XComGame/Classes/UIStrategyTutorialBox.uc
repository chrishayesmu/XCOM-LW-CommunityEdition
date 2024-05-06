class UIStrategyTutorialBox extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var private string m_strHelpText;
var private bool m_bPlayingOutro;
var private bool m_bIsStrategy;

defaultproperties
{
    s_package="/ package/gfxStrategyTutorialBox/StrategyTutorialBox"
    s_screenId="gfxStrategyTutorialBox"
    s_name="theStrategyTutorialBox"
}