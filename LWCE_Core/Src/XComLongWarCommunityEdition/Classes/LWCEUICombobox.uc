class LWCEUICombobox extends LWCEUIWidget;

function AddListItem(int id, string strLabel)
{
    AS_AddListItem(id, strLabel);
}

function ClearList()
{
    AS_ClearList();
}

function Realize()
{
    AS_Realize();
}

function SetButtonLabel(string strLabel)
{
    AS_SetButtonLabel(strLabel);
    SetBool("_visible", true);
}

function SetButtonText(string strText)
{
    AS_SetButtonText(strText);
    AS_SetText(strText);
}

function SetSelectedItem(int Index)
{
    AS_SetFocus(string(Index));
}

protected function AS_AddListItem(float id, string strLabel)
{
    ActionScriptVoid("AddListItem");
}

protected function AS_ClearList()
{
    ActionScriptVoid("clearList");
}

protected function AS_Realize()
{
    ActionScriptVoid("realize");
}

protected function AS_SetButtonLabel(string strText)
{
    local ASValue myValue;
    local array<ASValue> myArray;
    //ActionScriptVoid("setButtonLabel");

    myValue.Type = AS_String;
    myValue.S = strText;
    myArray.AddItem(myValue);

    Invoke("setButtonLabel", myArray);
}

protected function AS_SetFocus(string strIndex)
{
    ActionScriptVoid("setFocus");
}

protected function AS_SetButtonText(string strText)
{
    ActionScriptVoid("setButtonText");
}

protected function AS_SetText(string strText)
{
    ActionScriptVoid("setText");
}