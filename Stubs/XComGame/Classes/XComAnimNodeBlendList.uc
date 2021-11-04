class XComAnimNodeBlendList extends AnimNodeBlendList
    abstract
    native(Animation);
//complete  stub

function SetActiveChild(int ChildIndex, float BlendTime)
{
    local AnimNodeSequence LocalSequence;

    LocalSequence = AnimNodeSequence(Children[ChildIndex].Anim);
    if((ChildIndex != ActiveChildIndex) || (LocalSequence != none) && !LocalSequence.bPlaying)
    {
        super.SetActiveChild(ChildIndex, BlendTime);
    }
}

defaultproperties
{
    bPlayActiveChild=true
    bFixNumChildren=true
}