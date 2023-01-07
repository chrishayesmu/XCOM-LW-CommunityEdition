class LWCE_XComAlienPodManager extends XComAlienPodManager;

simulated function int OvermindSpawn(int iSpawn)
{
    local int iNum, nSpawned, iPod;
    local LWCE_XGUnit kAlien;
    local Vector vLoc;
    local XComSpawnPoint_Alien kSpawnPt;
    local EPawnType eAlienType;
    local XComAlienPod kPod;
    local TAlienSpawn kSpawn;
    local array<ECharacter> arrPodMembers;
    local array<XGUnit> arrAlienList;
    local array<EItemType> arrAltWeapon;
    local bool bUseAltWeapon;

    if (iSpawn >= m_arrSpawnList.Length || iSpawn < 0)
    {
        return 0;
    }

    kSpawn = m_arrSpawnList[iSpawn];
    nSpawned = 0;
    kPod = kSpawn.kSpawnLoc;

    if (kPod != none)
    {
        arrPodMembers = GetPodCharArray(kSpawn.kPod, arrAltWeapon);
        kPod.NumAliens = arrPodMembers.Length;

        if (kSpawn.ePodDevice != eItem_NONE)
        {
            kPod.SetItemType(kSpawn.ePodDevice);
        }

        kPod.PreSpawnInit(true);
        iPod = m_arrPod.Length;
        m_arrPod.AddItem(kPod);
        `BATTLE.m_kLevel.AddPod(kPod);

        for (iNum = 0; iNum < kPod.NumAliens; iNum++)
        {
            kSpawnPt = kPod.GetSpawnPoint(iNum, vLoc, true);

            if (kSpawnPt != none)
            {
                kSpawnPt.SnapToGround(32.0);
                eAlienType = class'XGGameData'.static.MapCharacterToPawn(arrPodMembers[iNum]);
                bUseAltWeapon = (128 & kSpawn.kPod.eMainAltWeapon) != 0;
                kAlien = LWCE_XGUnit(m_kPlayer.SpawnAlien(eAlienType, kSpawnPt,,,, bUseAltWeapon));

                if (kAlien != none)
                {
                    // Only alien 0 can be a pod leader under normal circumstances
                    if (iNum == 0)
                    {
                        kAlien.InitUnitUpgrades(15 & kSpawn.kPod.eMainAltWeapon);
                    }
                    else
                    {
                        kAlien.InitUnitUpgrades(0);
                    }

                    kAlien.m_kBehavior.InitPod(iPod, kPod.m_bEnabled);

                    if (kPod.m_bEnabled)
                    {
                        kPod.AddAlien(kAlien);
                    }

                    arrAlienList.AddItem(kAlien);
                    nSpawned++;

                    if (m_bHasTerrorPods)
                    {
                        InitTerroristAlien(kAlien, iNum);
                    }

                    kAlien.m_kPod = kPod;
                    kPod.m_arrAlienSpawnPts.AddItem(kSpawnPt);
                }
                else
                {
                    kPod.m_aBadSpawnLoc.AddItem(vLoc);
                }
            }
            else
            {
                kPod.m_aBadSpawnLoc.AddItem(vLoc);
            }
        }

        kPod.PostSpawnInit();
        m_kPlayer.OnSpawn(iSpawn, arrAlienList);
    }

    return nSpawned;
}