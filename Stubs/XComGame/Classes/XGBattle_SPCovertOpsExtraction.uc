class XGBattle_SPCovertOpsExtraction extends XGBattle_SP
	config(GameData)
    notplaceable;
//complete stub

struct CheckpointRecord_XGBattle_SPCovertOpsExtraction extends CheckpointRecord_XGBattle_SP
{
    var XGUnit m_kCovertOperative;
};

var const config int m_iCovertOpsCashRewardAmount;
var XGUnit m_kCovertOperative;

function XGUnit GetCovertOperative(){}
function CollectLoot(){}
function bool ShouldAwardIntel(){}
function bool DoesCovertOperativeHaveToSurvive(){}
function XComSpawnPoint ChooseCovertOperativeSpawnPoint(){}
function TTransferSoldier CreateDebugCovertOperative(XGUnit kTemplate){}
function ForceCovertOperativeLoadout(out TTransferSoldier kTransferSoldier){}
function SpawnCovertOperative(){}
function InitPlayers(optional bool bLoading){}
simulated function InitRadarArrays(){}
function PutSoldiersOnDropship(){}

simulated state Running{
    event BeginState(name PrevState){}
}
state AbortMissionCheck{
    function bool ShouldShowAbortDialog()
	{}
}

