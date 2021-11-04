class XComAnimNodeAiming extends AnimNodeBlendList
    native(Animation);
//complete stub

enum EAnimAim
{
    eAnimAim_NotTurning,
    eAnimAim_Turning,
    eAnimAim_MAX
};

// Export UXComAnimNodeAiming::execSetStaticActiveChild(FFrame&, void* const)
native function SetStaticActiveChild(int iChild, float fBlendTime);
