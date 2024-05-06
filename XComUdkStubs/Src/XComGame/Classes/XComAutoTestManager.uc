class XComAutoTestManager extends AutoTestManager
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var XComTacticalController TacticalController;
var int iSecondsRemaining;
var int iNextMapIndex;
var bool bPlayGame;
var bool bStressTestReactionFire;
var Vector TargetLoc;
var private transient int iRand;
var private transient int iCnt;
var private transient int iDPadPresses;

defaultproperties
{
    iSecondsRemaining=600
    bPlayGame=true
    bStressTestReactionFire=true
}