class HighlanderUIButton extends HighlanderUIWidget;

function SetStyle(int iNewStyle, optional float fFontSize = 20.0, optional bool bResizeToText = true)
{
    AS_SetStyle(iNewStyle, fFontSize, bResizeToText);
}

function SetLabel(string strNewText)
{
    AS_SetText(strNewText);
}

function SetHTMLText(string strNewText)
{
    AS_SetHTMLText(strNewText);
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

function SetIcon(string strIconLabel)
{
    AS_SetIcon(strIconLabel);
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