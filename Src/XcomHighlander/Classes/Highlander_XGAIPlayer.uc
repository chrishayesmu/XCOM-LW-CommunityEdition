class Highlander_XGAIPlayer extends XGAIPlayer;

simulated function LoadSquad(array<TTransferSoldier> Soldiers, array<int> arrTechHistory, array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes)
{
    `HL_LOG_CLS("LoadSquad: Soldiers.Length = " $ Soldiers.Length);

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

        if (Highlander_XGInventory(kUnit.GetInventory()).HL_HasItemOfType(`LW_ITEM_ID(Medikit)) && kUnit.GetMediKitCharges() > 0)
        {
            m_arrHealer.AddItem(kUnit);
        }
    }

    return m_arrHealer.Length > 0;
}

simulated function UpdateWeaponTactics(XGInventory kInventory)
{
    local Highlander_XGInventory kHLInventory;

    kHLInventory = Highlander_XGInventory(kInventory);

    if (kHLInventory.HL_HasItemOfType(`LW_ITEM_ID(RecoillessRifle)) || kHLInventory.HL_HasItemOfType(`LW_ITEM_ID(RocketLauncher)))
    {
        m_fMinTeammateDistance = 224.0;
    }
}

// IMPORTANT: This function is an override of a function in XGPlayer. Since we can't modify the inheritance hierarchy,
// this function has been inserted into each Highlander child class override of XGPlayer.
// ***If you modify this function, apply the changes in all child classes as well!***
function XGUnit SpawnUnit(class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
{
    local XGUnit kUnit;

    if (kUnitClassToSpawn == class'XGUnit')
    {
        kUnitClassToSpawn = class'Highlander_XGUnit';
    }

    kUnit = Spawn(kUnitClassToSpawn, kPlayerController,, kLocation, kRotation,,, m_eTeam);
    kUnit.SetBattleScanner(bBattleScanner);

    if (!kUnit.Init(self, kCharacter, kSquad, bDestroyOnBadLocation, bSnapToGround))
    {
        kUnit.Destroy();
        return none;
    }

    if (kSpawnPoint != none)
    {
        kSpawnPoint.m_kLastActorSpawned = kUnit;
    }

    if (kCharacter != none)
    {
        kCharacter.m_kUnit = kUnit;
    }

    return kUnit;
}