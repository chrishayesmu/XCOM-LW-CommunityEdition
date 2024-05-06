class XComAnimNodeUnitStairState extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object,Object,Object,Object);

enum EAnimUnitStairState
{
    eAnimUnitStairState_OffStairs,
    eAnimUnitStairState_UpStairs,
    eAnimUnitStairState_DownStairs,
    eAnimUnitStairState_MAX
};

defaultproperties
{
    Children(0)=(Name="Off Stairs")
    Children(1)=(Name="Up Stairs")
    Children(2)=(Name="Down Stairs")
}