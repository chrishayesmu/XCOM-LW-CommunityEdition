class XComAnimNodeBlendSynchTurning extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object);

var bool m_bIsTurnZeroValid;
var float m_fPreviousTargetDirAngle;

defaultproperties
{
    Children(0)=(Name="Left 45")
    Children(1)=(Name="Left 90")
    Children(2)=(Name="Left 180")
    Children(3)=(Name="Right 180")
    Children(4)=(Name="Right 90")
    Children(5)=(Name="Right 45")
    Children(6)=(Name="Not Turning")
}