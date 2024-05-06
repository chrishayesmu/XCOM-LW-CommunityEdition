class XGSightManager extends XGSightManagerNativeBase
    notplaceable
    hidecategories(Navigation);

var transient bool CachedPositionsInitialized;
var transient array<Vector> CachedUnitPos;
var protected int m_iVisibleCacheTime;