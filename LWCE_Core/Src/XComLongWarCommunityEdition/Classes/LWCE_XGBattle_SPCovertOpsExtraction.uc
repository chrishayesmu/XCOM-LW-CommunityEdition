class LWCE_XGBattle_SPCovertOpsExtraction extends XGBattle_SPCovertOpsExtraction;

`include(generators.uci)

`LWCE_GENERATOR_XGBATTLE

function CollectLoot()
{
    local int Index;
    local LWCE_XGBattleDesc kDesc;

    kDesc = LWCE_XGBattleDesc(m_kDesc);
    kDesc.m_kDropShipCargoInfo.m_kReward.iCredits += m_iCovertOpsCashRewardAmount;

    if (ShouldAwardIntel())
    {
        kDesc.m_kArtifactsContainer.Set('Item_EXALTIntelligence', 1);
    }

    class'XComCollectible'.static.CollectCollectibles(m_kDesc.m_arrArtifacts);

    for (Index = 0; Index < m_kDesc.m_arrArtifacts.Length; Index++)
    {
        if (m_kDesc.m_arrArtifacts[Index] > 0)
        {
            kDesc.m_kArtifactsContainer.AdjustQuantity(class'LWCE_XGItemTree'.static.ItemNameFromBaseID(Index), m_kDesc.m_arrArtifacts[Index]);
        }
    }

    kDesc.m_kArtifactsContainer.AdjustQuantity('Item_Meld', GetRecoveredMeldAmount());
}

function InitPlayers(optional bool bLoading = false)
{
    class'LWCE_XGBattle_Extensions'.static.InitPlayers(self, bLoading);

    if (!bLoading)
    {
        SpawnCovertOperative();
    }
}

function SpawnCovertOperative()
{
    class'LWCE_XGBattle_Extensions'.static.SpawnCovertOperative(self);
}