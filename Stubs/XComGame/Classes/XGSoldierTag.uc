class XGSoldierTag extends XGLocalizeTag
    native(Core);

var TSoldier Soldier;

// Export UXGSoldierTag::execExpand(FFrame&, void* const)
native function bool Expand(string InString, out string OutString);
