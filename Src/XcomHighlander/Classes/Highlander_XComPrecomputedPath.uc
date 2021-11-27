class Highlander_XComPrecomputedPath extends XComPrecomputedPath;

simulated event PostBeginPlay() {
    super.PostBeginPlay();
}

simulated event Tick(float DeltaTime) {
    super.Tick(DeltaTime);
}

simulated function Vector GetEndPosition() {
    local bool bFloorTile;
    local int X, Y, Z;
    local Vector vCenter;

    vCenter = super.GetEndPosition();

    if (kCurrentWeapon.m_kGameWeapon.IsA('XGWeapon_SmokeGrenade')
        || kCurrentWeapon.m_kGameWeapon.IsA('XGWeapon_GasGrenade')
        || kCurrentWeapon.m_kGameWeapon.IsA('XGWeapon_ThinmanGrenade')
    ) {
        bFloorTile = class'XComWorldData'.static.GetWorldData().GetFloorTileForPosition(vCenter, X, Y, Z);

        if (!bFloorTile)
        {
            vCenter.Z += 64.0 * 1.50;
            bFloorTile = class'XComWorldData'.static.GetWorldData().GetFloorTileForPosition(vCenter, X, Y, Z);
        }

        if (bFloorTile)
        {
            vCenter = class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(X, Y, Z);
            vCenter.Z += 64.0 * 1.10;
        }
    }
    return vCenter;
}
