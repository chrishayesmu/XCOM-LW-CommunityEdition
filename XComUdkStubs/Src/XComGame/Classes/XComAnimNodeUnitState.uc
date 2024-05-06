class XComAnimNodeUnitState extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object,Object,Object,Object);

enum EAnimUnitState
{
    eAnimUnitState_Normal,
    eAnimUnitState_HighAlert,
    eAnimUnitState_LookingAt,
    eAnimUnitState_Panicking,
    eAnimUnitState_HighCoverFront,
    eAnimUnitState_HighCoverBack,
    eAnimUnitState_HighCoverLeft,
    eAnimUnitState_HighCoverRight,
    eAnimUnitState_LowCoverFront,
    eAnimUnitState_LowCoverBack,
    eAnimUnitState_LowCoverLeft,
    eAnimUnitState_LowCoverRight,
    eAnimUnitState_MAX
};

defaultproperties
{
    bPlayActiveChild=true
    Children(0)=(Name="Normal")
    Children(1)=(Name="HighAlert")
    Children(2)=(Name="LookingAt")
    Children(3)=(Name="Panicking")
    Children(4)=(Name="HighCoverFront")
    Children(5)=(Name="HighCoverBack")
    Children(6)=(Name="HighCoverLeft")
    Children(7)=(Name="HighCoverRight")
    Children(8)=(Name="LowCoverFront")
    Children(9)=(Name="LowCoverBack")
    Children(10)=(Name="LowCoverLeft")
    Children(11)=(Name="LowCoverRight")
    bFixNumChildren=true
}