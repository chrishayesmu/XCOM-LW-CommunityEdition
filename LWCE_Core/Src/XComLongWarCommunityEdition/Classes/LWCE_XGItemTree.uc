class LWCE_XGItemTree extends XGItemTree
    dependson(LWCETypes)
    config(LWCEBaseStrategyGame);

var private LWCEItemTemplateManager m_kItemTemplateMgr;

/// <summary>
/// Maps from an item's name to its ID in the base game. This is very slow and done only where
/// absolutely necessary. Mods should avoid using this method.
/// </summary>
static function EItemType BaseIDFromItemName(name ItemName)
{
    local int Index;

    for (Index = 1; Index < 255; Index++)
    {
        if (ItemNameFromBaseID(Index) == ItemName)
        {
            return EItemType(Index);
        }
    }

    return eItem_None;
}

/// <summary>
/// Maps to an item's name from its ID in the base game. Mods should generally avoid using
/// this as much as possible, and stick to names only.
/// </summary>
static function name ItemNameFromBaseID(int iItemId)
{
    switch (iItemId)
    {
        case 1:
            return 'Item_ScatterBlaster';
        case 2:
            return 'Item_Pistol';
        case 3:
            return 'Item_GaussRifle';
        case 4:
            return 'Item_Shotgun';
        case 5:
            return 'Item_GaussAutorifle';
        case 6:
            return 'Item_GaussLongRifle';
        case 7:
            return 'Item_RecoillessRifle';
        case 8:
            return 'Item_LaserPistol';
        case 9:
            return 'Item_PulseRifle';
        case 10:
            return 'Item_ScatterLaser';
        case 11:
            return 'Item_PulseAutoblaster';
        case 12:
            return 'Item_PulseSniperRifle';
        case 13:
            return 'Item_PlasmaPistol';
        case 14:
            return 'Item_PlasmaCarbine';
        case 15:
            return 'Item_PlasmaRifle';
        case 16:
            return 'Item_AlloyCannon';
        case 17:
            return 'Item_PlasmaNovagun';
        case 18:
            return 'Item_PlasmaSniperRifle';
        case 19:
            return 'Item_BlasterLauncher';
        case 20:
            return 'Item_MechtoidCannon';
        case 21:
            return 'Item_AlienPistol_Seeker';
        case 22:
            return 'Item_KineticStrikeModule';
        case 23:
            return 'Item_Flamethrower';
        case 24:
            return 'Item_GrenadeLauncher';
        case 25:
            return 'Item_RestorativeMist';
        case 26:
            return 'Item_ElectroPulse';
        case 27:
            return 'Item_ProximityMineLauncher';
        case 28:
            return 'Item_Minigun';
        case 29:
            return 'Item_LaserLance';
        case 30:
            return 'Item_ParticleCannon';
        case 31:
            return 'Item_AlloyJacketedRounds';
        case 32:
            return 'Item_AssaultCarbine';
        case 33:
            return 'Item_SectopodTurret';
        case 34:
            return 'Item_MarksmansScope';
        case 35:
            return 'Item_ChryssalidClaw';
        case 36:
            return 'Item_DroneBeam';
        case 37:
            return 'Item_PsiAmp';
        case 38:
            return 'Item_Grapple';
        case 39:
            return 'Item_CyberdiscCannon';
        case 40:
            return 'Item_EnhancedBeamOptics';
        case 41:
            return 'Item_AlienPistol';
        case 42:
            return 'Item_AlienCarbine';
        case 43:
            return 'Item_AlienCarbine_Floater';
        case 44:
            return 'Item_AlienCarbine_Muton';
        case 45:
            return 'Item_AlienRifle';
        case 46:
            return 'Item_AlienRifle_HeavyFloater';
        case 47:
            return 'Item_AlienHeavyWeapon';
        case 48:
            return 'Item_PlasmaStellerator';
        case 49:
            return 'Item_ZombieFist';
        case 50:
            return 'Item_PsiLocus';
        case 51:
            return 'Item_BerserkerBlade';
        case 52:
            return 'Item_AlienCarbine_Outsider';
        case 53:
            return 'Item_GaussCarbine';
        case 54:
            return 'Item_AcidSpit';
        case 55:
            return 'Item_SectopodClusterBomb';
        case 56:
            return 'Item_SeekerTentacles';
        case 57:
            return 'Item_TacVest';
        case 58:
            return 'Item_BansheeArmor';
        case 59:
            return 'Item_TacArmor';
        case 60:
            return 'Item_CarapaceArmor';
        case 61:
            return 'Item_CorsairArmor';
        case 62:
            return 'Item_TitanArmor';
        case 63:
            return 'Item_ArchangelArmor';
        case 64:
            return 'Item_ShadowArmor';
        case 65:
            return 'Item_VortexArmor';
        case 66:
            return 'Item_LeatherJacket';
        case 67:
            return 'Item_SeraphArmor';
        case 68:
            return 'Item_AuroraArmor';
        case 69:
            return 'Item_Medikit';
        case 70:
            return 'Item_CombatStims';
        case 71:
            return 'Item_MindShield';
        case 72:
            return 'Item_ChitinPlating';
        case 73:
            return 'Item_ArcThrower';
        case 74:
            return 'Item_SCOPE';
        case 75:
            return 'Item_AlloyPlating';
        case 76:
            return 'Item_RespiratorImplant';
        case 77:
            return 'Item_Rocket';
        case 78:
            return 'Item_ReaperPack';
        case 79:
            return 'Item_LaserSight';
        case 80:
            return 'Item_HiCapMags';
        case 81:
            return 'Item_HEGrenade';
        case 82:
            return 'Item_SmokeGrenade';
        case 83:
            return 'Item_FlashbangGrenade';
        case 84:
            return 'Item_AlienGrenade';
        case 85:
            return 'Item_ShadowDevice';
        case 86:
            return 'Item_ChemGrenade';
        case 87:
            return 'Item_APGrenade';
        case 88:
            return 'Item_MimicBeacon';
        case 89:
            return 'Item_ShredderRocket';
        case 90:
            return 'Item_BattleComputer';
        case 91:
            return 'Item_AlienGrenade_HeavyFloater';
        case 92:
            return 'Item_AlienGrenade_Muton';
        case 93:
            return 'Item_AlienGrenade_Cyberdisc';
        case 94:
            return 'Item_ChameleonSuit';
        case 95:
            return 'Item_CeramicPlating';
        case 96:
            return 'Item_PsiGrenade';
        case 97:
            return 'Item_BattleScanner';
        case 98:
            return 'Item_AlienTrophy';
        case 99:
            return 'Item_ReflexCannon';
        case 100:
            return 'Item_SHIV';
        case 101:
            return 'Item_SHIVAlloy';
        case 102:
            return 'Item_SHIVHover';
        case 103:
            return 'Item_Interceptor';
        case 104:
            return 'Item_Firestorm';
        case 105:
            return 'Item_Skyranger';
        case 106:
            return 'Item_Satellite';
        case 107:
            return 'Item_HEATAmmo';
        case 108:
            return 'Item_HoloTargeter';
        case 109:
            return 'Item_Autocannon';
        case 110:
            return 'Item_SentryGun';
        case 111:
            return 'Item_SuperheavyPulser';
        case 112:
            return 'Item_SuperheavyPlasma';
        case 113:
            return 'Item_SHIVChassis';
        case 114:
            return 'Item_SHIVAlloyChassis';
        case 115:
            return 'Item_SHIVHoverChassis';
        case 116:
            return 'Item_StingrayMissiles';
        case 117:
            return 'Item_PhoenixCannon';
        case 118:
            return 'Item_AvalancheMissiles';
        case 119:
            return 'Item_LaserCannon';
        case 120:
            return 'Item_PlasmaCannon';
        case 121:
            return 'Item_EMPCannon';
        case 122:
            return 'Item_FusionLance';
        case 123:
            return 'Item_DrumMags';
        case 124:
            return 'Item_SmartshellPod';
        case 125:
            return 'Item_DefenseMatrix';
        case 126:
            return 'Item_UFOTracking';
        case 127:
            return 'Item_UplinkTargeting';
        case 128:
            return 'Item_WeaponSupercooler';
        case 129:
            return 'Item_TheThumper';
        case 130:
            return 'Item_AutoSentryTurret';
        case 131:
            return 'Item_AdaptiveTrackingPod';
        case 132:
            return 'Item_CoreArmoring';
        case 133:
            return 'Item_DamageControlPod';
        case 134:
            return 'Item_CorpseSectoid';
        case 135:
            return 'Item_CorpseSectoidCommander';
        case 136:
            return 'Item_CorpseFloater';
        case 137:
            return 'Item_CorpseHeavyFloater';
        case 138:
            return 'Item_CorpseThinMan';
        case 139:
            return 'Item_CorpseMuton';
        case 140:
            return 'Item_CorpseMutonElite';
        case 141:
            return 'Item_CorpseBerserker';
        case 142:
            return 'Item_CyberdiscWreck';
        case 143:
            return 'Item_CorpseEthereal';
        case 144:
            return 'Item_ChryssalidCarcass';
        case 145:
            return 'Item_MEC3Valiant';
        case 146:
            return 'Item_SectopodWreck';
        case 147:
            return 'Item_DroneWreck';
        case 148:
            return 'Item_MEC5Devastator';
        case 149:
            return 'Item_SuperheavyLaser';
        case 150:
            return 'Item_CaptiveSectoid';
        case 151:
            return 'Item_CaptiveSectoidCommander';
        case 152:
            return 'Item_CaptiveFloater';
        case 153:
            return 'Item_CaptiveHeavyFloater';
        case 154:
            return 'Item_CaptiveThinMan';
        case 155:
            return 'Item_CaptiveMuton';
        case 156:
            return 'Item_CaptiveMutonElite';
        case 157:
            return 'Item_CaptiveBerserker';
        case 158:
            return 'Item_CaptiveEthereal';
        case 159:
            return 'Item_PhalanxArmor';
        case 160:
            return 'Item_AegisArmor';
        case 161:
            return 'Item_Elerium';
        case 162:
            return 'Item_AlienAlloy';
        case 163:
            return 'Item_WeaponFragment';
        case 164:
            return 'Item_Meld';
        case 165:
            return 'Item_AlienEntertainment';
        case 166:
            return 'Item_AlienFood';
        case 167:
            return 'Item_AlienStasisTank';
        case 168:
            return 'Item_UFOFlightComputer';
        case 169:
            return 'Item_AlienSurgery';
        case 170:
            return 'Item_UFOPowerSource';
        case 171:
            return 'Item_HyperwaveBeacon';
        case 172:
            return 'Item_AlienEntertainmentDamaged';
        case 173:
            return 'Item_AlienFoodDamaged';
        case 174:
            return 'Item_AlienStasisTankDamaged';
        case 175:
            return 'Item_UFOFlightComputerDamaged';
        case 176:
            return 'Item_AlienSurgeryDamaged';
        case 177:
            return 'Item_UFOPowerSourceDamaged';
        case 178:
            return 'Item_FuelCell';
        case 179:
            return 'Item_FusionCore';
        case 180:
            return 'Item_EtherealDevice';
        case 181:
            return 'Item_EXALTIntelligence';
        case 182:
            return 'Item_KestrelArmor';
        case 183:
            return 'Item_OutsiderShard';
        case 184:
            return 'Item_SkeletonKey';
        case 185:
            return 'Item_SectopodChestCannon';
        case 186:
            return 'Item_Railgun';
        case 187:
            return 'Item_MechtoidCore';
        case 188:
            return 'Item_SeekerWreck';
        case 189:
            return 'Item_AlloyCarbidePlating';
        case 190:
            return 'Item_PulseLance';
        case 191:
            return 'Item_MEC6Vanguard';
        case 192:
            return 'Item_BaseAugments';
        case 193:
            return 'Item_MEC1Paladin';
        case 194:
            return 'Item_MEC2Defender';
        case 195:
            return 'Item_MEC4Dauntless';
        case 196:
            return 'Item_AlloyBipod';
        case 197:
            return 'Item_BreachingAmmo';
        case 198:
            return 'Item_ArmorPiercingAmmo';
        case 199:
            return 'Item_AdvancedSuppressionModule';
        case 200:
            return 'Item_ImpactVest';
        case 201:
            return 'Item_TacticalSensors';
        case 202:
            return 'Item_WalkerServos';
        case 203:
            return 'Item_NeuralGunlink';
        case 204:
            return 'Item_ShredderAmmo';
        case 205:
            return 'Item_PsiScreen';
        case 206:
            return 'Item_RebuildSHIV';
        case 207:
            return 'Item_RebuildSHIVAlloy';
        case 208:
            return 'Item_RebuildSHIVHover';
        case 209:
            return 'Item_IlluminatorGunsight';
        case 210:
            return 'Item_MEC7Vindicator';
        case 211:
            return 'Item_IncineratorModule';
        case 212:
            return 'Item_AssaultRifle';
        case 213:
            return 'Item_SniperRifle';
        case 214:
            return 'Item_SAW';
        case 215:
            return 'Item_LaserRifle';
        case 216:
            return 'Item_LaserSniperRifle';
        case 217:
            return 'Item_Autolaser';
        case 218:
            return 'Item_RocketLauncher';
        case 219:
            return 'Item_TargetingModule';
        case 220:
            return 'Item_ReinforcedArmor';
        case 221:
            return 'Item_EleriumTurbos';
        case 222:
            return 'Item_MotionTracker';
        case 223:
            return 'Item_CognitiveEnhancer';
        case 224:
            return 'Item_Neuroregulator';
        case 225:
            return 'Item_FlakAmmo';
        case 226:
            return 'Item_MarksmansRifle';
        case 227:
            return 'Item_LaserStrikeRifle';
        case 228:
            return 'Item_AlloyStrikeRifle';
        case 229:
            return 'Item_BlasterRifle';
        case 230:
            return 'Item_ReflexRifle';
        case 231:
            return 'Item_SMG';
        case 232:
            return 'Item_LaserShatterray';
        case 233:
            return 'Item_GaussStuttergun';
        case 234:
            return 'Item_PulseStengun';
        case 235:
            return 'Item_PlasmaStormgun';
        case 236:
            return 'Item_MachinePistol';
        case 237:
            return 'Item_Heater';
        case 238:
            return 'Item_GaussAutopistol';
        case 239:
            return 'Item_Blaster';
        case 240:
            return 'Item_PlasmaMauler';
        case 241:
            return 'Item_BattleRifle';
        case 242:
            return 'Item_HeavyLaserRifle';
        case 243:
            return 'Item_HeavyGaussRifle';
        case 244:
            return 'Item_HeavyPulseRifle';
        case 245:
            return 'Item_HeavyPlasmaRifle';
        case 246:
            return 'Item_LMG';
        case 247:
            return 'Item_GatlingLaser';
        case 248:
            return 'Item_GaussMachineGun';
        case 249:
            return 'Item_GatlingPulser';
        case 250:
            return 'Item_PlasmaDragon';
        case 251:
            return 'Item_LaserCarbine';
        case 252:
            return 'Item_PulseCarbine';
        case 253:
            return 'Item_ArcRifle';
        case 254:
            return 'Item_SawedOffShotgun';
        default:
            return '';
    }
}

