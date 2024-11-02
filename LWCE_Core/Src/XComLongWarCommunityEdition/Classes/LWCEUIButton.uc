class LWCEUIButton extends LWCEUIWidget;

enum LWCEButtonStyle
{
    eBtnStyle_None,
    eBtnStyle_HotlinkButton,
    eBtnStyle_SelectedShowsHotlink,
    eBtnStyle_HotlinkWhenSansMouse,
    eBtnStyle_ButtonWhenMouse
};

// Handlers which will run, in order, when this button is pressed.
var array< delegate<LWCEButtonOnPress> > m_arrOnPressHandlers;

var protectedwrite bool m_bIsEnabled;
var protectedwrite bool m_bIsHtmlText;
var protectedwrite bool m_bResizeToText;
var protectedwrite float m_fFontSize;
var protectedwrite LWCEButtonStyle m_eButtonStyle;
var protectedwrite string m_strIconLabel; // Reference class UI_FxsGamepadIcons for valid values
var protectedwrite string m_strLabelText;

delegate LWCEButtonOnPress();

function Init()
{
    if (m_bIsInited)
    {
        return;
    }

    super.Init();

    // Hook in our onpress handler, which is responsible for invoking the UC delegates
    AS_SetOnPress(OnPress);

    SetFontSize(m_fFontSize);
    SetIcon(m_strIconLabel);
    SetResizeToText(m_bResizeToText);
    SetStyle(m_eButtonStyle);
    SetEnabled(m_bIsEnabled);

    if (m_bIsHtmlText)
    {
        SetHtmlLabel(m_strLabelText);
    }
    else
    {
        SetLabel(m_strLabelText);
    }
}

function SetFontSize(float fFontSize)
{
    m_fFontSize = fFontSize;

    if (m_bIsInited)
    {
        AS_SetStyle(m_eButtonStyle, m_fFontSize, m_bResizeToText);
    }
}

function SetStyle(LWCEButtonStyle eNewStyle)
{
    m_eButtonStyle = eNewStyle;

    if (m_bIsInited)
    {
        AS_SetStyle(m_eButtonStyle, m_fFontSize, m_bResizeToText);
    }
}

function SetResizeToText(bool bResizeToText)
{
    m_bResizeToText = bResizeToText;

    if (m_bIsInited)
    {
        AS_SetStyle(m_eButtonStyle, m_fFontSize, m_bResizeToText);
    }
}

function SetHtmlLabel(string strNewText)
{
    m_bIsHtmlText = true;
    m_strLabelText = strNewText;

    if (m_bIsInited)
    {
        AS_SetHTMLText(strNewText);
    }
}

function SetEnabled(bool bIsEnabled)
{
    m_bIsEnabled = bIsEnabled;

    if (m_bIsInited)
    {
        if (m_bIsEnabled)
        {
            AS_Enable();
        }
        else
        {
            AS_Disable();
        }
    }
}

function SetIcon(string strIconLabel)
{
    m_strIconLabel = strIconLabel;

    if (m_bIsInited)
    {
        AS_SetIcon(strIconLabel);
    }
}

function SetLabel(string strNewText)
{
    m_bIsHtmlText = false;
    m_strLabelText = strNewText;

    if (m_bIsInited)
    {
        AS_SetText(strNewText);
    }
}

function Select()
{
    AS_Select();
}

function Deselect()
{
    AS_Deselect();
}

function OnReceiveFocus()
{
    AS_OnReceiveFocus();
}

function OnLoseFocus()
{
    AS_OnLoseFocus();
}

protected function OnPress()
{
    local delegate<LWCEButtonOnPress> del;

    foreach m_arrOnPressHandlers(del)
    {
        del();
    }
}

// ActionScript proxy functions, only to be called by the public versions above

protected function AS_SetStyle(int iNewStyle, optional float fFontSize = 20.0, optional bool bResizeToText = true)
{
	ActionScriptVoid("setStyle");
}

protected function AS_SetText(string strNewText)
{
	ActionScriptVoid("setText");
}

protected function AS_SetHTMLText(string strNewText)
{
	ActionScriptVoid("setHTMLText");
}

protected function AS_Select()
{
	ActionScriptVoid("select");
}

protected function AS_Deselect()
{
	ActionScriptVoid("deselect");
}

protected function AS_Disable()
{
	ActionScriptVoid("disable");
}

protected function AS_Enable()
{
	ActionScriptVoid("enable");
}

protected function AS_OnReceiveFocus()
{
	ActionScriptVoid("onReceiveFocus");
}

protected function AS_OnLoseFocus()
{
	ActionScriptVoid("onLoseFocus");
}

protected function AS_SetIcon(string strIconLabel)
{
	ActionScriptVoid("setIcon");
}

protected function AS_SetOnPress(delegate<LWCEButtonOnPress> del)
{
    ActionScriptSetFunction("release");
}

defaultproperties
{
    m_bIsEnabled=true
    m_bIsHtmlText=false
    m_bResizeToText=false
    m_eButtonStyle=eBtnStyle_None
    m_fFontSize=20.0
    m_strIconLabel=""
    m_strLabelText=""
}