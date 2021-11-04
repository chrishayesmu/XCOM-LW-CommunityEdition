class XGLoadoutInstances extends Actor;
//complete stub

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

simulated function bool IsInitialReplicationComplete(){}
simulated function string ToString(){}
auto simulated state WaitUntilInitialReplicationComplete{}

