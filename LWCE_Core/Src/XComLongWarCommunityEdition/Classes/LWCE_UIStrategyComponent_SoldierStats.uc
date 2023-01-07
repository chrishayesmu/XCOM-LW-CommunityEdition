class LWCE_UIStrategyComponent_SoldierStats extends UIStrategyComponent_SoldierStats;

function UpdateData()
{
    local LWCE_TSoldier kChar;
    local string Health;

    kChar = LWCE_XGStrategySoldier(m_kLocalMgr.m_kSoldier).m_kCESoldier;

    Health = m_kLocalMgr.m_kHeader.txtHP.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtHPMod.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtSpeed.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtSpeedMod.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtWill.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtWillMod.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtOffense.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtOffenseMod.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtDefense.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtDefenseMod.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtStrength.StrValue;
    Health $= "|" $ m_kLocalMgr.m_kHeader.txtCritShot.StrValue;
    Health $= "|" $ kChar.iXP;

    if (!m_kLocalMgr.m_kSoldier.IsATank())
    {
        if (m_kLocalMgr.m_kSoldier.GetRank() < 7)
        {
            Health $= "|" $ (m_kLocalMgr.m_kSoldier.TACTICAL().GetXPRequired(m_kLocalMgr.m_kSoldier.GetRank() + 1));
        }
        else
        {
            Health $= "|0";
        }
    }
    else
    {
        Health $= "|-1";
    }

    Health $= "|" $ kChar.iPsiXP;

    if (LWCE_XGFacility_Labs(m_kLocalMgr.LABS()).LWCE_IsResearched('Tech_Xenopsionics') && !m_kLocalMgr.m_kSoldier.IsATank() && !m_kLocalMgr.m_kSoldier.IsAugmented() && !m_kLocalMgr.m_kSoldier.HasPerk(ePerk_GeneMod_BrainDamping))
    {
        if (m_kLocalMgr.m_kSoldier.GetPsiRank() < 6)
        {
            Health $= "|" $ (m_kLocalMgr.m_kSoldier.TACTICAL().GetPsiXPRequired(m_kLocalMgr.m_kSoldier.GetPsiRank() + 1));
        }
        else
        {
            Health $= "|0";
        }
    }
    else
    {
        Health $= "|-1";
    }

    AS_SetSoldierStats(Health, "", "", "");
}