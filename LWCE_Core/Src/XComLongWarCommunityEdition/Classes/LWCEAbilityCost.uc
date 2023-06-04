class LWCEAbilityCost extends Object
	abstract;

var bool bFreeCost; //  If true, then ApplyCost should do nothing, but CanAfford will still check the requirements.

function name CanAfford(LWCE_XGAbility kAbility, const LWCE_TAvailableTarget kTarget);

function ApplyCost(LWCE_XGAbility kAbility, const LWCE_TAvailableTarget kTarget);

protected function bool ShouldSkipCost()
{
    return bFreeCost || (`LWCE_CHEATMGR_TAC != none && `LWCE_CHEATMGR_TAC.bUnlimitedMoves);
}