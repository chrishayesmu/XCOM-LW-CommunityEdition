// This file contains a set of utilities for copying data across actors. This is useful in cases where we need to spawn
// an actor as an LWCE subclass, but the archetype is a base game class, so the Spawn call will fail. Instead of call Spawn
// with no archetype, and copy the properties ourselves after.
//
// Credit for most of this work goes to szmind, who kindly sent me utilities he had developed.
class LWCEActorUtilities extends Object
    abstract;

static function InitPawnFromArchetype(XComUnitPawn kArchetype, XComUnitPawn kOutPawn)
{
    if (kArchetype == none || kOutPawn == none)
    {
        `LWCE_LOG_CLS("Error in InitPawnFromArchetype: kArchetype = " $ kArchetype $ ", kOutPawn = " $ kOutPawn);
        return;
    }

	kOutPawn.CylinderComponent = new (kOutPawn) class'CylinderComponent'(kArchetype.CylinderComponent);
	kOutPawn.AttachComponent(kOutPawn.CylinderComponent);
	kOutPawn.CollisionComponent = kOutPawn.CylinderComponent;

	kOutPawn.LightEnvironment = new (kOutPawn) class'DynamicLightEnvironmentComponent'(kArchetype.LightEnvironment);
	kOutPawn.AttachComponent(kOutPawn.LightEnvironment);

	kOutPawn.Mesh = new (kOutPawn) class'SkeletalMeshComponent'(kArchetype.Mesh);
	kOutPawn.Mesh.SetLightEnvironment(kOutPawn.LightEnvironment);
	kOutPawn.Mesh.SetShadowParent(kOutPawn.Mesh);
	kOutPawn.AttachComponent(kOutPawn.Mesh);

	kOutPawn.RangeIndicator = new (kOutPawn) class'StaticMeshComponent'(kArchetype.RangeIndicator);
	kOutPawn.AttachComponent(kOutPawn.RangeIndicator);

	kOutPawn.MindMergeFX_Send = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.MindMergeFX_Send);
	kOutPawn.AttachComponent(kOutPawn.MindMergeFX_Send);

	kOutPawn.MindMergeFX_Receive = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.MindMergeFX_Receive);
	kOutPawn.AttachComponent(kOutPawn.MindMergeFX_Receive);

	kOutPawn.PsiPanicFX_Receive = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.PsiPanicFX_Receive);
	kOutPawn.AttachComponent(kOutPawn.PsiPanicFX_Receive);

	kOutPawn.MindFrayFX_Receive = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.MindFrayFX_Receive);
	kOutPawn.AttachComponent(kOutPawn.MindFrayFX_Receive);

	kOutPawn.MindControlFX_Send = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.MindControlFX_Send);
	kOutPawn.AttachComponent(kOutPawn.MindControlFX_Send);

	kOutPawn.MindControlFX_Receive = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.MindControlFX_Receive);
	kOutPawn.AttachComponent(kOutPawn.MindControlFX_Receive);

	kOutPawn.PsiInspiredFX_Receive = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.PsiInspiredFX_Receive);
	kOutPawn.AttachComponent(kOutPawn.PsiInspiredFX_Receive);

	kOutPawn.DisablingShot_Receive = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.DisablingShot_Receive);
	kOutPawn.AttachComponent(kOutPawn.DisablingShot_Receive);

	kOutPawn.StunShot_Receive = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.StunShot_Receive);
	kOutPawn.AttachComponent(kOutPawn.StunShot_Receive);
/* COMMENTED OUT, THESE PROPERTIES ARE INITIALIZED during XComHumanPawn.PostBeginPlay
	if(kArchetype.m_kKitMesh != none)
		kOutPawn.m_kKitMesh=new (kOutPawn) class'SkeletalMeshComponent'(kArchetype.m_kKitMesh);
	if(kArchetype.m_kHeadMeshComponent != none)
		kOutPawn.m_kHeadMeshComponent=new (kOutPawn) class'SkeletalMeshComponent'(kArchetype.m_kHeadMeshComponent);
	if(kArchetype.HairComponent != none)
		kOutPawn.HairComponent = new (kOutPawn) class'SkeletalMeshComponent'(kArchetype.HairComponent);
*/
	kOutPawn.TracerBeamedFX = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.TracerBeamedFX);
	kOutPawn.PoisonedByChryssalidFX = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.PoisonedByChryssalidFX);
	kOutPawn.PoisonedByThinmanFX = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.PoisonedByThinmanFX);
	kOutPawn.ElectropulsedFX = new (kOutPawn) class'ParticleSystemComponent'(kArchetype.ElectropulsedFX);
	kOutPawn.CloseAndPersonalRing = StaticMesh(DynamicLoadObject("UI_Range.Meshes.RadiusRing_CloseAndPersonal", class'StaticMesh'));
	kOutPawn.ArcThrowerRing = StaticMesh(DynamicLoadObject("UI_Range.Meshes.RadiusRing_ArcThrower", class'StaticMesh'));
	kOutPawn.CivilianRescueRing = StaticMesh(DynamicLoadObject("UI_Range.Meshes.RadiusRing_CivRescue", class'StaticMesh'));
	kOutPawn.MedikitRing = StaticMesh(DynamicLoadObject("UI_Range.Meshes.RadiusRing_MedKit", class'StaticMesh'));
	kOutPawn.KineticStrikeCard = StaticMesh(DynamicLoadObject("UI_Range.Meshes.KinetiStrikeDir_Plane", class'StaticMesh'));
	kOutPawn.FlamethrowerCard = StaticMesh(DynamicLoadObject("UI_Range.Meshes.96Triangle", class'StaticMesh'));
    kOutPawn.m_kAuxiliaryMaterial_ZeroAlpha = Material(DynamicLoadObject("FX_Visibility.Materials.MPar_NoUnitGlow", class'Material'));

    if (kArchetype.IsA('XComAlienPawn'))
    {
        CopyXComAlienPawnProperties(XComAlienPawn(kArchetype), XComAlienPawn(kOutPawn));
    }
    else if (kArchetype.IsA('XComHumanPawn'))
    {
        CopyXComHumanPawnProperties(XComHumanPawn(kArchetype), XComHumanPawn(kOutPawn));
    }
    else
    {
        CopyXComUnitPawnProperties(kArchetype, kOutPawn);
    }
}

static function CopyActorProperties(Actor Source, Actor Destination)
{
	Destination.bWorldGeometry = Source.bWorldGeometry;
	Destination.bCanStepUpOn = Source.bCanStepUpOn;
	Destination.bAllowFluidSurfaceInteraction = Source.bAllowFluidSurfaceInteraction;
	Destination.bConsiderAllStaticMeshComponentsForStreaming = Source.bConsiderAllStaticMeshComponentsForStreaming;
	Destination.bBlocksNavigation = Source.bBlocksNavigation;
	Destination.bNoEncroachCheck = Source.bNoEncroachCheck;
	Destination.bPhysRigidBodyOutOfWorldCheck = Source.bPhysRigidBodyOutOfWorldCheck;
	Destination.bEdShouldSnap = Source.bEdShouldSnap;
	Destination.bPathColliding = Source.bPathColliding;
	Destination.bLockLocation = Source.bLockLocation;
	Destination.RotationRate = Source.RotationRate;
}

static function CopyPawnProperties(Pawn Source, Pawn Destination)
{
    CopyActorProperties(Source, Destination);

	Destination.bCanCrouch = Source.bCanCrouch;
	Destination.bLOSHearing = Source.bLOSHearing;
	Destination.bMuffledHearing = Source.bMuffledHearing;
	Destination.bDontPossess = Source.bDontPossess;
	Destination.bFastAttachedMove = Source.bFastAttachedMove;
	Destination.HearingThreshold = Source.HearingThreshold;
	Destination.Alertness = Source.Alertness;
	Destination.SightRadius = Source.SightRadius;
	Destination.PeripheralVision = Source.PeripheralVision;
	Destination.RBPushRadius = Source.RBPushRadius;
	Destination.RBPushStrength = Source.RBPushStrength;
	Destination.WalkingPhysics = Source.WalkingPhysics;
	Destination.ViewPitchMin = Source.ViewPitchMin;
	Destination.ViewPitchMax = Source.ViewPitchMax;
	Destination.ScalarParameterInterpArray = Source.ScalarParameterInterpArray;
	Destination.EyeHeight = Source.EyeHeight;
}

static function CopyXComAlienPawnProperties(XComAlienPawn Source, XComAlienPawn Destination)
{
    `LWCE_LOG_CLS("CopyXComAlienPawnProperties: Source = " $ Source $ ", Destination = " $ Destination);

	if (Source != none)
	{
        CopyXComUnitPawnProperties(Source, Destination);

		Destination.Voice = Source.Voice;

        if (Destination.IsA('XComSectopodDrone'))
        {
			XComSectopodDrone(Destination).OverloadParticleSystem = XComSectopodDrone(Source).OverloadParticleSystem;
        }
		else if (Destination.IsA('XComMechtoid'))
        {
			XComMechtoid(Destination).SectoidCorpseTemplate = XComMechtoid(Source).SectoidCorpseTemplate;
        }
		else if (Destination.IsA('XComSectopod'))
        {
			XComSectopod(Destination).DeathMeshOffset = XComSectopod(Source).DeathMeshOffset;
        }
		else if (Destination.IsA('XComZombie'))
		{
			XComZombie(Destination).ZombieSkinMaterial = XComZombie(Source).ZombieSkinMaterial;
			XComZombie(Destination).ZombieCivilianBodyMaterial = XComZombie(Source).ZombieCivilianBodyMaterial;
		}
	}
}

static function CopyXComHumanPawnProperties(XComHumanPawn Source, XComHumanPawn Destination)
{
	if (Source != none)
	{
        CopyXComUnitPawnProperties(Source, Destination);

		Destination.JetPackAnimSet = Source.JetPackAnimSet;
		Destination.AllowHelmets = Source.AllowHelmets;

		if (Source.IsA('XComMecPawn'))
		{
			XComMecPawn(Destination).MECSounds = XComMecPawn(Source).MECSounds;
		}
	}
}

static function CopyXComUnitPawnProperties(XComUnitPawn Source, XComUnitPawn Destination)
{
    CopyPawnProperties(Source, Destination);

	Destination.bSkipIK = Source.bSkipIK;
	Destination.bAllowFireFromSuppressIdle = Source.bAllowFireFromSuppressIdle;
	Destination.bAllowOnlyLowCoverAnims = Source.bAllowOnlyLowCoverAnims;
	Destination.m_bUseRMA = Source.m_bUseRMA;
	Destination.DefaultUnitPawnAnimsets = Source.DefaultUnitPawnAnimsets;
	Destination.CustomFlightMovementRifleAnimsets = Source.CustomFlightMovementRifleAnimsets;
	Destination.CustomFlightMovementPistolAnimsets = Source.CustomFlightMovementPistolAnimsets;
	Destination.PathingRadius = Source.PathingRadius;
	Destination.ThrowGrenadeStartPosition = Source.ThrowGrenadeStartPosition;
	Destination.ThrowGrenadeStartPositionUnderhand = Source.ThrowGrenadeStartPositionUnderhand;
	Destination.m_arrParticleEffects = Source.m_arrParticleEffects;
	Destination.HiddenSlots = Source.HiddenSlots;
	Destination.HeadBoneName = Source.HeadBoneName;
	Destination.FocusFireBlendTime = Source.FocusFireBlendTime;
	Destination.Movement_Stop_Blend = Source.Movement_Stop_Blend;
	Destination.Into_Idle_Blend = Source.Into_Idle_Blend;
	Destination.Start_Turn_Blend = Source.Start_Turn_Blend;
	Destination.Start_Strangle_Blend = Source.Start_Strangle_Blend;
	Destination.Stop_Strangle_Blend = Source.Stop_Strangle_Blend;
	Destination.Kill_Strangle_Blend = Source.Kill_Strangle_Blend;
	Destination.LocalCameraOffset = Source.LocalCameraOffset;
	Destination.CameraFocusDistance = Source.CameraFocusDistance;
	Destination.AimLimit = Source.AimLimit;
	Destination.AimSpeedFactor = Source.AimSpeedFactor;
	Destination.AimStopThreshold = Source.AimStopThreshold;
	Destination.AimSpeedMin = Source.AimSpeedMin;
	Destination.AimSpeedMax = Source.AimSpeedMax;
	Destination.AimAtTargetMissPercent = Source.AimAtTargetMissPercent;
	Destination.TurnSpeedMultiplier = Source.TurnSpeedMultiplier;
	Destination.Footsteps = Source.Footsteps;
	Destination.DamageEffectContainer = Source.DamageEffectContainer;
	Destination.PlayNonFootstepSounds = Source.PlayNonFootstepSounds;
	Destination.bDoDyingActions = Source.bDoDyingActions;
	Destination.SmashEnvironmentOnDeath = Source.SmashEnvironmentOnDeath;
	Destination.m_bHasFullAnimWeightBones = Source.m_bHasFullAnimWeightBones;
	Destination.m_bOnlyAllowAnimLeftHandIKNotify = Source.m_bOnlyAllowAnimLeftHandIKNotify;
	Destination.m_bDropWeaponOnDeath = Source.m_bDropWeaponOnDeath;
	Destination.PhysicsPushScale = Source.PhysicsPushScale;
	Destination.RagdollFlag = Source.RagdollFlag;
	Destination.RagdollBlendTime = Source.RagdollBlendTime;
	Destination.DeathHandlerTemplate = Source.DeathHandlerTemplate;
	Destination.UITextures = Source.UITextures;
	Destination.CloseRangeMissDistance = Source.CloseRangeMissDistance;
	Destination.NormalMissDistance = Source.NormalMissDistance;
	Destination.NormalMissAngleMultiplier = Source.NormalMissAngleMultiplier;
	Destination.CloseRangeMissAngleMultiplier = Source.CloseRangeMissAngleMultiplier;
	Destination.SetCollisionSize(Source.CollisionRadius, Source.CollisionHeight);
	Destination.AOEHitMaterial = Source.AOEHitMaterial;
	Destination.m_bAuxParamNeedsAOEMaterial = Source.m_bAuxParamNeedsAOEMaterial;
	Destination.m_bAuxAlwaysVisible = Source.m_bAuxAlwaysVisible;
	Destination.m_eOpenCloseState = Source.m_eOpenCloseState;
	Destination.abColCylEnable = Source.abColCylEnable;
	Destination.fBaseZMeshTranslation = Source.fBaseZMeshTranslation;
	Destination.arrPawnPerkContent = Source.arrPawnPerkContent;
	Destination.m_DefaultLightingChannels = Source.m_DefaultLightingChannels;
	Destination.m_fPercent = Source.m_fPercent;
	Destination.m_fVisibilityPercentage = Source.m_fVisibilityPercentage;
	Destination.bUseBoneSprings = Source.bUseBoneSprings;
	Destination.m_bTutorialCanDieInMatinee = Source.m_bTutorialCanDieInMatinee;
	Destination.bAllowPersistentFX = Source.bAllowPersistentFX;
	Destination.m_deathHandler = Source.m_deathHandler;
	Destination.fPhysicsMotorForce = Source.fPhysicsMotorForce;

    //kDestPawn.CovertOpsMesh = Source.CovertOpsMesh; requires replacement variable
	//kDestPawn.ExaltSuicideSyringeMesh = Source.ExaltSuicideSyringeMesh; requires replacement variable
}