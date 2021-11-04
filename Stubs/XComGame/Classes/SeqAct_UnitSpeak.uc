// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class SeqAct_UnitSpeak extends SequenceAction
	forcescriptorder(true)
    hidecategories(Object);

var Object Unit;
var() ECharacterSpeech Event;

event Activated()
{
    local XComUnitPawn Speaker;

    Speaker = GetUnitPawn(Unit);
    if(Speaker != none)
    {
        Speaker.UnitSpeak(Event);
    }
}

function XComUnitPawn GetUnitPawn(Object Dude)
{
    local XComUnitPawn P;

    P = XComUnitPawn(Dude);
    if(P != none)
    {
        return P;
    }
    else
    {
        if(XGUnit(Dude) != none)
        {
            return XGUnit(Dude).GetPawn();
        }
    }
    return none;
}

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit",PropertyName=Unit)
    ObjName="Unit Speak"
}