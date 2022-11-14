class LWCE_XGSummaryUI extends XGSummaryUI;

function TTableMenuOption BuildArtifactLine(EItemType eItem, int iQuantity)
{
    local TTableMenuOption kOption;

    `LWCE_LOG_DEPRECATED_CLS(BuildArtifactLine);

    return kOption;
}

function TTableMenuOption LWCE_BuildArtifactLine(name ItemName, int iQuantity)
{
    local LWCEItemTemplate kItem;
    local TTableMenuOption kOption;

    kItem = `LWCE_ITEM(ItemName);
    kOption.arrStrings[0] = kItem.strName;
    kOption.arrStrings[1] = string(iQuantity);
    kOption.arrStates[0] = eUIState_Normal;
    kOption.arrStates[1] = eUIState_Normal;

    if (kOption.arrStrings[0] == "")
    {
        kOption.arrStrings[0] = string(ItemName);
    }

    return kOption;
}

function CollectArtifactsFromDeadAliens()
{
    local XGSquad kSquad;
    local XGUnit kAlien;
    local EItemType eCaptive;
    local XGInventoryItem kItem;
    local LWCE_XGBattleDesc kDesc;
    local LWCE_XGDropshipCargoInfo kCargo;
    local LWCEItemContainer kCargoItems, kDescItems;
    local LWCEEquipmentTemplate kEquipment;
    local int iArtifactRecoveryChance;
    local int iAlloys, iElerium, iMeld;
    local int I, Index, iItem;
    local name ItemName;

    kDesc = LWCE_XGBattleDesc(Desc());
    kDescItems = kDesc.m_kArtifactsContainer;

    kCargo = LWCE_XGDropshipCargoInfo(kDesc.m_kDropShipCargoInfo);
    kCargoItems = kCargo.m_kArtifactsContainer;
    kCargoItems.Clear();

    if (BATTLE().m_iResult == eResult_Victory)
    {
        iArtifactRecoveryChance = 100;
        kCargoItems.Set('Item_OutsiderShard', kDescItems.Get('Item_OutsiderShard').iQuantity);

        // TODO: move rewards to config
        if (kDesc.m_iMissionType == eMission_ExaltRaid)
        {
            kCargoItems.Set('Item_CognitiveEnhancer', 1);
            kCargoItems.Set('Item_Neuroregulator', 1);
            kCargoItems.Set('Item_IlluminatorGunsight', 1);
            kCargo.m_kReward.iCredits += 1250;
        }
    }
    else
    {
        // When losing a mission, recovery chance scales with the number of surviving soldiers you have
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
        ItemName = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(I);

        for (Index = 0; Index < kDescItems.Get(ItemName).iQuantity; Index++)
        {
            if (Rand(100) < iArtifactRecoveryChance)
            {
                kCargoItems.AdjustQuantity(ItemName, 1);
            }
        }
    }

    for (I = 161; I < 182; I++)
    {
        ItemName = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(I);
        kDescItems.Delete(ItemName);
    }

    kSquad = `BATTLE.GetAIPlayer().GetSquad();

    for (I = 0; I < kSquad.GetNumPermanentMembers(); I++)
    {
        kAlien = kSquad.GetPermanentMemberAt(I);

        if (kAlien != none)
        {
            // Nothing is recovered from captives unless we won
            if (kAlien.m_bStunned && iArtifactRecoveryChance == 100)
            {
                // TODO: connect this to item config
                eCaptive = class'XGGameData'.static.CharToCaptive(ECharacter(kAlien.GetCharacter().m_kChar.iType));

                if (eCaptive != 0)
                {
                    kCargoItems.AdjustQuantity(class'LWCE_XGItemTree'.static.ItemNameFromBaseID(eCaptive), 1);
                }

                for (Index = 0; Index < 22; Index++)
                {
                    kItem = kAlien.GetInventory().GetPrimaryItemInSlot(ELocation(Index));

                    if (LWCE_XGWeapon(kItem) != none)
                    {
                        kEquipment = LWCE_XGWeapon(kItem).m_kTemplate;

                        if (kEquipment.nmRecoveredItem != '')
                        {
                            kCargoItems.AdjustQuantity(kEquipment.nmRecoveredItem, 1);
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
                    kCargoItems.AdjustQuantity(class'LWCE_XGItemTree'.static.ItemNameFromBaseID(iItem), 1);
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
                        kCargoItems.AdjustQuantity('Item_CorpseSectoid', 1);
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

                kDescItems.AdjustQuantity('Item_AlienAlloy', iAlloys);
                kDescItems.AdjustQuantity('Item_Elerium', iElerium);
                kDescItems.AdjustQuantity('Item_Meld', iMeld);
            }
        }
    }

    // 161 through 164: elerium, alloys, weapon fragments, and meld
    for (I = 161; I < 165; I++)
    {
        ItemName = class'LWCE_XGItemTree'.static.ItemNameFromBaseID(I);

        if (`GAMECORE.IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
        {
            kDescItems.Set(ItemName, kDescItems.Get(ItemName).iQuantity / class'XGTacticalGameCore'.default.SW_MARATHON);
        }

        // All resources from alien corpses are divided by 10, since they have to be integers
        for (Index = 0; Index < (kDescItems.Get(ItemName).iQuantity / 10); Index++)
        {
            if (Rand(100) < iArtifactRecoveryChance)
            {
                kCargoItems.AdjustQuantity(ItemName, 1);
            }
        }
    }
}