function Init()
{
    m_kStrategyActorTag = new class'XGStrategyActorTag';

    m_kItemTemplateMgr = `LWCE_ITEM_TEMPLATE_MGR;

    m_arrStaff.Add(4);
    m_arrShips.Add(16);
    m_arrShipWeapons.Add(11);

    BuildShips();
    BuildShipWeapons();
    BuildStaffTypes();
}

function BuildShips()
{
    BuildShip(1,  m_strSizeSmall,     eImage_Interceptor, eShipWeapon_Avalanche);                            // Interceptor
    BuildShip(2,  m_strSizeSmall,     eImage_Skyranger);                                                     // Skyranger
    BuildShip(3,  m_strSizeSmall,     eImage_Firestorm,   eShipWeapon_Avalanche);                            // Firestorm
    BuildShip(4,  m_strSizeSmall,     eImage_SmallScout,  eShipWeapon_UFOPlasmaI);                           // Scout
    BuildShip(5,  m_strSizeMedium,    eImage_LargeScout,  eShipWeapon_UFOPlasmaI);                           // Destroyer
    BuildShip(6,  m_strSizeLarge,     eImage_Abductor,    eShipWeapon_UFOPlasmaII);                          // Abductor
    BuildShip(7,  m_strSizeLarge,     eImage_SupplyShip,  eShipWeapon_UFOPlasmaII);                          // Transport
    BuildShip(8,  m_strSizeVeryLarge, eImage_Battleship,  eShipWeapon_UFOFusionI);                           // Battleship
    BuildShip(9,  m_strSizeMedium,    eImage_EtherealUFO, eShipWeapon_UFOPlasmaII, eShipWeapon_UFOPlasmaI);  // Overseer
    BuildShip(10, m_strSizeSmall,     eImage_SmallScout,  eShipWeapon_UFOPlasmaI);                           // Fighter
    BuildShip(11, m_strSizeMedium,    eImage_LargeScout,  eShipWeapon_UFOPlasmaI);                           // Raider
    BuildShip(12, m_strSizeLarge,     eImage_Abductor,    eShipWeapon_UFOPlasmaII);                          // Harvester
    BuildShip(13, m_strSizeLarge,     eImage_SupplyShip,  eShipWeapon_UFOPlasmaII);                          // Terror Ship
    BuildShip(14, m_strSizeVeryLarge, eImage_Battleship,  eShipWeapon_UFOPlasmaII, eShipWeapon_UFOPlasmaI);  // Assault Carrier

    UpdateShips();
}

function BuildShipWeapons()
{
    local int ToHitBonus;

    ToHitBonus = IsOptionEnabled(`LW_SECOND_WAVE_ID(TheFriendlySkies)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0;

    // XCOM weapons
    BuildShipWeapon(1, -1,  100, 0.750, 140,  5,  40 + ToHitBonus); // Phoenix Cannon
    BuildShipWeapon(2, -1,  100, 1.50,  200,  10, 40 + ToHitBonus); // Stingray Missiles
    BuildShipWeapon(3, -1,  100, 2.0,   340,  0,  40 + ToHitBonus); // Avalanche Missiles
    BuildShipWeapon(4, -1,  100, 1.0,   290,  5,  55 + ToHitBonus); // Laser Cannon
    BuildShipWeapon(5, -1,  100, 1.0,   650,  22, 40 + ToHitBonus); // Plasma Cannon
    BuildShipWeapon(6, -1,  100, 0.550, 310,  30, 30 + ToHitBonus); // EMP Cannon
    BuildShipWeapon(7, -1,  100, 1.250, 1200, 26, 30 + ToHitBonus); // Fusion Lance

    // UFO weapons
    BuildShipWeapon(8,  -1, 101, 1.150, 450,  0,  33); // UFO: Single Plasma
    BuildShipWeapon(9,  -1, 101, 1.250, 800,  20, 40); // UFO: Double Plasma
    BuildShipWeapon(10, -1, 101, 1.250, 1300, 50, 45); // UFO: Fusion Lance

    UpdateShips();
}

