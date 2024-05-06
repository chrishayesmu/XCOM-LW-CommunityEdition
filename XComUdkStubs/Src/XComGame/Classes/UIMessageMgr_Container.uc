class UIMessageMgr_Container extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

var int idCounter;
var array<UI_FxsMessageBox> Messages;

defaultproperties
{
    idCounter=-1
    s_name="messageVerticalContainer"
}