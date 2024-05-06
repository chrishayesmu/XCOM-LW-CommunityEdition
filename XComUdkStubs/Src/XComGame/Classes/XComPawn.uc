class XComPawn extends GamePawn
    abstract
    native(Unit)
    config(Game)
    hidecategories(Navigation)
    implements(IMouseInteractionInterface,XComCoverInterface,IXComBuildingVisInterface);

var XComPawnIndoorOutdoorInfo IndoorInfo;
var XGCharacter m_kXGCharacter;
var bool bConsiderForCover;

defaultproperties
{
    InventoryManagerClass=class'XComInventoryManager'
}