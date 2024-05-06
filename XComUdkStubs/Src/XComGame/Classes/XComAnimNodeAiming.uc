class XComAnimNodeAiming extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object,Object,Object,Object);

enum EAnimAim
{
    eAnimAim_NotTurning,
    eAnimAim_Turning,
    eAnimAim_MAX
};

defaultproperties
{
    bPlayActiveChild=true
    Children(0)=(Name="Aiming and Not Turning")
    Children(1)=(Name="Aiming and Turning")
    bFixNumChildren=true
}