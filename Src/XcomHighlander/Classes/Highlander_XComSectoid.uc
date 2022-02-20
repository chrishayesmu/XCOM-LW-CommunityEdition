class Highlander_XComSectoid extends XComSectoid;

simulated function ApplyShredderRocket(const DamageEvent Dmg, bool enemyOfUnitHit)
{
    class'Highlander_XComUnitPawn_Extensions'.static.ApplyShredderRocket(self, Dmg, enemyOfUnitHit);
}

function DoDeathOnOutsideOfBounds()
{
    class'Highlander_XComUnitPawn_Extensions'.static.DoDeathOnOutsideOfBounds(self);
}

simulated event AnimTreeUpdated(SkeletalMeshComponent SkelMesh)
{
    `HL_LOG_CLS("AnimTreeUpdated");

    super.AnimTreeUpdated(SkelMesh);
}

simulated event PostBeginPlay()
{
    `HL_LOG_CLS("PostBeginPlay");

    super.PostBeginPlay();
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    `HL_LOG_CLS("PostInitAnimTree");

    `HL_LOG_CLS("SkelComp == Mesh: " $ (SkelComp == Mesh));
    `HL_LOG_CLS("Mesh.Animations != none: " $ (Mesh.Animations != none));

    super.PostInitAnimTree(SkelComp);
}

simulated event ReplicatedEvent(name VarName)
{
    `HL_LOG_CLS("ReplicatedEvent");

    super.ReplicatedEvent(VarName);
}

