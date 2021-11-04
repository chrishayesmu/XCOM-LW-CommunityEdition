class XGBulletTag extends XGLocalizeTag
    native(Core);

// Export UXGBulletTag::execExpand(FFrame&, void* const)
native function bool Expand(string InString, out string OutString);
