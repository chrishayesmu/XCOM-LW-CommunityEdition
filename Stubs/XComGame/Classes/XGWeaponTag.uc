class XGWeaponTag extends XGLocalizeTag
    native(Core);
//complete stub

var XGWeapon Weapon;

// Export UXGWeaponTag::execExpand(FFrame&, void* const)
native function bool Expand(string InString, out string OutString);
