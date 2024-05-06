class XComAnimNodeStartLoopStop extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object,Object,Object,Object);

enum EAnimStartLoopStop
{
    eAnimStartLoopStop_Start,
    eAnimStartLoopStop_Loop,
    eAnimStartLoopStop_Stop,
    eAnimStartLoopStop_Idle,
    eAnimStartLoopStop_MAX
};

defaultproperties
{
    ActiveChildIndex=3
    bPlayActiveChild=true
    Children(0)=(Name="Start")
    Children(1)=(Name="Loop")
    Children(2)=(Name="Stop")
    Children(3)=(Name="Idle")
    bFixNumChildren=true
}