class XGObjectiveManager extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord
{
    var EGameObjective m_eObjective;
    var bool m_bObjectiveAnnounced;
};
var EGameObjective m_eObjective;
var bool m_bObjectiveAnnounced;

function Init(optional EGameObjective eObjective){}
function bool NewObjective(EGameObjective eObjective){}
function Update(){}
function bool IsObjectiveComplete(EGameObjective eObj){}

function array<TSubObjective> GetSubObjectives(EGameObjective eObj){}

function TSubObjective BuildSubObjective(ESubObjective eSubObj){}

