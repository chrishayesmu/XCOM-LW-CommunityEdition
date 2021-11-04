class XGInventory extends XGInventoryNativeBase
	notplaceable
    hidecategories(Navigation);
//complete stub

function int GetLocationCount(){}
function OnLoad(XGUnit kUnit){}
function ApplyInventoryOnLoad(){}
simulated function SetActiveWeapon(XGWeapon kWeapon){}
simulated function GetRearBackPackItemArray(out array<int> arrBackPackItemsReturned){}
simulated function XGInventoryItem GetRearBackpackItem(EItemType eTypeRequested){}
simulated function int GetNumClips(int iWeaponType){}
simulated function XGWeapon GetPrimaryWeapon(){}
simulated function XGWeapon GetSecondaryWeapon(){}
simulated function XGWeapon GetPrimaryWeaponForUI(){}
simulated function XGWeapon GetSecondaryWeaponForUI(){}
simulated function GetLargeItems(out array<XGWeapon> arrLargeItems){}
simulated function GetWeapons(out array<XGWeapon> arrWeapons){}
simulated function bool HasSomethingEquipped(ELocation eLoc){}
simulated function DetermineEngagementRange(){}
simulated function bool DropItem(XGInventoryItem kItem){}
simulated function bool EquipItem(XGInventoryItem kItem, bool bImmediate, optional bool bSkipEquipSlotChecks=FALSE){}
simulated function PresEquip(XGInventoryItem kItem, bool bImmediate){}
simulated function PresRemoveItem(XGInventoryItem kItem){}
simulated function bool UnequipItem(optional bool bOverrideWithRightSling=FALSE, optional bool bManualItemAttachToReservedSlot=FALSE){}
simulated function XGWeapon SearchForSecondaryWeapon(){}
simulated function bool HasItemOfType(EItemType anItemType){}
simulated function int GetNumItems(EItemType eItem){}
simulated function string ToString(){}
simulated function bool IsInitialReplicationComplete(){}
simulated function SetAllInventoryLightingChannels(bool bEnableDLE, LightingChannelContainer NewLightingChannel){}

defaultproperties
{
    bTickIsDisabled=true
}