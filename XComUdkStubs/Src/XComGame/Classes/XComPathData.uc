class XComPathData extends Object
    native(Core);

struct native PathPoint
{
    var Vector Position;
    var ETraversalType Traversal;
    var Actor Actor;
};

struct native ReplicatedPathPoint
{
    var Vector vRawPathPoint;
    var ETraversalType eTraversal;
    var float fTimestamp;
    var bool bPathPointSet;
};