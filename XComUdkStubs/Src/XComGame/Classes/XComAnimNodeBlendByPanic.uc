class XComAnimNodeBlendByPanic extends AnimNodeBlendList
    hidecategories(Object,Object,Object,Object);

enum ECCPanic
{
    eECCP_Start,
    eECCP_Loop1,
    eECCP_Loop2,
    eECCP_Stop,
    eECCP_MAX
};

defaultproperties
{
    bPlayActiveChild=true
    Children(0)=(Name="Panic Start")
    Children(1)=(Name="Panic Loop1")
    Children(2)=(Name="Panic Loop2 (reserved)")
    Children(3)=(Name="Panic Stop")
    bFixNumChildren=true
}