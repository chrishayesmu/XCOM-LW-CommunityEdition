class XGActionQueue extends Actor
    native(Action)
    notplaceable
    hidecategories(Navigation);

var protected array<XGAction> m_arrActions;
var array<string> m_arrActionLogging;

defaultproperties
{
    bTickIsDisabled=true
}