class LWCE_XGUnit extends XGUnit;

function int AbsorbDamage(const int IncomingDamage, XGUnit kDamageCauser, XGWeapon kWeapon)
{
    local float fAbsorptionFieldsBasis, fReturnDmg, fDist;
    local int iReturnDmg;

    fReturnDmg = float(IncomingDamage);

    // Apply the Damage Reduction stat
    if ((m_aCurrentStats[eStat_DamageReduction] % 100) > 0)
    {
        fReturnDmg = fReturnDmg - (float(m_aCurrentStats[eStat_DamageReduction] % 100) / float(10));
    }

    // Mind merge bonus DR (XCOM only)
    if (!IsAI() && m_iWillCheatBonus > 0)
    {
        fReturnDmg -= `LWCE_TACCFG(fMindMergeDRPerWill) * float(m_iWillCheatBonus);
    }

    // Damage Control
    if (m_kCharacter.HasUpgrade(ePerk_DamageControl) && m_iDamageControlTurns > 0 && fReturnDmg > 1.0)
    {
        fReturnDmg -= `LWCE_TACCFG(fDamageControlDRBonus);
    }

    // One for All bonus DR
    if (m_bOneForAllActive)
    {
        fReturnDmg -= `LWCE_TACCFG(fOneForAllDRBonus);
    }

    // Uber Ethereal bonus DR: 15 per remaining Ethereal in the level
    if (m_kCharacter.m_eType == ePawnType_EtherealUber)
    {
        foreach AllActors(class'XGUnit', m_kZombieVictim)
        {
            if (m_kZombieVictim.IsAliveAndWell() && m_kZombieVictim.m_kCharacter.m_eType == ePawnType_Elder)
            {
                fReturnDmg -= float(15);
            }
        }
    }

    // Combat stims damage multiplier
    if (GetAppliedAbility(eAbility_CombatStim) != none)
    {
        fReturnDmg *= `LWCE_TACCFG(fCombatStimsIncomingDamageMultiplier);
    }

    // Reduce melee damage for soldiers with Chitin Plating and for Chryssalids
    if (kWeapon != none)
    {
        if (kWeapon.IsMelee() || kWeapon.IsA('XGWeapon_MEC_KineticStrike'))
        {
            if (GetInventory() != none && GetInventory().GetRearBackpackItem(eItem_ChitinPlating) != none)
            {
                fReturnDmg *= `LWCE_TACCFG(fIncomingMeleeDamageMultiplierForChitinPlating);
            }
            else if (m_kCharacter.m_kChar.iType == eChar_Chryssalid)
            {
                fReturnDmg *= `LWCE_TACCFG(fIncomingMeleeDamageMultiplierForChryssalids);
            }
        }
    }

    // Psi Shield on Mechtoids provides DR
    if (GetShieldHP() > 0)
    {
        fReturnDmg *= `LWCE_TACCFG(fPsiShieldIncomingDamageMultiplier);
    }

    // Shock-Absorbent Armor if attacker within 4 tiles
    if (kDamageCauser != none && m_kCharacter.HasUpgrade(ePerk_ShockAbsorbentArmor))
    {
        fDist = VSize(GetLocation() - kDamageCauser.GetLocation());

        if (fDist <= `LWCE_TACCFG(fShockAbsorbentArmorRadius))
        {
            fReturnDmg *= `LWCE_TACCFG(fShockAbsorbentArmorIncomingDamageMultiplier);
        }
    }

    // Absorption Fields: X% DR of remaining damage greater than Y
    if (m_kCharacter.HasUpgrade(ePerk_AbsorptionFields))
    {
        if (fReturnDmg > `LWCE_TACCFG(fAbsorptionFieldsActivationThreshold))
        {
            fAbsorptionFieldsBasis = fReturnDmg - `LWCE_TACCFG(fAbsorptionFieldsActivationThreshold);
            fReturnDmg -= fAbsorptionFieldsBasis * `LWCE_TACCFG(fAbsorptionFieldsIncomingDamageMultiplier);
            m_bAbsorptionFieldsWorked = true;
        }
    }

    // Acid: negate percentage of DR, with a minimum value
    if (IsPoisoned())
    {
        fReturnDmg += FMax(`LWCE_TACCFG(fAcidMinimumDRRemoved),
                           `LWCE_TACCFG(fAcidDRRemovalPercentage) * (float(IncomingDamage) - fReturnDmg));
    }

    if (IsInCover())
    {
        if (!IsFlankedBy(kDamageCauser) || (kWeapon != none && kWeapon.IsA('XGWeapon_NeedleGrenade')))
        {
            fDist = fReturnDmg;

            // Base DR bonus from being in cover
            if (IsInLowCover())
            {
                fReturnDmg -= `LWCE_TACCFG(fLowCoverDRBonus);
            }
            else
            {
                fReturnDmg -= `LWCE_TACCFG(fHighCoverDRBonus);
            }

            // Doubled cover DR bonus if hunkered
            if (IsHunkeredDown())
            {
                if (IsInLowCover())
                {
                    fReturnDmg -= `LWCE_TACCFG(fLowCoverDRBonus);
                }
                else
                {
                    fReturnDmg -= `LWCE_TACCFG(fHighCoverDRBonus);
                }
            }

            // Will to Survive DR
            if (m_kCharacter.HasUpgrade(ePerk_WillToSurvive))
            {
                fReturnDmg -= `LWCE_TACCFG(fWillToSurviveDRBonus);
            }

            // Fortiores Una
            if (m_kCharacter.HasUpgrade(`LW_PERK_ID(FortioresUna)) && HasBonus(170))
            {
                if (IsInLowCover())
                {
                    fReturnDmg -= `LWCE_TACCFG(fLowCoverDRBonus);
                }
                else
                {
                    fReturnDmg -= `LWCE_TACCFG(fHighCoverDRBonus);
                }
            }
        }
    }

    if (kDamageCauser != none)
    {
        // Combined Arms: negate 1 DR
        if (kDamageCauser.m_kCharacter.HasUpgrade(`LW_PERK_ID(CombinedArms)))
        {
            fReturnDmg += `LWCE_TACCFG(fCombinedArmsDRPenetration);
        }

        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kDamageCauser.m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(ArmorPiercingAmmo)))
        {
            if (kWeapon != none && !kWeapon.HasProperty(eWP_Assault) && !kWeapon.HasProperty(eWP_Pistol))
            {
                fReturnDmg += 2.0; // TODO: configure this value on the item itself
            }
        }

        if (kWeapon != none)
        {
            if (class'XGTacticalGameCore'.static.GetWeaponClass(kWeapon.ItemType()) == 3) // Gauss tier weapon
            {
                fReturnDmg += `LWCE_TACCFG(fGaussWeaponsDRPenetration);

                if ((kDamageCauser.m_kCharacter.m_kChar.aUpgrades[123] & 32) > 0) // Quenchguns
                {
                    fReturnDmg += `LWCE_TACCFG(fQuenchgunsDRPenetration);
                }
            }
        }

        fReturnDmg = FMin(fReturnDmg, float(IncomingDamage));
    }

    if (fReturnDmg < float(IncomingDamage))
    {
        if (kDamageCauser != none)
        {
            if (kWeapon != none && kWeapon.HasProperty(eWP_Assault))
            {
                // DR penalty for shotguns unless using Breaching Ammo
                if (!class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kDamageCauser.m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(BreachingAmmo)))
                {
                    fReturnDmg -= (`LWCE_TACCFG(fShotgunDRPenalty) * (float(IncomingDamage) - fReturnDmg));
                }
            }
        }

        fReturnDmg = FMax(fReturnDmg, float(0));

        if (kWeapon != none && kWeapon.IsA('XGWeapon_MEC_KineticStrike'))
        {
            iReturnDmg = FFloor(fReturnDmg);
        }
        else if (FRand() < (fReturnDmg - float(FFloor(fReturnDmg))))
        {
            iReturnDmg = FCeil(fReturnDmg);
        }
        else if (IncomingDamage == 12345)
        {
            // This is some special case that I don't even want to start digging into
            iReturnDmg = FCeil(fReturnDmg);
        }
        else
        {
            iReturnDmg = FFloor(fReturnDmg);
        }

        // Record the amount of DR for display later
        if (IncomingDamage - iReturnDmg > 0)
        {
            m_bCantBeHurt = IncomingDamage - iReturnDmg;
        }

        return iReturnDmg;
    }

    return IncomingDamage;
}

function AddCriticallyWoundedAction(optional bool bStunAlien = false, optional bool bLoading = false)
{
    local XGAction_CriticallyWounded kAction;
    local XGAIPlayer kAI;

    if (!bLoading)
    {
        if (!bStunAlien && IsAlien_CheckByCharType())
        {
            return;
        }

        if (m_bCriticallyWounded || (m_kCurrAction != none && m_kCurrAction.IsA('XGAction_CriticallyWounded')))
        {
            return;
        }
    }

    if (IsMoving())
    {
        m_kActionQueue.Clear(true, false);
    }

    m_bCriticallyWounded = true;
    kAI = XGAIPlayer(`BATTLE.GetAIPlayer());

    if (kAI != none)
    {
        kAI.OnCriticalWound(self);
    }

    if (bStunAlien)
    {
        m_bStunned = true;
        m_bStabilized = true;

        if (m_kCharacter.m_kChar.iType == eChar_Outsider)
        {
            LWCE_XGBattleDesc(`BATTLE.m_kDesc).m_kArtifactsContainer.AdjustQuantity(`LW_ITEM_ID(OutsiderShard), 1);
            PRES().UINarrative(`XComNarrativeMoment("OutsiderShardFirstSeen"));
        }

        // LWCE issue #7: if the last visible enemy is stunned instead of killed, combat music will continue playing.
        // This fix simply stops the music in that case.
        if (ShouldStopCombatMusicAfterBeingStunned())
        {
            XComTacticalSoundManager(XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetSoundManager()).StopCombatMusic();
        }
    }

    kAction = Spawn(class'XGAction_CriticallyWounded', Owner);
    kAction.Init(self, bLoading);

    if (bLoading && !m_bStabilized)
    {
        `PRES.MSGBleedingOut(self);
    }

    AddAction(kAction);
}

simulated function AddWeaponAbilities(XGTacticalGameCoreNativeBase GameCore, Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly = false)
{
    local int Index, iAbilityId, iBackpackIndex;
    local LWCE_XGInventory kInventory;
    local XGCharacter kChar;
    local XGWeapon kWeapon, kActiveWeapon;
    local array<XGWeapon> arrWeapons, arrEquippableWeapons;

    kChar = m_kCharacter;
    kInventory = LWCE_XGInventory(m_kInventory);

    if (kChar.HasUpgrade(`LW_PERK_ID(SmokeGrenade)) && !kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(SmokeGrenade)))
    {
        kWeapon = Spawn(class'XGWeapon_SmokeGrenade', self, /* SpawnTag */, /* SpawnLocation */, /* SpawnRotation */, /* ActorTemplate */, /* bNoCollisionFail */ true);
        kWeapon.Init();

        m_kInventory.AddItem(kWeapon, eSlot_RearBackPack, /* bMultipleItems */ true);

        if (WorldInfo.NetMode != NM_Standalone && Role == ROLE_Authority)
        {
            m_kDynamicSpawnedSmokeGrenade.m_kDynamicSpawnWeapon = kWeapon;
            m_kDynamicSpawnedSmokeGrenade.m_eDynamicSpawnWeaponSlotLocation = eSlot_RearBackPack;
        }
    }

    if (kChar.HasUpgrade(`LW_PERK_ID(BattleScanner)) && !kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(BattleScanner)))
    {
        kWeapon = Spawn(class'XGWeapon_BattleScanner', self, /* SpawnTag */, /* SpawnLocation */, /* SpawnRotation */, /* ActorTemplate */, /* bNoCollisionFail */ true);
        kWeapon.Init();

        m_kInventory.AddItem(kWeapon, eSlot_RearBackPack, /* bMultipleItems */ true);

        if (WorldInfo.NetMode != NM_Standalone && Role == ROLE_Authority)
        {
            m_kDynamicSpawnedBattleScanner.m_kDynamicSpawnWeapon = kWeapon;
            m_kDynamicSpawnedBattleScanner.m_eDynamicSpawnWeaponSlotLocation = eSlot_RearBackPack;
        }
    }

    kWeapon = XGWeapon(kInventory.FindItemByEnum(`LW_ITEM_ID(Medikit)));

    if (kWeapon != none)
    {
        if (kChar.HasUpgrade(`LW_PERK_ID(Revive)))
        {
            iAbilityId = eAbility_Revive;
        }
        else
        {
            iAbilityId = eAbility_Stabilize;
        }

        GenerateAbilities(iAbilityId, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
    }

    kActiveWeapon = kInventory.GetActiveWeapon();

    for (Index = 0; Index < eSlot_MAX; Index++)
    {
        if (Index == eSlot_RearBackPack)
        {
            for (iBackpackIndex = 0; iBackpackIndex < kInventory.GetNumberOfItemsInSlot(eSlot_RearBackPack); iBackpackIndex++)
            {
                kWeapon = XGWeapon(kInventory.GetItemByIndexInSlot(iBackpackIndex, eSlot_RearBackPack));

                if (kWeapon == none)
                {
                    continue;
                }

                // Skip reloadable weapons that are out of ammo
                if (kWeapon.iAmmo == 0 && kWeapon.m_kTWeapon.aProperties[eWP_NoReload] != 0)
                {
                    continue;
                }

                // Skip overheated weapons
                if (kWeapon.iOverheatChance == 100 && kWeapon.m_kTWeapon.aProperties[eWP_Overheats] != 0)
                {
                    continue;
                }

                if (kWeapon.m_kTWeapon.aProperties[eWP_Secondary] != 0)
                {
                    arrWeapons.AddItem(kWeapon);
                }
                else
                {
                    arrEquippableWeapons.AddItem(kWeapon);
                }
            }
        }
        else
        {
            kWeapon = XGWeapon(kInventory.GetItem(ELocation(Index)));

            if (kWeapon == none)
            {
                continue;
            }

            if (kWeapon == kActiveWeapon)
            {
                // TODO: the active weapon might belong at the front of the array
                arrWeapons.AddItem(kWeapon);
            }
            else if (kWeapon.m_kTWeapon.aProperties[eWP_Secondary] != 0)
            {
                arrWeapons.AddItem(kWeapon);
            }
            else
            {
                arrEquippableWeapons.AddItem(kWeapon);
            }
        }
    }

    foreach arrWeapons(kWeapon)
    {
        if (kWeapon.m_kTWeapon.aProperties[eWP_Sniper] != 0)
        {
            if (kChar.HasUpgrade(`LW_PERK_ID(PrecisionShot)))
            {
                GenerateAbilities(eAbility_PrecisionShot, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (kChar.HasUpgrade(`LW_PERK_ID(DisablingShot)))
            {
                GenerateAbilities(eAbility_DisablingShot, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }
        }

        if (kWeapon.WeaponHasStandardShot())
        {
            // No idea what these two character types are for, maybe some kind of debug
            if (kChar.HasUpgrade(`LW_PERK_ID(Suppression)) || kChar.m_kChar.iType == 67 || kChar.m_kChar.iType == 63)
            {
                if (kWeapon.m_kTWeapon.aProperties[eWP_Pistol] == 0)
                {
                    iAbilityID = kChar.HasUpgrade(`LW_PERK_ID(Mayhem)) ? eAbility_ShotMayhem : eAbility_ShotSuppress;

                    GenerateAbilities(iAbilityID, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
                }
            }

            if (kChar.HasUpgrade(`LW_PERK_ID(RapidFire)))
            {
                GenerateAbilities(eAbility_RapidFire, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (kChar.HasUpgrade(`LW_PERK_ID(Flush)) && kWeapon.m_kTWeapon.aProperties[eWP_Secondary] == 0)
            {
                GenerateAbilities(eAbility_ShotFlush, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (kChar.HasUpgrade(`LW_PERK_ID(CollateralDamage)))
            {
                GenerateAbilities(eAbility_MEC_Barrage, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }
        }

        // Deliberately using enums here and not LongWarConstants, because the item named Rocket Launcher in the constants
        // isn't actually the same item that the native code would be looking for
        if (kWeapon.GameplayType() == eItem_RocketLauncher || kWeapon.GameplayType() == eItem_BlasterLauncher)
        {
            if (kChar.HasUpgrade(`LW_PERK_ID(ShredderAmmo)))
            {
                GenerateAbilities(eAbility_ShredderRocket, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (kChar.HasUpgrade(`LW_PERK_ID(FireRocket)))
            {
                GenerateAbilities(eAbility_RocketLauncher, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }
        }

        if (kWeapon.GameplayType() == eItem_ArcThrower)
        {
            if (kChar.HasUpgrade(`LW_PERK_ID(DroneCapture)))
            {
                GenerateAbilities(eAbility_ShotDroneHack, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (kChar.HasUpgrade(`LW_PERK_ID(FieldRepairs)))
            {
                GenerateAbilities(eAbility_RepairSHIV, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }
        }

        // In the base native code, there's a check for the SHIV Suppression perk here; however in Long War, that perk ID is
        // repurposed and SHIVs just get the regular Suppression check, so that check is omitted.


        // Look at abilities from the weapon's configuration
        for (Index = 1; Index < 96; Index++)
        {
            if (kWeapon.m_kTWeapon.aAbilities[Index] <= 0)
            {
                continue;
            }

            if (AbilityIsInList(Index, arrAbilities))
            {
                continue;
            }

            GenerateAbilities(Index, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
        }

        // Lastly, check if we need to reload
        if (kWeapon.iAmmo < 100 && kWeapon.m_kTWeapon.aProperties[eWP_NoReload] == 0)
        {
            GenerateAbilities(eAbility_Reload, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
        }
    }

    // Loop the other array of weapons and generate eAbility_EquipWeapon for them
    foreach arrEquippableWeapons(kWeapon)
    {
        GenerateAbilities(eAbility_EquipWeapon, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
    }
}

function ApplyInventoryStatModifiers()
{
    local EItemType eWeapon_GameplayType;
    local XGInventory kInventory;
    local XGWeapon kWeapon;
    local array<int> arrBackPackItems;

    eWeapon_GameplayType = eItem_None;
    kInventory = GetInventory();

    if (kInventory != none)
    {
        kWeapon = kInventory.GetActiveWeapon();

        if (kWeapon != none)
        {
            eWeapon_GameplayType = kWeapon.ItemType();
        }
    }

    `GAMECORE.GetBackpackItemArray(m_kCharacter.m_kChar.kInventory, arrBackPackItems);
    m_aCurrentStats[9] = m_aCurrentStats[eStat_HP];
    RemoveStatModifiers(m_aInventoryStats);

    `LWCE_GAMECORE.LWCE_GetInventoryStatModifiers(m_aInventoryStats, m_kCharacter.m_kChar, eWeapon_GameplayType, arrBackPackItems);

    if (m_iWillCheatBonus > 0 && IsAI())
    {
        m_aInventoryStats[eStat_HP] += (1 + (m_iWillCheatBonus / 25));
    }

    if (m_iWillCheatBonus > 0)
    {
        m_aInventoryStats[eStat_Will] += (0 + (m_iWillCheatBonus / 10));
    }

    AddStatModifiers(m_aInventoryStats);

    if (m_iWillCheatBonus < 0)
    {
        if (IsAI())
        {
            m_aCurrentStats[eStat_HP] = m_aCurrentStats[9];
            SetUnitHP(m_aCurrentStats[eStat_HP]);
        }
        else if (m_aCurrentStats[eStat_HP] <= 0)
        {
            SetUnitHP(1);
        }
        else
        {
            SetUnitHP(m_aCurrentStats[eStat_HP]);
        }
    }

    m_aCurrentStats[9] = 0;
    SetUnitHP(Min(GetUnitHP(), GetUnitMaxHP()));
    m_aInventoryStats[3] += m_iCovertOpKills;
}

simulated function ApplyLoadout(XGLoadoutInstances kLoadoutInstances, bool bLoadFromCheckpoint)
{
    local int I, J;
    local XGInventoryItem kItemToEquip, kItem;
    local XGInventory kInventory;
    local array<XGWeapon> Weapons;
    local bool bLoadoutIsNew;

    bLoadoutIsNew = (m_kLoadoutInstances != kLoadoutInstances) || (WorldInfo.NetMode != NM_Standalone);
    m_kLoadoutInstances = kLoadoutInstances;
    m_kLoadoutInstances.m_kUnit = self;

    if (Role == ROLE_Authority && GetInventory() == none)
    {
        kInventory = Spawn(class'LWCE_XGInventory', Owner);
        SetInventory(kInventory);
        kInventory.PostInit();
    }

    kInventory = GetInventory();

    if (kInventory != none)
    {
        for (I = 0; I < eSlot_MAX; I++)
        {
            if (I == eSlot_RearBackPack)
            {
                for (J = 0; J < m_kLoadoutInstances.m_iNumBackpackItems; J++)
                {
                    kItem = m_kLoadoutInstances.m_aBackpackItems[J];

                    if (kItem != none)
                    {
                        if (!bLoadoutIsNew)
                        {
                            kItem.Init();
                        }

                        if (bLoadFromCheckpoint)
                        {
                            kItem.m_kEntity = kItem.CreateEntity();
                        }

                        kInventory.AddItem(kItem, eSlot_RearBackPack, true);
                    }
                }
            }
            else
            {
                if (m_kLoadoutInstances.m_aItems[I] != none)
                {
                    kItem = m_kLoadoutInstances.m_aItems[I];

                    if (!bLoadoutIsNew)
                    {
                        kItem.Init();
                    }

                    if (bLoadFromCheckpoint)
                    {
                        kItem.m_kEntity = kItem.CreateEntity();
                    }
                    else if (kItem.m_kEntity != none)
                    {
                        m_kPawn.UpdateMeshMaterials(XComWeapon(kItem.m_kEntity).Mesh);
                    }

                    kInventory.AddItem(kItem, ELocation(I));
                }
            }
        }

        if (bLoadoutIsNew)
        {
            kInventory.CalculateWeaponToEquip();

            if (m_kCharacter.m_kChar.iType == eChar_Soldier && m_kCharacter.m_kChar.eClass == 6)
            {
                kInventory.GetLargeItems(Weapons);

                for (I = 0; I < Weapons.Length; I++)
                {
                    kInventory.EquipItem(Weapons[I], true, true);
                }

                kInventory.SetActiveWeapon(Weapons[0]);
            }
            else if (kInventory.m_kPrimaryWeapon != none)
            {
                kItemToEquip = kInventory.m_kPrimaryWeapon;
            }
            else if (kInventory.m_kSecondaryWeapon != none)
            {
                kItemToEquip = kInventory.m_kSecondaryWeapon;
            }

            if (kItemToEquip != none)
            {
                kInventory.EquipItem(kItemToEquip, true, true);
            }
        }
    }

    ProcessNewPosition();

    if (WorldInfo.NetMode == NM_Client)
    {
        kLoadoutInstances.ServerDestroy();
    }
    else if (WorldInfo.NetMode == NM_Standalone)
    {
        kLoadoutInstances.Destroy();
    }

    if (GetPawn().IsA('XComHumanPawn') && !IsCivilian())
    {
        XComHumanPawn(GetPawn()).AttachKit();
    }

    if (!bLoadFromCheckpoint)
    {
        LoadoutChanged_UpdateModifiers();

        if (WorldInfo.NetMode == NM_Standalone)
        {
            BuildAbilities();
        }
    }
}

function BuildAbilities(optional bool bUpdateUI = true)
{
    local bool bShouldBuild;
    local int Index;
    local Vector vLocation;
    local array<XGAbility> arrAbilities;
    local XGTacticalGameCore kGameCore;

    bShouldBuild = true;
    kGameCore = `GAMECORE;

    if (Role < ROLE_Authority)
    {
        return;
    }

    if (`WORLDINFO.NetMode != NM_Standalone)
    {
        // TODO: add this if we want multiplayer support
    }

    if (!m_bBuildAbilityDataDirty)
    {
        return;
    }

    if (!bShouldBuild)
    {
        return;
    }

    m_iBuildAbilityNotifier++;
    bNetDirty = true;
    bForceNetUpdate = true;
    m_bBuildAbilityDataDirty = false;

    ClearAbilities();

    if (m_kPawn != none)
    {
        vLocation = m_kPawn.Location;
    }

    AddMoveAbilities(kGameCore, arrAbilities);
    AddWeaponAbilities(kGameCore, vLocation, arrAbilities);
    AddPerkSpecificAbilities(kGameCore, arrAbilities);

    // Not entirely sure about the order on these three
    AddPsiAbilities(vLocation, arrAbilities);
    AddCharacterAbilities(vLocation, arrAbilities);
    AddArmorAbilities(vLocation, arrAbilities);

    // Remove any abilities which shouldn't be shown and are unavailable (doesn't matter for AI)
    if (!IsAI())
    {
        for (Index = arrAbilities.Length - 1; Index >= 0; Index--)
        {
            if (arrAbilities[Index].aDisplayProperties[eDisplayProp_HideUnavailable] != 0 && !arrAbilities[Index].CheckAvailable())
            {
                arrAbilities[Index].Destroy();
                arrAbilities.Remove(Index, 1);
            }
        }
    }

    // Reset m_aAbilities
    for (Index = 0; Index < 64; Index++)
    {
        m_aAbilities[Index] = none;
    }

    for (Index = 0; Index < arrAbilities.Length; Index++)
    {
        m_aAbilities[Index] = arrAbilities[Index];
    }

    m_iNumAbilities = arrAbilities.Length;

    // This part isn't in the native code; in fact I can't find reference to bUpdateUI at all.
    // But our version doesn't work without it.
    if (bUpdateUI)
    {
        UpdateAbilitiesUI();
    }
}

simulated function bool CanTakeDamage()
{
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return false;
    }

    return super.CanTakeDamage();
}

function CheckForDamagedItems()
{
    local int I, iWeaponFragments;
    local XGInventoryItem kWeapon;
    local EItemType eWeapon;

    if (m_bWasKilledByExplosion)
    {
        if (!IsMine() && IsAlien() && !IsExalt())
        {
            `BATTLE.m_kDesc.m_kDropShipCargoInfo.m_bAlienDiedByExplosive = true;
        }
    }

    for (I = 0; I < eSlot_MAX; I++)
    {
        kWeapon = GetInventory().GetItem(ELocation(I));

        if (kWeapon == none)
        {
            continue;
        }

        eWeapon = kWeapon.GameplayType();

        if (eWeapon == 0)
        {
            eWeapon = kWeapon.ItemType();
        }

        if (!IsMine() && !m_bWasKilledByExplosion)
        {
            iWeaponFragments = `GAMECORE.GenerateWeaponFragments(eWeapon);

            if (iWeaponFragments > 0)
            {
                PRES().MSGWeaponFragments(`LWCE_TWEAPON_FROM_XG(XGWeapon(kWeapon)).strName, iWeaponFragments);
                LWCE_XGBattleDesc(`BATTLE.m_kDesc).m_kArtifactsContainer.AdjustQuantity(`LW_ITEM_ID(WeaponFragment), iWeaponFragments);
                kWeapon.m_bDamaged = true;
            }
        }

        if (m_bWasKilledByExplosion)
        {
            kWeapon.m_bDamaged = true;

            if (IsExalt() && WorldInfo.NetMode == NM_Standalone)
            {
                if (eWeapon > 211 && eWeapon < 219)
                {
                    PRES().MSGItemDestroyed(`LWCE_TWEAPON_FROM_XG(XGWeapon(kWeapon)).strName);
                }
            }
        }
    }
}

simulated function DebugCoverActors(XComTacticalCheatManager kCheatManager)
{
    local LWCE_XGTacticalGameCore kGameCore;
    local XGInventoryItem kItem;
    local int iItemIndex, iSlotIndex;

    kGameCore = `LWCE_GAMECORE;

    for (iSlotIndex = 0; iSlotIndex < eSlot_MAX; iSlotIndex++)
    {
        for (iItemIndex = 0; iItemIndex < GetInventory().GetNumberOfItemsInSlot(ELocation(iSlotIndex)); iItemIndex++)
        {
            kItem = GetInventory().GetItemByIndexInSlot(iItemIndex, ELocation(iSlotIndex));

            if (kItem != none)
            {
                if (kGameCore.WeaponHasProperty(kItem.ItemType(), eWP_Pistol))
                {
                    kItem.m_eReservedSlot = eSlot_RightThigh;
                }
                else if (kGameCore.WeaponHasProperty(kItem.ItemType(), eWP_Heavy))
                {
                    kItem.m_eReservedSlot = eSlot_LeftBack;
                }
                else if (kGameCore.WeaponHasProperty(kItem.ItemType(), eWP_Mec))
                {
                    kItem.m_eReservedSlot = ELocation(iSlotIndex);
                }
                else if (kGameCore.LWCE_GetTWeapon(kItem.ItemType()).iSize == 1)
                {
                    kItem.m_eReservedSlot = eSlot_RightBack;
                }
                else
                {
                    kItem.m_eReservedSlot = ELocation(iSlotIndex);
                }
            }
        }
    }
}

simulated function DrawRangesForMedikit(optional bool bDetach = true)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local LWCE_TWeapon kMedikit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;

    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(Medikit)))
    {
        return;
    }

    if (GetMediKitCharges() > 0)
    {
        kSquad = GetSquad();
        kMedikit = `LWCE_GAMECORE.LWCE_GetTWeapon(`LW_ITEM_ID(Medikit));
        fRadius = float(kMedikit.iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit != self && kUnit.CanBeHealedWithMedikit() && kUnit.IsVisible() && !kUnit.IsDead() && kUnit.GetPawn() != none && !`GAMECORE.CharacterHasProperty(kUnit.m_kCharacter.m_kChar.iType, eCP_Robotic))
            {
                kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().MedikitRing);
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function DrawRangesForRevive(optional bool bDetach = true)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;

    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(Medikit)))
    {
        return;
    }

    if (GetMediKitCharges() > 0)
    {
        kSquad = GetSquad();
        fRadius = float(`GAMECORE.m_kAbilities.GetTAbility(eAbility_Stabilize).iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit != self && !kUnit.IsDead() && kUnit.IsVisible() && kUnit.GetPawn() != none && kUnit.IsCriticallyWounded() && !`GAMECORE.CharacterHasProperty(kUnit.m_kCharacter.m_kChar.iType, eCP_Robotic))
            {
                kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().MedikitRing);
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function DrawRangesForRepairSHIV(optional bool bDetach)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;
    local XGWeapon kItem;
    local bool bHasRepair;

    bDetach = true;
    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(ArcThrower)))
    {
        return;
    }

    if (GetArcThrowerCharges() > 0)
    {
        kItem = XGWeapon(kInventory.FindItemByEnum(`LW_ITEM_ID(ArcThrower)));
        bHasRepair = false;

        for (I = 0; I < class'XGWeapon'.const.NUM_WEAP_ABILITIES; I++)
        {
            if (kItem.aAbilities[I] == eAbility_RepairSHIV)
            {
                bHasRepair = true;
                break;
            }
        }

        if (!bHasRepair)
        {
            return;
        }

        kSquad = GetSquad();
        fRadius = float(`GAMECORE.m_kAbilities.GetTAbility(eAbility_RepairSHIV).iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit != self
              && (`GAMECORE.CharacterHasProperty(kUnit.m_kCharacter.m_kChar.iType, eCP_Robotic) || kUnit.IsAugmented())
              && kUnit.GetUnitHP() < kUnit.GetUnitMaxHP()
              && kUnit.IsVisible()
              && !kUnit.IsDead()
              && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().MedikitRing);
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function DrawRangesForShotStun(optional XCom3DCursor kCursor = none, optional bool bDetach = true)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;

    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(ArcThrower)))
    {
        return;
    }

    if (GetArcThrowerCharges() > 0)
    {
        kSquad = `BATTLE.GetEnemyPlayer(GetPlayer()).GetSquad();

        // FIXME: Not sure why this is using eAbility_RepairSHIV instead of eAbility_ShotStun. They probably match in the
        // base game, but we should change this at some point for clarity's sake and easier modding.
        fRadius = float(`GAMECORE.m_kAbilities.GetTAbility(eAbility_RepairSHIV).iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (`GAMECORE.CanBeStunned(kUnit) && kUnit.IsVisible() && kUnit.IsAliveAndWell() && kUnit.GetPawn() != none)
            {
                if (kCursor == none || VSize(kCursor.Location - kUnit.GetPawn().Location) <= float(400))
                {
                    kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().ArcThrowerRing);
                }
                else if (bDetach)
                {
                    kUnit.GetPawn().DetachRangeIndicator();
                }
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function DrawRangesForDroneHack(optional XCom3DCursor kCursor = none, optional bool bDetach = true)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;
    local bool bHasHack;
    local XGWeapon kItem;

    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(ArcThrower)))
    {
        return;
    }

    if (GetArcThrowerCharges() > 0)
    {
        kItem = XGWeapon(kInventory.FindItemByEnum(`LW_ITEM_ID(ArcThrower)));
        bHasHack = false;

        for (I = 0; I < class'XGWeapon'.const.NUM_WEAP_ABILITIES; I++)
        {
            if (kItem.aAbilities[I] == eAbility_ShotDroneHack)
            {
                bHasHack = true;
                break;
            }
        }

        if (!bHasHack)
        {
            return;
        }

        kSquad = `BATTLE.GetEnemyPlayer(GetPlayer()).GetSquad();
        fRadius = float(`GAMECORE.m_kAbilities.GetTAbility(eAbility_ShotDroneHack).iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit.m_kCharacter.m_kChar.iType == eChar_Drone && kUnit.IsVisible() && kUnit.IsAliveAndWell() && kUnit.GetPawn() != none)
            {
                if (kCursor == none || VSize(kCursor.Location - kUnit.GetPawn().Location) <= float(400))
                {
                    kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().ArcThrowerRing);
                }
                else if (bDetach)
                {
                    kUnit.GetPawn().DetachRangeIndicator();
                }
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function GenerateAbilities(int iAbility, Vector vLocation, out array<XGAbility> arrAbilities, optional XGWeapon kWeapon, optional bool bForLocalUseOnly = false)
{
    // Based on reconstruction of the native GenerateAbilities
    local bool bIsPsionic, bIsValidTarget, bHasCustomRange, bTargetIsCriticallyWounded, bTargetNonRobotic, bTargetRobotic;
    local float fCustomRange;
    local int Index;
    local EAbilityRange eRange;
    local TAbility kTAbility;
    local XGAbility kAbility;
    local XGAbilityTree kAbilityTree;
    local XGTacticalGameCore kGameCore;
    local array<XGUnitNativeBase> arrPotentialTargets;
    local array<XGUnit> arrActualTargets;

    fCustomRange = 0.0;
    kGameCore = `GAMECORE;
    kAbilityTree = kGameCore.m_kAbilities;
    kTAbility = kAbilityTree.GetTAbility(iAbility);
    eRange = EAbilityRange(kTAbility.iRange);

    if (GenerateAbilities_CheckForFlyAbility(iAbility, arrAbilities, kGameCore))
    {
        return;
    }

    if (GenerateAbilities_CheckForCloseAbility(iAbility, arrAbilities, kGameCore))
    {
        return;
    }

    bIsPsionic = kAbilityTree.AbilityHasProperty(iAbility, eProp_Psionic);
    bHasCustomRange = kAbilityTree.AbilityHasProperty(iAbility, eProp_CustomRange);
    bTargetNonRobotic = kAbilityTree.AbilityHasProperty(iAbility, eProp_TargetNonRobotic);
    bTargetRobotic = kAbilityTree.AbilityHasProperty(iAbility, eProp_TargetRobotic);

    if (bIsPsionic)
    {
        bTargetNonRobotic = true;
    }

    if (bHasCustomRange)
    {
        fCustomRange = 64.0 * kTAbility.iRange;
    }

    if (iAbility == eAbility_ShotStandard && IsMeleeOnly())
    {
        eRange = eRange_Weapon;
    }

    if (kWeapon != none && kWeapon.m_kTWeapon.aProperties[eWP_Sniper] != 0 && eRange == eRange_Sight && m_kCharacter.HasUpgrade(`LW_PERK_ID(Squadsight)))
    {
        eRange = eRange_Squadsight;
    }

    GetTargetsInRange(kTAbility.iTargetType, eRange, arrPotentialTargets, vLocation, kWeapon, fCustomRange, /* bNoLOSRequired */ false, bTargetNonRobotic, bTargetRobotic, iAbility);

    for (Index = arrPotentialTargets.Length - 1; Index >=  0; Index--)
    {
        // Don't allow suppressing targets that aren't activated yet
        if (arrPotentialTargets[Index].m_kBehavior != none && arrPotentialTargets[Index].m_kBehavior.IsDormant(/* bFalseIfActivating */ false) && kAbilityTree.AbilityHasEffect(iAbility, eEffect_Suppression))
        {
            bIsValidTarget = false;
        }
        else
        {
            bIsValidTarget = true;
        }

        if (arrPotentialTargets[Index].m_bStunned || !bIsValidTarget)
        {
            arrPotentialTargets.Remove(Index, 1);
        }
        else
        {
            arrActualTargets.AddItem(XGUnit(arrPotentialTargets[Index]));
        }
    }

    if (kTAbility.iTargetType == eTarget_MultipleAllies ||
        kTAbility.iTargetType == eTarget_MultipleEnemies ||
        kTAbility.iTargetType == eTarget_SectoidAllies ||
        kTAbility.iTargetType == eTarget_MutonAllies)
    {
        // Abilities that target multiple things: just create the ability once, with all targets
        kAbility = kAbilityTree.SpawnAbility(iAbility, self, arrActualTargets, kWeapon, /* kMiscActor */ none, bForLocalUseOnly, /* bReactionFire */ false);
        arrAbilities.AddItem(kAbility);
    }
    else
    {
        arrActualTargets.Length = 1;

        for (Index = 0; Index < arrPotentialTargets.Length; Index++)
        {
            // TODO: not sure why this isn't just checked at the start of the function
            if (m_kCharacter.m_kChar.aUpgrades[ePerk_Revive] != 0 && kTAbility.iType == eAbility_Stabilize)
            {
                continue;
            }

            bTargetIsCriticallyWounded = arrPotentialTargets[Index].IsCriticallyWounded();

            // TODO: this is weirdly specific to psi panic, probably redundant with many other checks
            if (iAbility == eAbility_PsiPanic)
            {
                if (bTargetIsCriticallyWounded || !arrPotentialTargets[Index].IsAlive() || arrPotentialTargets[Index].IsPossessed())
                {
                    continue;
                }
            }

            if (kTAbility.aProperties[eProp_TargetCritical] != 0 && !bTargetIsCriticallyWounded)
            {
                continue;
            }

            if (!kAbilityTree.AbilityHasEffect(eEffect_Damage, iAbility) && arrPotentialTargets[Index].IsAnimal())
            {
                continue;
            }

            arrActualTargets[0] = XGUnit(arrPotentialTargets[Index]);
            kAbility = kAbilityTree.SpawnAbility(iAbility, self, arrActualTargets, kWeapon, /* kMiscActor */ none, bForLocalUseOnly, /* bReactionFire */ false);
            arrAbilities.AddItem(kAbility);
        }
    }

    // If we still haven't generated the ability, do it now without any targets
    if (!AbilityIsInList(iAbility, arrAbilities))
    {
        // In the native version, the array length is still 1 but arrUnknown[0] = none
        arrActualTargets.Length = 1;
        arrActualTargets[0] = none;
        kAbility = kAbilityTree.SpawnAbility(iAbility, self, arrActualTargets, kWeapon, /* kMiscActor */ none, bForLocalUseOnly, /* bReactionFire */ false);
        arrAbilities.AddItem(kAbility);
    }
}

simulated function bool GenerateAbilities_CheckForCloseAbility(int iAbility, out array<XGAbility> arrAbilities, XGTacticalGameCoreNativeBase GameCore)
{
    local XGAbility kAbility;
    local array<XGUnit> arrTargets;

    if (iAbility != eAbility_CloseCyberdisc)
    {
        return false;
    }

    if (m_kCharacter == none || m_kCharacter.m_kChar.iType != eChar_Cyberdisc)
    {
        return true;
    }

    if (m_kPawn.m_eOpenCloseState != eUP_Open)
    {
        return true;
    }

    if (FindAbility(eAbility_CloseCyberdisc, /* kTarget */ none) != none)
    {
        return true;
    }

    arrTargets.AddItem(self);

    kAbility = `GAMECORE.m_kAbilities.SpawnAbility(eAbility_CloseCyberdisc, self, arrTargets, /* kWeapon */ none, /* kMiscActor */ none, /* bForLocalUseOnly */ false, /* bReactionFire */ false);
    arrAbilities.AddItem(kAbility);

    return true;
}

simulated function bool GenerateAbilities_CheckForFlyAbility(int iAbility, out array<XGAbility> arrAbilities, XGTacticalGameCoreNativeBase GameCore)
{
    local int Index;
    local XGAbility kAbility;
    local array<XGUnit> arrTargets;

    if (iAbility != eAbility_Fly)
    {
        return false;
    }

    for (Index = 0; Index < arrAbilities.Length; Index++)
    {
        if (arrAbilities[Index].IsA('XGAbility_Fly'))
        {
            return true;
        }
    }

    arrTargets.AddItem(self);

    kAbility = `GAMECORE.m_kAbilities.SpawnAbility(eAbility_Fly, self, arrTargets, /* kWeapon */ none, /* kMiscActor */ none, /* bForLocalUseOnly */ false, /* bReactionFire */ false);
    arrAbilities.AddItem(kAbility);

    return true;
}

simulated function array<EItemType_Info> GetItemInfos()
{
    local LWCE_XGInventory kInventory;

    if (!m_bCheckedItemInfos)
    {
        m_bCheckedItemInfos = true;
        kInventory = LWCE_XGInventory(GetInventory());

        if (kInventory != none)
        {
            if (kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(MindShield)))
            {
                m_arrItemInfos.AddItem(1);
            }

            if (kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(ChitinPlating)))
            {
                m_arrItemInfos.AddItem(2);
            }

            if (kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(SCOPE)))
            {
                m_arrItemInfos.AddItem(3);
            }

            if (kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(ReaperPack)))
            {
                m_arrItemInfos.AddItem(4);
            }

            if (kInventory.LWCE_HasItemOfType(`LW_ITEM_ID(RespiratorImplant)))
            {
                m_arrItemInfos.AddItem(5);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(AlloyJacketedRounds)))
            {
                m_arrItemInfos.AddItem(14);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(EnhancedBeamOptics)))
            {
                m_arrItemInfos.AddItem(15);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(PlasmaStellerator)))
            {
                m_arrItemInfos.AddItem(16);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(LaserSight)))
            {
                m_arrItemInfos.AddItem(17);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(CeramicPlating)))
            {
                m_arrItemInfos.AddItem(18);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(HiCapMags)))
            {
                m_arrItemInfos.AddItem(19);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(BattleComputer)))
            {
                m_arrItemInfos.AddItem(20);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(ChameleonSuit)))
            {
                m_arrItemInfos.AddItem(21);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(HoloTargeter)))
            {
                m_arrItemInfos.AddItem(22);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(SmartshellPod)))
            {
                m_arrItemInfos.AddItem(23);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(CoreArmoring)))
            {
                m_arrItemInfos.AddItem(24);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(TheThumper)))
            {
                m_arrItemInfos.AddItem(25);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(ImpactVest)))
            {
                m_arrItemInfos.AddItem(26);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(FuelCell)))
            {
                m_arrItemInfos.AddItem(27);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(AlloyBipod)))
            {
                m_arrItemInfos.AddItem(28);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(BreachingAmmo)))
            {
                m_arrItemInfos.AddItem(29);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(ArmorPiercingAmmo)))
            {
                m_arrItemInfos.AddItem(30);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(WalkerServos)))
            {
                m_arrItemInfos.AddItem(31);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(NeuralGunlink)))
            {
                m_arrItemInfos.AddItem(32);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(ShredderAmmo)))
            {
                m_arrItemInfos.AddItem(33);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(PsiScreen)))
            {
                m_arrItemInfos.AddItem(34);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(IlluminatorGunsight)))
            {
                m_arrItemInfos.AddItem(35);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(IncineratorModule)))
            {
                m_arrItemInfos.AddItem(36);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(TargetingModule)))
            {
                m_arrItemInfos.AddItem(37);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(ReinforcedArmor)))
            {
                m_arrItemInfos.AddItem(38);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(EleriumTurbos)))
            {
                m_arrItemInfos.AddItem(39);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(CognitiveEnhancer)))
            {
                m_arrItemInfos.AddItem(40);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(Neuroregulator)))
            {
                m_arrItemInfos.AddItem(41);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(FlakAmmo)))
            {
                m_arrItemInfos.AddItem(42);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(AlloyPlating)))
            {
                m_arrItemInfos.AddItem(43);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, `LW_ITEM_ID(DrumMags)))
            {
                m_arrItemInfos.AddItem(44);
            }
        }
    }

    return m_arrItemInfos;
}

simulated function int GetOffense()
{
    local int iAim;
    local LWCE_XGTacticalGameCore kGameCore;

    iAim = m_aCurrentStats[eStat_Offense];
    kGameCore = `LWCE_GAMECORE;

    if (GetInventory().GetActiveWeapon() == none)
    {
        return iAim;
    }

    // I'm not really sure why we subtract the weapon's aim, but that's how it's done in the original
    iAim -= kGameCore.LWCE_GetTWeapon(GetInventory().GetActiveWeapon().ItemType()).kStatChanges.iAim;

    if (IsBeingSuppressed())
    {
        iAim -= class'XGTacticalGameCoreNativeBase'.const.SUPPRESSION_AIM_PENALTY;
    }

    if (IsPoisoned())
    {
        iAim -= kGameCore.POISONED_AIM_PENALTY;
    }

    return iAim;
}

simulated function GetTargetsInRange(int iTargetType, int iRangeType, out array<XGUnitNativeBase> arrTargets, Vector vLocation, optional XGWeapon kWeapon, optional float fCustomRange = 0.0, optional bool bNoLOSRequired, optional bool bSkipRoboticUnits = false, optional bool bSkipNonRoboticUnits = false, optional int eType = 0)
{
    local array<float> arrTargets_HeightBonusModifier, arrDistToTargetSq;
    local float fRange;
    local bool bHealing, bMindMerge;
    local int iCharFilter;

    arrTargets.Remove(0, arrTargets.Length);
    arrDistToTargetSq.Remove(0, arrDistToTargetSq.Length);
    bHealing = kWeapon != none && kWeapon.GameplayType() == eItem_Medikit;
    bMindMerge = eType == eAbility_MindMerge || eType == eAbility_GreaterMindMerge;

    if (iTargetType == eTarget_Self)
    {
        arrTargets.AddItem(self);
        return;
    }
    else if (iTargetType == eTarget_Location)
    {
        if ( kWeapon != none && (kWeapon.GameplayType() == `LW_ITEM_ID(RecoillessRifle) || kWeapon.GameplayType() == `LW_ITEM_ID(BlasterLauncher)) )
        {
            DetermineEnemiesInSight(arrTargets, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits);
        }

        return;
    }

    switch (iTargetType)
    {
        case eTarget_SingleDeadAlly:
            DetermineDeadAllies(arrTargets, arrDistToTargetSq, vLocation);
            break;
        case eTarget_SingleAlly:
        case eTarget_SingleAllyOrSelf:
        case eTarget_MultipleAllies:
        case eTarget_SectoidAllies:
        case eTarget_MutonAllies:
            if (iTargetType == eTarget_SectoidAllies || eType == eAbility_MindMerge)
            {
                if (IsAI())
                {
                    iCharFilter = 1 << eChar_Sectoid;
                }
                else
                {
                    iCharFilter = 1 << eChar_Soldier;
                }
            }

            if (iTargetType == eTarget_MutonAllies)
            {
                iCharFilter = (1 << eChar_Muton) | (1 << eChar_MutonBerserker) | (1 << eChar_MutonElite);
            }

            if (eType == 41) // Command
            {
                iCharFilter = 1;
            }

            if (fCustomRange != float(0))
            {
                DetermineFriendsInRange(fCustomRange, false, arrTargets, arrDistToTargetSq, vLocation, iCharFilter, bSkipRoboticUnits, bSkipNonRoboticUnits, bHealing, bMindMerge);
            }
            else
            {
                switch (iRangeType)
                {
                    case eRange_Weapon:
                        if (kWeapon != none)
                        {
                            fRange = class'LWCE_XGWeapon_Extensions'.static.LongRange(kWeapon) + float(m_aCurrentStats[eStat_WeaponRange]);
                            DetermineFriendsInRange(fRange, false, arrTargets, arrDistToTargetSq, vLocation, iCharFilter, bSkipRoboticUnits, bSkipNonRoboticUnits, bHealing, bMindMerge);
                        }

                        break;
                    case eRange_Sight:
                        DetermineFriendsInRange(-1.0, false, arrTargets, arrDistToTargetSq, vLocation, iCharFilter, bSkipRoboticUnits, bSkipNonRoboticUnits, bHealing, bMindMerge);
                        break;
                    case eRange_SquadSight:
                    case eRange_Unlimited:
                        DetermineFriendsInRange(-1.0, true, arrTargets, arrDistToTargetSq, vLocation, iCharFilter, bSkipRoboticUnits, bSkipNonRoboticUnits, bHealing, bMindMerge);
                        break;
                    default:
                        break;
                }
            }

            if (iTargetType == eTarget_SingleAllyOrSelf)
            {
                if (bHealing && CanBeHealedWithMedikit())
                {
                    arrTargets.AddItem(self);
                    arrDistToTargetSq.AddItem(0.0);
                }
            }

            break;

        case eTarget_SingleDeadEnemy:
            DetermineDeadEnemies(arrTargets, arrDistToTargetSq, vLocation);
            break;
        case eTarget_SingleEnemy:
        case eTarget_MultipleEnemies:
            if (fCustomRange != float(0))
            {
                DetermineEnemiesInRangeByWeapon(kWeapon, fCustomRange, arrTargets, arrTargets_HeightBonusModifier, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits);

                if (eType == eAbility_ShotStun)
                {
                    FilterStunTargets(arrTargets);
                }
            }
            else
            {
                switch (iRangeType)
                {
                    case eRange_Weapon:
                        DetermineEnemiesInRangeByWeapon(kWeapon, 0.0, arrTargets, arrTargets_HeightBonusModifier, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits);
                        break;
                    case eRange_Sight:
                        DetermineEnemiesInSight(arrTargets, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits, EAbility(eType));
                        break;
                    case eRange_SquadSight:
                        DetermineEnemiesInSquadSight(arrTargets, vLocation, !bNoLOSRequired, bSkipRoboticUnits, bSkipNonRoboticUnits, EAbility(eType));
                        break;
                    case eRange_Unlimited:
                        DetermineAllEnemies(arrTargets, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits);
                        break;
                    default:
                        break;
                }
            }

            break;
        default:
            break;
    }
}

function bool LoadInit(XGPlayer NewPlayer)
{
    if (super.LoadInit(NewPlayer))
    {
        // LWCE issue #23: the character's reference to the unit is not persisted, causing it to be lost
        // if the tac game is saved and loaded. We simply restore it manually.
        m_kCharacter.m_kUnit = self;

        `LWCE_GFX.OnUnitLoaded(self);

        return true;
    }

    return false;
}

function OnEnterPoison(XGVolume kVolume)
{
    // Don't apply poison to visibility helpers or it'll be visible on the UI
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return;
    }

    super.OnEnterPoison(kVolume);
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
}

simulated function ShowMouseOverDisc(optional bool bShow = true)
{
    if (m_bShowMouseOverDisc != bShow)
    {
        m_bShowMouseOverDisc = bShow;
        RefreshUnitDisc();

        `LWCE_VISHELPER.UpdateVisibilityMarkers();
    }
}

simulated event UpdateAbilitiesUI()
{
    super.UpdateAbilitiesUI();
}

simulated function UpdateInteractClaim()
{
    // Prevent visibility helpers from claiming interaction points such as doors and Meld
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return;
    }

    super.UpdateInteractClaim();
}

function UpdateItemCharges()
{
    // TODO: connect this to LWCE's item system
    local LWCE_XGInventory kInventory;

    kInventory = LWCE_XGInventory(GetInventory());

    SetGhostCharges(3);

    if (kInventory.LWCE_GetNumItems(`LW_ITEM_ID(Medikit)) > 0)
    {
        m_iMediKitCharges = kInventory.LWCE_GetNumItems(`LW_ITEM_ID(Medikit));

        if (m_kCharacter.HasUpgrade(`LW_PERK_ID(Packmaster)))
        {
            m_iMediKitCharges += kInventory.LWCE_GetNumItems(`LW_ITEM_ID(Medikit));
        }

        if (m_kCharacter.HasUpgrade(`LW_PERK_ID(FieldMedic)))
        {
            m_iMediKitCharges += kInventory.LWCE_GetNumItems(`LW_ITEM_ID(Medikit)) - 1;
        }
    }

    if (kInventory.LWCE_GetNumItems(`LW_ITEM_ID(ArcThrower)) > 0)
    {
        SetArcThrowerCharges(kInventory.LWCE_GetNumItems(`LW_ITEM_ID(ArcThrower)) * 1);

        if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
        {
            SetArcThrowerCharges(GetArcThrowerCharges() + kInventory.LWCE_GetNumItems(`LW_ITEM_ID(ArcThrower)));
        }

        if (m_kCharacter.HasUpgrade(ePerk_Repair))
        {
            SetArcThrowerCharges(GetArcThrowerCharges() + (kInventory.LWCE_GetNumItems(`LW_ITEM_ID(ArcThrower)) * 2));
        }
    }

    SetMimicBeaconCharges(kInventory.LWCE_GetNumItems(`LW_ITEM_ID(MimicBeacon)) * (m_kCharacter.HasUpgrade(`LW_PERK_ID(SmokeAndMirrors)) ? 2 : 1));
    SetFragGrenades(kInventory.LWCE_GetNumItems(`LW_ITEM_ID(HEGrenade)) * (m_kCharacter.HasUpgrade(`LW_PERK_ID(Grenadier)) ? 2 : 1));
    SetFlashBangs(kInventory.LWCE_GetNumItems(`LW_ITEM_ID(FlashbangGrenade)) * (m_kCharacter.HasUpgrade(`LW_PERK_ID(SmokeAndMirrors)) ? 2 : 1));
    SetAlienGrenades(kInventory.LWCE_GetNumItems(`LW_ITEM_ID(AlienGrenade)) * (m_kCharacter.HasUpgrade(`LW_PERK_ID(Grenadier)) ? 2 : 1));
    SetGhostGrenades(kInventory.LWCE_GetNumItems(`LW_ITEM_ID(ShadowDevice)) * (m_kCharacter.HasUpgrade(`LW_PERK_ID(SmokeAndMirrors)) ? 1 : 1));
    SetGasGrenades(kInventory.LWCE_GetNumItems(`LW_ITEM_ID(ChemGrenade)) * (m_kCharacter.HasUpgrade(`LW_PERK_ID(SmokeAndMirrors)) ? 2 : 1));
    SetNeedleGrenades(kInventory.LWCE_GetNumItems(`LW_ITEM_ID(APGrenade)) * (m_kCharacter.HasUpgrade(`LW_PERK_ID(Grenadier)) ? 2 : 1));

    if (m_kCharacter.HasUpgrade(`LW_PERK_ID(Packmaster)))
    {
        // SetGhostGrenades(GetGhostGrenades()); // Shadow Devices don't scale
        SetFragGrenades(GetFragGrenades() + kInventory.LWCE_GetNumItems(`LW_ITEM_ID(HEGrenade)));
        SetFlashBangs(GetFlashBangs() + kInventory.LWCE_GetNumItems(`LW_ITEM_ID(FlashbangGrenade)));
        SetAlienGrenades(GetAlienGrenades() + kInventory.LWCE_GetNumItems(`LW_ITEM_ID(AlienGrenade)));
        SetGasGrenades(GetGasGrenades() + kInventory.LWCE_GetNumItems(`LW_ITEM_ID(ChemGrenade)));
        SetNeedleGrenades(GetNeedleGrenades() + kInventory.LWCE_GetNumItems(`LW_ITEM_ID(APGrenade)));
        SetMimicBeaconCharges((GetMimicBeaconCharges()) + kInventory.LWCE_GetNumItems(`LW_ITEM_ID(MimicBeacon)));
    }

    if (m_kCharacter.HasUpgrade(`LW_PERK_ID(ShredderAmmo)))
    {
        SetShredderRockets(m_kCharacter.m_kChar.aUpgrades[ePerk_ShredderRocket] & 1);
        SetShredderRockets(m_iShredderRockets + (m_kCharacter.m_kChar.aUpgrades[ePerk_ShredderRocket] >> 1));
    }

    if (m_kCharacter.HasUpgrade(`LW_PERK_ID(FireRocket)))
    {
        SetRockets(1);

        if (m_kCharacter.HasUpgrade(/* Shock and Awe */ 92))
        {
            SetRockets(2);
        }

        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, /* Rocket */ 77))
        {
            SetRockets(GetRockets() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(BattleScanner)] & 1) > 0)
    {
        SetBattleScannerCharges(2);

        if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
        {
            SetBattleScannerCharges(3);
        }

        if (m_kCharacter.HasUpgrade(ePerk_SmokeAndMirrors))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(BattleScanner)] >> 1) > 0)
    {
        SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));

        if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));
        }

        if (m_kCharacter.HasUpgrade(ePerk_SmokeAndMirrors))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(SmokeGrenade)] & 1) > 0)
    {
        SetSmokeGrenadeCharges(1);

        if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
        {
            SetSmokeGrenadeCharges(2);
        }

        if (m_kCharacter.HasUpgrade(ePerk_SmokeAndMirrors))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(SmokeGrenade)] >> 1) > 0)
    {
        SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));

        if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));
        }

        if (m_kCharacter.HasUpgrade(ePerk_SmokeAndMirrors))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));
        }
    }

    if (m_kCharacter.m_kChar.eClass == eSC_Mec)
    {
        m_iFragGrenades = 0;
        m_iAlienGrenades = 0;
        m_iMediKitCharges = 0;

        for (m_iDamageControlTurns = 0; m_iDamageControlTurns < m_kCharacter.m_kChar.kInventory.iNumLargeItems; m_iDamageControlTurns++)
        {
            if (m_kCharacter.m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecFlameThrower)
            {
                m_iFlamethrowerCharges += 2;

                if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
                {
                    m_iFlamethrowerCharges += 1;
                }
            }

            if (m_kCharacter.m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecGrenadeLauncher)
            {
                m_iFragGrenades += 2;
                m_iAlienGrenades += 2;

                if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
                {
                    m_iFragGrenades += AdditionalGrenades;
                    m_iAlienGrenades += AdditionalGrenades;
                }

                if (m_kCharacter.HasUpgrade(ePerk_Grenadier))
                {
                    m_iFragGrenades += 1;
                    m_iAlienGrenades += 1;
                }
            }

            if (m_kCharacter.m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecRestorativeMist)
            {
                m_iMediKitCharges += 1;

                if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
                {
                    m_iMediKitCharges += AdditionalRestorativeMistShots;
                }

                if (m_kCharacter.HasUpgrade(ePerk_FieldMedic))
                {
                    m_iMediKitCharges += 2;
                }
            }

            if (m_kCharacter.m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecElectroPulse)
            {
                m_iProximityMines += 3;

                if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
                {
                    m_iProximityMines += AdditionalProximityMines;
                }
            }
        }

        m_iFragGrenades = Max(m_iFragGrenades, 2);
        m_iAlienGrenades = Max(m_iAlienGrenades, 2);
        m_iDamageControlTurns = 0;
    }

    // Seeker in multiplayer, presumably
    if (GetCharType() == eChar_Seeker && WorldInfo.NetMode != NM_Standalone)
    {
        SetStealthCharges(5);
    }

    for (m_iDamageControlTurns = 0; m_iDamageControlTurns < m_kCharacter.m_kChar.kInventory.iNumSmallItems; m_iDamageControlTurns++)
    {
        if (m_kCharacter.m_kChar.kInventory.arrSmallItems[m_iDamageControlTurns] == eItem_PsiGrenade)
        {
            m_iFlashBangs += m_kCharacter.HasUpgrade(ePerk_SmokeAndMirrors) ? 2 : 1;
            m_iFlashBangs += m_kCharacter.HasUpgrade(/* Packmaster */ 53) ? 1 : 0;
        }
    }

    m_iDamageControlTurns = 0;

    if (m_kCharacter.m_kChar.eClass != eSC_Mec)
    {
        if (m_kCharacter.HasUpgrade(ePerk_Savior))
        {
            m_iMediKitCharges += 2;
        }
    }

    if (m_kCharacter.m_kChar.eClass != eSC_Mec)
    {
        if (!IsAlien_CheckByCharType())
        {
            m_iFlamethrowerCharges = 0; // Command charges

            if (m_kCharacter.HasUpgrade(/* Legio Patria Nostra */ 156) || m_kCharacter.HasUpgrade(/* Stay Frosty */ 122))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (m_kCharacter.HasUpgrade(/* Fortiores Una */ 140) || m_kCharacter.HasUpgrade(/* Semper Vigilans */ 152))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (m_kCharacter.HasUpgrade(/* So Shall You Fight */ 1) || m_kCharacter.HasUpgrade(/* Into the Breach */ 161))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (m_kCharacter.HasUpgrade(/* Esprit de Corps */ 160) || m_kCharacter.HasUpgrade(/* Band of Warriors */ 157))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (m_kCharacter.HasUpgrade(/* Combined Arms */ 138) || m_kCharacter.HasUpgrade(/* So Others May Live */ 158))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, /* Motion Tracker */ 222))
            {
                m_iProximityMines = class'XGTacticalGameCore'.default.EXALT_LOOT1;

                if (m_kCharacter.HasUpgrade(/* Packmaster */ 53))
                {
                    m_iProximityMines += 1;
                }
            }
        }
    }

    `LWCE_MOD_LOADER.OnUpdateItemCharges(self);
}

simulated event SetBETemplate()
{
    // Don't set up bioelectric skin particles for visibility helpers, so they aren't shown
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return;
    }

    super.SetBETemplate();
}

protected function bool ShouldStopCombatMusicAfterBeingStunned()
{
    local array<XGUnitNativeBase> EnemiesInSquadSight;
    local XGPlayer kPlayer;
    local XGSquad Squad;
    local XGUnitNativeBase FriendlyUnit, EnemyUnit;

    // Logic here is basically mirrored from XGPlayer.OnUnitKilled, which stops the combat music
    // when the last visible enemy dies
    kPlayer = XGBattle_SP(`BATTLE).GetHumanPlayer();

    if (kPlayer.m_bKismetControlledCombatMusic)
    {
        return false;
    }

    Squad = kPlayer.GetSquad();
    FriendlyUnit = Squad.GetNextGoodMember();

    if (FriendlyUnit == none)
    {
        return true;
    }

    XGUnit(FriendlyUnit).DetermineEnemiesInSquadSight(EnemiesInSquadSight, FriendlyUnit.Location, false, false);

    foreach EnemiesInSquadSight(EnemyUnit)
    {
        if (EnemyUnit != self && !XGUnit(EnemyUnit).IsDeadOrDying())
        {
            return false;
        }
    }

    return true;
}

