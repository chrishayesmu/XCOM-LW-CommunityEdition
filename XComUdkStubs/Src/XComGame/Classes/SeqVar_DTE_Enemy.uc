class SeqVar_DTE_Enemy extends SeqVar_Object
    native
    forcescriptorder(true)
    hidecategories(Object);

var Object EnemyObject;
var() bool bAllEnemies;
var() int EnemyIdx;

defaultproperties
{
    SupportedClasses(0)=Class'Engine.Controller'
    SupportedClasses(1)=Class'Engine.Pawn'
    ObjName="Enemy"
}