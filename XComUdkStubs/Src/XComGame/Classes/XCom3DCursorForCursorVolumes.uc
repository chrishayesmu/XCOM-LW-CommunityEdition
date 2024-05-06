class XCom3DCursorForCursorVolumes extends XCom3DCursor
    native(Unit)
    config(Game)
    hidecategories(Navigation);

var XComLevelVolume m_kLevelVolume;
var array<XComCursorVolume> m_arrCachedCursorVolumes;
var Vector m_kLastCursorLocation;
var XComCursorVolume m_kLastStairVolume;