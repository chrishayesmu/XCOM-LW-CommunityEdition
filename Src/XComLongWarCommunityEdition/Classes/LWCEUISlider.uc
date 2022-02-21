class LWCEUISlider extends LWCEUIWidget;

function float GetPercent()
{
    return GetFloat("percent");
}

function SetLabel(string strLabel)
{
    AS_SetLabel(strLabel);
}

function SetPercent(float fPercent)
{
    AS_SetValue(fPercent);
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{

}

protected function AS_SetLabel(string strLabel)
{
	ActionScriptVoid("setLabel");
}

protected function AS_SetValue(float fPercent)
{
	ActionScriptVoid("setValue");
}