class LWCE_UITargetingReticle extends UITargetingReticle;

simulated function UpdateLocation()
{
    `LWCE_LOG_CLS("UpdateLocation: m_kTargetedUnit = " $ m_kTargetedUnit);

    super.UpdateLocation();
}

simulated function UpdateShotData()
{
    local XGAction_Targeting kTargetingAction;
    local LWCE_XGAbility kCEAbility;
    local int iHitChance, iCriticalChance;
    local bool bShotBlocked;

    `LWCE_LOG_CLS("UpdateShotData called");
    ScriptTrace();

    kTargetingAction = XGAction_Targeting(XComTacticalController(controllerRef).GetActiveUnit().GetAction());
    m_bUpdateShotWithLoc = false;

    if (kTargetingAction != none && kTargetingAction.m_kShot != none)
    {
        kCEAbility = LWCE_XGAbility(kTargetingAction.m_kShot);

        if (!kTargetingAction.m_kShot.ShouldShowPercentage())
        {
            SetAimPercentages(-1.0, -1.0);

            if (kTargetingAction.m_kShot.IsA('XGAbility_Rift') || kTargetingAction.m_kShot.m_kWeapon != none && kTargetingAction.m_kShot.m_kWeapon.GameplayType() == 97)
            {
                m_bUpdateShotWithLoc = true;
            }

            bShotBlocked = kTargetingAction.IsShotBlocked();

            if (bShotBlocked != m_bShotIsBlocked)
            {
                m_bShotIsBlocked = bShotBlocked;
                SetCursorMessage(m_bShotIsBlocked ? m_strShotIsBlocked : "");
            }
        }
        else
        {
            kTargetingAction.GetUIHitChance(iHitChance, iCriticalChance);

            if (kTargetingAction.m_kShot.HasProperty(46))
            {
                iHitChance = (10 * iHitChance) + 100;
            }

            SetAimPercentages(float(iHitChance) / 100.0, float(iCriticalChance) / 100.0);

            if (kTargetingAction.m_kShot.HasProperty(46))
            {
                m_bUpdateShotWithLoc = true;
            }

            bShotBlocked = kTargetingAction.IsShotBlocked();

            if (bShotBlocked != m_bShotIsBlocked)
            {
                m_bShotIsBlocked = bShotBlocked;
                SetCursorMessage(((m_bShotIsBlocked) ? m_strShotIsBlocked : ""));
            }
        }

        if (kCEAbility != none)
        {
            SetDisabled(kCEAbility.LWCE_CheckAvailable() != 'AA_Success');
        }
        else
        {
            SetDisabled(!kTargetingAction.m_kShot.CheckAvailable());
        }

        SetLockedOn(kTargetingAction.GetTargetPawn() != none);
    }
    else
    {
        SetAimPercentages(-1.0, -1.0);
        SetDisabled(false);
        SetLockedOn(false);
        SetAimPercentages(-1.0, -1.0);

        if (manager == none)
        {
        }
        else
        {
            SetLoc(float(manager.UIMGR_RES_X / 2), float(manager.UIMGR_RES_Y / 2));
        }
    }
}