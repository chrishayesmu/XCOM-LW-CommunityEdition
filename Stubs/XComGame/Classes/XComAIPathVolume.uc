class XComAIPathVolume extends Volume
    hidecategories(Navigation,Movement,Display);
//complete stub

var XComAlienPod m_kPod;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local XComUnitPawn Pawn;

    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    Pawn = XComUnitPawn(Other);
    if((Pawn != none) && m_kPod != none)
    {
        m_kPod.OnTouchPath(Pawn);
    }
}