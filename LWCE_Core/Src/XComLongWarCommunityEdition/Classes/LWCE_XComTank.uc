class LWCE_XComTank extends XComTank;

var name m_nmPrimaryWeapon;

function LWCE_Init(const out LWCE_TInventory Inv)
{
    `LWCE_LOG_CLS("LWCE_Init: Inv.arrLargeItems[0] = " $ Inv.arrLargeItems[0] $ ", Inv.nmArmor = " $ Inv.nmArmor);

    m_bUnitContentLoaded = false;
    m_nmPrimaryWeapon = Inv.arrLargeItems[0];

    SetPhysics(PHYS_Flying);

    // TODO
    //PawnType = EPawnType(class'LWCE_XGBattleDesc'.static.LWCE_MapSoldierToPawn(Inv.nmArmor, eGender_None));
    //`CONTENTMGR.RequestContentArchetype(eContent_Unit, PawnType, -1, self, OnArmorLoaded, true);
}

simulated function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID)
{
    local XComTank PawnArchetype;
    local SkeletalMesh WeaponMesh;
    local SkeletalMeshActor NewWeapon;
    local MeshComponent FoundMeshComponent;
    local int MatIdx;
    local name SocketName;

    PawnArchetype = XComTank(ArmorArchetype);

    if (PawnArchetype.Mesh.SkeletalMesh != Mesh.SkeletalMesh)
    {
        Mesh.SetSkeletalMesh(PawnArchetype.Mesh.SkeletalMesh);

        for (MatIdx = 0; MatIdx < PawnArchetype.Mesh.Materials.Length; MatIdx++)
        {
            Mesh.SetMaterial(MatIdx, PawnArchetype.Mesh.Materials[MatIdx]);
        }

        Mesh.PrestreamTextures(10.0, true);
        Mesh.SetLightEnvironment(LightEnvironment);
        LightEnvironment.ResetEnvironment();
        CacheTreads();
    }

    WeaponMesh = `LWCE_CONTENT_MGR.GetWeaponSkeletalMesh(m_nmPrimaryWeapon);

    if (WeaponMesh != none)
    {
        NewWeapon = Spawn(class'SkeletalMeshActorSpawnable', self,,,,, true);
        NewWeapon.SkeletalMeshComponent.SetSkeletalMesh(WeaponMesh);
        SocketName = class'XGInventory'.default.m_SocketNames[eSlot_RightHand];
        AttachItem(NewWeapon, SocketName, false, FoundMeshComponent);
    }

    m_bUnitContentLoaded = true;
}