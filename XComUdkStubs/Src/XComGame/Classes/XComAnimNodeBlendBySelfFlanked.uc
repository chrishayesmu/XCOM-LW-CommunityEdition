class XComAnimNodeBlendBySelfFlanked extends AnimNodeBlendList
    hidecategories(Object,Object,Object,Object);

enum ECCSelfFlanked
{
    eECCSF_Begin,
    eECCSF_Start,
    eECCSF_Fire,
    eECCSF_Reload,
    eECCSF_FlinchA,
    eECCSF_FlinchB,
    eECCSF_Idle,
    eECCSF_Stop,
    eECCSF_MAX
};

defaultproperties
{
    bPlayActiveChild=true
    Children(0)=(Name="SelfFlanked Begin")
    Children(1)=(Name="SelfFlanked Start")
    Children(2)=(Name="SelfFlanked Fire (Loopable)")
    Children(3)=(Name="SelfFlanked Reload (Loopable)")
    Children(4)=(Name="SelfFlanked FlinchA (Loopable)")
    Children(5)=(Name="SelfFlanked FlinchB (Loopable)")
    Children(6)=(Name="SelfFlanked Idle (Loopable)")
    Children(7)=(Name="SelfFlanked Stop")
    bFixNumChildren=true
}