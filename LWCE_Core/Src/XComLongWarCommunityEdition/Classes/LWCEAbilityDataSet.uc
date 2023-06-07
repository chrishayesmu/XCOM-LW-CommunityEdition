class LWCEAbilityDataSet extends LWCEDataSet;

//---------------------------------------------------------------------------------------
// Default variables for use when creating templates. Much like XCOM 2, these simplify template
// creation by providing pre-created values for many common scenarios. These variables should not
// be modified in any way.
//---------------------------------------------------------------------------------------

var LWCEAbilityToHitCalc_DeadEye DeadEye;
var LWCEAbilityToHitCalc_StandardAim SimpleStandardAim;
var LWCECondition_UnitProperty LivingShooterProperty;
var LWCECondition_UnitProperty LivingHostileTargetProperty;
var LWCEAbilityTrigger_PlayerInput PlayerInputTrigger;
var LWCEAbilityTrigger_UnitPostBeginPlay UnitPostBeginPlayTrigger;
var LWCEAbilityTargetStyle_Self SelfTarget;
var LWCEAbilityTargetStyle_Single SimpleSingleTarget;
var LWCECondition_Visibility VisibleToSourceCondition;

static function array<LWCEDataTemplate> CreateTemplates()
{
    local array<LWCEDataTemplate> arrTemplates;

    arrTemplates.AddItem(DamnGoodGround());
    arrTemplates.AddItem(Executioner());
    arrTemplates.AddItem(LowProfile());
    arrTemplates.AddItem(Ranger());
    arrTemplates.AddItem(StandardShot());

    return arrTemplates;
}

static function LWCEAbilityTemplate DamnGoodGround()
{
	local LWCEAbilityTemplate Template;
	local LWCEEffect_DamnGoodGround PersistentEffect;

	`CREATE_ABILITY_TEMPLATE(Template, 'DamnGoodGround');

	Template.AbilityIcon = "DamnGoodGround";
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = new class'LWCEEffect_DamnGoodGround';
	PersistentEffect.BuildPersistentEffect(1, /* bIsInfinite */ true);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.strFriendlyName, Template.strDescription, Template.AbilityIcon, /* bDisplayInHUD */ true);

	Template.AbilityTargetEffects.AddItem(PersistentEffect);

	return Template;
}

static function LWCEAbilityTemplate Executioner()
{
	local LWCEAbilityTemplate Template;
	local LWCEEffect_Executioner PersistentEffect;

	`CREATE_ABILITY_TEMPLATE(Template, 'Executioner');

	Template.AbilityIcon = "Executioner";
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = new class'LWCEEffect_Executioner';
	PersistentEffect.BuildPersistentEffect(1, /* bIsInfinite */ true);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.strFriendlyName, Template.strDescription, Template.AbilityIcon, /* bDisplayInHUD */ true);

	Template.AbilityTargetEffects.AddItem(PersistentEffect);

	return Template;
}

static function LWCEAbilityTemplate LowProfile()
{
	local LWCEAbilityTemplate Template;
	local LWCEEffect_LowProfile PersistentEffect;

	`CREATE_ABILITY_TEMPLATE(Template, 'LowProfile');

	Template.AbilityIcon = "LowProfile";
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = new class'LWCEEffect_LowProfile';
	PersistentEffect.BuildPersistentEffect(1, /* bIsInfinite */ true);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.strFriendlyName, Template.strDescription, Template.AbilityIcon, /* bDisplayInHUD */ true);

	Template.AbilityTargetEffects.AddItem(PersistentEffect);

	return Template;
}

static function LWCEAbilityTemplate Ranger()
{
	local LWCEAbilityTemplate Template;
	local LWCEEffect_Ranger RangerEffect;

	`CREATE_ABILITY_TEMPLATE(Template, 'Ranger');

	Template.AbilityIcon = "Gunslinger";
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	RangerEffect = new class'LWCEEffect_Ranger';
	RangerEffect.BuildPersistentEffect(1, /* bIsInfinite */ true);
	RangerEffect.SetDisplayInfo(ePerkBuff_Passive, Template.strFriendlyName, Template.strDescription, Template.AbilityIcon, /* bDisplayInHUD */ true);

	Template.AbilityTargetEffects.AddItem(RangerEffect);

	return Template;
}

