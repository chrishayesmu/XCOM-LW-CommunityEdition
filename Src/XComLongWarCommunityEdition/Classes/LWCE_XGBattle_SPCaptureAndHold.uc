class LWCE_XGBattle_SPCaptureAndHold extends XGBattle_SPCaptureAndHold;

`include(generators.uci)

`LWCE_GENERATOR_XGBATTLE

function CollectLoot()
{
    local int Index;
    local LWCE_XGBattleDesc kDesc;
    local XComCapturePointVolume kCapturePoint;

    kDesc = LWCE_XGBattleDesc(m_kDesc);
    kDesc.m_kDropShipCargoInfo.m_bAllPointsHeld = false;

    class'XComCollectible'.static.CollectCollectibles(m_kDesc.m_arrArtifacts);

    for (Index = 0; Index < m_kDesc.m_arrArtifacts.Length; Index++)
    {
        if (m_kDesc.m_arrArtifacts[Index] > 0)
        {
            kDesc.m_kArtifactsContainer.AdjustQuantity(Index, m_kDesc.m_arrArtifacts[Index]);
        }
    }

    kDesc.m_kArtifactsContainer.Set(`LW_ITEM_ID(Meld), GetRecoveredMeldAmount());

    foreach m_arrCapturePoints(kCapturePoint)
    {
        if (kCapturePoint.m_iCaptureSequenceIndex == 0 && kCapturePoint.IsActive())
        {
            m_kDesc.m_kDropShipCargoInfo.m_kReward.iCredits += m_iAllPointsSafeCashRewardAmount;
            m_kDesc.m_kDropShipCargoInfo.m_bAllPointsHeld = true;
        }
    }
}

function InitPlayers(optional bool bLoading = false)
{
    local XComCapturePointVolume kCapturePoint;

    class'LWCE_XGBattle_Extensions'.static.InitPlayers(self, bLoading);

    foreach AllActors(class'XComCapturePointVolume', kCapturePoint)
    {
        m_arrCapturePoints.AddItem(kCapturePoint);
    }
}