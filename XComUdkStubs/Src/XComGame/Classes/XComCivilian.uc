class XComCivilian extends XComHumanPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var() SoundCue FemaleOffscreenCue;
var string m_strFemaleOffscreenDeath;
var() SoundCue MaleOffscreenCue;
var string m_strMaleOffscreenDeath;
var int ColorIdx;

defaultproperties
{
    m_strFemaleOffscreenDeath="SoundCivilianFemaleScreams.CivFemaleScreamsOffscreenCue"
    m_strMaleOffscreenDeath="SoundCivilianMaleScreams.CivMaleScreamsOffscreenCue"
    ColorIdx=-1
    RangeIndicator=RangeIndicatorMeshComponent
    RagdollFlag=ERagdoll_Always

    begin object name=MyLightEnvironment
        MinTimeBetweenFullUpdates=3.0
        bSynthesizeSHLight=false
    end object

    begin object name=SkeletalMeshComponent
        AnimationLODDistanceFactor=0.20
        AnimationLODFrameRate=3
        bComponentUseFixedSkelBounds=true
    end object

}