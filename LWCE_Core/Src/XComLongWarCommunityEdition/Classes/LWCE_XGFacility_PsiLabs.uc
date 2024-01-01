class LWCE_XGFacility_PsiLabs extends XGFacility_PsiLabs
    dependson(LWCETypes);

struct LWCE_TPsiTrainee
{
    var XGStrategySoldier kSoldier;
    var LWCE_TPerkTreeChoice kPerk;
    var int iHoursLeft;
    var bool bTrainingSucceeded;
};

struct CheckpointRecord_LWCE_XGFacility_PsiLabs extends CheckpointRecord_XGFacility_PsiLabs
{
    var array<LWCE_TPsiTrainee> m_arrCETraining;
    var array<LWCE_TPsiTrainee> m_arrCECompleted;
};

var array<LWCE_TPsiTrainee> m_arrCETraining;
var array<LWCE_TPsiTrainee> m_arrCECompleted;

function Update()
{
    local int iTrainee;
    local XGStrategySoldier kSoldier;
    local bool bIsTraining;

    for (iTrainee = m_arrCETraining.Length - 1; iTrainee >= 0; iTrainee--)
    {
        m_arrCETraining[iTrainee].iHoursLeft -= 1;

        if (m_arrCETraining[iTrainee].iHoursLeft <= 0)
        {
            if (GEOSCAPE().IsBusy())
            {
                return;
            }

            DetermineGift(iTrainee);
            STORAGE().RestoreBackedUpInventory(m_arrCETraining[iTrainee].kSoldier);
            m_arrCECompleted.AddItem(m_arrCETraining[iTrainee]);
            m_arrCETraining.Remove(iTrainee, 1);
        }
    }

    if (m_arrCECompleted.Length > 0 && !m_bAnnouncedResults)
    {
        m_bAnnouncedResults = true;
        BARRACKS().ReorderRanks();
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('PsiTraining').Build());
    }

    foreach BARRACKS().m_arrSoldiers(kSoldier)
    {
        if (kSoldier.IsInPsiTesting())
        {
            bIsTraining = false;

            for (iTrainee = 0; iTrainee < m_arrCETraining.Length; iTrainee++)
            {
                if (kSoldier == m_arrCETraining[iTrainee].kSoldier)
                {
                    bIsTraining = true;
                    break;
                }
            }

            // No idea what this section is about
            if (!bIsTraining)
            {
                kSoldier.SetStatus(eStatus_GeneMod);
            }
        }
    }
}

function AddSoldier(XGStrategySoldier kSoldier, int iSlot)
{
    `LWCE_LOG_DEPRECATED_CLS(AddSoldier);
}

function LWCE_AddSoldier(XGStrategySoldier kSoldier, LWCE_TPerkTreeChoice kPerkChoice)
{
    local LWCE_TPsiTrainee kTrainee;

    if (m_arrCETraining.Length >= class'XGTacticalGameCore'.default.PSI_NUM_TRAINING_SLOTS)
    {
        return;
    }

    kTrainee.kSoldier = kSoldier;
    kTrainee.kPerk = kPerkChoice;
    kTrainee.iHoursLeft = (class'XGTacticalGameCore'.default.PSI_TRAINING_HOURS * kPerkChoice.iTargetWill) / kSoldier.GetMaxStat(eStat_Will);

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(TheOldPath)) > 0)
    {
        kTrainee.iHoursLeft *= (1.0 - (float(HQ().HasBonus(`LW_HQ_BONUS_ID(TheOldPath))) / 100.0));
    }

    kTrainee.kSoldier.m_iTurnsOut = kTrainee.iHoursLeft;
    kTrainee.kSoldier.SetStatus(eStatus_PsiTesting);
    STORAGE().BackupAndReleaseInventory(kSoldier);
    m_arrCETraining.AddItem(kTrainee);
    BARRACKS().ReorderRanks();
}

function bool ClearSlot(int iSlot)
{
    if (IsSlotOccupied(iSlot))
    {
        RemoveSoldier(m_arrCETraining[iSlot].kSoldier);
    }
    else
    {
        return false;
    }

    return true;
}

