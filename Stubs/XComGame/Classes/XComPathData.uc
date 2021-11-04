class XComPathData extends Object
    native(Core)
	dependsOn(XComWorldData);
//complete stub

struct native PathPoint
{
    var Vector Position;
    var XComWorldData.ETraversalType Traversal;
    var Actor Actor;
};

struct native ReplicatedPathPoint
{
    var Vector vRawPathPoint;
    var XComWorldData.ETraversalType eTraversal;
    var float fTimestamp;
    var bool bPathPointSet;

};

static final function string ReplicatedPathPoint_ToString(const out ReplicatedPathPoint kReplicatedPathPoint)
{
    local string strRep;

    strRep = "vRawPathPoint=" $ string(kReplicatedPathPoint.vRawPathPoint);
    strRep $= (", eTraversal=" $ string(kReplicatedPathPoint.eTraversal));
    strRep $= (", fTimestamp=" $ string(kReplicatedPathPoint.fTimestamp));
    strRep $= (", bPathPointSet=" $ string(kReplicatedPathPoint.bPathPointSet));
    return strRep;
}