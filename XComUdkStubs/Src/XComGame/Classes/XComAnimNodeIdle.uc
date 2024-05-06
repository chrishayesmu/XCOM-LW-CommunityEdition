class XComAnimNodeIdle extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum EAnimIdle
{
    eAnimIdle_Peek,
    eAnimIdle_Flinch,
    eAnimIdle_Fire,
    eAnimIdle_Idle,
    eAnimIdle_Panic,
    eAnimIdle_HunkerDown,
    eAnimIdle_MAX
};

defaultproperties
{
    bPlayActiveChild=true
    Children(0)=(Name="Peek")
    Children(1)=(Name="Flinch")
    Children(2)=(Name="Fire")
    Children(3)=(Name="Idle")
    Children(4)=(Name="Panic")
    Children(5)=(Name="Hunker Down")
    bFixNumChildren=true
}