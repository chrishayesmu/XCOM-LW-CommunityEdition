class SeqCond_SwitchString extends SeqCond_SwitchBase
    native(Level)
    forcescriptorder(true)
    hidecategories(Object);

struct native SwitchStringInfo
{
    var() init string StringName;
    var() byte bFallThru;
};

var() array<SwitchStringInfo> StringArray;

defaultproperties
{
    StringArray(0)=(StringName="Default")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="String")
    ObjName="Switch String"
}