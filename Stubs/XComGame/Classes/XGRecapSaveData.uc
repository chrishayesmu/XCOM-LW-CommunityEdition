class XGRecapSaveData extends Actor
    native
    notplaceable
    hidecategories(Navigation)
	DependsOn(XComMapManager);
//complete stub

struct CheckpointRecord
{
    var array<RecapStatValue> m_aRecapStats;
    var array<string> m_aJournalEvents;
};

var array<RecapStatValue> m_aRecapStats;
var array<string> m_aJournalEvents;

private final function int FindStatIndex(ERecapStats eStat){}
function int GetStat(ERecapStats eStat){}
function float GetAvgStat(ERecapStats eCountStat, ERecapStats eSumStat){}
function float AvgStat(ERecapStats eCountStat, ERecapStats eSumStat, int Value){}
function int SetStat(ERecapStats eStat, int NewValue){}
function int IncStat(ERecapStats eStat, optional int Value){}
function RecordEvent(string EventText){}
native function PrintJournalToLog();