class Highlander_XComPrecomputedPath extends XComPrecomputedPath;

simulated event PostBeginPlay() {
    super.PostBeginPlay();
}

simulated event Tick(float DeltaTime) {
    super.Tick(DeltaTime);
}

simulated function Vector GetEndPosition() {
    local Vector vCenter;

    vCenter = super.GetEndPosition();

    // Highlander issue #13
    // In XGVolumeMgr, volumes of type eVolume_Poison and eVolume_Smoke are
    // snapped to tile centers. This replicates the same behavior, but for
    // targeting.
    // Slight inconsistency: We need to manually map weapons to volume types here.
    if (kCurrentWeapon.m_kGameWeapon.IsA('XGWeapon_SmokeGrenade')
        || kCurrentWeapon.m_kGameWeapon.IsA('XGWeapon_GasGrenade')
        || kCurrentWeapon.m_kGameWeapon.IsA('XGWeapon_ThinmanGrenade')
    ) {
        vCenter = class'Highlander_XGVolumeMgr'.static.TiledVolumeLocation(vCenter);

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
