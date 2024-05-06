class XComTank extends XComUnitPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var MaterialInterface m_kMatInterface_TreadLeft;
var MaterialInterface m_kMatInterface_TreadRight;
var Vector m_fLastGroundTrack_Left;
var Vector m_fLastGroundTrack_Right;
var float m_fTreadPosLeft;
var float m_fTreadPosRight;
var float m_fTreadVelocityLeft;
var float m_fTreadVelocityRight;
var float m_fTreadFactor;
var AnimNode_MultiBlendPerBone TreadWheelsNode;
var AnimNodeSequence m_kTreadWheelNodeLeft;
var AnimNodeSequence m_kTreadWheelNodeRight;
var float m_fWheelFactor;
var private EItemType PrimaryWeapon;
var private bool m_bUnitContentLoaded;

defaultproperties
{
    m_fTreadFactor=0.030
    m_fWheelFactor=0.030
    TurnSpeedMultiplier=3.0
    m_bShouldTurnBeforeMoving=true
    HeadBoneName=hydraulics01b_bindjoint
}