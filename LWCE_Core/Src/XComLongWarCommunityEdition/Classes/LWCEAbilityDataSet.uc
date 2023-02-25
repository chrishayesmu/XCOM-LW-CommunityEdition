class LWCEAbilityDataSet extends LWCEDataSet;

//---------------------------------------------------------------------------------------
// Default variables for use when creating templates. Much like XCOM 2, these simplify template
// creation by providing pre-created values for many common scenarios. These variables should not
// be modified in any way.
//---------------------------------------------------------------------------------------

var LWCEAbilityToHitCalc_StandardAim SimpleStandardAim;
var LWCEAbilityCondition_UnitProperty LivingShooterProperty;
var LWCEAbilityCondition_UnitProperty LivingHostileTargetProperty;
var LWCEAbilityTargetStyle_Single SimpleSingleTarget;
var LWCEAbilityCondition_Visibility VisibleToSourceCondition;

static function array<LWCEDataTemplate> CreateTemplates()
{
    local array<LWCEDataTemplate> arrTemplates;

    arrTemplates.AddItem(StandardShot());

    return arrTemplates;
}

static function LWCEAbilityTemplate StandardShot()
{
	local LWCEAbilityTemplate Template;
    local LWCEAbilityCost_ActionPoints kActionPointsCost;
    local LWCEAbilityCost_Ammo kAmmoCost;
    local LWCEAbilityCondition_Visibility kVisCondition;

	`CREATE_ABILITY_TEMPLATE(Template, 'StandardShot');

    kActionPointsCost = new class'LWCEAbilityCost_ActionPoints';
    kActionPointsCost.iNumPoints = 1;
    kActionPointsCost.bConsumeAllPoints = true;
    kActionPointsCost.DoNotConsumeAllAbilities.AddItem('LightEmUp');
    Template.AbilityCosts.AddItem(kActionPointsCost);

    kAmmoCost = new class'LWCEAbilityCost_Ammo';
    kAmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(kAmmoCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    kVisCondition = new class'LWCEAbilityCondition_Visibility';
    kVisCondition.bRequireLineOfSight = true;
    kVisCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(kVisCondition);

	Template.AbilityToHitCalc = default.SimpleStandardAim;

    return Template;
}

defaultproperties
{
    Begin Object Class=LWCEAbilityToHitCalc_StandardAim Name=DefaultSimpleStandardAim
	End Object
	SimpleStandardAim = DefaultSimpleStandardAim;

	Begin Object Class=LWCEAbilityCondition_UnitProperty Name=DefaultLivingShooterProperty
		bExcludeLiving=false
		bExcludeDead=true
		bExcludeFriendlyToSource=false
		bExcludeHostileToSource=true
	End Object
	LivingShooterProperty = DefaultLivingShooterProperty;

	Begin Object Class=LWCEAbilityCondition_UnitProperty Name=DefaultLivingHostileTargetProperty
		bExcludeLiving=false
		bExcludeDead=true
		bExcludeFriendlyToSource=true
		bExcludeHostileToSource=false
		bTreatMindControlledSquadmateAsHostile=true
	End Object
	LivingHostileTargetProperty = DefaultLivingHostileTargetProperty;

    Begin Object Class=LWCEAbilityCondition_Visibility Name=DefaultVisibleToSourceCondition
		bRequireLineOfSight=true
		bAllowSquadsight=false
	End Object
	VisibleToSourceCondition = DefaultVisibleToSourceCondition;

    Begin Object Class=LWCEAbilityTargetStyle_Single Name=DefaultSimpleSingleTarget
	End Object
	SimpleSingleTarget = DefaultSimpleSingleTarget;
}