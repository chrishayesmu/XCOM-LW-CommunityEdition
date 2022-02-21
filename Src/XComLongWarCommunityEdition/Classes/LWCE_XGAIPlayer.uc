class LWCE_XGAIPlayer extends XGAIPlayer;

simulated function LoadSquad(array<TTransferSoldier> Soldiers, array<int> arrTechHistory, array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes)
{
    `LWCE_LOG_CLS("LoadSquad: Soldiers.Length = " $ Soldiers.Length);

    m_arrTechHistory.Add(61);
    CreateSquad(arrSpawnPoints, arrPawnTypes);
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

        if (LWCE_XGInventory(kUnit.GetInventory()).LWCE_HasItemOfType(`LW_ITEM_ID(Medikit)) && kUnit.GetMediKitCharges() > 0)
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

    if (kCEInventory.LWCE_HasItemOfType(`LW_ITEM_ID(RecoillessRifle)) || kCEInventory.LWCE_HasItemOfType(`LW_ITEM_ID(RocketLauncher)))
    {
        m_fMinTeammateDistance = 224.0;
    }
}

static simulated function class<XGCharacter> Unused_AlienTypeToClass(EPawnType eAlienType)
{
    return class'LWCE_XGPlayer_Extensions'.static.AlienTypeToClass(eAlienType);
}

function XGUnit SpawnUnit(class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
{
    return class'LWCE_XGPlayer_Extensions'.static.SpawnUnit(self, kUnitClassToSpawn, kPlayerController, kLocation, kRotation, kCharacter, kSquad, bDestroyOnBadLocation, kSpawnPoint, bSnapToGround, bBattleScanner);
}