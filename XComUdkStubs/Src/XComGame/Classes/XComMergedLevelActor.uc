class XComMergedLevelActor extends XComLevelActor
    native(Level)
    hidecategories(Navigation);

struct native UndoEntry
{
    var StaticMesh pStaticMesh;
    var Matrix kTransformToComponentSpace;
    var Vector kOriginDelta;
};

var() bool bTest;
var array<UndoEntry> m_kOriginalMeshes;
var Rotator m_kRotationAtMerge;