simulated state Active
{
    function AddPathAction(optional int iCustomPathLength = 0, optional bool bNoCloseCombat = false)
    {
        local XGAction_Path kAction;

        if (`BATTLE.IsTurnTimerCloseToExpiring())
        {
            AddIdleAction();
            return;
        }

        if (iCustomPathLength == 0)
        {
            if (GetMoves() == 0)
            {
                AddIdleAction();
                return;
            }
            else if (IsMine() && IsFlying())
            {
                SetDashing(false);
                SetPathLength(GetMaxPathLength() * 2);
            }
            else
            {
                SetPathLength(GetMaxPathLength());
            }
        }
        else
        {
            SetPathLength(iCustomPathLength);
        }

        GetPathingPawn().MyUnit = none;

        kAction = Spawn(class'LWCE_XGAction_Path', Owner);
        kAction.Init(self);
        kAction.SetBoundToClientProxyID(m_iBindNextPathActionToClientProxyActionID);
        kAction.m_bNoCloseCombat = bNoCloseCombat;
        AddAction(kAction);

        m_iBindNextPathActionToClientProxyActionID = -1;
    }

    simulated event BeginState(name nmPrev)
    {
        super.BeginState(nmPrev);
    }

    simulated event EndState(name nmNext)
    {
        super.EndState(nmNext);
    }
}

auto simulated state Inactive
{
    simulated event BeginState(name nmPrev)
    {
        super.BeginState(nmPrev);
    }
}

simulated event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}