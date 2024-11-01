class LWCE_UIFxsMovie extends UIFxsMovie;

simulated function FlashRaiseInit(string Path)
{
    `LWCE_LOG("FlashRaiseInit: Path=" $ Path);

    super.FlashRaiseInit(Path);
}

simulated function FlashRaiseCommand(string Path, string Cmd, string Arg)
{
    `LWCE_LOG("FlashRaiseCommand: Path=" $ Path $ ", Cmd=" $ Cmd $ ", Arg=" $ Arg);

    super.FlashRaiseCommand(Path, Cmd, Arg);
}

simulated function FlashRaiseMouseEvent(string Path, int Cmd, string Arg)
{
    `LWCE_LOG("FlashRaiseMouseEvent: Path=" $ Path $ ", Cmd=" $ Cmd $ ", Arg=" $ Arg);

    super.FlashRaiseMouseEvent(Path, Cmd, Arg);
}