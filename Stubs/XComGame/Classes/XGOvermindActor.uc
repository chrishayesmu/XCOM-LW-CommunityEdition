class XGOvermindActor extends Actor
    hidecategories(Navigation)
    native(AI)
    notplaceable
    DependsOn(XGGameData);
//complete stub

const TileSize = 96.0f;
const SectionSize = 10.0f;
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

struct native TAlienSpawn
{
    var XComAlienPod kSpawnLoc;
    var TAlienPod kPod;
    var EPodAnimation eAnim;
    var EItemType ePodDevice;
};

struct native TMapSection
{
    var int iRow;
    var int iColumn;
    var Vector vCenter;
    var TRect m_kRect;
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

function TTile Tile(int X, int Y, int Z){}
function TTile PointToTile(Vector vPoint){}
function Vector TileToPoint(out TTile kTile){}
function array<XGUnit> EnemiesToUnits(array<XGEnemyUnit> arrEnemies){}
function ClampToBounds(out Vector vPoint){}
function XGBattle_SP BATTLE(){}
function XGAIPlayer AI(){}
function XGOvermind OVERMIND(){}
function XGPlayer XCom(){}
function EMissionType MISSION_TYPE(){}
function XGBattleDesc BattleDesc(){}
function XComWorldData World(){}
function bool Roll(int iChance){}
function TRect Rect(float fLeft, float fTop, float fRight, float fBottom){}
function float RectWidth(TRect kRect){}
function float RectHeight(TRect kRect){}
function Vector2D RectCenter(TRect kRect){}
function float RectCenterX(TRect kRect){}
function float RectCenterY(TRect kRect){}
function TRect ScaleRect(TRect kRect, float fScale){}
function bool HitRect(Vector vPoint, TRect kRect){}