function bool CanBeBuilt(int iItemId)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function CanBeBuilt was called. This needs to be replaced with LWCEItemTemplate.CanBeBuilt. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool CanBeSold(int iItemId)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function CanBeSold was called. This needs to be replaced with LWCEItemTemplate.CanBeSold. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool CanFacilityBeBuilt(int iFacility)
{
    `LWCE_LOG_DEPRECATED_CLS(CanFacilityBeBuilt);

    return false;
}

function bool LWCE_CanFacilityBeBuilt(name FacilityName)
{
    local array<LWCE_TStaffRequirement> arrStaffRequirements;
    local LWCEFacilityTemplate kTemplate;
    local LWCE_XGHeadquarters kHQ;

    kTemplate = `LWCE_FACILITY(FacilityName);
    kHQ = LWCE_XGHeadquarters(HQ());

    // Access lifts aren't built through the normal UI, which uses this function
    if (FacilityName == 'Facility_AccessLift')
    {
        return false;
    }

    if (!kHQ.ArePrereqsFulfilled(kTemplate.kPrereqs))
    {
        return false;
    }

    arrStaffRequirements = kTemplate.GetStaffRequirements();

    if (!kHQ.AreStaffPresent(arrStaffRequirements))
    {
        return false;
    }

    if (kTemplate.iMaxInstances > 0 && kHQ.LWCE_GetNumFacilities(FacilityName, /* bIncludeBuilding */ true) >= kTemplate.iMaxInstances)
    {
        return false;
    }

    return true;
}

