class UIProtoScreen extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

enum EMenuStates
{
    eState_Disabled,
    eState_Enabled,
    eState_MAX
};

var array<UIProtoWidget> m_arrWidgets;
var protected string m_strReturn;
var protected bool m_bAllowsScrolling;
var protected bool m_bLeftAnalogVScrolling;
var protected bool m_bLeftAnalogHScrolling;
var protected bool m_bIgnoreInput;
var bool m_bHorizontalInput;
var protected float m_fLeftAnalogRepeatTimer;
var protected UIProtoWidget m_kFocus;
var protected int m_iCurrentSelection;
var protected int m_InputNextContainer;
var protected int m_InputPrevContainer;
var protected int m_InputNextItem;
var protected int m_InputPrevItem;

defaultproperties
{
    s_package="/ package/gfxProtoUI/ProtoUI"
    s_screenId="gfxProtoUI"
    e_InputState=eInputState_Evaluate
    s_name="protoUI"
}