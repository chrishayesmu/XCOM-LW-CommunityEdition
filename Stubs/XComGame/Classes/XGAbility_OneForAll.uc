class XGAbility_OneForAll extends XGAbility_GameCore
    native(Core)
    notplaceable
    hidecategories(Navigation);
//complete stub

simulated function ApplyEffect()
{}

// Export UXGAbility_OneForAll::execInternalCheckAvailable(FFrame&, void* const)
native function bool InternalCheckAvailable();