function DetermineGift(int iTrainee)
{
    local bool bGifted;
    local LWCE_TPerkTreeChoice kEmptyPerkChoice;

    m_iNumTested += 1;
    m_arrCETraining[iTrainee].kSoldier.m_iTurnsOut = 0;

    if (m_arrCETraining[iTrainee].kSoldier.bForcePsiGift)
    {
        bGifted = true;
        m_arrCETraining[iTrainee].kSoldier.bForcePsiGift = false;
    }
    else if (Roll(RollForGift(m_arrCETraining[iTrainee].kSoldier)))
    {
        m_arrCETraining[iTrainee].kSoldier.m_kChar.bHasPsiGift = true;
        bGifted = true;
    }

    if (bGifted)
    {
        m_arrCETraining[iTrainee].kSoldier.SetStatus(eStatus_Active);
        m_iNumGifted += 1;
        m_arrCETraining[iTrainee].kSoldier.GivePerk(m_arrCETraining[iTrainee].kPerk.iPerkId);
        m_arrCETraining[iTrainee].kSoldier.PsiLevelUp();

        if (m_arrCETraining[iTrainee].kSoldier.GetPsiRank() == 5)
        {
            if (m_bFoundFirst != true)
            {
                m_bFoundFirst = true;
                PsiCinematicSoldier = m_arrCETraining[iTrainee].kSoldier;
                m_bSubjectZeroCinematic = true;
            }
        }

        STAT_AddStat(18, 1);
    }
    else
    {
        m_arrCETraining[iTrainee].kSoldier.SetStatus(eStatus_Active);
        m_arrCETraining[iTrainee].kPerk = kEmptyPerkChoice;
    }

    m_arrCETraining[iTrainee].bTrainingSucceeded = bGifted;
}

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iTrainTime, iEvent;
    local LWCE_THQEvent kEvent;
    local bool bAdded;
    local array<int> arrEventTimes;
    local LWCE_TPsiTrainee kTrainee;

    foreach m_arrCETraining(kTrainee)
    {
        if (arrEventTimes.Find(kTrainee.iHoursLeft) == INDEX_NONE)
        {
            arrEventTimes.AddItem(kTrainee.iHoursLeft);
        }
    }

    for (iTrainTime = 0; iTrainTime < arrEventTimes.Length; iTrainTime++)
    {
        kEvent.EventType = 'PsiTraining';
        kEvent.iHours = arrEventTimes[iTrainTime];

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }
}

function bool IsSlotOccupied(int iSlot)
{
    return m_arrCETraining.Length > iSlot;
}

function RemoveSoldier(XGStrategySoldier kSoldier)
{
    local int iTrainee;

    if (kSoldier == PsiCinematicSoldier)
    {
        return;
    }

    for (iTrainee = 0; iTrainee < m_arrCETraining.Length; iTrainee++)
    {
        if (m_arrCETraining[iTrainee].kSoldier == kSoldier)
        {
            m_arrCETraining[iTrainee].kSoldier.m_iTurnsOut = 0;
            m_arrCETraining[iTrainee].kSoldier.SetStatus(eStatus_Active);
            STORAGE().RestoreBackedUpInventory(kSoldier);
            m_arrCETraining.Remove(iTrainee, 1);
            BARRACKS().ReorderRanks();
        }
    }
}

function int RollForGift(XGStrategySoldier kSoldier)
{
    local int iChance, iTraineeWill, iEvenWillSuccessChance, iSoldierIndex, iTargetWill, Index;

    iSoldierIndex = -1;

    for (Index = 0; Index < m_arrCETraining.Length; Index++)
    {
        if (m_arrCETraining[Index].kSoldier == kSoldier)
        {
            iSoldierIndex = Index;
            break;
        }
    }

    if (iSoldierIndex == -1)
    {
        return 0;
    }

    iTargetWill = m_arrCETraining[iSoldierIndex].kPerk.iTargetWill;
    iTraineeWill = Max(LWCE_XGStrategySoldier(kSoldier).m_kCEChar.aStats[eStat_Will], 1);
    iEvenWillSuccessChance = int(float(100) * class'XGTacticalGameCore'.default.PSI_GIFT_CHANCE);

    if (iTraineeWill <= (iTargetWill + 80 - iEvenWillSuccessChance))
    {
        iChance = (iTraineeWill - iTargetWill) + iEvenWillSuccessChance;
        iChance = Max(1, iChance);
    }
    else
    {
        iChance = int(float(100) - (400.0 / float(iTraineeWill - iTargetWill + iEvenWillSuccessChance - 60)));
        iChance = Min(99, iChance);
    }

    if (HQ().HasBonus(`LW_HQ_BONUS_ID(LegacyOfUxmal)) > 0)
    {
        iChance += HQ().HasBonus(`LW_HQ_BONUS_ID(LegacyOfUxmal));
        iChance = Min(99, iChance);
    }

    return iChance;
}

state WaitingToStartPsiCinematic
{
Begin:
    PRES().GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0.0, 1.0), 0.50);
    PRES().HideUIForCinematics();
    PRES().UILoadAnimation(true);
    PRES().GetStrategyHUD().AS_HideResourcesPanel();

    PsiCinematicSoldier.SetHQLocation(eSoldierLoc_PsiLabsCinematic, true, 0, true);

    while (PsiCinematicSoldier.m_kPawn == none || !PsiCinematicSoldier.m_kPawn.IsPawnReadyForViewing())
    {
        Sleep(0.10);
    }

    if (LWCE_XGStrategySoldier(PsiCinematicSoldier).m_kCESoldier.kAppearance.nmGender == 'Male')
    {
        PRES().UINarrative(`XComNarrativeMoment("Psionics"),, PsiCinematicComplete, SendSoldierToPsiCinematic, Base().GetFacility3DLocation(eFacility_PsiLabs));
    }
    else
    {
        PRES().UINarrative(`XComNarrativeMoment("Psionics_Female"),, PsiCinematicComplete, SendSoldierToPsiCinematic, Base().GetFacility3DLocation(eFacility_PsiLabs));
    }

    GotoState('None');
    stop;
}