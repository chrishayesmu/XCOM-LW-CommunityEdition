class LWCEUICombobox extends LWCEUIWidget;

function AddListItem(int id, string strLabel)
{
    AS_AddListItem(id, strLabel);
}

function SetButtonLabel(string strLabel)
{
    AS_SetButtonLabel(strLabel);
}

function SetButtonText(string strText)
{
    AS_SetButtonText(strText);
}

protected function AS_AddListItem(int id, string strLabel)
{
    ActionScriptVoid("AddListItem");
}

protected function AS_SetButtonLabel(string strText)
{
    ActionScriptVoid("setButtonLabel");
}

protected function AS_SetButtonText(string strText)
{
    ActionScriptVoid("setButtonText");
}