static function LWCEAbilityTemplate StandardShot()
{
	local LWCEAbilityTemplate Template;
    local LWCEAbilityCost_ActionPoints kActionPointsCost;
    local LWCEAbilityCost_Ammo kAmmoCost;
    local LWCECondition_Visibility kVisCondition;
	local LWCEEffect_ApplyWeaponDamage kEffect;

	`CREATE_ABILITY_TEMPLATE(Template, 'StandardShot');

    Template.AbilityIcon = "Standard";

    kActionPointsCost = new class'LWCEAbilityCost_ActionPoints';
    kActionPointsCost.iNumPoints = 1;
    kActionPointsCost.bConsumeAllPoints = true;
    kActionPointsCost.DoNotConsumeAllAbilities.AddItem('LightEmUp');
    Template.AbilityCosts.AddItem(kActionPointsCost);

    kAmmoCost = new class'LWCEAbilityCost_Ammo';
    kAmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(kAmmoCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    kVisCondition = new class'LWCECondition_Visibility';
    kVisCondition.bRequireLineOfSight = true;
    kVisCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(kVisCondition);

	kEffect = new class'LWCEEffect_ApplyWeaponDamage';
	kEffect.bDealEnvironmentalDamage = true;
	kEffect.bDealUnitDamage = true;
	Template.AbilityTargetEffects.AddItem(kEffect);

	Template.AbilityToHitCalc = default.SimpleStandardAim;

	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}

static function TypicalAbility_BuildVisualization(const out LWCE_TAbilityInputContext kInputContext, const out LWCE_TAbilityResult kResult)
{
	local LWCEAction_ExitCover ExitCoverAction;
	local LWCEAction_Fire FireAction;
	local LWCEAction_ToggleTacticalHUD HUDAction;
	local VisualizationActionMetadata BlankMetadata, ActionMetadata;

	`LWCE_LOG_CLS("Building typical ability visualization for ability name " $ kInputContext.AbilityTemplateName);
	ActionMetadata.VisualizeActor = kInputContext.Source;

	HUDAction = LWCEAction_ToggleTacticalHUD(class'LWCEAction_ToggleTacticalHUD'.static.CreateInVisualizationTree(ActionMetadata));
	HUDAction.m_bShowHUD = false;

	ExitCoverAction = LWCEAction_ExitCover(class'LWCEAction_ExitCover'.static.CreateInVisualizationTree(ActionMetadata, , ActionMetadata.LastActionAdded));
	ExitCoverAction.ForAbilityContext(kInputContext, kResult);

	// For now this is just the Fire action
	FireAction = LWCEAction_Fire(class'LWCEAction_Fire'.static.CreateInVisualizationTree(ActionMetadata, , ActionMetadata.LastActionAdded));
	FireAction.ForAbilityContext(kInputContext, kResult);

	HUDAction = LWCEAction_ToggleTacticalHUD(class'LWCEAction_ToggleTacticalHUD'.static.CreateInVisualizationTree(ActionMetadata, , ActionMetadata.LastActionAdded));
	HUDAction.m_bShowHUD = true;
}

defaultproperties
{
	Begin Object Class=LWCEAbilityToHitCalc_DeadEye Name=DefaultDeadEye
	End Object
	DeadEye = DefaultDeadEye;

    Begin Object Class=LWCEAbilityToHitCalc_StandardAim Name=DefaultSimpleStandardAim
        bCanCrit=true
	End Object
	SimpleStandardAim = DefaultSimpleStandardAim;

	Begin Object Class=LWCECondition_UnitProperty Name=DefaultLivingShooterProperty
		bExcludeLiving=false
		bExcludeDead=true
		bExcludeFriendlyToSource=false
		bExcludeHostileToSource=true
	End Object
	LivingShooterProperty = DefaultLivingShooterProperty;

	Begin Object Class=LWCECondition_UnitProperty Name=DefaultLivingHostileTargetProperty
		bExcludeLiving=false
		bExcludeDead=true
		bExcludeFriendlyToSource=true
		bExcludeHostileToSource=false
		bTreatMindControlledSquadmateAsHostile=true
	End Object
	LivingHostileTargetProperty = DefaultLivingHostileTargetProperty;

    Begin Object Class=LWCECondition_Visibility Name=DefaultVisibleToSourceCondition
		bRequireLineOfSight=true
		bAllowSquadsight=false
	End Object
	VisibleToSourceCondition = DefaultVisibleToSourceCondition;

    Begin Object Class=LWCEAbilityTargetStyle_Single Name=DefaultSimpleSingleTarget
	End Object
	SimpleSingleTarget = DefaultSimpleSingleTarget;

	Begin Object Class=LWCEAbilityTargetStyle_Self Name=DefaultSelfTarget
	End Object
	SelfTarget = DefaultSelfTarget;

	Begin Object Class=LWCEAbilityTrigger_PlayerInput Name=DefaultPlayerInputTrigger
	End Object
	PlayerInputTrigger = DefaultPlayerInputTrigger;

	Begin Object Class=LWCEAbilityTrigger_UnitPostBeginPlay Name=DefaultUnitPostBeginPlayTrigger
	End Object
	UnitPostBeginPlayTrigger = DefaultUnitPostBeginPlayTrigger;
}