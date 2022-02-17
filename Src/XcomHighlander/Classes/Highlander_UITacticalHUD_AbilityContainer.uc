class Highlander_UITacticalHUD_AbilityContainer extends UITacticalHUD_AbilityContainer;

simulated function BuildAbilities(XGUnit kUnit)
{
    local int I, forceAbilitySlot, Len;
    local XGAbility kAbility;
    local XGAction_Targeting kTargetingAction;
    local XGWeapon kActiveWeapon;

    `HL_LOG_CLS("BuildAbilities");

    forceAbilitySlot = 0;

    if (UITacticalHUD(screen).IsMenuRaised())
    {
        `HL_LOG_CLS("Menu raised");

        kTargetingAction = XGAction_Targeting(kUnit.GetAction());

        if (kTargetingAction == none && WorldInfo.NetMode != NM_Standalone)
        {
            return;
        }
    }

    m_arrAbilities.Length = 0;
    Len = kUnit.GetNumAbilities();
    `HL_LOG_CLS("Unit has " $ Len $ " abilities");

    for (I = 0; I < Len; I++)
    {
        kAbility = kUnit.GetAbility(I);

        if (kAbility == none)
        {
            `HL_LOG_CLS("Ability " $ I $ " is none");
            continue;
        }

        if (AlreadyHaveThisAbilityType(m_arrAbilities, kAbility, (kTargetingAction != none ? kTargetingAction.m_kTargetedEnemy : none)))
        {
            `HL_LOG_CLS("Already have ability " $ kAbility);
            continue;
        }

        if (!kAbility.ShowAbility())
        {
            `HL_LOG_CLS("ShowAbility is false for ability " $ kAbility);
            continue;
        }

        if (kAbility.GetType() == eAbility_Reload && !class'Engine'.static.IsSonOfFacemelt())
        {
            kActiveWeapon = kUnit.GetInventory().GetActiveWeapon();

            if (kActiveWeapon != none && kActiveWeapon.iAmmo <= 0)
            {
                m_arrAbilities.InsertItem(0, kAbility);
                ++forceAbilitySlot;
            }
            else
            {
                m_arrAbilities.AddItem(kAbility);
            }
        }
        else if (kAbility.GetType() == eAbility_ShotStandard)
        {
            if (kUnit.IsMeleeOnly())
            {
                kAbility.strName = m_strMeleeAttackName;
            }

            m_arrAbilities.InsertItem(forceAbilitySlot, kAbility);
            ++forceAbilitySlot;
        }
        else
        {
            m_arrAbilities.AddItem(kAbility);
        }
    }

    `HL_LOG_CLS("After loop: m_arrAbilities.Length = " $ m_arrAbilities.Length);

    PopulateFlash(kUnit);

    if (UITacticalHUD(screen).IsMenuRaised() && m_arrAbilities.Length > 0)
    {
        if (m_iMouseTargetedAbilityIndex > -1)
        {
            SetAbilityByIndex(m_iMouseTargetedAbilityIndex);
        }
        else if (m_iCurrentIndex < 0)
        {
            SetAbilityByIndex(0);
        }
        else
        {
            SetAbilityByIndex(m_iCurrentIndex);
        }
    }
    else
    {
        m_iCurrentIndex = -1;
    }

    UpdateWatchVariables();
    CheckForHelpMessages();
}