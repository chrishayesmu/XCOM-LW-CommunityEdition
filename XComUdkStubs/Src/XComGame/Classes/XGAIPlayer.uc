class XGAIPlayer extends XGPlayer
    native(AI)
    notplaceable
    hidecategories(Navigation);

const AI_ALIEN_COUNT = 4;
const MaxUnitCount = 128;
const MAX_ACTIVE_PAWN_TYPES = 69;
const AI_MAX_CACHE_VER = 60000;

enum AIOrderMode
{
    eAIOM_StaticClosestFirst,
    eAIOM_DynamicFurthestFirst,
    eAIOM_DynamicClosestFirst,
    eAIOM_MAX
};

struct native prox_info
{
    var float fDistSq;
    var XGUnit kUnit;
    var int iAlienNum;

    structdefaultproperties
    {
        fDistSq=0.0
        kUnit=none
        iAlienNum=0
    }
};

struct native Mimic_Beacon_Info
{
    var int iTurnsRemaining;
    var Vector vLoc;
    var XGUnit UnitFired;
};

struct native UFO_data
{
    var float fRadius;
    var Vector vCenter;
};

struct CheckpointRecord_XGAIPlayer extends CheckpointRecord
{
    var int m_iCurrUnit;
    var int m_uiHasBeenVisible;
    var UFO_data m_kSquadStart;
    var XGAIPlayerOvermindHandler m_kOvermindHandler;
    var XGUnit m_kVIP;
    var bool m_bVIPChecked;
    var bool m_bIsTerrorMap;
    var array<XGUnit> m_arrTerrorAliens;
    var array<Mimic_Beacon_Info> m_arrMimicBeacons;
};

struct native adjacency_list
{
    var float Dist[128];
};

struct native TeamAttack
{
    var XGUnit kFlanker;
    var XGUnit kTarget;
    var Vector vFlankPointA;
    var Vector vFlankPointB;
    var bool bValid;
    var bool bSuppressed;
};

struct mindfray_option
{
    var XGUnit kFrayer;
    var array<XGUnit> akFrayTargets;
    var array<XGUnit> akPsiControlTargets;
    var array<XGUnit> akPsiPanicTargets;
};

var array<adjacency_list> m_kTeamAdjacencyMatrix;
var array<adjacency_list> m_kEnemyAdjacencyMatrix;
var int m_iCurrUnit;
var int m_uiHasBeenVisible;
var UFO_data m_kSquadStart;
var bool m_bSkipAI;
var bool m_bShowAI;
var bool m_bAbortedMove;
var bool m_bHasUFO;
var bool m_bHasHiders;
var bool bVerboseLogging;
var bool m_bVisibleCacheDirty;
var bool m_bHomogeneousLoadouts;
var bool m_bPauseAlienTurn;
var bool m_bGrenadeThrown;
var bool m_bLaunched;
var bool m_bIdleTurn;
var bool m_bIgnoreConstraints;
var bool m_bLoadedFromSave;
var bool m_bIsTerrorMap;
var bool m_bAttackedCivilianThisTurn;
var bool m_bVIPChecked;
var bool m_bHasAoETargets;
var array<prox_info> m_akProxInfo;
var int m_iShotFired;
var int m_nMaxInactivityAlienSpawns;
var float m_fMaxUnitRadius;
var float m_fCallWaiting;
var array<XGUnit> m_arrWaitingToRespond;
var float m_fMinEndTime;
var float m_fNextRandomSoundTime;
var int m_bsCanAttack;
var XGUnit m_kFlankingTarget;
var XGUnit m_kTarget;
var array<badcover> m_arrBadCover;
var int m_iActivePawnCount[69];
var int iPathFailures;
var int iPathAttempts;
var array<XComSpawnPoint> m_arrDebugSpawnPts;
var array<XComSpawnPoint> m_arrDebugLootSpawns;
var array<XComProjectile_FragGrenade> m_arrGrenadeList;
var float fHangTimer;
var array<XGUnit> m_arrVisibleCache;
var array<XGUnit> m_arrAllEnemies;
var array<XGUnit> m_arrValidTargets;
var array<XGUnit> m_arrCachedSquad;
var array<XGUnit> m_arrActiveEngaged;
var array<XGUnit> m_arrInactive;
var array<XGUnit> m_arrNotVisible;
var array<XGUnit> m_arrEnemiesInOverwatch;
var array<XGUnit> m_arrBattleScanners;
var array<ai_cover_score> m_arrTacticalData;
var array<ai_cover_score> m_arrTerroristData;
var array<ai_cover_score> m_arrHiddenData;
var array<XComCoverPoint> m_arrFlankPoints;
var XComCoverPoint m_kLaunchTo;
var float m_fMaxWeaponRange;
var float m_fMinTeammateDistance;
var float m_fDefaultMinEngageRange;
var XGAIPlayerOvermindHandler m_kOvermindHandler;
var TeamAttack m_kTeamAttack;
var array<XGUnit> m_arrSuppressed;
var array<XGUnit> m_arrGrenadiers;
var int m_eDefaultType;
var int m_nPreplacedAliens;
var int m_iTurnsIdle;
var array<Box> m_arrDangerZones;
var array<XGInventoryItem> m_arrSeenWeapons;
var XGAIPlayer.AIOrderMode m_eOrder;
var array<XGUnit> m_arrSuppressTarget;
var array<XGUnit> m_arrPriorityList;
var(Terror) int m_iMaxCivilianKillRate;
var int m_iTerrorLastKillTurn;
var int m_nLastKillCount;
var array<XGUnit> m_arrTerrorAliens;
var array<XGUnit> m_arrHiddenTerrorAliens;
var array<XGUnit> m_arrVisibleTerrorAliens;
var XGAIAbilityRules m_kAbilityRules;
var int m_iCurrCacheVer;
var XGLevel kLevel;
var const localized string m_strAIHangAborted;
var XGUnit m_kVIP;
var array<aoe_target> m_arrAoETarget;
var aoe_target m_kDeathBlossomTarget;
var aoe_target m_kLastAoETargetUsed;
var array<XGUnit> m_arrAoECachedTargets;
var XGUnit m_kMindFrayTarget;
var XGUnit m_kPriorityUnit;
var XGUnit m_kPsiAttacker;
var int m_nMaxMindMergesPerTurn;
var int m_nMindMergesThisTurn;
var XGUnit m_kLaunchCandidate;
var XGUnit m_kDeathBlossomCandidate;
var array<XGUnit> m_arrMindMergeCandidates;
var Vector m_vUpdateUnitLookAt;
var Volume m_kPriorityVolume;
var array<XGUnit> m_arrHealer;
var array<heal_option> m_arrWounded;
var array<heal_option> m_arrHealAssignment;
var privatewrite array<Mimic_Beacon_Info> m_arrMimicBeacons;
var int m_iStrangleCooldown;
var array<XGUnit> m_arrUnitsInCapZone;
var XGUnit kDebugDest;
var int m_iDebugLogPos;
var int m_iMinScore;
var int m_iMaxScore;

delegate int WoundedSort(heal_option kOptionA, heal_option kOptionB)
{
}

defaultproperties
{
    m_nMaxInactivityAlienSpawns=5
    m_fMinTeammateDistance=128.0
    m_iMaxCivilianKillRate=3
    m_iTerrorLastKillTurn=-1
    m_eTeam=eTeam_Alien
}