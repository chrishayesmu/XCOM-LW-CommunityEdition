class XGAbility_GameCore extends XGAbility_Targeted
	 native(Core);
//complete stub


native function bool InternalCheckAvailable();

simulated function ApplyEffect(){}

simulated function BeginAbility(){}

simulated function EndAbility(){}

simulated function bool Projectile_OverrideStartPositionAndDir(out Vector tempTrace, out Vector tempDir){}

