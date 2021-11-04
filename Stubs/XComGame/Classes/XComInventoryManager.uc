class XComInventoryManager extends InventoryManager
    hidecategories(Navigation);
//complete stub

simulated function RemoveFromInventory(Inventory ItemToRemove);

simulated event DiscardInventory();

simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
    return none;
}