simulated event bool RestoreAnimSetsToDefault()
{
    `HL_LOG_CLS("RestoreAnimSetsToDefault: DefaultUnitPawnAnimsets.Length = " $ DefaultUnitPawnAnimsets.Length);

    return super.RestoreAnimSetsToDefault();
}

simulated event Tick(float dt)
{
    super.Tick(dt);
}

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
    super.BeginAnimControl(InInterpGroup);
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
    super.FinishAnimControl(InInterpGroup);
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    super.InterpolationStarted(InterpAction, GroupInst);
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    super.InterpolationFinished(InterpAction);
}

simulated event SetVisible(bool bVisible)
{
    super.SetVisible(bVisible);
}

simulated event bool OverRotated(out Rotator out_Desired, out Rotator out_Actual)
{
    return super.OverRotated(out_Desired, out_Actual);
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    super.FellOutOfWorld(dmgType);
}

simulated event OutsideWorldBounds()
{
    super.OutsideWorldBounds();
}

simulated event OnCleanupWorld()
{
    super.OnCleanupWorld();
}

simulated event SetInitialState()
{
    super.SetInitialState();
}

simulated event ConstraintBrokenNotify(Actor ConOwner, RB_ConstraintSetup ConSetup, RB_ConstraintInstance ConInstance)
{
    super.ConstraintBrokenNotify(ConOwner, ConSetup, ConInstance);
}

simulated event NotifySkelControlBeyondLimit(SkelControlLookAt LookAt)
{
    super.NotifySkelControlBeyondLimit(LookAt);
}

simulated event TakeDirectDamage(const DamageEvent Dmg)
{
    super.TakeDirectDamage(Dmg);
}

simulated event TakeSplashDamage(const DamageEvent Dmg)
{
    super.TakeSplashDamage(Dmg);
}

simulated event ModifyHearSoundComponent(AudioComponent AC)
{
    super.ModifyHearSoundComponent(AC);
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
    return super.GetFaceFXAudioComponent();
}

simulated event ReceivedNewEvent(SequenceEvent Evt)
{
    super.ReceivedNewEvent(Evt);
}

simulated event ShutDown()
{
    super.ShutDown();
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    super.GetActorEyesViewPoint(out_Location, out_Rotation);
}

simulated event byte ScriptGetTeamNum()
{
    return super.ScriptGetTeamNum();
}

simulated event InterpolationChanged(SeqAct_Interp InterpAction)
{
    super.InterpolationChanged(InterpAction);
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    super.PostRenderFor(PC, Canvas, CameraPosition, CameraDir);
}

simulated event RootMotionModeChanged(SkeletalMeshComponent SkelComp)
{
    super.RootMotionModeChanged(SkelComp);
}

simulated event RootMotionProcessed(SkeletalMeshComponent SkelComp)
{
    super.RootMotionProcessed(SkelComp);
}

simulated event RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
    super.RootMotionExtracted(SkelComp, ExtractedRootMotionDelta);
}

simulated event OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance)
{
    super.OnRigidBodySpringOverextension(BodyInstance);
}

simulated event PostDemoRewind()
{
    super.PostDemoRewind();
}

simulated event ReplicationEnded()
{
    super.ReplicationEnded();
}

simulated event CacheAnimNodes()
{
    super.CacheAnimNodes();
}

simulated event BuildScriptAnimSetList()
{
    super.BuildScriptAnimSetList();
}

simulated event AnimSetListUpdated()
{
    super.AnimSetListUpdated();
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, bool bEnableRootMotion)
{
    super.SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping, bEnableRootMotion);
}

simulated event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return super.PlayActorFaceFXAnim(AnimSet, GroupName, SeqName, SoundCueToPlay);
}

simulated event Rotator GetViewRotation()
{
    return super.GetViewRotation();
}

simulated event Vector GetPawnViewLocation()
{
    return super.GetPawnViewLocation();
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    return super.GetWeaponStartTraceLocation(CurrentWeapon);
}

simulated event bool InFreeCam()
{
    return super.InFreeCam();
}

simulated event EndCrouch(float HeightAdjust)
{
    super.EndCrouch(HeightAdjust);
}

simulated event StartCrouch(float HeightAdjust)
{
    super.StartCrouch(HeightAdjust);
}

simulated event Destroyed()
{
    super.Destroyed();
}

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
}

simulated event bool IsSameTeam(Pawn Other)
{
    return super.IsSameTeam(Other);
}

simulated event TornOff()
{
    super.TornOff();
}

simulated event BecomeViewTarget(PlayerController PC)
{
    super.BecomeViewTarget(PC);
}

simulated event Speak(SoundCue Cue)
{
    super.Speak(Cue);
}

simulated event Timer()
{
    super.Timer();
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

/*
simulated event BeginState(name PreviousStateName)
{
    super.
}
*/

simulated event UpdateShadowSettings(bool bInWantShadow)
{
    super.UpdateShadowSettings(bInWantShadow);
}

/*
simulated event EndState(name NextStateName)
{
    super.
}
*/

simulated event PlayMECEventSound(EMECEvent Event)
{
    super.PlayMECEventSound(Event);
}

simulated event XComBuildingVolume GetCurrentBuildingVolumeIfInside()
{
    return super.GetCurrentBuildingVolumeIfInside();
}

simulated event bool IsInside()
{
    return super.IsInside();
}

simulated event SetInWater(bool bInWater, optional float fWaterWorldZ, optional array<ParticleSystem> InWaterParticles)
{
    super.SetInWater(bInWater, fWaterWorldZ, InWaterParticles);
}

simulated event Attach(Actor Other)
{
    super.Attach(Other);
}

simulated event Detach(Actor Other)
{
    super.Detach(Other);
}

simulated event PlayFootStepSound(int FootDown)
{
    super.PlayFootStepSound(FootDown);
}

simulated event PlayInWaterParticles(int FootDown)
{
    super.PlayInWaterParticles(FootDown);
}

simulated event Vector GetLeftHandIKTargetLoc()
{
    return super.GetLeftHandIKTargetLoc();
}

simulated event OnUnSelected()
{
    super.OnUnSelected();
}

simulated event OnSelected()
{
    super.OnSelected();
}

simulated event UnMountCinematicFaceFX()
{
    super.UnMountCinematicFaceFX();
}

simulated event FaceFXAsset GetActorFaceFXAsset()
{
    return super.GetActorFaceFXAsset();
}

simulated event ApplyGhostMaterials(MaterialInstanceTimeVarying MITV)
{
    super.ApplyGhostMaterials(MITV);
}

event MAT_BeginAIGroup(Vector StartLoc, Rotator StartRot)
{
    super.MAT_BeginAIGroup(StartLoc, StartRot);
}

event MAT_FinishAIGroup()
{
    super.MAT_FinishAIGroup();
}