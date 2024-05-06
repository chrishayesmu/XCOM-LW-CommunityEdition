class UIMouseCursor extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var privatewrite Vector2D m_v2MouseLoc;
var privatewrite Vector2D m_v2MouseFrameDelta;
var privatewrite bool bIsInDefaultLocation;

defaultproperties
{
    bIsInDefaultLocation=true
    s_package="/ package/gfxMouseCursor/MouseCursor"
    s_screenId="gfxMouseCursor"
    s_name="theMouseCursorContainer"
    m_bVisible=false
}