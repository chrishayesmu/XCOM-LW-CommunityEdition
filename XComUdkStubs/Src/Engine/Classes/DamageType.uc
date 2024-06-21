/**
 * DamageType, the base class of all damagetypes.
 * this and its subclasses are never spawned, just used as information holders
 *
 * NOTE:  we can not do:  HideDropDown on this class as we need to be able to use it in SeqEvent_TakeDamage for objects taking
 * damage from any DamageType!
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class DamageType extends object
	native
	abstract;

var() bool bArmorStops;
var bool bCausedByWorld;
var bool bExtraMomentumZ;
var() bool bCausesFracture;
var(RigidBody) bool bKRadialImpulse;
var(RigidBody) bool bRadialDamageVelChange;
var(RigidBody) float KDamageImpulse;
var(RigidBody) float KDeathVel;
var(RigidBody) float KDeathUpKick;
// var(RigidBody) float KImpulseRadius; // XCOM addition
// var float FracturedMeshRadiusMultiplier;
var(RigidBody) float RadialDamageImpulse;
var float VehicleDamageScaling;
var float VehicleMomentumScaling;
var ForceFeedbackWaveform DamagedFFWaveform;
var ForceFeedbackWaveform KilledFFWaveform;
var float FracturedMeshDamage;

static function float VehicleDamageScalingFor(Vehicle V)
{
	return Default.VehicleDamageScaling;
}

defaultproperties
{
    bArmorStops=true
    bExtraMomentumZ=true
    KDamageImpulse=800.0
    // KImpulseRadius=250.0
    // FracturedMeshRadiusMultiplier=1.0
    VehicleDamageScaling=1.0
    VehicleMomentumScaling=1.0
    FracturedMeshDamage=1.0
}