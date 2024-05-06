class XGOvermindActor extends Actor
    native(AI)
    notplaceable
    hidecategories(Navigation);

const ENEMY_POD_PADDING = 6.0f;
const TileSize = 96.0f;
const SectionSize = 10.0f;
const HUNT_MAX_TURNS = 8;
const OVERMIND_CALL_TIMER = 2;

enum EManeuverType
{
    eManeuver_Move,
    eManeuver_Attack,
    eManeuver_Deploy,
    eManeuver_RevealPatrol,
    eManeuver_RevealLurk,
    eManeuver_RevealTerror,
    eManeuver_RevealCamZoom,
    eManeuver_CallRandomly,
    eManeuver_CallForHelp,
    eManeuver_CallTheHunt,
    eManeuver_CallRetreat,
    eManeuver_CallHeardNoise,
    eManeuver_MAX
};

enum EManeuverStatus
{
    eManeuverStatus_OnTask,
    eManeuverStatus_Success,
    eManeuverStatus_Failure,
    eManeuverStatus_MAX
};

enum EPodTactic
{
    ePT_None,
    ePT_LurkBody,
    ePT_LurkOnGuard,
    ePT_Patrol,
    ePT_Hunt,
    ePT_Fight,
    ePT_Terrorize,
    ePT_Reveal,
    ePT_Retreat,
    ePT_MAX
};

enum EPodAnimation
{
    ePA_None,
    ePA_LurkMummy,
    ePA_LurkBody,
    ePA_Patrolling,
    ePA_Terror,
    ePA_MAX
};

struct native TMapSection
{
    var int iRow;
    var int iColumn;
    var Vector vCenter;
    var TRect m_kRect;
};

struct native TAlienSpawn
{
    var XComAlienPod kSpawnLoc;
    var TAlienPod kPod;
    var EPodAnimation eAnim;
    var EItemType ePodDevice;
};

struct native TBox
{
    var int iTopY;
    var int iLeftX;
    var int iBottomY;
    var int iRightX;
    var int iFloorZ;
    var int iCeilingZ;
};

struct native TBuilding
{
    var TRect rectBuilding;
    var bool bIsUFO;
};