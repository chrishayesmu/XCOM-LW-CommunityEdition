class XGAbility_Ascend extends XGAbility_Targeted
    native(Core)
    notplaceable
    hidecategories(Navigation);
//complete stub

// Export UXGAbility_Ascend::execInternalCheckAvailable(FFrame&, void* const)
native function bool InternalCheckAvailable();

simulated function ApplyEffect()
{
}