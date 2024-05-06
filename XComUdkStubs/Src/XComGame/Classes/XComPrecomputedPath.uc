class XComPrecomputedPath extends Actor
    native(Weapon)
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

const MAXPRECOMPUTEDPATHKEYFRAMES = 128;
const PATHSTARTTIME = 1.0f;
const PATHMAXTIME = 2.5f;
const MAX_CB_OFFSET = 192.0f;

struct native XKeyframe
{
    var float fTime;
    var Vector vLoc;
    var Rotator rRot;
    var bool bValid;
};

var repnotify XKeyframe akKeyframesReplicated[128];
var XKeyframe akKeyframes[128];
var repnotify int iNumKeyframesReplicated;
var int iNumKeyframes;
var bool bAllValidKeyframeDataReplicated;
var bool bEnableTick;
var bool bSplineDirty;
var bool bOnlyDrawIfFriendlyToLocalPlayer;
var bool m_bValid;
var bool m_bBlasterBomb;
var int iLastExtractedKeyframe;
var InterpCurveVector kSplineInfo;
var float fEmitterTimeStep;
var XComWeapon kCurrentWeapon;
var export editinline XComRenderablePathComponent kRenderablePath;
var const string PathingRibbonMaterialName;
var repnotify ETeam eComputePathForTeam;
var float m_fTime;
var config float BlasterBombSpeed;

defaultproperties
{
    iNumKeyframesReplicated=-1
    iNumKeyframes=-1
    bOnlyDrawIfFriendlyToLocalPlayer=true
    fEmitterTimeStep=0.050
    PathingRibbonMaterialName="MarcPackage.Materials.TrailRibbon"
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}