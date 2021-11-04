class XGNarrative extends Actor
    config(Narrative)
    notplaceable
    hidecategories(Navigation)
	dependsOn(XGGameData);
//complete stub

struct TItemUnlock
{
    var bool bItem;
    var bool bFacility;
    var bool bFoundryProject;
    var bool bGeneMod;
    var bool bMecArmor;
    var SoundCue sndFanfare;
    var XGGameData.EItemType eItemUnlocked;
    var XGGameData.EItemType eItemUnlocked2;
    var int iUnlocked;
    var int eUnlockImage;
    var string strTitle;
    var string strName;
    var string strDescription;
    var string strHelp;
};

struct CheckpointRecord
{
    var array<int> m_arrTipCounters;
    var array<int> m_arrNarrativeCounters;
    var bool m_bSilenceNewbieMoments;
};

var array<int> m_arrTipCounters;
var array<int> m_arrNarrativeCounters;
var array<int> m_arrNarrativeCountersAtStartOfMap;
var array<XComNarrativeMoment> m_arrNarrativeMoments;
var const config array<config string> NarrativeMoments;
var const config array<config string> NewbieMoments;
var bool m_bSilenceNewbieMoments;

simulated function InitNarrative(optional bool bSilenceNewbieMoments){}
simulated function int GetNextTip(ETipTypes eTip){}
simulated function int FindMomentID(string Moment){}
simulated function StoreNarrativeCounters(){}
simulated function RestoreNarrativeCounters(){}
event PreBeginPlay(){}
function DoSilenceNewbieMoments(){}
simulated function bool SilenceNewbieMoments(){}

