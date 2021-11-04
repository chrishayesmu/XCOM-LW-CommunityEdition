class XComSeeker extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);
//complete stub

var bool m_bStealthFXOn;
var() const MaterialInstanceTimeVarying StealthIntroMITV;
var() const MaterialInstanceTimeVarying StealthOutroMITV;
var() const MaterialInstanceTimeVarying StealthPersistentMITV;

simulated function BeginStealth(){}
simulated function EndStealth(){}
simulated function float SetStealthFX(bool bShouldStealth){}
simulated function PlayPersistentStealthFX(){}
simulated event ApplyStealthMaterials(MaterialInstanceTimeVarying MITV){}
simulated function CleanUpStealthFX(){}
function SetMovementPhysics(){}
