class SeqVar_XComUnitPawn extends SeqVar_Object
    native(Unit)
    forcescriptorder(true)
    hidecategories(Object);

var transient array<Object> Units;
var() bool bActiveUnit;
var() bool bAllUnits;
var() int UnitIdx;

defaultproperties
{
    SupportedClasses(0)=Class'XComUnitPawn'
    ObjName="XComUnit"
}