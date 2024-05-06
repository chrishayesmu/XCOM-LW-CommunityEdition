class XComRandomList extends Object;

struct list_option
{
    var int iDataID;
    var int iOptionIndex;
    var bool bExcludeRepeats;
};

var array<list_option> m_aOptions;
var array<int> m_aShuffledList;