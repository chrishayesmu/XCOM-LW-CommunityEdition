class XComMainMenuGame extends XComMainMenuGameInfoNativeBase
    config(Game)
    hidecategories(Navigation,Movement,Collision);

defaultproperties
{
    PlayerControllerClass=class'XComMainMenuController'
}