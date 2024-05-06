class XComSeeker extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var bool m_bStealthFXOn;
var() private const MaterialInstanceTimeVarying StealthIntroMITV;
var() private const MaterialInstanceTimeVarying StealthOutroMITV;
var() private const MaterialInstanceTimeVarying StealthPersistentMITV;

defaultproperties
{
    TurnSpeedMultiplier=100.0
    m_bShouldTurnBeforeMoving=true
}