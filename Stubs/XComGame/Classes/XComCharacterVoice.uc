class XComCharacterVoice extends Object
    hidecategories(Object)
    native(Unit)
	dependson(XGGameData);
//complete stub

var() notforconsole array<XComCharacterVoiceBank> VoiceBanks;
var() array<string> VoiceBankNames;
var() SoundCue CharacterCustomizationCue;
var const transient XComCharacterVoiceBank CurrentVoiceBank;
var const transient bool bStreamingRequestInFlight;

// Export UXComCharacterVoice::execGetSoundCue(FFrame&, void* const)
native final function SoundCue GetSoundCue(ECharacterSpeech Event);

// Export UXComCharacterVoice::execStreamNextVoiceBank(FFrame&, void* const)
native final function StreamNextVoiceBank(optional bool bForce);

function PlaySoundForEvent(ECharacterSpeech Event, Actor Owner){}
