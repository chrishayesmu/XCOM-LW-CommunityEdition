class XGUnitFlyingRing extends StaticMeshComponent
    config(Game)
    editinlinenew
    hidecategories(Object);

var transient XComUnitPawnNativeBase m_kPawn;
var transient float m_fCurrentDelay;
var transient float m_fCurrentCursorPosition;
var const globalconfig transient float m_fSweepDistancePerSecond;
var const globalconfig transient float m_fTimeToDelay;