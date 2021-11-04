class XG3DInterface extends Actor
    notplaceable
    hidecategories(Navigation);

//complete stub

simulated function DrawSound(Vector vSoundStart, Vector vSoundEnd);

simulated function DRAWRange(Vector vCenter, float fRadius, LinearColor clrRange)
{
    local Vector vCenterTop;

    vCenterTop = vCenter;
    vCenterTop.Z += float(1);
    XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).mSimpleShapeManager.DrawCylinder(vCenter, vCenterTop, fRadius, clrRange);
}

simulated function DRAWControlCone(Vector vStart, Vector VDir, float fDist, float fAngle, LinearColor kColor)
{
    vStart.Z = 10.0;
    VDir.Z = 0.0;
    XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).mSimpleShapeManager.DrawCone(vStart, vStart + (VDir * fDist), 0.017453290 * fAngle, kColor, 0.010, false, true);
}

simulated function DRAWPinningCone(Vector vStart, XGUnit kPinnedUnit, LinearColor kColor)
{
    local Vector vEnd;

    vEnd = kPinnedUnit.GetLocation();
    vStart.Z = 10.0;
    vEnd.Z = 10.0;
    XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).mSimpleShapeManager.DrawCone(vStart, vEnd, 0.017453290 * float(15), kColor, 0.010, false, true);
}

simulated function DrawExplosiveRange(Vector vTarget, XGWeapon kWeapon, int iAddedTime);