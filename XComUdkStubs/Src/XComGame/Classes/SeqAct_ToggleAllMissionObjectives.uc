class SeqAct_ToggleAllMissionObjectives extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Show All")
    InputLinks(1)=(LinkDesc="Hide All")
    InputLinks(2)=(LinkDesc="Clear All")
    ObjName="Toggle All Mission Objectives"
}