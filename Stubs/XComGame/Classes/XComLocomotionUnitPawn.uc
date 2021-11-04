class XComLocomotionUnitPawn extends XComUnitPawnNativeBase
	    native(Unit)
    config(Game);
//complete stub

var bool bWeaponIsDown;
var Vector LastLocation_WeaponDownCheck;
var Rotator LastRotation_WeaponDownCheck;

simulated function OnLocalPlayerTeamTypeReceived(ETeam eLocalPlayerTeam){}
native simulated function EvaluateWeaponPose();
native simulated function SetWeaponDownNodes(bool bWeaponDown, float BlendTime);
