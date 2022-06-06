class Helpers extends Object
    abstract
    native;

struct native ProjectPathPredictionPoint
{
    var transient float Time;
    var transient Vector Location;
    var transient Vector Velocity;
};

struct native CamCageResult
{
    var int iCamZoneID;
    var int iCamZoneBlocked;
};

native static final function float S_EvalInterpCurveFloat(const out InterpCurveFloat Curve, float AlphaValue);
static function BetterInvoke(){}
native static final function GetComplexViewOrientation(ScriptSceneView SceneView, Vector PrimaryAimPos, Vector SecondaryAimPos, Rotator EndRotation, out Vector out_Location, out Rotator out_Rotation);
native static final function Rotator RotateLocalByWorld(Rotator Local, Rotator ByWorld);
native static final function SetParticleGameSpeed(float TimeScale);
native static final function PredictProjectilePath(Vector StartLocation, Vector StartVelocity, float Gravity, float BounceFactor, float TotalTime, int NumberOfSteps, out array<ProjectPathPredictionPoint> PredictedPositions, optional float DisableGravityAtZSpeed = 32.0, optional bool bDrawLines = false);
native static final function bool isVisibilityBlocked(Vector vFrom, Vector vTo, Actor SourceActor, out Vector vHitLoc, optional bool bVolumesOnly = false);
static simulated function bool isOnScreen(Vector vTarget, TPOV kPOV, float fAspectRatio){}
native static final function WorldInfo GetWorldInfo();
static final function OutputMsg(string msg, optional name logCategory){}
static final function Vector GetMovementData(InterpData MatineeData, int iUnitIdx, optional bool bGetPos, optional int iKeyFrame){}
static final function float GetPercentageToCameraView(XComTacticalController kTacticalController, XGCameraView kStartingView, XGCameraView kEndingView){}
native static simulated function SetGameRenderingEnabled(bool Enabled, int iFrameDelay);
native static final function int NextAbilityID();
native static function Vector2D GetUVCoords(StaticMeshComponent MeshComp, Vector vWorldStartPos, Vector vWorldDirection);
native static final function bool AreVectorsDifferent(const out Vector v1, const out Vector v2, float fTolerance);
native static final function string NetGetVerifyPackageHashes();