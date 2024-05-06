class UITurnOverlay extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

enum ETurnOverlay
{
    eTurnOverlay_Local,
    eTurnOverlay_Remote,
    eTurnOverlay_Alien,
    eTurnOverlay_MAX
};

var private float m_fAnimateTime;
var private float m_fAnimateRate;
var private bool m_bXComTurn;
var private bool m_bAlienTurn;
var private bool m_bOtherTurn;
var const localized string m_sXComTurn;
var const localized string m_sAlienTurn;
var const localized string m_sOtherTurn;
var const localized string m_sExaltTurn;

defaultproperties
{
    m_fAnimateRate=0.010
    s_package="/ package/gfxTurnOverlay/TurnOverlay"
    s_screenId="gfxTurnOverlay"
    s_name="theTurnOverlay"
}