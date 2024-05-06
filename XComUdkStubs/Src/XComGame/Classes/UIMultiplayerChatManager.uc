class UIMultiplayerChatManager extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

const MY_MESSAGE_COLOR_HTML = "B9FFFF";
const OPPONENT_MESSAGE_COLOR_HTML = "EE1C25";

var private bool m_bIsActive;
var private bool m_bMuteChime;
var private bool m_bMuteChat;

defaultproperties
{
    s_package="/ package/gfxChat/Chat"
    s_screenId="gfxChat"
    e_InputState=eInputState_Evaluate
    s_name="theScreen"
}