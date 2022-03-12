class LWCE_UIMECInventory extends UIMECInventory;

simulated function OnBuildNewMec()
{
    LWCE_XGCyberneticsUI(GetMgr()).RepairAll();
}