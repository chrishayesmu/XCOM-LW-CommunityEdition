class LWCE_XGPlayer_Extensions extends Object;

static simulated function class<XGCharacter> AlienTypeToClass(EPawnType eAlienType)
{
    switch (eAlienType)
    {
        case ePawnType_Sectoid:
            return class'LWCE_XGCharacter_Sectoid';
        case ePawnType_Sectoid_Commander:
            return class'LWCE_XGCharacter_Sectoid_Commander';
        case ePawnType_Floater:
            return class'LWCE_XGCharacter_Floater';
        case ePawnType_Floater_Heavy:
            return class'LWCE_XGCharacter_Floater_Heavy';
        case ePawnType_Muton:
            return class'LWCE_XGCharacter_Muton';
        case ePawnType_Muton_Elite:
            return class'LWCE_XGCharacter_Muton_Elite';
        case ePawnType_Muton_Berserker:
            return class'LWCE_XGCharacter_Muton_Berserker';
        case ePawnType_Chryssalid:
            return class'LWCE_XGCharacter_Chryssalid';
        case ePawnType_Sectopod:
            return class'LWCE_XGCharacter_Sectopod';
        case ePawnType_Cyberdisc:
            return class'LWCE_XGCharacter_Cyberdisc';
        case ePawnType_ThinMan:
            return class'LWCE_XGCharacter_ThinMan';
        case ePawnType_Elder:
            return class'LWCE_XGCharacter_Elder';
        case ePawnType_EtherealUber:
            return class'LWCE_XGCharacter_EtherealUber';
        case ePawnType_SectopodDrone:
            return class'LWCE_XGCharacter_SectopodDrone';
        case ePawnType_Zombie:
            return class'LWCE_XGCharacter_Zombie';
        case ePawnType_Outsider:
            return class'LWCE_XGCharacter_Outsider';
        case ePawnType_BattleScanner:
            return class'LWCE_XGCharacter_BattleScanner';
        case ePawnType_Mechtoid:
            return class'LWCE_XGCharacter_Mechtoid';
        case ePawnType_Seeker:
            return class'LWCE_XGCharacter_Seeker';
        case ePawnType_ExaltOperative:
            return class'LWCE_XGCharacter_ExaltOperative';
        case ePawnType_ExaltSniper:
            return class'LWCE_XGCharacter_ExaltSniper';
        case ePawnType_ExaltHeavy:
            return class'LWCE_XGCharacter_ExaltHeavy';
        case ePawnType_ExaltMedic:
            return class'LWCE_XGCharacter_ExaltMedic';
        case ePawnType_ExaltEliteOperative:
            return class'LWCE_XGCharacter_ExaltEliteOperative';
        case ePawnType_ExaltEliteSniper:
            return class'LWCE_XGCharacter_ExaltEliteSniper';
        case ePawnType_ExaltEliteHeavy:
            return class'LWCE_XGCharacter_ExaltEliteHeavy';
        case ePawnType_ExaltEliteMedic:
            return class'LWCE_XGCharacter_ExaltEliteMedic';
        default:
            return class'LWCE_XGCharacter_Sectoid';
    }
}

static function XGUnit SpawnUnit(XGPlayer kPlayer, class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
{
    local XGUnit kUnit;

    if (kUnitClassToSpawn == class'XGUnit')
    {
        kUnitClassToSpawn = class'LWCE_XGUnit';
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