class XGItem extends Actor
    abstract
    native(Core)
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var bool m_bDamaged;
};

var protected EItemType m_eType;
var protected string m_strUIImage;
var bool m_bDamaged;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bTickIsDisabled=true
    bAlwaysRelevant=true
}