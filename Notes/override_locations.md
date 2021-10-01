
# What is a 'Class Override'?

UnrealScript shares many runtime semantics with object-oriented programs of the early 2000's (e.g. Java). An aspect of this is that strings can serve as identifiers for doing namespace/variable resolution, and 'dynamic' class creation.

...

(more of an explainer to go here)
...

# Identifying ideal patching locations

The goal here is to identify the most ideal bytecode patch locations for class overrides. ideal being locations that give the most control over further class creation, and require the least amount of bytecode patching.


Roughly, `XComGame` is primarily responsible for tactical missions in Xcom, and `XComStrategyGame` is responsible for the strategy layer (i.e. the 'Xcom HQ' layer). Annoyingly, both have fairly different initialisation routines, meaning we can't have a one-size fits all approach to patching.

For `XComGame` - "initialisation" means:
    - Transitioning from the strategy (hq) layer into a mission (skyranger, xcom hq defence)
    - Loading a savegame from the shell (i.e. main menu, pause menu in both tac/strat layer)

`XComGame` doesn't deviate much from the canonical model of initialisation stated by https://docs.unrealengine.com/udk/Three/UnrealScriptGameFlow.html. This means that before any other classes are initialised, `XComGameInfo.InitGame` will be called:

```cpp
class XComTacticalGame extends XComGameInfo;

event InitGame(string Options, out string ErrorMessage) {
    // ...
    super.InitGame(Options, ErrorMessage);
}
```

`XComGameInfo`, `XComTacticalGame`'s superclass, is modified by long war to be the entrypoint for loading in and running its custom mutators:

```cpp
class XComGameInfo extends FrameworkGame;

// ...

event InitGame(string Options, out string ErrorMessage) {
    AddMutator("XComMutator.XComMutatorLoader", true);
    if(BaseMutator != none) {
        BaseMutator.Mutate("XComGameInfo.InitGame", GetALocalPlayerController());
    }
    CacheMods();
    super(GameInfo).InitGame(Options, ErrorMessage);
}
```

A nice property of the tactical layer is that many important (perhaps all?) classes initialised  `XComGameInfo` or `XComTacticalGame`, and are thus easily mallable from within UnrealScript:

```cpp
class XComGameInfo extends FrameworkGame;

// ...

defaultproperties
{
    TacticalSaveGameClass=class'Checkpoint_TacticalGame'
    TransportSaveGameClass=class'Checkpoint_StrategyTransport'
    bRestartLevel=false
    DefaultPawnClass=class'XCom3DCursor'
    HUDType=class'XComHUD'
    PlayerControllerClass=class'XComTacticalController'
    PlayerReplicationInfoClass=class'XComPlayerReplicationInfo'
    GameReplicationInfoClass=class'XComGameReplicationInfo'
}
```

```cpp
class XComTacticalGame extends XComGameInfo;

// ...

defaultproperties
{
    // ...
    HUDType=class'XComTacticalHUD'
    AutoTestManagerClass=class'XComAutoTestManager'
    GameReplicationInfoClass=class'XComTacticalGRI'
}
```