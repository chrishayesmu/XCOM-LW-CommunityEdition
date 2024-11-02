class LWCEUICheckbox extends LWCEUIWidget;

enum EUIStyle_Checkbox
{
    eUISChk_TextOnLeft,
    eUISChk_TextOnRight
};

var array< delegate<LWCECheckboxOnToggle> > m_arrOnToggleHandlers;

var protectedwrite bool m_bIsChecked;
var protectedwrite bool m_bIsReadOnly;
var protectedwrite EUIStyle_Checkbox m_eCheckboxStyle;
var protectedwrite string m_strLabelText;

delegate LWCECheckboxOnToggle();

function Init()
{
    if (m_bIsInited)
    {
        return;
    }

    super.Init();

    // Hook in our onpress handler, which is responsible for invoking the UC delegates
    AS_SetOnPress(OnPress);

    SetChecked(m_bIsChecked);
    SetReadOnly(m_bIsReadOnly);
    SetTextStyle(m_eCheckboxStyle);

    SetLabel(m_strLabelText);
}

protected function OnPress()
{
    // Our code drives the state of the Flash movie
    SetChecked(!m_bIsChecked);
}

function SetChecked(bool bIsChecked)
{
    local delegate<LWCECheckboxOnToggle> del;

    if (m_bIsReadOnly)
    {
        // Can't just early return here; we might need to call AS_SetChecked
        // below in order to have the right visual state during initialization
        bIsChecked = m_bIsChecked;
    }

    m_bIsChecked = bIsChecked;

    if (m_bIsInited)
    {
        AS_SetChecked(m_bIsChecked);

        foreach m_arrOnToggleHandlers(del)
        {
            del();
        }
    }
}

function SetLabel(string strLabel)
{
    m_strLabelText = strLabel;

    if (m_bIsInited)
    {
        AS_SetLabel(m_strLabelText);
    }
}

function SetReadOnly(bool bIsReadOnly)
{
    m_bIsReadOnly = bIsReadOnly;

    if (m_bIsInited)
    {
        AS_SetReadOnly(m_bIsReadOnly);
    }
}

function SetTextStyle(EUIStyle_Checkbox eStyle)
{
    local int iStyle;

    m_eCheckboxStyle = eStyle;

    if (m_bIsInited)
    {
        iStyle = eStyle == eUISChk_TextOnLeft ? 0 : 1;

        AS_SetTextStyle(iStyle);
    }
}

protected function AS_SetChecked(bool bChecked)
{
	ActionScriptVoid("setChecked");
}

protected function AS_SetLabel(string txt)
{
	ActionScriptVoid("setLabel");
}

protected function AS_SetOnPress(delegate<LWCECheckboxOnToggle> del)
{
    ActionScriptSetFunction("release");
}

protected function AS_SetReadOnly(bool bReadOnly)
{
	ActionScriptVoid("setReadOnly");
}

protected function AS_SetTextStyle(int iStyle)
{
	ActionScriptVoid("setTextStyle");
}

defaultproperties
{
    m_bIsChecked=false
    m_bIsReadOnly=false
    m_eCheckboxStyle=eUISChk_TextOnLeft
}