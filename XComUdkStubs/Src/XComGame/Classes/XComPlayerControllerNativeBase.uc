class XComPlayerControllerNativeBase extends GamePlayerController
    native(Core)
    config(Game)
    hidecategories(Navigation);

var privatewrite bool m_bIsMouseActive;
var privatewrite bool m_bIsConsoleBuild;
var privatewrite bool m_bIsTouchEnabled;

defaultproperties
{
    bAlwaysTick=true
}