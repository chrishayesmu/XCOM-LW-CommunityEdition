class UIMouseGuard extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager)
{
    BaseInit(_controller, _manager);
}

simulated function OnInit()
{
    super.OnInit();
}

simulated function bool OnMouseEvent(int ucmd, array<string> parsedArgs)
{
    return true;
}