class LWCE_XGAbility extends XGAbility_GameCore;

// TODO: this struct doesn't allow for hit chance/damage for each additional target, only primary
struct LWCE_TTargetOption
{
    var LWCE_TAvailableTarget kTarget;
    var LWCEAbilityUsageSummary kPreview;
};

struct CheckpointRecord_LWCE_XGAbility extends CheckpointRecord_XGAbility_Targeted
{
    var name m_TemplateName;
};

var name m_TemplateName;

var LWCEAbilityTemplate m_kTemplate;
var array<LWCE_TTargetOption> arrTargetOptions;
var LWCE_TAbilityResult m_kResult;
var int m_iCurrentTargetIndex;

static function bool HitResultIsCritical(const out LWCE_TAbilityResult kResult)
{
    return kResult.HitResult == eHit_HitCrit;
}

static function bool HitResultIsHit(const out LWCE_TAbilityResult kResult)
{
    return kResult.HitResult == eHit_HitCrit || kResult.HitResult == eHit_HitNoCrit;
}

function Init(int iAbility)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(name nmAbility)
{
    m_TemplateName = nmAbility;
    m_kTemplate = `LWCE_ABILITY(nmAbility);
    m_kWeapon = GetWeaponToUse();
    m_iCurrentTargetIndex = INDEX_NONE;

    strName = m_kTemplate.strFriendlyName;
    strHelp = m_kTemplate.strHelp;
    strTargetMessage = m_kTemplate.strTargetMessage;
    strPerformerMessage = m_kTemplate.strPerformerMessage;

    GatherTargets();
}

simulated function name LWCE_CheckAvailable()
{
    local LWCE_TAvailableTarget kTarget;

    if (m_iCurrentTargetIndex >= 0 && m_iCurrentTargetIndex < arrTargetOptions.Length)
    {
        kTarget = arrTargetOptions[m_iCurrentTargetIndex].kTarget;
    }

    return m_kTemplate.CheckAvailable(self, kTarget);
}

function name Activate(optional out LWCE_TAbilityResult kOutResult)
{
    local LWCEEffect kEffect;
    local LWCE_TAbilityInputContext kInputContext;
    local LWCE_TAbilityResult kResult;
    local name nmAvailableCode, nmApplyResult;
    local bool bIsHit, bIsCrit;
    local LWCE_XGUnit kSource, kTarget;

    `LWCE_LOG_CLS("Activating ability " $ m_TemplateName);

    kSource = LWCE_XGUnit(m_kUnit);
    kTarget = LWCE_XGUnit(GetPrimaryTarget());
    nmAvailableCode = LWCE_CheckAvailable();

    if (nmAvailableCode != 'AA_Success')
    {
        `LWCE_LOG_CLS("Ability is not currently available: availability code is " $ nmAvailableCode);
        return nmAvailableCode;
    }

    bIsHit = `SYNC_RAND(100) < GetHitChance();
    bIsCrit = bIsHit ? `SYNC_RAND(100) < GetCriticalChance() : false;

    if (bIsHit && !bIsCrit)
    {
        kResult.HitResult = eHit_HitNoCrit;
    }
    else if (bIsHit && bIsCrit)
    {
        kResult.HitResult = eHit_HitCrit;
    }
    else
    {
        // TODO, allow for preventing hits
        kResult.HitResult = eHit_Miss;
    }

    `LWCE_LOG_CLS("Ability result is " $ kResult.HitResult);

    // TODO: much more to do with input context here
    kInputContext.AbilityTemplateName = m_TemplateName;
    kInputContext.Ability = self;
    kInputContext.Source = kSource;
    kInputContext.PrimaryTarget = kTarget;
    kInputContext.Weapon = GetWeaponToUse();

    // Apply source effects
    foreach m_kTemplate.AbilitySourceEffects(kEffect)
    {
        nmApplyResult = kEffect.ApplyEffect(kInputContext, kTarget, kResult);

        kResult.SourceEffectResults.Effects.AddItem(kEffect);
        kResult.SourceEffectResults.ApplyResults.AddItem(nmApplyResult);
    }

    // Apply target effects
    // TODO: no support for multi-target abilities here
    if (kTarget != none)
    {
        foreach m_kTemplate.AbilityTargetEffects(kEffect)
        {
            `LWCE_LOG_CLS("Attempting to apply effect " $ kEffect);

            nmApplyResult = kEffect.ApplyEffect(kInputContext, kTarget, kResult);

            kResult.TargetEffectResults.Effects.AddItem(kEffect);
            kResult.TargetEffectResults.ApplyResults.AddItem(nmApplyResult);
        }
    }

    if (m_kTemplate.BuildVisualizationFn != none)
    {
        m_kTemplate.BuildVisualizationFn(kInputContext, kResult);
    }

    kOutResult = kResult;
    m_kResult = kResult;

    return 'AA_Success';
}

function ApplyCost()
{
    `LWCE_LOG_NOT_IMPLEMENTED(ApplyCost);
}

simulated function bool CanFireWeapon()
{
    `LWCE_LOG_NOT_IMPLEMENTED(CanFireWeapon);
    return true;
}

simulated function bool CanFreeAim()
{
    `LWCE_LOG_NOT_IMPLEMENTED(CanFreeAim);
    return false;
}

simulated event bool CanTargetUnit(XGUnit kUnit)
{
    `LWCE_LOG_NOT_IMPLEMENTED(CanTargetUnit);
    return true;
}

simulated function int FindTargetIndex(XGUnit kTarget)
{
    local int iTarget;

    for (iTarget = 0; iTarget < arrTargetOptions.Length; iTarget++)
    {
        if (arrTargetOptions[iTarget].kTarget.kPrimaryTarget == kTarget)
        {
            return iTarget;
        }
    }

    return INDEX_NONE;
}

function GatherTargets()
{
    local LWCEAbilityUsageSummary kPreview;
    local LWCE_TTargetOption kTargetOption;
    local array<LWCE_TAvailableTarget> arrTargets;
    local int Index;

    arrTargetOptions.Length = 0;

    m_kTemplate.GatherTargets(self, arrTargets);

    `LWCE_LOG_CLS("Ability " $ m_TemplateName $ " found " $ arrTargets.Length $ " potential targets for unit " $ m_kUnit.m_kCharacter.GetFullName());

    for (Index = 0; Index < arrTargets.Length; Index++)
    {
        kPreview = m_kTemplate.GenerateAbilityPreview(self, arrTargets[Index]);

        kTargetOption.kTarget = arrTargets[Index];
        kTargetOption.kPreview = kPreview;

        arrTargetOptions.AddItem(kTargetOption);

        // `LWCE_LOG_CLS("Target option " $ Index $ ": " $ kPreview.iFinalHitChance $ " hit chance, " $ kPreview.iFinalCritChance $ " crit chance");
    }

    if (arrTargetOptions.Length > 0)
    {
        m_iCurrentTargetIndex = 0;
    }
}

simulated function int GetCriticalChance()
{
    // TODO: this approach doesn't allow for crits on rockets/grenades, which may be a desired mod
    if (m_iCurrentTargetIndex < 0 || m_iCurrentTargetIndex >= arrTargetOptions.Length)
    {
        return 0;
    }

    return m_kTemplate.AbilityToHitCalc.GetFinalCritChance(self, arrTargetOptions[m_iCurrentTargetIndex].kPreview);
}

function LWCE_TDamagePreview GetDamagePreview(LWCE_XGUnit kTarget, bool bIsHit, bool bIsCrit)
{
    local LWCE_TAbilityResult kFakeResult;
    local LWCE_TDamagePreview kCurrentPreview, kFinalPreview;
    local LWCE_TAbilityInputContext kInputContext;
    local LWCEEffect kEffect;

    kFinalPreview.kPrimaryTarget = kTarget;

    if (bIsHit && bIsCrit)
    {
        kFakeResult.HitResult = eHit_HitCrit;
    }
    else if (bIsHit)
    {
        kFakeResult.HitResult = eHit_HitNoCrit;
    }
    else
    {
        kFakeResult.HitResult = eHit_Miss;
    }

    `LWCE_LOG_CLS("LWCE_XGAbility: GetDamagePreview: " $ m_kTemplate.AbilityTargetEffects.Length $ " effects to process");

    // TODO have a real input context
    kInputContext.AbilityTemplateName = m_TemplateName;
    kInputContext.Ability = self;
    kInputContext.Source = m_kUnit;
    kInputContext.PrimaryTarget = kTarget;
    kInputContext.Weapon = GetWeaponToUse();

    foreach m_kTemplate.AbilityTargetEffects(kEffect)
    {
        kCurrentPreview = kEffect.GetDamagePreview(kInputContext, kTarget, /* bAsPrimaryTarget */ true, kFakeResult);

        kFinalPreview.iMinDamage += kCurrentPreview.iMinDamage;
        kFinalPreview.iMaxDamage += kCurrentPreview.iMaxDamage;
        kFinalPreview.iMinDamageReduction += kCurrentPreview.iMinDamageReduction;
        kFinalPreview.iMaxDamageReduction += kCurrentPreview.iMaxDamageReduction;
    }

    return kFinalPreview;
}

simulated function int GetEmptyTargetIndex()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetEmptyTargetIndex);

    return INDEX_NONE;
}

simulated function int GetHitChance()
{
    if (m_iCurrentTargetIndex < 0 || m_iCurrentTargetIndex >= arrTargetOptions.Length)
    {
        return 0;
    }

    return m_kTemplate.AbilityToHitCalc.GetFinalHitChance(self, arrTargetOptions[m_iCurrentTargetIndex].kPreview);
}

simulated function int GetNumTargets()
{
    // TODO might need to only count targets where kPrimaryTarget != none
    return arrTargetOptions.Length;
}

simulated function XGUnit GetPrimaryTarget()
{
    if (m_iCurrentTargetIndex < 0 || m_iCurrentTargetIndex >= arrTargetOptions.Length)
    {
        return none;
    }

    return arrTargetOptions[m_iCurrentTargetIndex].kTarget.kPrimaryTarget;
}

simulated function bool GetTargets(out array<XGUnit> arrTargets)
{
    local int I;

    for (I = 0; I < arrTargetOptions.Length; I++)
    {
        if (arrTargetOptions[I].kTarget.kPrimaryTarget != none && arrTargetOptions[I].kTarget.kPrimaryTarget.IsAlive())
        {
            arrTargets.AddItem(arrTargetOptions[I].kTarget.kPrimaryTarget);
        }
    }

    return arrTargets.Length > 0;
}

function LWCEWeaponTemplate GetWeaponTemplate()
{
    if (m_kWeapon == none)
    {
        return none;
    }

    return LWCE_XGWeapon(m_kWeapon).m_kTemplate;
}

simulated function bool IsBlasterLauncherShot()
{
    `LWCE_LOG_NOT_IMPLEMENTED(IsBlasterLauncherShot);
    return false;
}

simulated function bool IsRocketShot()
{
    `LWCE_LOG_NOT_IMPLEMENTED(IsRocketShot);
    return false;
}

function bool IsTriggeredByInput()
{
    return m_kTemplate.IsAbilityInputTriggered();
}

function bool IsTriggeredOnUnitPostBeginPlay()
{
    return m_kTemplate.IsTriggeredOnUnitPostBeginPlay();
}

simulated function SetCurrentTarget(XGUnitNativeBase kTarget)
{
    local int Index;

    for (Index = 0; Index < arrTargetOptions.Length; Index++)
    {
        if (arrTargetOptions[Index].kTarget.kPrimaryTarget == kTarget)
        {
            m_iCurrentTargetIndex = Index;
            return;
        }
    }

    m_iCurrentTargetIndex = INDEX_NONE;
}

simulated function bool ShouldShowCritPercentage()
{
    `LWCE_LOG_NOT_IMPLEMENTED(ShouldShowCritPercentage);
    return true;
}

simulated function bool ShouldShowPercentage()
{
    `LWCE_LOG_NOT_IMPLEMENTED(ShouldShowPercentage);
    return true;
}

protected function LWCE_XGWeapon GetWeaponToUse()
{
    switch (m_kTemplate.UseWithWeaponSlot)
    {
        case eAWS_Primary:
            return LWCE_XGWeapon(m_kUnit.GetInventory().GetPrimaryWeapon());
        case eAWS_Secondary:
            return LWCE_XGWeapon(m_kUnit.GetInventory().GetSecondaryWeapon());
        case eAWS_Equipped:
            return LWCE_XGWeapon(m_kUnit.GetInventory().GetActiveWeapon());
        case eAWS_None:
            return none;
        case eAWS_Source:
            // In this case, we want to find the inventory item which gave this unit the ability
            // TODO
        default:
            return none;
    }
}