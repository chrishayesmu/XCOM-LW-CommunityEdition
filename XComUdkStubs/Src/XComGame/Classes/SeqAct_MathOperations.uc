class SeqAct_MathOperations extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum Operation
{
    OPER_Add,
    OPER_Subtract,
    OPER_Multiply,
    OPER_Divide,
    OPER_MAX
};

var() float A;
var() float B;
var float Result;
var() SeqAct_MathOperations.Operation MathOperation;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="A",PropertyName=A)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="B",PropertyName=B)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Float',LinkDesc="Result",PropertyName=Result,bWriteable=true)
    ObjName="Operations"
}