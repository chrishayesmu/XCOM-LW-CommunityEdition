class XComAnimNodeBlendByMovementType extends XComAnimNodeBlendList
    native(Animation)
	dependson(XComGameReplicationInfo);
//complete stub

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

simulated function SetAnim(ESingleAnim eAnim, optional ERootBoneAxis AxisX, optional ERootBoneAxis AxisY, optional ERootBoneAxis AxisZ){}
simulated function SetAnimReverse(ESingleAnim eAnim, optional ERootBoneAxis AxisX, optional ERootBoneAxis AxisY, optional ERootBoneAxis AxisZ){}
simulated function SetAnimEnd(ESingleAnim eAnim, optional ERootBoneAxis AxisX, optional ERootBoneAxis AxisY, optional ERootBoneAxis AxisZ){}
simulated function SetAnimByName(name AnimName, optional ERootBoneAxis AxisX, optional ERootBoneAxis AxisY, optional ERootBoneAxis AxisZ, optional float UseRate=1.0){}
