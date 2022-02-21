class LWCE_XGSummaryUI extends XGSummaryUI;

function TTableMenuOption BuildArtifactLine(EItemType eItem, int iQuantity)
{
    local TTableMenuOption kOption;

    `LWCE_LOG_DEPRECATED_CLS(BuildArtifactLine);

    return kOption;
}

function TTableMenuOption LWCE_BuildArtifactLine(int iItemId, int iQuantity)
{
    local LWCE_TItem kItem;
    local TTableMenuOption kOption;

    kItem = `LWCE_ITEM(iItemId);
    kOption.arrStrings[0] = kItem.strName;
    kOption.arrStrings[1] = string(iQuantity);
    kOption.arrStates[0] = eUIState_Normal;
    kOption.arrStates[1] = eUIState_Normal;

    if (kOption.arrStrings[0] == "")
    {
        kOption.arrStrings[0] = string(iItemId);
    }

    return kOption;
}

function CollectArtifactsFromDeadAliens()
{
    local XGSquad kSquad;
    local XGUnit kAlien;
    local int iArtifactRecoveryChance;
    local int iAlloys, iElerium, iMeld;
    local int I, Index, iItem;
    local EItemType eCaptive;
    local XGInventoryItem kItem;
    local LWCE_XGBattleDesc kDesc;
    local LWCE_XGDropshipCargoInfo kCargo;
    local LWCEItemContainer kCargoItems, kDescItems;

    kDesc = LWCE_XGBattleDesc(Desc());
    kDescItems = kDesc.m_kArtifactsContainer;

    kCargo = LWCE_XGDropshipCargoInfo(kDesc.m_kDropShipCargoInfo);
    kCargoItems = kCargo.m_kArtifactsContainer;
    kCargoItems.Clear();

    if (BATTLE().m_iResult == eResult_Victory)
    {
        iArtifactRecoveryChance = 100;
        kCargoItems.Set(`LW_ITEM_ID(OutsiderShard), kDescItems.Get(`LW_ITEM_ID(OutsiderShard)).iQuantity);

        if (kDesc.m_iMissionType == eMission_ExaltRaid)
        {
            kCargoItems.Set(`LW_ITEM_ID(CognitiveEnhancer), 1);
            kCargoItems.Set(`LW_ITEM_ID(Neuroregulator), 1);
            kCargoItems.Set(`LW_ITEM_ID(IlluminatorGunsight), 1);
            kCargo.m_kReward.iCredits += 1250;
        }
    }
    else
    {
        iArtifactRecoveryChance = 0;
        kSquad = XGBattle_SP(`BATTLE).GetHumanPlayer().GetSquad();

        for (I = 0; I < kSquad.GetNumPermanentMembers(); I++)
        {
            iArtifactRecoveryChance += 4 * GetSoldierStatus(kSquad.GetPermanentMemberAt(I));
        }
    }

    // Copy over artifacts from the mission data before moving on to corpses
    for (I = (iArtifactRecoveryChance == 100 ? 161 : 163) ; I < (iArtifactRecoveryChance == 100 ? 182 : 165); I++)
    {
        for (Index = 0; Index < kDescItems.Get(I).iQuantity; Index++)
        {
            if (Rand(100) < iArtifactRecoveryChance)
            {
                kCargoItems.AdjustQuantity(I, 1);
            }
        }
    }

    for (I = 161; I < 182; I++)
    {
        kDescItems.Delete(I);
    }

    kSquad = `BATTLE.GetAIPlayer().GetSquad();

    for (I = 0; I < kSquad.GetNumPermanentMembers(); I++)
    {
        kAlien = kSquad.GetPermanentMemberAt(I);

        if (kAlien != none)
        {
            if (kAlien.m_bStunned)
            {
                // TODO: connect this to item config
                eCaptive = class'XGGameData'.static.CharToCaptive(ECharacter(kAlien.GetCharacter().m_kChar.iType));

                if (eCaptive != 0 && iArtifactRecoveryChance == 100)
                {
                    kCargoItems.AdjustQuantity(eCaptive, 1);
                }

                for (Index = 0; Index < 22; Index++)
                {
                    kItem = kAlien.GetInventory().GetPrimaryItemInSlot(ELocation(Index));

                    if (kAlien.IsExalt())
                    {
                        iItem = kItem.ItemType();
                    }
                    else
                    {
                        switch (kItem.ItemType())
                        {
                            case eItem_SectoidPlasmaPistol:
                                iItem = eItem_SectoidPlasmaPistol;
                                break;
                            case eItem_PlasmaLightRifle_ThinMan:
                            case eItem_PlasmaLightRifle_Floater:
                            case eItem_PlasmaLightRifle_Muton:
                            case eItem_OutsiderWeapon:
                                iItem = eItem_PlasmaLightRifle_ThinMan;
                                break;
                            case eItem_PlasmaLightRifle_Floater:
                            case eItem_PlasmaLightRifle_Muton:
                                iItem = eItem_PlasmaLightRifle_Floater;
                                break;
                            case eItem_HeavyPlasma_Muton:
                                iItem = eItem_HeavyPlasma_Muton;
                                break;
                            default:
                                iItem = kItem.GameplayType();
                                break;
                        }
                    }

                    // 41 through 47: alien weapons
                    // 215 through 217: EXALT laser weapons
                    if ( (iItem >= 41 && iItem <= 47) || (iItem >= 215 && iItem <= 217) || iItem == eItem_AlienGrenade )
                    {
                        if (iArtifactRecoveryChance == 100)
                        {
                            kCargoItems.AdjustQuantity(iItem, 1);
                        }
                    }
                }
            }

            if (kAlien.IsDeadOrDying() && !kAlien.m_bWasKilledByExplosion)
            {
                // TODO: connect this to item config
                iItem = class'XGGameData'.static.CharToCorpse(kAlien.GetCharacter().m_kChar.iType);

                if (iItem != 0 && Rand(100) < iArtifactRecoveryChance)
                {
                    kCargoItems.AdjustQuantity(iItem, 1);
                }

                iAlloys = 0;
                iElerium = 0;
                iMeld = 0;

                switch (kAlien.GetCharacter().m_kChar.iType)
                {
                    case eChar_Floater:
                        iAlloys = (class'XGTacticalGameCore'.default.HFLOATER_ALLOYS / 100);
                        iElerium = (class'XGTacticalGameCore'.default.HFLOATER_ELERIUM / 100);
                        iMeld = (class'XGTacticalGameCore'.default.HFLOATER_MELD / 100);
                        break;
                    case eChar_Seeker:
                        iAlloys = (class'XGTacticalGameCore'.default.DRONE_ALLOYS / 100);
                        iElerium = (class'XGTacticalGameCore'.default.DRONE_ELERIUM / 100);
                        break;
                    case eChar_Cyberdisc:
                        iAlloys = class'XGTacticalGameCore'.default.CYBERDISC_ALLOYS;
                        iElerium = class'XGTacticalGameCore'.default.CYBERDISC_ELERIUM;
                        break;
                    case eChar_Drone:
                        iAlloys = (class'XGTacticalGameCore'.default.DRONE_ALLOYS % 100);
                        iElerium = (class'XGTacticalGameCore'.default.DRONE_ELERIUM % 100);
                        break;
                    case eChar_FloaterHeavy:
                        iAlloys = (class'XGTacticalGameCore'.default.HFLOATER_ALLOYS % 100);
                        iElerium = (class'XGTacticalGameCore'.default.HFLOATER_ELERIUM % 100);
                        iMeld = (class'XGTacticalGameCore'.default.HFLOATER_MELD % 100);
                        break;
                    case eChar_Sectopod:
                        iAlloys = class'XGTacticalGameCore'.default.SECTOPOD_ALLOYS;
                        iElerium = class'XGTacticalGameCore'.default.SECTOPOD_ELERIUM;
                        break;
                    case eChar_Mechtoid:
                        iAlloys = class'XGTacticalGameCore'.default.MECHTOID_ALLOYS;
                        iElerium = class'XGTacticalGameCore'.default.MECHTOID_ELERIUM;
                        iMeld = class'XGTacticalGameCore'.default.MECHTOID_MELD;
                        kCargoItems.AdjustQuantity(`LW_ITEM_ID(SectoidCorpse), 1);
                        break;
                    case eChar_ExaltEliteOperative:
                    case eChar_ExaltEliteSniper:
                    case eChar_ExaltEliteHeavy:
                    case eChar_ExaltEliteMedic:
                        if (!kAlien.m_bLeftBehind)
                        {
                            iMeld = class'XGTacticalGameCore'.default.CB_FUNDING_BONUS;
                        }

                        break;
                    default:
                        if (!kAlien.m_bLeftBehind)
                        {
                            iMeld = class'XGTacticalGameCore'.default.CB_FUTURECOMBAT_BONUS;
                        }
                }

                kDescItems.AdjustQuantity(`LW_ITEM_ID(AlienAlloy), iAlloys);
                kDescItems.AdjustQuantity(`LW_ITEM_ID(Elerium), iElerium);
                kDescItems.AdjustQuantity(`LW_ITEM_ID(Meld), iMeld);
            }
        }
    }

    // 161 through 164: elerium, alloys, weapon fragments, and meld
    for (I = 161; I < 165; I++)
    {
        if (`GAMECORE.IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
        {
            kDescItems.Set(I, kDescItems.Get(I).iQuantity / class'XGTacticalGameCore'.default.SW_MARATHON);
        }

        // All resources from alien corpses are divided by 10, since they have to be integers
        for (Index = 0; Index < (kDescItems.Get(I).iQuantity / 10); Index++)
        {
            if (Rand(100) < iArtifactRecoveryChance)
            {
                kCargoItems.AdjustQuantity(I, 1);
            }
        }
    }
}

function UpdateArtifacts()
{
    local LWCEItemContainer kArtifactsContainer;
    local LWCE_TItemQuantity kItemQuantity;
    local TTableMenu kTable;

    `LWCE_LOG_CLS("UpdateArtifacts");

    kArtifactsContainer = LWCE_XGDropshipCargoInfo(Desc().m_kDropShipCargoInfo).m_kArtifactsContainer;

    kTable.arrCategories.AddItem(30);
    kTable.arrCategories.AddItem(31);
    kTable.kHeader.arrStrings = GetHeaderStrings(kTable.arrCategories);
    kTable.kHeader.arrStates = GetHeaderStates(kTable.arrCategories);

    foreach kArtifactsContainer.m_arrEntries(kItemQuantity)
    {
        if (kItemQuantity.iQuantity > 0)
        {
            kTable.arrOptions.AddItem(LWCE_BuildArtifactLine(kItemQuantity.iItemId, kItemQuantity.iQuantity));
        }
    }

    kTable.bTakesNoInput = true;
    m_kArtifacts.mnuSummary = kTable;
}