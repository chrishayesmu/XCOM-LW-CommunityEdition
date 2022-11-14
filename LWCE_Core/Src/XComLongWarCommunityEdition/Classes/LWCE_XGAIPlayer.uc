class LWCE_XGAIPlayer extends XGAIPlayer;

`include(generators.uci)

`LWCE_GENERATOR_XGPLAYER

simulated function CreateSquad(array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes)
{
    `LWCE_LOG_CLS("CreateSquad begin");
    super.CreateSquad(arrSpawnPoints, arrPawnTypes);
    `LWCE_LOG_CLS("CreateSquad end");
}

event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}

simulated function class<XGAIBehavior> AlienTypeToBehaviorClass(EPawnType eAlienType)
{
    switch (eAlienType)
    {
        case ePawnType_Sectoid:
            return class'LWCE_XGAIBehavior_Sectoid';
        case ePawnType_Sectoid_Commander:
            return class'LWCE_XGAIBehavior_SectoidCommander';
        case ePawnType_Floater:
            return class'LWCE_XGAIBehavior_Floater';
        case ePawnType_Floater_Heavy:
            return class'LWCE_XGAIBehavior_FloaterHeavy';
        case ePawnType_Muton:
            return class'LWCE_XGAIBehavior_Muton';
        case ePawnType_Muton_Elite:
            return class'LWCE_XGAIBehavior_MutonElite';
        case ePawnType_Muton_Berserker:
            return class'LWCE_XGAIBehavior_MutonBerserker';
        case ePawnType_ThinMan:
            return class'LWCE_XGAIBehavior_ThinMan';
        case ePawnType_Elder:
        case ePawnType_EtherealUber:
            return class'LWCE_XGAIBehavior_Elder';
        case ePawnType_CyberDisc:
            return class'LWCE_XGAIBehavior_Cyberdisc';
        case ePawnType_Chryssalid:
            return class'LWCE_XGAIBehavior_Chryssalid';
        case ePawnType_Sectopod:
            return class'LWCE_XGAIBehavior_Sectopod';
        case ePawnType_SectopodDrone:
            return class'LWCE_XGAIBehavior_SectopodDrone';
        case ePawnType_Zombie:
            return class'LWCE_XGAIBehavior_Zombie';
        case ePawnType_Mechtoid:
            return class'LWCE_XGAIBehavior_Mechtoid';
        case ePawnType_Outsider:
            return class'LWCE_XGAIBehavior';
        case ePawnType_ExaltOperative:
            return class'LWCE_XGAIBehavior_ExaltOperative';
        case ePawnType_ExaltSniper:
            return class'LWCE_XGAIBehavior_ExaltSniper';
        case ePawnType_ExaltHeavy:
            return class'LWCE_XGAIBehavior_ExaltHeavy';
        case ePawnType_ExaltMedic:
            return class'LWCE_XGAIBehavior_ExaltMedic';
        case ePawnType_ExaltEliteOperative:
            return class'LWCE_XGAIBehavior_ExaltEliteOperative';
        case ePawnType_ExaltEliteSniper:
            return class'LWCE_XGAIBehavior_ExaltEliteSniper';
        case ePawnType_ExaltEliteHeavy:
            return class'LWCE_XGAIBehavior_ExaltEliteHeavy';
        case ePawnType_ExaltEliteMedic:
            return class'LWCE_XGAIBehavior_ExaltEliteMedic';
        case ePawnType_Seeker:
            return class'LWCE_XGAIBehavior_Seeker';
        default:
            return class'LWCE_XGAIBehavior';
    }
}

simulated function bool IsHanging(string szDesc, optional float fHangLength = 15.0)
{
    local XGAction kAction;
    local XGAction_Fire kFireAction;
    local bool bMoving, bCloseCombat, bReactionFire, bSuppressionExecuting, bIsAnyoneMindMergeWhiplashDying, bMindControl;

    if (m_kActiveUnit != none)
    {
        kAction = m_kActiveUnit.GetAction();
        kFireAction = XGAction_Fire(m_kActiveUnit.GetAction());
        bMoving = m_kActiveUnit.IsMoving();
        bCloseCombat = (kAction != none) && kAction.IsA('XGAction_CloseCombat');
        bSuppressionExecuting = m_kActiveUnit.IsSuppressionExecuting();

        if (kFireAction != none && kFireAction.m_kShot != none)
        {
            bReactionFire = kFireAction.m_kShot.m_bReactionFire;
            bMindControl = kFireAction.m_kShot.iType == eAbility_PsiControl;
        }

        bIsAnyoneMindMergeWhiplashDying = m_kActiveUnit.GetSquad().IsAnyoneElse_CheckUnitDelegate(m_kActiveUnit.CheckUnitDelegate_IsMindMergeWhiplashDying, m_kActiveUnit);
    }

    if (XComTacticalController(GetALocalPlayerController()).m_bInCinematicMode || bMoving || bCloseCombat || bReactionFire || bSuppressionExecuting || bIsAnyoneMindMergeWhiplashDying || bMindControl)
    {
        ResetHangTimer();
    }
    else if (WorldInfo.TimeSeconds - fHangTimer > fHangLength)
    {
        if (m_kActiveUnit != none && GetNearestEnemy(m_kActiveUnit.GetLocation()) != none)
        {
            // These are left in because they're native and might have side effects we don't know about
            if (class'XComWorldData'.static.GetWorldData().HasPendingVisibilityUpdates())
            {
            }

            if (class'XComWorldData'.static.GetWorldData().IsRebuildingTiles())
            {
            }

            if (`BATTLE.m_kPodMgr.IsBusy())
            {
                `BATTLE.m_kPodMgr.ClearPodQueues();
            }

            if (m_kActiveUnit.GetAction().IsA('XGAction_Wait'))
            {
                m_kActiveUnit.GetAction().Abort();
            }

            m_kOvermindHandler.ClearImmediateManeuvers();

            return true;
        }

        // TODO: what to do if m_kActiveUnit == none? is that hanging or not?
        return true;
    }

    return false;
}

simulated function LoadInit()
{
    super.LoadInit();
}

function bool UpdateHealers()
{
    local XGUnit kUnit;

    m_arrHealer.Length = 0;

    foreach m_arrCachedSquad(kUnit)
    {
        if (kUnit.GetRemainingActions() == 0)
        {
            continue;
        }

        if (LWCE_XGInventory(kUnit.GetInventory()).LWCE_HasItemOfType('Item_Medikit') && kUnit.GetMediKitCharges() > 0)
        {
            m_arrHealer.AddItem(kUnit);
        }
    }

    return m_arrHealer.Length > 0;
}

simulated function UpdateWeaponTactics(XGInventory kInventory)
{
    local LWCE_XGInventory kCEInventory;

    kCEInventory = LWCE_XGInventory(kInventory);

    if (kCEInventory.LWCE_HasItemOfType('Item_RecoillessRifle') || kCEInventory.LWCE_HasItemOfType('Item_RocketLauncher'))
    {
        m_fMinTeammateDistance = 224.0;
    }
}

state ExecutingAI
{
    event PushedState()
    {
        super.PushedState();
    }

    event PoppedState()
    {
        super.PoppedState();
    }
}

auto simulated state Inactive
{
    simulated function BeginTurn()
    {
        super.BeginTurn();
    }

    simulated event Tick(float fDeltaT)
    {
        super.Tick(fDeltaT);
    }

    stop;
}