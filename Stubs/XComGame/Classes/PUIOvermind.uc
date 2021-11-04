class PUIOvermind extends UIScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

const UNIT_DRAW_RADIUS = 0.01;
const MAP_SCREEN_SIZE = 0.99f;

struct TUILayout
{
    var Vector2D v2Dir;
    var TRect rectBounds;
    var float fMapWidth;
    var float fMapHeight;
    var TRect rectScreenBounds;
};

var XGBattle_SP m_kBattle;
var XGAIPlayer m_kAI;
var XGPlayer m_kPlayer;
var XGOvermind m_kOvermind;
var TUILayout m_kLayoutUI;
var int m_iLine;

simulated function Init(){}
simulated function OnInit(){}
function Draw(){}
simulated function bool OnCancel(optional string strOption){}
simulated function DrawLayout(){}
simulated function DrawCursor(){}
simulated function DrawPlayDirection(){}
simulated function DrawBuildings(){}
simulated function DrawSections(){}
simulated function DrawSection(int iSection){}
simulated function DrawHuntTargets();
simulated function DrawSpawns(){}
simulated function DrawSpawn(XComAlienPod kSpawn, int iSpawn){}
simulated function DrawLink(XGUnit kUnit1, XGUnit kUnit2, Color clrLink){}
simulated function DrawUnit(XGUnit kUnit){}
simulated function DrawAlien(XGUnit kUnit){}
simulated function DrawSoldier(XGUnit kUnit){}
simulated function DrawTactic(XGPod kPod, int iPodID){}
simulated function DrawMoveManeuver(XGTactic kTactic, XGManeuver_Move kManeuver, int iManeuver, int iPodID){}
simulated function DrawPod(XGPod kPod, int iPodID){}
simulated function DrawEnemyPod(XGEnemyPod kPod, int iPodID){}
simulated function DrawPods(){}
simulated function DrawEnemy(){}
function TRect ConvertRectToScreenCoords(TRect kRect){}
function Vector2D GetScreenLoc(Vector vLoc){}
simulated function string GetAlienName(XGUnit kUnit){}
simulated function int GetUnitIndex(XGUnit kUnit){}
simulated function string GetSoldierName(XGUnit kUnit){}
simulated function InitLayout(){}
function InitLayoutScreenCoords(TRect kRect){}
