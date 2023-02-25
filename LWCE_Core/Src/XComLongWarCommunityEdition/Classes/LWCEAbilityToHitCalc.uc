class LWCEAbilityToHitCalc extends Object
    abstract;

function int GetHitChance(LWCE_XGAbility kAbility, LWCE_TAvailableTarget kTarget, optional out TShotInfo kShotInfo, optional out TShotResult kResult);