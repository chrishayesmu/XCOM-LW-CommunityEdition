class XComMecPawn extends XComHumanPawn
    config(Game);
//complete stub

var() XComMECSoundCollection MECSounds;
var EItemType m_ePreviewWeapon;

simulated function SetPreviewWeapon(XGGameData.EItemType eWeapon);
simulated function AddRequiredAnimSets(){}
simulated event PlayMECEventSound(AnimNotify_MEC.EMECEvent Event){}
simulated function AddKitRequests();

state InHQ{
    simulated event BeginState(name PreviousStateName){}
    simulated function SetInventory(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance){}
    simulated function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID){}

}
state CharacterCustomization{
    simulated event BeginState(name PreviousStateName){}
    simulated function SetInventory(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance){}
    function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID){}
    simulated function SetPreviewWeapon(EItemType eWeapon){}
    function ApplyPreviewMaterialToComponent(MeshComponent kComponent){}
}

state OffDuty{
    simulated event BeginState(name PreviousStateName){}
}
state MedalCeremony{
		    simulated event BeginState(name PreviousStateName){}   
}
