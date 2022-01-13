class Highlander_XGUnit extends XGUnit;

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

        if (GetCharacter().m_kChar.iType == eChar_Outsider)
        {
            Highlander_XGBattleDesc(`BATTLE.m_kDesc).m_kArtifactsContainer.AdjustQuantity(`LW_ITEM_ID(OutsiderShard), 1);
            PRES().UINarrative(`XComNarrativeMoment("OutsiderShardFirstSeen"));
        }

        // Highlander issue #7: if the last visible enemy is stunned instead of killed, combat music will continue playing.
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

    `GAMECORE.GetBackpackItemArray(GetCharacter().m_kChar.kInventory, arrBackPackItems);
    m_aCurrentStats[9] = m_aCurrentStats[eStat_HP];
    RemoveStatModifiers(m_aInventoryStats);

    `HL_TAC_GAMECORE.HL_GetInventoryStatModifiers(m_aInventoryStats, m_kCharacter.m_kChar, eWeapon_GameplayType, arrBackPackItems);

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
        kInventory = Spawn(class'Highlander_XGInventory', Owner);
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
                PRES().MSGWeaponFragments(`HL_TWEAPON(XGWeapon(kWeapon)).strName, iWeaponFragments);
                Highlander_XGBattleDesc(`BATTLE.m_kDesc).m_kArtifactsContainer.AdjustQuantity(`LW_ITEM_ID(WeaponFragment), iWeaponFragments);
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
                    PRES().MSGItemDestroyed(`HL_TWEAPON(XGWeapon(kWeapon)).strName);
                }
            }
        }
    }
}

simulated function DebugCoverActors(XComTacticalCheatManager kCheatManager)
{
    local Highlander_XGTacticalGameCore kGameCore;
    local XGInventoryItem kItem;
    local int iItemIndex, iSlotIndex;

    kGameCore = `HL_GAMECORE;

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
                else if (kGameCore.HL_GetTWeapon(kItem.ItemType()).iSize == 1)
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
    local HL_TWeapon kMedikit;
    local int I;
    local float fRadius;
    local Highlander_XGInventory kInventory;

    kInventory = Highlander_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.HL_HasItemOfType(`LW_ITEM_ID(Medikit)))
    {
        return;
    }

    if (GetMediKitCharges() > 0)
    {
        kSquad = GetSquad();
        kMedikit = `HL_GAMECORE.HL_GetTWeapon(`LW_ITEM_ID(Medikit));
        fRadius = float(kMedikit.iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit != self && kUnit.CanBeHealedWithMedikit() && kUnit.IsVisible() && !kUnit.IsDead() && kUnit.GetPawn() != none && !`GAMECORE.CharacterHasProperty(kUnit.GetCharacter().m_kChar.iType, eCP_Robotic))
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
    local Highlander_XGInventory kInventory;

    kInventory = Highlander_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.HL_HasItemOfType(`LW_ITEM_ID(Medikit)))
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

            if (kUnit != self && !kUnit.IsDead() && kUnit.IsVisible() && kUnit.GetPawn() != none && kUnit.IsCriticallyWounded() && !`GAMECORE.CharacterHasProperty(kUnit.GetCharacter().m_kChar.iType, eCP_Robotic))
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
    local Highlander_XGInventory kInventory;
    local XGWeapon kItem;
    local bool bHasRepair;

    bDetach = true;
    kInventory = Highlander_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.HL_HasItemOfType(`LW_ITEM_ID(ArcThrower)))
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
              && (`GAMECORE.CharacterHasProperty(kUnit.GetCharacter().m_kChar.iType, eCP_Robotic) || kUnit.IsAugmented())
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
    local Highlander_XGInventory kInventory;

    kInventory = Highlander_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.HL_HasItemOfType(`LW_ITEM_ID(ArcThrower)))
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
    local Highlander_XGInventory kInventory;
    local bool bHasHack;
    local XGWeapon kItem;

    kInventory = Highlander_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.HL_HasItemOfType(`LW_ITEM_ID(ArcThrower)))
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

            if (kUnit.GetCharacter().m_kChar.iType == eChar_Drone && kUnit.IsVisible() && kUnit.IsAliveAndWell() && kUnit.GetPawn() != none)
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

simulated function array<EItemType_Info> GetItemInfos()
{
    local Highlander_XGInventory kInventory;

    if (!m_bCheckedItemInfos)
    {
        m_bCheckedItemInfos = true;
        kInventory = Highlander_XGInventory(GetInventory());

        if (kInventory != none)
        {
            if (kInventory.HL_HasItemOfType(`LW_ITEM_ID(MindShield)))
            {
                m_arrItemInfos.AddItem(1);
            }

            if (kInventory.HL_HasItemOfType(`LW_ITEM_ID(ChitinPlating)))
            {
                m_arrItemInfos.AddItem(2);
            }

            if (kInventory.HL_HasItemOfType(`LW_ITEM_ID(SCOPE)))
            {
                m_arrItemInfos.AddItem(3);
            }

            if (kInventory.HL_HasItemOfType(`LW_ITEM_ID(ReaperPack)))
            {
                m_arrItemInfos.AddItem(4);
            }

            if (kInventory.HL_HasItemOfType(`LW_ITEM_ID(RespiratorImplant)))
            {
                m_arrItemInfos.AddItem(5);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(AlloyJacketedRounds)))
            {
                m_arrItemInfos.AddItem(14);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(EnhancedBeamOptics)))
            {
                m_arrItemInfos.AddItem(15);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(PlasmaStellerator)))
            {
                m_arrItemInfos.AddItem(16);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(LaserSight)))
            {
                m_arrItemInfos.AddItem(17);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(CeramicPlating)))
            {
                m_arrItemInfos.AddItem(18);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(HiCapMags)))
            {
                m_arrItemInfos.AddItem(19);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(BattleComputer)))
            {
                m_arrItemInfos.AddItem(20);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ChameleonSuit)))
            {
                m_arrItemInfos.AddItem(21);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(HoloTargeter)))
            {
                m_arrItemInfos.AddItem(22);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(SmartshellPod)))
            {
                m_arrItemInfos.AddItem(23);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(CoreArmoring)))
            {
                m_arrItemInfos.AddItem(24);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TheThumper)))
            {
                m_arrItemInfos.AddItem(25);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ImpactVest)))
            {
                m_arrItemInfos.AddItem(26);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(FuelCell)))
            {
                m_arrItemInfos.AddItem(27);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(AlloyBipod)))
            {
                m_arrItemInfos.AddItem(28);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(BreachingAmmo)))
            {
                m_arrItemInfos.AddItem(29);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ArmorPiercingAmmo)))
            {
                m_arrItemInfos.AddItem(30);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(WalkerServos)))
            {
                m_arrItemInfos.AddItem(31);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(NeuralGunlink)))
            {
                m_arrItemInfos.AddItem(32);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ShredderAmmo)))
            {
                m_arrItemInfos.AddItem(33);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(PsiScreen)))
            {
                m_arrItemInfos.AddItem(34);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(IlluminatorGunsight)))
            {
                m_arrItemInfos.AddItem(35);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(IncineratorModule)))
            {
                m_arrItemInfos.AddItem(36);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(TargetingModule)))
            {
                m_arrItemInfos.AddItem(37);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(ReinforcedArmor)))
            {
                m_arrItemInfos.AddItem(38);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(EleriumTurbos)))
            {
                m_arrItemInfos.AddItem(39);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(CognitiveEnhancer)))
            {
                m_arrItemInfos.AddItem(40);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(Neuroregulator)))
            {
                m_arrItemInfos.AddItem(41);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(FlakAmmo)))
            {
                m_arrItemInfos.AddItem(42);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(AlloyPlating)))
            {
                m_arrItemInfos.AddItem(43);
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, `LW_ITEM_ID(DrumMags)))
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
    local Highlander_XGTacticalGameCore kGameCore;

    iAim = m_aCurrentStats[eStat_Offense];
    kGameCore = `HL_GAMECORE;

    if (GetInventory().GetActiveWeapon() == none)
    {
        return iAim;
    }

    // I'm not really sure why we subtract the weapon's aim, but that's how it's done in the original
    iAim -= kGameCore.HL_GetTWeapon(GetInventory().GetActiveWeapon().ItemType()).kStatChanges.iAim;

    if (IsBeingSuppressed())
    {
        iAim -= kGameCore.SuppressionAimPenalty;
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
                            fRange = class'Highlander_XGWeapon_Extensions'.static.LongRange(kWeapon) + float(m_aCurrentStats[eStat_WeaponRange]);
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

function UpdateItemCharges()
{
    // TODO: connect this to the Highlander's item system
    local Highlander_XGInventory kInventory;

    kInventory = Highlander_XGInventory(GetInventory());

    SetGhostCharges(3);

    if (kInventory.HL_GetNumItems(`LW_ITEM_ID(Medikit)) > 0)
    {
        m_iMediKitCharges = kInventory.HL_GetNumItems(`LW_ITEM_ID(Medikit));

        if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
        {
            m_iMediKitCharges += kInventory.HL_GetNumItems(`LW_ITEM_ID(Medikit));
        }

        if (GetCharacter().HasUpgrade(ePerk_FieldMedic))
        {
            m_iMediKitCharges += kInventory.HL_GetNumItems(`LW_ITEM_ID(Medikit)) - 1;
        }
    }

    if (kInventory.HL_GetNumItems(`LW_ITEM_ID(ArcThrower)) > 0)
    {
        SetArcThrowerCharges(kInventory.HL_GetNumItems(`LW_ITEM_ID(ArcThrower)) * 1);

        if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
        {
            SetArcThrowerCharges(GetArcThrowerCharges() + kInventory.HL_GetNumItems(`LW_ITEM_ID(ArcThrower)));
        }

        if (GetCharacter().HasUpgrade(ePerk_Repair))
        {
            SetArcThrowerCharges(GetArcThrowerCharges() + (kInventory.HL_GetNumItems(`LW_ITEM_ID(ArcThrower)) * 2));
        }
    }

    SetMimicBeaconCharges(kInventory.HL_GetNumItems(`LW_ITEM_ID(MimicBeacon)) * (GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors) ? 2 : 1));
    SetFragGrenades(kInventory.HL_GetNumItems(`LW_ITEM_ID(HEGrenade)) * (GetCharacter().HasUpgrade(ePerk_Grenadier) ? 2 : 1));
    SetFlashBangs(kInventory.HL_GetNumItems(`LW_ITEM_ID(FlashbangGrenade)) * (GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors) ? 2 : 1));
    SetAlienGrenades(kInventory.HL_GetNumItems(`LW_ITEM_ID(AlienGrenade)) * (GetCharacter().HasUpgrade(ePerk_Grenadier) ? 2 : 1));
    SetGhostGrenades(kInventory.HL_GetNumItems(`LW_ITEM_ID(ShadowDevice)) * (GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors) ? 1 : 1));
    SetGasGrenades(kInventory.HL_GetNumItems(`LW_ITEM_ID(ChemGrenade)) * (GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors) ? 2 : 1));
    SetNeedleGrenades(kInventory.HL_GetNumItems(`LW_ITEM_ID(APGrenade)) * (GetCharacter().HasUpgrade(ePerk_Grenadier) ? 2 : 1));

    if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
    {
        // SetGhostGrenades(GetGhostGrenades()); // Shadow Devices don't scale
        SetFragGrenades(GetFragGrenades() + kInventory.HL_GetNumItems(`LW_ITEM_ID(HEGrenade)));
        SetFlashBangs(GetFlashBangs() + kInventory.HL_GetNumItems(`LW_ITEM_ID(FlashbangGrenade)));
        SetAlienGrenades(GetAlienGrenades() + kInventory.HL_GetNumItems(`LW_ITEM_ID(AlienGrenade)));
        SetGasGrenades(GetGasGrenades() + kInventory.HL_GetNumItems(`LW_ITEM_ID(ChemGrenade)));
        SetNeedleGrenades(GetNeedleGrenades() + kInventory.HL_GetNumItems(`LW_ITEM_ID(APGrenade)));
        SetMimicBeaconCharges((GetMimicBeaconCharges()) + kInventory.HL_GetNumItems(`LW_ITEM_ID(MimicBeacon)));
    }

    if (GetCharacter().HasUpgrade(ePerk_ShredderRocket))
    {
        SetShredderRockets(m_kCharacter.m_kChar.aUpgrades[ePerk_ShredderRocket] & 1);
        SetShredderRockets(m_iShredderRockets + (m_kCharacter.m_kChar.aUpgrades[ePerk_ShredderRocket] >> 1));
    }

    if (GetCharacter().HasUpgrade(ePerk_FireRocket))
    {
        SetRockets(1);

        if (GetCharacter().HasUpgrade(/* Shock and Awe */ 92))
        {
            SetRockets(2);
        }

        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, /* Rocket */ 77))
        {
            SetRockets(GetRockets() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] & 1) > 0)
    {
        SetBattleScannerCharges(2);

        if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
        {
            SetBattleScannerCharges(3);
        }

        if (GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1) > 0)
    {
        SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));

        if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));
        }

        if (GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] & 1) > 0)
    {
        SetSmokeGrenadeCharges(1);

        if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
        {
            SetSmokeGrenadeCharges(2);
        }

        if (GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1) > 0)
    {
        SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));

        if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));
        }

        if (GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));
        }
    }

    if (GetCharacter().m_kChar.eClass == eSC_Mec)
    {
        m_iFragGrenades = 0;
        m_iAlienGrenades = 0;
        m_iMediKitCharges = 0;

        for (m_iDamageControlTurns = 0; m_iDamageControlTurns < GetCharacter().m_kChar.kInventory.iNumLargeItems; m_iDamageControlTurns++)
        {
            if (GetCharacter().m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecFlameThrower)
            {
                m_iFlamethrowerCharges += 2;

                if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
                {
                    m_iFlamethrowerCharges += 1;
                }
            }

            if (GetCharacter().m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecGrenadeLauncher)
            {
                m_iFragGrenades += 2;
                m_iAlienGrenades += 2;

                if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
                {
                    m_iFragGrenades += AdditionalGrenades;
                    m_iAlienGrenades += AdditionalGrenades;
                }

                if (GetCharacter().HasUpgrade(ePerk_Grenadier))
                {
                    m_iFragGrenades += 1;
                    m_iAlienGrenades += 1;
                }
            }

            if (GetCharacter().m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecRestorativeMist)
            {
                m_iMediKitCharges += 1;

                if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
                {
                    m_iMediKitCharges += AdditionalRestorativeMistShots;
                }

                if (GetCharacter().HasUpgrade(ePerk_FieldMedic))
                {
                    m_iMediKitCharges += 2;
                }
            }

            if (GetCharacter().m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecElectroPulse)
            {
                m_iProximityMines += 3;

                if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
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

    for (m_iDamageControlTurns = 0; m_iDamageControlTurns < GetCharacter().m_kChar.kInventory.iNumSmallItems; m_iDamageControlTurns++)
    {
        if (GetCharacter().m_kChar.kInventory.arrSmallItems[m_iDamageControlTurns] == eItem_PsiGrenade)
        {
            m_iFlashBangs += GetCharacter().HasUpgrade(ePerk_SmokeAndMirrors) ? 2 : 1;
            m_iFlashBangs += GetCharacter().HasUpgrade(/* Packmaster */ 53) ? 1 : 0;
        }
    }

    m_iDamageControlTurns = 0;

    if (GetCharacter().m_kChar.eClass != eSC_Mec)
    {
        if (GetCharacter().HasUpgrade(ePerk_Savior))
        {
            m_iMediKitCharges += 2;
        }
    }

    if (GetCharacter().m_kChar.eClass != eSC_Mec)
    {
        if (!IsAlien_CheckByCharType())
        {
            m_iFlamethrowerCharges = 0; // Command charges

            if (GetCharacter().HasUpgrade(/* Legio Patria Nostra */ 156) || GetCharacter().HasUpgrade(/* Stay Frosty */ 122))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (GetCharacter().HasUpgrade(/* Fortiores Una */ 140) || GetCharacter().HasUpgrade(/* Semper Vigilans */ 152))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (GetCharacter().HasUpgrade(/* So Shall You Fight */ 1) || GetCharacter().HasUpgrade(/* Into the Breach */ 161))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (GetCharacter().HasUpgrade(/* Esprit de Corps */ 160) || GetCharacter().HasUpgrade(/* Band of Warriors */ 157))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (GetCharacter().HasUpgrade(/* Combined Arms */ 138) || GetCharacter().HasUpgrade(/* So Others May Live */ 158))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, /* Motion Tracker */ 222))
            {
                m_iProximityMines = class'XGTacticalGameCore'.default.EXALT_LOOT1;

                if (GetCharacter().HasUpgrade(/* Packmaster */ 53))
                {
                    m_iProximityMines += 1;
                }
            }
        }
    }

    `HL_MOD_LOADER.OnUpdateItemCharges(self);
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

        iCustomPathLength = 0;
        bNoCloseCombat = false;

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

        kAction = Spawn(class'Highlander_XGAction_Path', Owner);
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