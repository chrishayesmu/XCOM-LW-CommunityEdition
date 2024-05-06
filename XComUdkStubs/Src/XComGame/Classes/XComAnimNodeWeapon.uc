class XComAnimNodeWeapon extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object,Object,Object,Object);

enum EAnimWeapon
{
    eAnimWeapon_Idle,
    eAnimWeapon_FocusFire,
    eAnimWeapon_CCFire,
    eAnimWeapon_Reload,
    eAnimWeapon_Equip,
    eAnimWeapon_UnEquip,
    eAnimWeapon_UnEquippedIdle,
    eAnimWeapon_MAX
};

defaultproperties
{
    bPlayActiveChild=true
    NodeName=AnimNode
}