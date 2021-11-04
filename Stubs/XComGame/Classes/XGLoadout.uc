class XGLoadout extends Actor
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord
{
    var bool m_bIsSoldierLoadout;
    var class<XGInventoryItem> m_aItems[26];
    var class<XGInventoryItem> m_aBackpackItems[5];
    var int m_iNumBackpackItems;
};

var bool m_bIsSoldierLoadout;
var class<XGInventoryItem> m_aItems[26];
var class<XGInventoryItem> m_aBackpackItems[5];
var int m_iNumBackpackItems;

function ApplyCheckpointRecord(){}

defaultproperties
{
    bHidden=true
    bTickIsDisabled=true
}