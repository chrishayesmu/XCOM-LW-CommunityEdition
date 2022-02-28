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
        kDesc.m_kArtifactsContainer.Set(`LW_ITEM_ID(EXALTIntelligence), 1);
    }

    class'XComCollectible'.static.CollectCollectibles(m_kDesc.m_arrArtifacts);

    for (Index = 0; Index < m_kDesc.m_arrArtifacts.Length; Index++)
    {
        if (m_kDesc.m_arrArtifacts[Index] > 0)
        {
            kDesc.m_kArtifactsContainer.AdjustQuantity(Index, m_kDesc.m_arrArtifacts[Index]);
        }
    }

    kDesc.m_kArtifactsContainer.Set(`LW_ITEM_ID(Meld), GetRecoveredMeldAmount());
}

function SpawnCovertOperative()
{
    local XGPlayer kPlayer;
    local XComSpawnPoint kSpawnPoint;
    local TTransferSoldier kTransferSoldier;
    local XGCharacter_Soldier kChar;
    local XGUnit kSoldier;
    local bool bGeneMod;

    kSpawnPoint = ChooseCovertOperativeSpawnPoint();

    if (kSpawnPoint == none)
    {
        return;
    }

    kPlayer = GetHumanPlayer();

    if (kPlayer == none)
    {
        return;
    }

    if (m_kTransferSave != none)
    {
        kTransferSoldier = m_kTransferSave.m_kBattleDesc.m_kDropShipCargoInfo.m_kCovertOperative;
    }
    else
    {
        kTransferSoldier = CreateDebugCovertOperative(kPlayer.GetSquad().GetMemberAt(0));
    }

    ForceCovertOperativeLoadout(kTransferSoldier);

    kChar = Spawn(class'XGCharacter_Soldier');
    kChar.SetTSoldier(kTransferSoldier.kSoldier);
    kChar.SetTCharacter(kTransferSoldier.kChar);

    bGeneMod = class'XComPerkManager'.static.HasAnyGeneMod(kTransferSoldier.kChar.aUpgrades);
    kChar.m_eType = EPawnType(class'XGBattleDesc'.static.MapSoldierToPawn(kTransferSoldier.kChar.kInventory.iArmor, kTransferSoldier.kSoldier.kAppearance.iGender, bGeneMod));

    kSoldier = kPlayer.SpawnUnit(class'XGUnit', kPlayer.m_kPlayerController, kSpawnPoint.Location, kSpawnPoint.Rotation, kChar, kPlayer.GetSquad(),, kSpawnPoint);
    kSoldier.m_iUnitLoadoutID = kTransferSoldier.iUnitLoadoutID;
    kSoldier.AddStatModifiers(kTransferSoldier.aStatModifiers);

    XComHumanPawn(kSoldier.GetPawn()).SetAppearance(kChar.m_kSoldier.kAppearance);
    class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kSoldier);
    kSoldier.UpdateItemCharges();

    m_kCovertOperative = kSoldier;
}