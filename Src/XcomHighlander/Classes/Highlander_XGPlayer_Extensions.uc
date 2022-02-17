class Highlander_XGPlayer_Extensions extends Object;

static simulated function class<XGCharacter> AlienTypeToClass(EPawnType eAlienType)
{
    switch (eAlienType)
    {
        case ePawnType_Sectoid:
            return class'Highlander_XGCharacter_Sectoid';
        case ePawnType_Sectoid_Commander:
            return class'Highlander_XGCharacter_Sectoid_Commander';
        case ePawnType_Floater:
            return class'Highlander_XGCharacter_Floater';
        case ePawnType_Floater_Heavy:
            return class'Highlander_XGCharacter_Floater_Heavy';
        case ePawnType_Muton:
            return class'Highlander_XGCharacter_Muton';
        case ePawnType_Muton_Elite:
            return class'Highlander_XGCharacter_Muton_Elite';
        case ePawnType_Muton_Berserker:
            return class'Highlander_XGCharacter_Muton_Berserker';
        case ePawnType_Chryssalid:
            return class'Highlander_XGCharacter_Chryssalid';
        case ePawnType_Sectopod:
            return class'Highlander_XGCharacter_Sectopod';
        case ePawnType_Cyberdisc:
            return class'Highlander_XGCharacter_Cyberdisc';
        case ePawnType_ThinMan:
            return class'Highlander_XGCharacter_ThinMan';
        case ePawnType_Elder:
            return class'Highlander_XGCharacter_Elder';
        case ePawnType_EtherealUber:
            return class'Highlander_XGCharacter_EtherealUber';
        case ePawnType_SectopodDrone:
            return class'Highlander_XGCharacter_SectopodDrone';
        case ePawnType_Zombie:
            return class'Highlander_XGCharacter_Zombie';
        case ePawnType_Outsider:
            return class'Highlander_XGCharacter_Outsider';
        case ePawnType_BattleScanner:
            return class'Highlander_XGCharacter_BattleScanner';
        case ePawnType_Mechtoid:
            return class'Highlander_XGCharacter_Mechtoid';
        case ePawnType_Seeker:
            return class'Highlander_XGCharacter_Seeker';
        case ePawnType_ExaltOperative:
            return class'Highlander_XGCharacter_ExaltOperative';
        case ePawnType_ExaltSniper:
            return class'Highlander_XGCharacter_ExaltSniper';
        case ePawnType_ExaltHeavy:
            return class'Highlander_XGCharacter_ExaltHeavy';
        case ePawnType_ExaltMedic:
            return class'Highlander_XGCharacter_ExaltMedic';
        case ePawnType_ExaltEliteOperative:
            return class'Highlander_XGCharacter_ExaltEliteOperative';
        case ePawnType_ExaltEliteSniper:
            return class'Highlander_XGCharacter_ExaltEliteSniper';
        case ePawnType_ExaltEliteHeavy:
            return class'Highlander_XGCharacter_ExaltEliteHeavy';
        case ePawnType_ExaltEliteMedic:
            return class'Highlander_XGCharacter_ExaltEliteMedic';
        default:
            return class'Highlander_XGCharacter_Sectoid';
    }
}

static function XGUnit SpawnUnit(XGPlayer kPlayer, class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
{
    local XGUnit kUnit;

    if (kUnitClassToSpawn == class'XGUnit')
    {
        kUnitClassToSpawn = class'Highlander_XGUnit';
    }

    kUnit = kPlayer.Spawn(kUnitClassToSpawn, kPlayerController,, kLocation, kRotation,,, kPlayer.m_eTeam);
    kUnit.SetBattleScanner(bBattleScanner);

    if (!kUnit.Init(kPlayer, kCharacter, kSquad, bDestroyOnBadLocation, bSnapToGround))
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