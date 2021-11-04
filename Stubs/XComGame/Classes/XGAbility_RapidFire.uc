class XGAbility_RapidFire extends XGAbility_GameCore
    native(Core);
//complete stub

var bool bShotTwice;
var int m_iNumShots;

// Export UXGAbility_RapidFire::execInternalCheckAvailable(FFrame&, void* const)
native function bool InternalCheckAvailable();

function SetNumShots(int iNumShots){}
function int CalcMaxExecutions(){}