function EItemType CaptiveToCorpse(EItemType eCaptive)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function CaptiveToCorpse was called. This needs to be replaced with LWCEItemTemplate.nmCaptiveToCorpseId. Stack trace follows.");
    ScriptTrace();

    return eItem_None;
}

function int CharacterToCorpse(int iCharacterId)
{
    `LWCE_LOG_DEPRECATED_CLS(CharacterToCorpse);

    return 0;
}

function name LWCE_CharacterToCorpse(int iCharacterId)
{
    local array<name> arrPossibleCorpses;
    local array<LWCEItemTemplate> arrTemplates;
    local LWCEItemTemplate kItem;

    arrTemplates = m_kItemTemplateMgr.GetAllItemTemplates();

    foreach arrTemplates(kItem)
    {
        if (kItem.IsCorpse() && kItem.iCorpseToCharacterId == iCharacterId)
        {
            arrPossibleCorpses.AddItem(kItem.GetItemName());
        }
    }

    if (arrPossibleCorpses.Length == 0)
    {
        return '';
    }

    return arrPossibleCorpses[Rand(arrPossibleCorpses.Length)];
}

function int GetAlloySalePrice()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetAlloySalePrice);

    return -1;
}

function array<TItem> GetBuildItems(int iCategory)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetBuildItems);

    return arrItems;
}

function array<LWCEItemTemplate> LWCE_GetBuildItems(name nmCategory)
{
    local array<LWCEItemTemplate> arrItems, arrTemplates;
    local LWCEItemTemplate kItem;
    local int iPriorityItems;

    //`LWCE_LOG_CLS("LWCE_GetBuildItems: nmCategory = " $ nmCategory);

    arrTemplates = m_kItemTemplateMgr.GetAllItemTemplates();

    foreach arrTemplates(kItem)
    {
        //`LWCE_LOG_CLS("Checking item " $ kItem.GetItemName() $ " in category " $ kItem.nmCategory $ ": can be built = " $ kItem.CanBeBuilt());

        if (kItem.nmCategory == nmCategory && kItem.CanBeBuilt())
        {
            if (kItem.IsPriority())
            {
                arrItems.InsertItem(iPriorityItems, kItem);
                ++iPriorityItems;
            }
            else
            {
                arrItems.AddItem(kItem);
            }
        }
    }

    return arrItems;
}

