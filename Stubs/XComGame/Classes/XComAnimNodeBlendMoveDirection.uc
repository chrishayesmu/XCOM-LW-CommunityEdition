class XComAnimNodeBlendMoveDirection extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object,Object,Object,Object);

var() float DirDegreesPerSecond;
var float DirAngle;
var Vector MoveDir;
var bool m_bLockDirection;

function EnableLockDirection(optional bool bResetAnims){}
function bool ValidateChildrenAsAnimNodeSequences(){}
function DisableLockDirection(){}
function bool IsMoveStartStillPlaying(optional float fTimeFromEndToStopPlaying=0.20){}

defaultproperties
{
    DirDegreesPerSecond=360.0
    Children(0)=(Name=Forward,Weight=1.0)
    Children(1)=(Name=Backward)
    Children(2)=(Name=Left)
    Children(3)=(Name=Right)
    Children(4)=(Name=Stationary)
    Children(5)=(Name=BackwardRight)
    bFixNumChildren=true
}