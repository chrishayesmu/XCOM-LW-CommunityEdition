class XGTactic_Lurk extends XGTactic
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord_XGTactic_Lurk extends CheckpointRecord
{
    var Vector m_vLurkLoc;
    var EItemType m_eLurkDevice;
};

var Vector m_vLurkLoc;
var EItemType m_eLurkDevice;

function bool IsComplete(){}
function InitLurk(XGPod kPod, EPodTactic eTactic, Vector vLoc, optional XGGameData.EItemType eLurkDevice){}
function bool HasBeenPassed(float fEnemyParameter){}
function Lurk(Vector vLoc){}
function EPodAnimation GetPodAnim(){}

defaultproperties
{
    m_strName="LURK"
}