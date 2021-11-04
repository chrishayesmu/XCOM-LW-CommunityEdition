class XComZombieManager extends XComCountdownObjectManager;

//complete stub

var array<XGAIChryssalidEgg> m_arrActive;
var array<XGAIChryssalidEgg> m_arrSpawning;
var XGAIChryssalidEgg m_kActiveEgg;
var int m_iActiveEgg;

function bool HasActiveEggsForPlayer(XGPlayer kPlayer){}
simulated function AddActiveEgg(XGAIChryssalidEgg kEgg){}
simulated function UpdateActiveCountdownObjects(){}
simulated function Explode(){}
simulated function XGAIChryssalidEgg GetNextSpawningZombie(){}
simulated function InitCountdownObjectLoop(){}
function InitZombieContent(){}
simulated function bool HasCountdownObjects(){}
simulated function bool IsCountdownObjectVisible(){}
simulated function CountdownObjectLoop_Iterate(){}
simulated function bool HasTickingObjects(){}
simulated function string GetDebugLabel(Actor kObj){}
simulated function bool GetNextActive(out Actor kObj){}

state Active{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}

}
