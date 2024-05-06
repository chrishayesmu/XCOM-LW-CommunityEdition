class UIWidgetHelper extends Actor
    notplaceable
    hidecategories(Navigation);

const INCREASE_VALUE = -1;
const DECREASE_VALUE = -2;

enum EUINavDirection
{
    eNavDir_None,
    eNavDir_Down,
    eNavDir_Up,
    eNavDir_MAX
};

var protected array<UIWidget> m_arrWidgets;
var int m_iCurrentWidget;
var string s_widgetName;
var string s_name;
var EUINavDirection m_eDirection;

defaultproperties
{
    s_widgetName="option"
    s_name=""widgetHelper.""
}