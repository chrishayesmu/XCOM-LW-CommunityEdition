class LWCEAbilityCost extends Object
	abstract;

var bool bFreeCost; //  If true, then ApplyCost should do nothing, but CanAfford will still check the requirements.

function name CanAfford(LWCE_XGAbility kAbility);

function ApplyCost(LWCE_XGAbility kAbility);

protected function bool ShouldSkipCost()
{
    return bFreeCost || (`LWCE_CHEATMGR_TAC != none && `LWCE_CHEATMGR_TAC.bUnlimitedMoves);
}