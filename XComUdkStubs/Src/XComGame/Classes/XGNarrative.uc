class XGNarrative extends Actor
    config(Narrative)
    notplaceable
    hidecategories(Navigation);

struct TItemUnlock
{
    var bool bItem;
    var bool bFacility;
    var bool bFoundryProject;
    var bool bGeneMod;
    var bool bMecArmor;
    var SoundCue sndFanfare;
    var EItemType eItemUnlocked;
    var EItemType eItemUnlocked2;
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
var protectedwrite array<XComNarrativeMoment> m_arrNarrativeMoments;
var const config array<config string> NarrativeMoments;
var const config array<config string> NewbieMoments;
var bool m_bSilenceNewbieMoments;