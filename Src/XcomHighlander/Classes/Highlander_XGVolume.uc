class Highlander_XGVolume extends XGVolume;

function OnUnitLeft(XGUnit kUnit)
{
    local int iEffect;
    local XGBattle kBattle;

    kBattle = `BATTLE;

    for (iEffect = 0; iEffect < 9; iEffect++)
    {
        if (!HasEffect(EVolumeEffect(iEffect)))
        {
            continue;
        }

        switch (iEffect)
        {
            case eVolumeEffect_BlocksSight:
                kUnit.LeaveSightBlockingVolume(self);
                break;
            case eVolumeEffect_TelekineticField:
                kUnit.OnLeaveTelekineticField(self);
                break;
            case eVolumeEffect_Rift:
                kUnit.OnLeaveRift(self);
                break;
            default:
                break;
        }

        if (GetType() == eVolume_Smoke)
        {
            if (m_kInstigator.GetCharacter().HasUpgrade(52))
            {
                kUnit.m_bInDenseSmoke = false;
                kUnit.RemoveBonus(52);
            }

            kUnit.m_bInSmokeBomb = false;
            kUnit.RemoveBonus(44);
        }
        else if (GetType() == eVolume_CombatDrugs)
        {
            if (!`GAMECORE.CharacterHasProperty(kUnit.GetCharacter().m_kChar.iType, eCP_Robotic))
            {
                kUnit.m_bInCombatDrugs = false;
                kUnit.RemoveBonus(51);
            }

            kUnit.m_bInSmokeBomb = false;
            kUnit.RemoveBonus(44);
        }

        kUnit.RemoveVolume(self);
        RemoveUnit(kUnit);
    }

    // Highlander issue #2: due to XGUnit.m_bInCombatDrugs and XGUnit.m_bInSmokeBomb being boolean variables, a unit which is in multiple smoke
    // volumes at once will lose all of them whenever one effect is lost (either due to expiring over time, or the unit moving out of one volume
    // but not the other). This fix simply checks for overlapping smoke volumes and reapplies their benefits if any exist.
    if (GetType() == eVolume_Smoke || GetType() == eVolume_CombatDrugs)
    {
        for (iEffect = 0; iEffect < kBattle.m_kVolumeMgr.m_iNumVolumes; iEffect++)
        {
            if (kBattle.m_kVolumeMgr.m_aVolumes[iEffect] == self)
            {
                continue;
            }

            if (kBattle.m_kVolumeMgr.m_aVolumes[iEffect].GetType() != eVolume_Smoke
            &&  kBattle.m_kVolumeMgr.m_aVolumes[iEffect].GetType() != eVolume_CombatDrugs)
            {
                continue;
            }

            if (kBattle.m_kVolumeMgr.m_aVolumes[iEffect].HasUnitEntered(kUnit))
            {
                kUnit.m_bInSmokeBomb = true;
                kUnit.AddBonus(44);

                if (kBattle.m_kVolumeMgr.m_aVolumes[iEffect].GetType() == eVolume_Smoke && kBattle.m_kVolumeMgr.m_aVolumes[iEffect].m_kInstigator.GetCharacter().HasUpgrade(52))
                {
                    kUnit.m_bInDenseSmoke = true;
                    kUnit.AddBonus(52);
                }
                else if (kBattle.m_kVolumeMgr.m_aVolumes[iEffect].GetType() == eVolume_CombatDrugs && !`GAMECORE.CharacterHasProperty(kUnit.GetCharacter().m_kChar.iType, eCP_Robotic))
                {
                    kUnit.m_bInCombatDrugs = true;
                    kUnit.AddBonus(51);
                }

                kUnit.UpdateCoverBonuses(none);
            }
        }
    }
}