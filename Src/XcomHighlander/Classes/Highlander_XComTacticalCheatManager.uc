class Highlander_XComTacticalCheatManager extends XComTacticalCheatManager;

var bool bDisplayMovementGrid;

exec function ToggleDebugMenu()
{
    if (DebugMenu == none)
    {
        DebugMenu = Outer.Spawn(class'Highlander_UIDebugMenu');
    }

    if (DebugMenu.m_bEnabled == false)
    {
        if (Outer.m_Pres.GetHUD().m_bDebugHardHide)
        {
            UIToggleHardHide();
        }

        DebugMenu.Init(Outer, Outer.m_Pres.GetHUD());
        Outer.PlayerInput.PushState('DebugMenuEnabled');
    }
    else
    {
        DebugMenu.Lower();
        DebugMenu = none;
        Outer.PlayerInput.PopState();
    }
}

exec function ToggleDisplayOfMovementGrid()
{
    bDisplayMovementGrid = !bDisplayMovementGrid;
}