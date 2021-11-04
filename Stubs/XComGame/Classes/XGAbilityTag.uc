class XGAbilityTag extends XGLocalizeTag
    native(Core);
//complete stub

var XGAbility Ability;

// Export UXGAbilityTag::execExpand(FFrame&, void* const)
native function bool Expand(string InString, out string OutString);

// Export UXGAbilityTag::execGetAbilityDuration(FFrame&, void* const)
native function int GetAbilityDuration(int iAbility);

// Export UXGAbilityTag::execGetAbilityCooldown(FFrame&, void* const)
native function int GetAbilityCooldown(int iAbility);
