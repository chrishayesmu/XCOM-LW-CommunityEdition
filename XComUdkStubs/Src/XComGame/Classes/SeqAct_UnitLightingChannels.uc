class SeqAct_UnitLightingChannels extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

struct TLightingData
{
    var() name ChannelName;
    var() LightingChannelContainer LightingChannel;
};

struct TUnitLighting
{
    var() name PawnChannel;
    var() name AttachementChannel;
    var() bool bDisableDLE;
    var() int SquadMemberIdx;
};

var(Lighting) array<TLightingData> LightingChannels;
var(Pawn) array<TUnitLighting> UnitLighting;
var LightingChannelContainer DefaultLightingChannel;

defaultproperties
{
    DefaultLightingChannel=(bInitialized=true,Dynamic=true)
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Set")
    InputLinks(1)=(LinkDesc="Restore")
    ObjName="Unit Lighting Channels"
}