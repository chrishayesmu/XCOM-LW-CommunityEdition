class XComCharacterVoice extends Object
    hidecategories(Object);

var() notforconsole array<XComCharacterVoiceBank> VoiceBanks;
var() private const editconst array<editconst string> VoiceBankNames;
var privatewrite const transient XComCharacterVoiceBank CurrentVoiceBank;
var privatewrite const transient bool bStreamingRequestInFlight;
var() SoundCue CharacterCustomizationCue;