class XGLoadoutInstances extends Actor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var XGUnit m_kUnit;
    var int m_iNumItems;
    var int m_iNumBackpackItems;
    var XGInventoryItem m_aItems[26];
    var XGInventoryItem m_aBackpackItems[5];
};

var XGUnit m_kUnit;
var int m_iNumItems;
var int m_iNumBackpackItems;
var XGInventoryItem m_aItems[26];
var XGInventoryItem m_aBackpackItems[5];

defaultproperties
{
    m_iNumItems=-1
    m_iNumBackpackItems=-1
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}