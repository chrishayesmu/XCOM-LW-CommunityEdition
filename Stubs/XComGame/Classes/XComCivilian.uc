class XComCivilian extends XComHumanPawn
    config(Game);
//complete stub

var() SoundCue FemaleOffscreenCue;
var string m_strFemaleOffscreenDeath;
var() SoundCue MaleOffscreenCue;
var string m_strMaleOffscreenDeath;
var int ColorIdx;

simulated event PostBeginPlay(){}
function DelayedDeathSound(){}
function RandomizeAppearance(optional EGender ForceGender){}
function ApplyTemplate(name TemplateName){}
simulated function UpdateCivilianBodyMaterial(MaterialInstanceConstant MIC){}

defaultproperties
{
    m_strFemaleOffscreenDeath="SoundCivilianFemaleScreams.CivFemaleScreamsOffscreenCue"
    m_strMaleOffscreenDeath="SoundCivilianMaleScreams.CivMaleScreamsOffscreenCue"
}