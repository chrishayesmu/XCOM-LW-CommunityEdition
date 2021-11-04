class XComRandomList extends Object;
//complete stub

struct list_option
{
    var int iDataID;
    var int iOptionIndex;
    var bool bExcludeRepeats;
};

var array<list_option> m_aOptions;
var array<int> m_aShuffledList;

simulated function AddOption(int iOptionID, optional bool bExcludeRepeats){}
function Shuffle(optional int iStartingOptionIndex){}
simulated function bool HandleExclusions(){}
simulated function int FindRepeatOffender(optional int iStartIdx){}
simulated function bool ReorderOption(int iOffenseIdx){}
simulated function int Peek(){}
simulated function int Pop(){}
simulated function LogShuffledList();