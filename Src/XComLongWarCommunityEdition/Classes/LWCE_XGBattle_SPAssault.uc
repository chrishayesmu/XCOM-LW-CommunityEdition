class LWCE_XGBattle_SPAssault extends XGBattle_SPAssault;

`include(generators.uci)

`LWCE_GENERATOR_XGBATTLE

function CollectLoot()
{
    local int Index;
    local string strMapName;
    local LWCE_XGBattleDesc kDesc;

    kDesc = LWCE_XGBattleDesc(m_kDesc);

    if (kDesc.m_eCouncilType == eFCM_ChryssalidHive)
    {
        return;
    }

    strMapName = `WORLDINFO.GetMapName();
    class'XComCollectible'.static.CollectCollectibles(m_kDesc.m_arrArtifacts);

    for (Index = 0; Index < m_kDesc.m_arrArtifacts.Length; Index++)
    {
        if (m_kDesc.m_arrArtifacts[Index] > 0)
        {
            kDesc.m_kArtifactsContainer.AdjustQuantity(Index, m_kDesc.m_arrArtifacts[Index]);
        }
    }

    kDesc.m_kArtifactsContainer.Set(`LW_ITEM_ID(Meld), GetRecoveredMeldAmount());

    if (strMapName == "DLC1_3_Gangplank")
    {
        // TODO move these amounts into config
        kDesc.m_kArtifactsContainer.AdjustQuantity(`LW_ITEM_ID(Elerium), 80);
        kDesc.m_kArtifactsContainer.AdjustQuantity(`LW_ITEM_ID(AlienAlloy), 80);
    }
}

function InitPlayers(optional bool bLoading = false)
{
    class'LWCE_XGBattle_Extensions'.static.InitPlayers(self, bLoading);
}