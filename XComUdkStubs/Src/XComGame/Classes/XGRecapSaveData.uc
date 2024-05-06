class XGRecapSaveData extends Actor
    native
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var array<RecapStatValue> m_aRecapStats;
    var array<string> m_aJournalEvents;
};

var array<RecapStatValue> m_aRecapStats;
var array<string> m_aJournalEvents;