function TMissionFactor GetCiviliansSavedFactor()
{
    local TMissionFactor kFactor;
    local XGSquad kCivSquad;
    local XGUnit kUnit;
    local int iDeadVisHelpers, iKilled, iTotal, iTotalVisHelpers, iPercentageKilled, iRating;

    kCivSquad = BATTLE().GetAnimalPlayer().GetSquad();

    // LWCE: since vis helpers are on the civilian team, they end up getting shown in the summary UI and are
    // also included in the data transferred back to the strategy layer. We just want to get rid of them here.

    foreach AllActors(class'XGUnit', kUnit)
    {
        if (kUnit.GetSquad() == kCivSquad && class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit))
        {
            iTotalVisHelpers++;

            // Vis helpers shouldn't be able to die, but just to be safe
            if (kUnit.IsDeadOrDying())
            {
                iDeadVisHelpers++;
            }
        }
    }

    if (BATTLE().m_iResult == eResult_Victory)
    {
        iKilled = kCivSquad.GetNumDead() - iDeadVisHelpers;
    }
    else
    {
        iKilled = kCivSquad.GetNumPermanentMembers() - iDeadVisHelpers;
    }

    iTotal = kCivSquad.GetNumPermanentMembers() - iTotalVisHelpers;
    Desc().m_kDropShipCargoInfo.m_iCiviliansSaved = iTotal - iKilled;
    Desc().m_kDropShipCargoInfo.m_iCiviliansTotal = iTotal;
    iPercentageKilled = (iKilled * 100) / iTotal;

    if (iPercentageKilled <= 25)
    {
        iRating = 3;
    }
    else if (iPercentageKilled <= 50)
    {
        iRating = 2;
    }
    else if (iPercentageKilled < 90)
    {
        iRating = 1;
    }
    else
    {
        iRating = 0;
    }

    kFactor.strFactor = m_strLabelCiviliansSaved;
    kFactor.iIcon = 1;
    kFactor.strResult = string(iTotal - iKilled) $ "/" $ string(iTotal);
    kFactor.iRating = iRating;
    kFactor.iResult = iTotal - iKilled;
    kFactor.strRating = GetRatingString(iRating);
    kFactor.iState = GetRatingState(iRating);

    return kFactor;
}

function UpdateArtifacts()
{
    local LWCEItemContainer kArtifactsContainer;
    local LWCE_TItemQuantity kItemQuantity;
    local TTableMenu kTable;

    kArtifactsContainer = LWCE_XGDropshipCargoInfo(Desc().m_kDropShipCargoInfo).m_kArtifactsContainer;

    kTable.arrCategories.AddItem(30);
    kTable.arrCategories.AddItem(31);
    kTable.kHeader.arrStrings = GetHeaderStrings(kTable.arrCategories);
    kTable.kHeader.arrStates = GetHeaderStates(kTable.arrCategories);

    foreach kArtifactsContainer.m_arrEntries(kItemQuantity)
    {
        if (kItemQuantity.iQuantity > 0)
        {
            kTable.arrOptions.AddItem(LWCE_BuildArtifactLine(kItemQuantity.ItemName, kItemQuantity.iQuantity));
        }
    }

    kTable.bTakesNoInput = true;
    m_kArtifacts.mnuSummary = kTable;
}

function UpdateHeader()
{
    local LWCE_XGBattleDesc kDesc;
    local TText txtBulletin;

    kDesc = LWCE_XGBattleDesc(Desc());

    // LWCE issue #60: prepend the time with the mission's date
    m_kHeader.txtOpName.StrValue = kDesc.m_strOpName;
    m_kHeader.txtMissionType.StrValue = kDesc.m_strDesc;
    m_kHeader.txtLocation.StrValue = kDesc.m_strLocation;
    m_kHeader.txtTime.StrValue = kDesc.m_strDate $ " - " $ kDesc.m_strTime;
    m_kHeader.arrBulletins[0] = txtBulletin;

    if (BATTLE().m_iResult == eResult_Victory)
    {
        m_kHeader.txtResult.StrValue = m_strMissionComplete;
        m_kHeader.txtResult.iState = eUIState_Good;
        m_kHeader.iStatus = 2;
    }
    else if (XComPresentationLayer(Owner.Owner).m_bConfirmedAbortMission)
    {
        m_kHeader.txtResult.StrValue = m_strMissionAbandoned;
        m_kHeader.txtResult.iState = eUIState_Bad;
        m_kHeader.iStatus = 1;
    }
    else if (BATTLE().m_iResult == eResult_Defeat)
    {
        m_kHeader.txtResult.StrValue = m_strMissionFailed;
        m_kHeader.txtResult.iState = eUIState_Bad;
        m_kHeader.iStatus = 3;
    }
    else
    {
        m_kHeader.txtResult.StrValue = "???";
        m_kHeader.txtResult.iState = eUIState_Normal;
    }
}