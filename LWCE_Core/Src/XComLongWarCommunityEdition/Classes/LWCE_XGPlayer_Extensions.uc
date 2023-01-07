class LWCE_XGPlayer_Extensions extends Object
    abstract;

static simulated function class<XGCharacter> AlienTypeToClass(EPawnType eAlienType)
{
    // Currently unused; using it will break character models
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

static function XGUnit GetNearestEnemy(XGPlayer kSelf, Vector vPoint, optional out float fClosestDist, optional bool bUseVisibleList = false, optional bool bConsiderCiviliansEnemies = false)
{
    local XGSquad kEnemySquad;
    local XGUnit kEnemy, kClosest;
    local float fDist;

    kEnemySquad = `BATTLE.GetEnemySquad(kSelf);
    kEnemy = kEnemySquad.GetNextGoodMember(kEnemy,, false);
    fClosestDist = -1.0;

    while (kEnemy != none)
    {
        if (!class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kEnemy))
        {
            fDist = VSizeSq(kEnemy.GetLocation() - vPoint);

            if (kClosest == none || fDist < fClosestDist)
            {
                kClosest = kEnemy;
                fClosestDist = fDist;
            }
        }

        kEnemy = kEnemySquad.GetNextGoodMember(kEnemy,, false);
    }

    return kClosest;
}

static function LoadSquad(XGPlayer kSelf, array<TTransferSoldier> Soldiers, array<LWCE_TTransferSoldier> ceSoldiers, array<int> arrTechHistory, array<XComSpawnPoint> arrSpawnPoints, array<EPawnType> arrPawnTypes)
{
    if (LWCE_XGPlayer(kSelf) != none)
    {
        LWCE_XGPlayer(kSelf).LWCE_LoadSquad(Soldiers, ceSoldiers, arrSpawnPoints, arrPawnTypes);
    }
    else
    {
        // Other player types ultimately just delegate to this
        kSelf.CreateSquad(arrSpawnPoints, arrPawnTypes);
    }

    `LWCE_LOG_CLS("LoadSquad end");
}

static function XGUnit SpawnAlien(XGPlayer kSelf, EPawnType eAlienType, XComSpawnPoint_Alien kSpawnPt, optional bool bSnapToCover = false, optional bool bSnapToGround = true, optional bool bAddFlag = true, optional bool bUseAltWeapon = false, optional bool bBattleScanner = false)
{
    local XGCharacter kChar;
    local LWCE_XGUnit kAlien;
    local Vector vLoc, HitLocation, HitNormal;

    if (eAlienType == ePawnType_None)
    {
        eAlienType = ePawnType_Sectoid;
    }

    kChar = kSelf.Spawn(AlienTypeToClass(eAlienType));

    if (bSnapToGround)
    {
        if (kSelf.Trace(HitLocation, HitNormal, kSpawnPt.GetSpawnPointLocation() + vect(0.0, 0.0, -128.0), kSpawnPt.GetSpawnPointLocation(), false) != none)
        {
            vLoc = HitLocation + vect(0.0, 0.0, 32.0);
        }
        else
        {
            vLoc = kSpawnPt.GetSpawnPointLocation() + vect(0.0, 0.0, 32.0);
        }
    }
    else
    {
        vLoc = kSpawnPt.GetSpawnPointLocation();
    }

    kAlien = LWCE_XGUnit(kSelf.SpawnUnit(class'XGUnit', kSelf.m_kPlayerController, vLoc, kSpawnPt.Rotation, kChar, kSelf.m_kSquad, /* bDestroyOnBadLocation */ true, kSpawnPt, bSnapToGround, bBattleScanner));

    if (kAlien == none)
    {
        vLoc = XComTacticalGRI(kSelf.WorldInfo.GRI).GetClosestValidLocation(kSpawnPt.GetSpawnPointLocation(), none,, false);
        kAlien = LWCE_XGUnit(kSelf.SpawnUnit(class'XGUnit', kSelf.m_kPlayerController, vLoc, kSpawnPt.Rotation, kChar, kSelf.m_kSquad, /* bDestroyOnBadLocation */ true, kSpawnPt));
    }

    if (kAlien != none)
    {
        kAlien.SetDiscState(eDS_Bad);
        class'LWCE_XGLoadoutMgr'.static.EquipUnit(kAlien, class'XGLoadoutMgr'.static.GetLoadoutTemplateFromCharacter(ECharacter(kAlien.GetCharType()), bUseAltWeapon));
        kAlien.UpdateItemCharges();

        if (!bBattleScanner)
        {
            kAlien.GetPawn().MovementNode.SetActiveChild(1, 0.10);
        }

        if (bAddFlag && `PRES.m_kUnitFlagManager != none)
        {
            `PRES.m_kUnitFlagManager.AddFlag(kAlien);
        }

        if (eAlienType != ePawnType_BattleScanner)
        {
            class'XComWorldData'.static.GetWorldData().SetTileBlockedByUnitFlag(kAlien);
        }
    }

    `LWCE_LOG_CLS("SpawnAlien: end");

    return kAlien;
}

static function XGUnit SpawnUnit(XGPlayer kSelf, class<XGUnit> kUnitClassToSpawn, PlayerController kPlayerController, Vector kLocation, Rotator kRotation, XGCharacter kCharacter, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional XComSpawnPoint kSpawnPoint, optional bool bSnapToGround = true, optional bool bBattleScanner = false)
{
    local XGUnit kUnit;

    if (kUnitClassToSpawn == class'XGUnit')
    {
        kUnitClassToSpawn = class'LWCE_XGUnit';
    }

    kUnit = kSelf.Spawn(kUnitClassToSpawn, kPlayerController,, kLocation, kRotation,,, kSelf.m_eTeam);
    kUnit.SetBattleScanner(bBattleScanner);

    if (!kUnit.Init(kSelf, kCharacter, kSquad, bDestroyOnBadLocation, bSnapToGround))
    {
        `LWCE_LOG_CLS("Could not init unit " $ kUnit $ " belonging to character " $ kCharacter);
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

    `LWCE_MOD_LOADER.OnUnitSpawned(kUnit);

    return kUnit;
}