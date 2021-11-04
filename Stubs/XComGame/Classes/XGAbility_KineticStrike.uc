class XGAbility_KineticStrike extends XGAbility_GameCore
    native(Core)
    notplaceable
    hidecategories(Navigation);

// Export UXGAbility_KineticStrike::execInternalCheckAvailable(FFrame&, void* const)
native function bool InternalCheckAvailable();