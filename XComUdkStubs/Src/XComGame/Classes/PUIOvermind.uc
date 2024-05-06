class PUIOvermind extends UIScreen
    notplaceable
    hidecategories(Navigation);

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

defaultproperties
{
    s_screenId="gfxProtoUIOvermind"
}