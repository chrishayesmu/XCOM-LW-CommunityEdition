class UI_FxsGamepadIcons extends Object
    native(Core);
//complete stub

const ICON_A_X = "Icon_A_X";
const ICON_B_CIRCLE = "Icon_B_CIRCLE";
const ICON_X_SQUARE = "Icon_X_SQUARE";
const ICON_Y_TRIANGLE = "Icon_Y_TRIANGLE";
const ICON_START = "Icon_START";
const ICON_BACK_SELECT = "Icon_BACK_SELECT";
const ICON_DPAD = "Icon_DPAD";
const ICON_DPAD_UP = "Icon_DPAD_UP";
const ICON_DPAD_DOWN = "Icon_DPAD_DOWN";
const ICON_DPAD_LEFT = "Icon_DPAD_LEFT";
const ICON_DPAD_RIGHT = "Icon_DPAD_RIGHT";
const ICON_DPAD_HORIZONTAL = "Icon_DPAD_HORIZONTAL";
const ICON_DPAD_VERTICAL = "Icon_DPAD_VERTICAL";
const ICON_LSTICK = "Icon_LSTICK";
const ICON_RSTICK = "Icon_RSTICK";
const ICON_LB_L1 = "Icon_LB_L1";
const ICON_LT_L2 = "Icon_LT_L2";
const ICON_LSCLICK_L3 = "Icon_LSCLICK_L3";
const ICON_RB_R1 = "Icon_RB_R1";
const ICON_RT_R2 = "Icon_RT_R2";
const ICON_RSCLICK_R3 = "Icon_RSCLICK_R3";
const ICON_ABILITY_OVERWATCH = "Icon_OVERWATCH_HTML";
const ICON_KEY_TAB = "Icon_KEY_TAB";
const ICON_PC_LEFTMOUSE = "PC_mouseLeft";
const ICON_PC_RIGHTMOUSE = "PC_mouseRight";
const ICON_PC_WHEELCLICK = "PC_mouseWheelClick";
const ICON_PC_WHEELSCROLL = "PC_mouseWheelScroll";
const ICON_PC_MOUSE_4 = "PC_mouseLeft4";
const ICON_PC_MOUSE_5 = "PC_mouseLeft5";
const ICON_PC_ARROWLEFT = "PC_arrowLEFT";
const ICON_PC_ARROWRIGHT = "PC_arrowRIGHT";
const ICON_PC_ARROWUP = "PC_arrowUP";
const ICON_PC_ARROWDOWN = "PC_arrowDOWN";
const ICON_PC_LEFTMOUSE4 = "PC_mouseLeft4";
const ICON_PC_LEFTMOUSE5 = "PC_mouseLeft5";

static function string HTML(string sIcon, optional int imgDimensions=30, optional int vspaceOffset){}
static function string HTML_MESSENGER(string sIcon){}
static function string HTML_TITLEFONT(string sIcon){}
static function string HTML_BODYFONT(string sIcon){}
static function string HTML_KEYMAP(string sKeymap){}
static function string InsertGamepadIcons(string sSource){}
static function string InsertGamepadIconsMessenger(string sSource){}
static function string FindAbilityKey(string sSource, string sAction, int iActionEnum, out byte bKeyNotFound, XComKeybindingData kKeybinds, PlayerInput kPlayerInput){}
static function string InsertAbilityKeys(string sSource, out byte bKeyNotFound, XComKeybindingData kKeybinds, PlayerInput kPlayerInput){}
static function string InsertPCIcons(string sSource){}
static function string GetAdvanceButtonIcon(){}
static function string GetBackButtonIcon(){}
native static function bool IsAdvanceButtonSwapActive();