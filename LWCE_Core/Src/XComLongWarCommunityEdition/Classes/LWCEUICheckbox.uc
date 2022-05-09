class LWCEUICheckbox extends LWCEUIWidget;

enum EUIStyle_Checkbox
{
    eUISChk_TextOnLeft,
    eUISChk_TextOnRight
};

function SetChecked(bool bChecked)
{
    AS_SetChecked(bChecked);
}

function SetEnabled(bool bEnabled)
{
    if (bEnabled)
    {
        AS_Enable();
    }
    else
    {
        AS_Disable();
    }
}

function SetIcon(string strIconLabel)
{
    AS_SetIcon(strIconLabel);
}

function SetLabel(string strLabel)
{
    AS_SetLabel(strLabel);
}

function SetTextStyle(EUIStyle_Checkbox eStyle)
{
    local int iStyle;

    iStyle = eStyle == eUISChk_TextOnLeft ? 0 : 1;

    AS_SetTextStyle(iStyle);
}

function AS_Disable()
{
	ActionScriptVoid("disable");
}

function AS_Enable()
{
	ActionScriptVoid("enable");
}

protected function AS_SetChecked(bool bChecked)
{
	ActionScriptVoid("setChecked");
}

protected function AS_SetIcon(string strIconLabel)
{
	ActionScriptVoid("setIcon");
}

protected function AS_SetLabel(string strLabel)
{
	ActionScriptVoid("setLabel");
}

protected function AS_SetTextStyle(int iStyle)
{
	ActionScriptVoid("setTextStyle");
}