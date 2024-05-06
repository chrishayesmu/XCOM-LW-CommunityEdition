class XComAnimNodeBlendByMovementType extends XComAnimNodeBlendList
    native(Animation)
    hidecategories(Object);

enum EMoveType
{
    eMoveType_Running,
    eMoveType_Stationary,
    eMoveType_Dead,
    eMoveType_Turn,
    eMoveType_Action,
    eMoveType_StartRunning,
    eMoveType_Anim,
    eMoveType_MAX
};

defaultproperties
{
    Children(0)=(Name="Running")
    Children(1)=(Name="Stationary")
    Children(2)=(Name="Dead")
    Children(3)=(Name="Turn")
    Children(4)=(Name="Action")
    Children(5)=(Name="Start Running")
    Children(6)=(Name="Anim")
}