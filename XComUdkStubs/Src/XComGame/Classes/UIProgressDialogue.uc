class UIProgressDialogue extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

struct TProgressDialogData
{
    var string strTitle;
    var string strDescription;
    var string strAbortButtonText;
    var delegate<ButtonPressCallback> fnCallback;
    var delegate<ProgressDialogOpenCallback> fnProgressDialogOpenCallback;

    structdefaultproperties
    {
        strTitle="<NO DATA PROVIDED>"
        strAbortButtonText="<DEFAULT ABORT>"
    }
};

var private TProgressDialogData m_kData;
var delegate<ButtonPressCallback> m_fnCallback;

delegate ButtonPressCallback()
{
}

delegate ProgressDialogOpenCallback()
{
}

defaultproperties
{
    s_package="/ package/gfxProgressDialogue/ProgressDialogue"
    s_screenId="gfxProgressDialogue"
    m_bAnimateIntro=false
    m_bAnimateOutro=false
    e_InputState=eInputState_Consume
    s_name="theProgressDialogue"
}