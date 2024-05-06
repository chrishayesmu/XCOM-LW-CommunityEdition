class XGLoadout extends Actor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var bool m_bIsSoldierLoadout;
    var class<XGInventoryItem> m_aItems[26];
    var class<XGInventoryItem> m_aBackpackItems[5];
    var int m_iNumBackpackItems;
};

var protected bool m_bIsSoldierLoadout;
var class<XGInventoryItem> m_aItems[26];
var class<XGInventoryItem> m_aBackpackItems[5];
var private int m_iNumBackpackItems;

defaultproperties
{
    bHidden=true
    bTickIsDisabled=true
    bForceNoTick=true
}