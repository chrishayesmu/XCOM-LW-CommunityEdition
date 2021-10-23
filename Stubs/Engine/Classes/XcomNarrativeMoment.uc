class XComNarrativeMoment extends Object
    native;
//complete stub

enum ENarrativeMomentType
{
    eNarrMoment_CommLink,
    eNarrMoment_CommLinkModal,
    eNarrMoment_CommLinkModalLookAt,
    eNarrMoment_Matinee,
    eNarrMoment_MatineeModal,
    eNarrMoment_Tentpole,
    eNarrMoment_VoiceOnly,
    eNarrMoment_VoiceOnlyMissionStream,
    eNarrMoment_Bink,
    eNarrMoment_MAX
};

var() ENarrativeMomentType eType;
var() bool bFirstTimeAtIndexZero;
var() bool bDontPlayIfNarrativePlaying;
var() bool bUseCinematicSoundClass;
var transient bool bFirstRunOnly;
var() notforconsole array<SoundCue> Conversations;
var() editconst array<editconst name> arrConversations;
var() string strMapToStream;
var() name nmRemoteEvent;
var() string strBink;
var transient int iID;

simulated function bool ShouldClearQueueOfNonTentpoles(){}
simulated function bool CanBeCanceled(){}
simulated function bool UseFadeToBlack(){}
simulated function bool IsModal(){}
simulated function bool IsVoiceOnly(){}
