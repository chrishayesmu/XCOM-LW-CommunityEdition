class SeqAct_DisplayUISpecialMissionTimer extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum TimerColors
{
    Normal_Blue,
    Bad_Red,
    Good_Green,
    Disabled_Grey,
    TimerColors_MAX
};

var int iNumTurns;
var bool bShouldShow;
var string sDisplayMsg;
var() TimerColors TimerColor;

defaultproperties
{
    TimerColor=Bad_Red
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Int',LinkDesc="# Turns Remaining",PropertyName=iNumTurns)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Bool',LinkDesc="bShouldShow?",PropertyName=bShouldShow,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Display Message",PropertyName=sDisplayMsg,bWriteable=true)
    ObjName="UI Special Mission Timer"
}