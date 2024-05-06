class XComAnimNodeWeaponState extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object);

enum EAnimWeaponState
{
    eAnimWeaponState_Idle,
    eAnimWeaponState_Fire,
    eAnimWeaponState_MAX
};

defaultproperties
{
    bPlayActiveChild=true
    Children(0)=(Name="RaisedIdle")
    Children(1)=(Name="Fire")
    bFixNumChildren=true
}