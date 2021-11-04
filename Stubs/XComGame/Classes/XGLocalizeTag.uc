class XGLocalizeTag extends Object
    native(Core);
//complete stub

var string Tag;
var XGTacticalGameCoreNativeBase m_kGameCore;

// Export UXGLocalizeTag::execGetTacticalGameCore(FFrame&, void* const)
native function GetTacticalGameCore();

// Export UXGLocalizeTag::execExpand(FFrame&, void* const)
native function bool Expand(string InString, out string OutString);