function int GetEleriumSalePrice()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetEleriumSalePrice);

    return -1;
}

function TItem GetItem(int iItem, optional int iTransactionType = eTransaction_Build)
{
    local TItem kItem;

    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetItem was called. This needs to be replaced with the macro LWCE_ITEM. Stack trace follows.");
    ScriptTrace();

    return kItem;
}

function int GetItemBuildTime(EItemType eItem, EItemCategory eItemCat, int iEngineerDays)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetItemBuildTime);
    return 0;
}

function int GetItemQuestPrice(EItemType eItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetItemQuestPrice was called. This needs to be replaced with LWCEItemTemplate.GetSalePrice. Stack trace follows.");
    ScriptTrace();

    return -1;
}

function int GetItemSalePrice(EItemType eItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetItemSalePrice was called. This needs to be replaced with LWCEItemTemplate.GetSalePrice. Stack trace follows.");
    ScriptTrace();

    return -1;
}

function TShipWeapon GetShipWeapon(int iWeaponType)
{
    if (iWeaponType >= m_arrShipWeapons.Length)
    {
        `LWCE_LOG_CLS("ERROR: invalid iWeaponType " $ iWeaponType $ " passed to GetShipWeapon");
        ScriptTrace();
    }

    return m_arrShipWeapons[iWeaponType];
}

function string GetSummary(int iItemId)
{
    `LWCE_LOG_CLS("LWCE_XGItemTree.GetSummary is deprecated. Use LWCEItemTemplate.strBriefSummary instead. Stack trace follows.");
    ScriptTrace();

    return "";
}

function bool IsArmor(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsArmor was called. This needs to be replaced with LWCEItemTemplate.IsArmor. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsCaptive(EItemType eItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsCaptive was called. This needs to be replaced with LWCEItemTemplate.IsCaptive. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsCorpse(int iItemId)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsCorpse was called. This needs to be replaced with LWCEItemTemplate.IsCorpse. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsItem(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsItem was called. This needs to be replaced with LWCEItemTemplate.IsEquipment. Stack trace follows.");
    ScriptTrace();

    return false;
}

simulated function bool IsItemUniqueEquip(EItemType eItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsItemUniqueEquip was called. This needs to be replaced with LWCEEquipmentTemplate.bIsUniqueEquip. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsLargeWeapon(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsLargeWeapon was called. This needs to be replaced with LWCEWeaponTemplate.IsLarge. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsSmallItem(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsSmallItem was called. This needs to be replaced with LWCEWeaponTemplate.IsSmall. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsSmallWeapon(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsSmallWeapon was called. This needs to be replaced with LWCEWeaponTemplate.IsSmall. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsWeapon(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsWeapon was called. This needs to be replaced with LWCEItemTemplate.IsWeapon. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool ItemIsValid(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(ItemIsValid);
    return false;
}

function UpdateShips()
{
    local LWCE_XGFacility_Engineering kEngineering;

    m_iCurrentCategory = Clamp(STAT_GetStat(1) / 30, 0, 32);
    UpdateShip(2, 2000, 10, 8, 0, 0);

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());

    if (kEngineering == none)
    {
        return;
    }

    UpdateShip(1, class'XGTacticalGameCore'.default.ContBalance_Classic[1].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[1].iScientists1 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_EleriumAfterburners')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[1].iEngineers4 : 0), class'XGTacticalGameCore'.default.ContBalance_Classic[1].iEngineers2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ArmoredFighters')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[1].iScientists3 : 0), class'XGTacticalGameCore'.default.ContBalance_Classic[1].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[1].iEngineers3 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_PenetratorWeapons')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[1].iScientists4 : 0));
    UpdateShip(3, class'XGTacticalGameCore'.default.ContBalance_Classic[3].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[3].iScientists1 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_EleriumAfterburners')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[3].iEngineers4 : 0), class'XGTacticalGameCore'.default.ContBalance_Classic[3].iEngineers2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ArmoredFighters')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[3].iScientists3 : 0), class'XGTacticalGameCore'.default.ContBalance_Classic[3].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[3].iEngineers3 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_PenetratorWeapons')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[3].iScientists4 : 0));
    UpdateShip(4, class'XGTacticalGameCore'.default.ContBalance_Classic[4].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[4].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[4].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[4].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[4].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[4].iEngineers3);
    UpdateShip(5, class'XGTacticalGameCore'.default.ContBalance_Classic[5].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[5].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[5].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[5].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[5].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[5].iEngineers3);
    UpdateShip(6, class'XGTacticalGameCore'.default.ContBalance_Classic[6].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[6].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[6].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[6].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[6].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[6].iEngineers3);
    UpdateShip(7, class'XGTacticalGameCore'.default.ContBalance_Classic[7].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[7].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[7].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[7].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[7].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[7].iEngineers3);
    UpdateShip(8, class'XGTacticalGameCore'.default.ContBalance_Classic[8].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[8].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[8].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[8].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[8].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[8].iEngineers3);
    UpdateShip(9, class'XGTacticalGameCore'.default.ContBalance_Classic[9].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[9].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[9].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[9].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[9].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[9].iEngineers3);
    UpdateShip(10, class'XGTacticalGameCore'.default.ContBalance_Classic[10].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[10].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[10].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[10].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[10].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[10].iEngineers3);
    UpdateShip(11, class'XGTacticalGameCore'.default.ContBalance_Classic[11].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[11].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[11].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[11].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[11].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[11].iEngineers3);
    UpdateShip(12, class'XGTacticalGameCore'.default.ContBalance_Classic[12].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[12].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[12].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[12].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[12].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[12].iEngineers3);
    UpdateShip(13, class'XGTacticalGameCore'.default.ContBalance_Classic[13].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[13].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[13].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[13].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[13].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[13].iEngineers3);
    UpdateShip(14, class'XGTacticalGameCore'.default.ContBalance_Classic[14].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[14].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[14].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[14].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[14].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[14].iEngineers3);

    if (m_iCurrentCategory > 8)
    {
        BuildShip(5, m_strSizeMedium, 80, 9);
    }

    if (m_iCurrentCategory > 10)
    {
        BuildShip(10, m_strSizeSmall, 79, 8, 8);
    }

    if (m_iCurrentCategory > 12)
    {
        BuildShip(6, m_strSizeLarge, 81, 9, 8);
        BuildShip(13, m_strSizeLarge, 82, 9, 8);
    }

    if (m_iCurrentCategory > 18)
    {
        BuildShip(11, m_strSizeMedium, 80, 8, 8);
        BuildShip(14, m_strSizeVeryLarge, 84, 9, 9);
        UpdateShip(5, class'XGTacticalGameCore'.default.ContBalance_Classic[15].iEngineers1, class'XGTacticalGameCore'.default.ContBalance_Classic[15].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[15].iEngineers2 + (class'XGTacticalGameCore'.default.ContBalance_Classic[15].iScientists3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[15].iScientists2, class'XGTacticalGameCore'.default.ContBalance_Classic[15].iEngineers3);
    }

    if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_PhoenixCoilguns'))
    {
        BuildShipWeapon(1, -1, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[28].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[28].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[28].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[28].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[28].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    }
    else
    {
        BuildShipWeapon(1, -1, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[21].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[21].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[21].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[21].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[21].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    }

    BuildShipWeapon(2, 3, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[22].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[22].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[22].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[22].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[22].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(3, 3, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[23].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[23].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[23].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[23].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[23].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));

    if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_Supercapacitors'))
    {
        BuildShipWeapon(4, -1, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[29].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[29].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[29].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[29].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[29].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    }
    else
    {
        BuildShipWeapon(4, -1, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[24].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[24].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[24].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[24].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[24].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    }

    BuildShipWeapon(5, 10, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[25].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[25].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[25].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[25].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[25].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(6, -1, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[26].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[26].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[26].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[26].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[26].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(7, 10, 100, float(class'XGTacticalGameCore'.default.ContBalance_Classic[27].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[27].iScientists1, class'XGTacticalGameCore'.default.ContBalance_Classic[27].iEngineers2, (class'XGTacticalGameCore'.default.ContBalance_Classic[27].iScientists2 + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[27].iEngineers3 : 0)) + ((IsOptionEnabled(24)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0));
    BuildShipWeapon(8, -1, 101, float(class'XGTacticalGameCore'.default.ContBalance_Classic[30].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[30].iScientists1 + (class'XGTacticalGameCore'.default.ContBalance_Classic[30].iEngineers3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[30].iEngineers2, class'XGTacticalGameCore'.default.ContBalance_Classic[30].iScientists2 + ((class'XGTacticalGameCore'.default.ContBalance_Classic[30].iScientists3 * m_iCurrentCategory) + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_UFOCountermeasures')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[30].iEngineers4 : 0)));
    BuildShipWeapon(9, -1, 101, float(class'XGTacticalGameCore'.default.ContBalance_Classic[31].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[31].iScientists1 + (class'XGTacticalGameCore'.default.ContBalance_Classic[31].iEngineers3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[31].iEngineers2, class'XGTacticalGameCore'.default.ContBalance_Classic[31].iScientists2 + ((class'XGTacticalGameCore'.default.ContBalance_Classic[31].iScientists3 * m_iCurrentCategory) + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_UFOCountermeasures')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[31].iEngineers4 : 0)));
    BuildShipWeapon(10, -1, 101, float(class'XGTacticalGameCore'.default.ContBalance_Classic[32].iEngineers1) / float(100), class'XGTacticalGameCore'.default.ContBalance_Classic[32].iScientists1 + (class'XGTacticalGameCore'.default.ContBalance_Classic[32].iEngineers3 * m_iCurrentCategory), class'XGTacticalGameCore'.default.ContBalance_Classic[32].iEngineers2, class'XGTacticalGameCore'.default.ContBalance_Classic[32].iScientists2 + ((class'XGTacticalGameCore'.default.ContBalance_Classic[32].iScientists3 * m_iCurrentCategory) + ((kEngineering.LWCE_IsFoundryTechResearched('Foundry_UFOCountermeasures')) ? class'XGTacticalGameCore'.default.ContBalance_Classic[32].iEngineers4 : 0)));

    if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_WingtipSparrowhawks'))
    {
        BuildShip(1, m_strSizeSmall, 68, 3, 2);
        BuildShip(3, m_strSizeSmall, 69, 3, 2);
    }

    UpdateAllShipTemplates();
}