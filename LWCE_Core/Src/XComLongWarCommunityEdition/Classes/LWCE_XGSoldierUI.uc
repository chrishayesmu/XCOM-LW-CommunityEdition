class LWCE_XGSoldierUI extends XGSoldierUI
    dependson(LWCE_XGFacility_Lockers);

struct LWCE_TInventoryOption
{
    var int iOptionType;
    var bool bHighlight;
    var bool bShowItemCard;
    var bool bInfinite;
    var TImage imgItem;
    var TText txtName;
    var TText txtLabel;
    var TText txtQuantity;
    var string strHelp;
    var int iState;
    var int iSlot;
    var name ItemName;
};

struct LWCE_TSoldierGear
{
    var TText txtTitle;
    var int iHighlight;
    var bool bDataDirty;
    var array<LWCE_TInventoryOption> arrOptions;
};

struct LWCE_TSoldierLocker
{
    var TText txtTitle;
    var TText txtMsg;
    var int iHighlight;
    var bool bIsSelected;
    var array<LWCE_TInventoryOption> arrOptions;
};

var LWCE_TSoldierGear m_kCEGear;
var LWCE_TSoldierLocker m_kCELocker;

var const localized string m_strStatBonusesPrefix;
var const localized string m_strStatBonusesSeparator;
var const localized string m_strStatBonusesAim;
var const localized string m_strStatBonusesDamageReduction;
var const localized string m_strStatBonusesHP;
var const localized string m_strStatBonusesMobility;
var const localized string m_strStatBonusesWill;

event Destroyed()
{
    super.Destroyed();
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
}

function TInventoryOption BuildInventoryOption(int iItemId, int iOptionType, bool bHighlight)
{
    local TInventoryOption kOption;

    `LWCE_LOG_DEPRECATED_CLS(BuildInventoryOption);

    return kOption;
}

function LWCE_TInventoryOption LWCE_BuildInventoryOption(name ItemName, int iOptionType, bool bHighlight)
{
    local LWCEItemTemplate kItem;
    local LWCE_TInventoryOption kOption;

    kItem = `LWCE_ITEM(ItemName);

    kOption.ItemName = ItemName;
    kOption.iOptionType = iOptionType;

    switch (iOptionType)
    {
        case eInvSlot_Armor:
            kOption.txtLabel.StrValue = m_strArmor;
            break;
        case eInvSlot_Pistol:
            kOption.txtLabel.StrValue = m_strPistol;
            break;
        case eInvSlot_Large:
            kOption.txtLabel.StrValue = m_strLargeItem;
            break;
        case eInvSlot_Small:
            kOption.txtLabel.StrValue = m_strSmallItem;
            break;
    }

    if (ItemName != '')
    {
        kOption.txtName.StrValue = kItem.StrName;
        kOption.imgItem.strPath = kItem.ImagePath;
        kOption.bInfinite = kItem.IsInfinite();
    }
    else
    {
        kOption.txtName.StrValue = m_strEmpty;
        kOption.imgItem.iImage = 0;
    }

    kOption.bHighlight = bHighlight;
    return kOption;
}

function TInventoryOption BuildLockerOption(TLockerItem kItem, int iOptionType)
{
    local TInventoryOption kOption;

    `LWCE_LOG_DEPRECATED_CLS(BuildLockerOption);

    return kOption;
}

function LWCE_TInventoryOption LWCE_BuildLockerOption(LWCE_TLockerItem kItem, int iOptionType)
{
    local LWCEEquipmentTemplate kInvItem;
    local LWCE_TInventoryOption kOption;

    kInvItem = LWCEEquipmentTemplate(`LWCE_ITEM(kItem.ItemName));

    kOption.ItemName = kItem.ItemName;
    kOption.iOptionType = iOptionType;
    kOption.iState = eUIState_Normal;
    kOption.bShowItemCard = true;

    if (kItem.bTechLocked)
    {
        kOption.txtLabel.StrValue = m_strLabelRequiresResearch;
    }
    else if (kItem.bClassLocked)
    {
        if (m_kSoldier == BARRACKS().m_kVolunteer && kInvItem.IsArmor())
        {
            kOption.txtLabel.StrValue = Caps(m_strLabelUnavailableToVolunteer);
        }
        else
        {
            kOption.txtLabel.StrValue = m_strLabelItemUnavailableToClass;
        }
    }
    else if (kInvItem.bIsUniqueEquip && HasItemEquipped(kItem.ItemName))
    {
        kOption.txtLabel.StrValue = m_strLabelUniqueEquip;
    }
    else if (!HasAnyOfItemsEquipped(kInvItem.arrCompatibleEquipment, true))
    {
        kOption.txtLabel.StrValue = m_strLabelReaperRoundsRestriction;
    }
    else if (HasAnyOfItemsEquipped(kInvItem.arrIncompatibleEquipment, false))
    {
        kOption.txtLabel.StrValue = m_strLabelReaperRoundsRestriction;
    }
    else if (HasAnyOfItemsEquipped(kInvItem.arrMutuallyExclusiveEquipment, false))
    {
        kOption.txtLabel.StrValue = m_strLabelClassTypeOnly;
    }

    if (kOption.txtLabel.StrValue != "")
    {
        kOption.txtLabel.iState = eUIState_Bad;
        kOption.iState = eUIState_Disabled;
    }

    kOption.txtName.StrValue = kInvItem.strName;
    kOption.imgItem.strPath = kInvItem.ImagePath;
    kOption.bInfinite = kInvItem.IsInfinite();

    if (!kOption.bInfinite)
    {
        kOption.txtQuantity.StrValue = string(kItem.iQuantity);
    }

    return kOption;
}

function bool CanPromote()
{
    local bool bIsPsiPromotion;
    local int iRow, iPerkId;
    local LWCE_XGStrategySoldier kSoldier;

    bIsPsiPromotion = m_iCurrentView == eSoldierView_PsiPromotion;
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);
    iRow = GetAbilityTreeBranch() - 1;

    iPerkId = kSoldier.LWCE_GetPerkInClassTree(iRow, GetAbilityTreeColumnAsPerkIndex(), bIsPsiPromotion);

    if (bIsPsiPromotion && `LWCE_PSILABS.m_arrCETraining.Length >= class'XGTacticalGameCore'.default.PSI_NUM_TRAINING_SLOTS)
    {
        return false;
    }

    if (kSoldier.PerkLockedOut(iPerkId, iRow, bIsPsiPromotion))
    {
        return false;
    }

    return true;
}

// Clamps the highlighted row/column of the ability tree so that they're never selecting an empty space on the tree.
simulated function ClampAbilityTreeSelection()
{
    local int iRow, iNumColumns;
    local LWCE_XComPerkManager kPerkMgr;

    kPerkMgr = `LWCE_PERKS_STRAT;

    iRow = GetAbilityTreeBranch() - 1;
    iNumColumns = kPerkMgr.GetNumColumnsInTreeRow(LWCE_XGStrategySoldier(m_kSoldier), iRow, m_iCurrentView == eSoldierView_PsiPromotion);

    if (iNumColumns == 1)
    {
        SetAbilityTreeOption(1);
    }
    else if (iNumColumns == 2 && GetAbilityTreeOption() == 1)
    {
        SetAbilityTreeOption(2);
    }
}

simulated function int GetAbilityTreeBranch()
{
    return Max(1, super.GetAbilityTreeBranch());
}

function string GetHighlightedPerkDescription()
{
    local bool bIsPsiPromotion;
    local int iRow, iColumn;
    local string strStatChanges;
    local LWCE_TCharacterStats kStatChanges;
    local LWCE_TPerkTreeChoice kPerkChoice;
    local LWCE_XComPerkManager kPerkMgr;
    local LWCE_XGStrategySoldier kSoldier;

    bIsPsiPromotion = m_iCurrentView == eSoldierView_PsiPromotion;
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);
    kPerkMgr = `LWCE_PERKS_STRAT;
    iRow = GetAbilityTreeBranch() - 1;
    iColumn = GetAbilityTreeColumnAsPerkIndex();

    // TODO: doesn't work for Training Roulette
    if (!kPerkMgr.TryGetPerkChoiceInTree(kPerkChoice, kSoldier, iRow, iColumn, bIsPsiPromotion))
    {
        `LWCE_LOG_CLS("Couldn't find perk in tree at row " $ iRow $ ", column " $ iColumn);
        return "ERROR";
    }

    if (bIsPsiPromotion && kSoldier.PerkLockedOut(kPerkChoice.iPerkId, iRow, bIsPsiPromotion) && !kSoldier.HasPerk(kPerkChoice.iPerkId))
    {
        // Rift training: uses a set bit in the Mind Control perk upgrade slot to check if the soldier has MC'd an Ethereal yet
        // TODO: consolidate the Rift/psi stuff into a few methods
        if (kPerkChoice.iPerkId == `LW_PERK_ID(Rift))
        {
            if ((m_kSoldier.m_kChar.aUpgrades[`LW_PERK_ID(MindControl)] & 254) == 0)
            {
                return m_strLockedPsiAbilityDescription;
            }
        }

        if (!`LWCE_HQ.ArePrereqsFulfilled(kPerkChoice.kPrereqs))
        {
            return m_strLockedPsiAbilityDescription;
        }
    }

    // TODO: with Hidden Trees, only disable for unreached ranks
    if (!IsOptionEnabled(`LW_SECOND_WAVE_ID(HiddenTrees)))
    {
        kStatChanges = kPerkMgr.GetPerkStatChanges(kSoldier, GetAbilityTreeBranch() - 1, GetAbilityTreeColumnAsPerkIndex(), bIsPsiPromotion);
        strStatChanges = GetStatChangesString(kStatChanges);

        if (strStatChanges != "")
        {
            return strStatChanges $ "\n" $ kPerkMgr.GetBriefSummary(kPerkChoice.iPerkId);
        }
    }

    return kPerkMgr.GetBriefSummary(kPerkChoice.iPerkId);
}

function string GetHighlightedPromoPerkName()
{
    local bool bIsPsiPromotion;
    local int iRow, iColumn;
    local LWCE_TPerkTreeChoice kPerkChoice;
    local LWCE_XGStrategySoldier kSoldier;
    local LWCE_XComPerkManager kPerkMgr;

    bIsPsiPromotion = m_iCurrentView == eSoldierView_PsiPromotion;
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);
    kPerkMgr = `LWCE_PERKS_STRAT;
    iRow = GetAbilityTreeBranch() - 1;
    iColumn = GetAbilityTreeColumnAsPerkIndex();

    // TODO: doesn't work for Training Roulette
    if (!kPerkMgr.TryGetPerkChoiceInTree(kPerkChoice, kSoldier, iRow, iColumn, bIsPsiPromotion))
    {
        `LWCE_LOG_CLS("Couldn't find perk in tree at row " $ iRow $ ", column " $ iColumn);
        return "ERROR";
    }

    if (bIsPsiPromotion && m_kSoldier.PerkLockedOut(kPerkChoice.iPerkId, iRow, bIsPsiPromotion) && !m_kSoldier.HasPerk(kPerkChoice.iPerkId))
    {
        // Rift training: uses a set bit in the Mind Control perk upgrade slot to check if the soldier has MC'd an Ethereal yet
        if (kPerkChoice.iPerkId == ePerk_Rift)
        {
            if ((m_kSoldier.m_kChar.aUpgrades[ePerk_MindControl] & 254) == 0)
            {
                return m_strLockedAbilityLabel;
            }
        }

        if (!`LWCE_HQ.ArePrereqsFulfilled(kPerkChoice.kPrereqs))
        {
            return m_strLockedAbilityLabel;
        }
    }

    return `LWCE_PERKS_STRAT.GetPerkName(kPerkChoice.iPerkId);
}

function TItemCard GetItemCardFromOption(TInventoryOption kItemOp)
{
    local TItemCard kItemCard;

    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetItemCardFromOption was called. This needs to be replaced with LWCE_XGItemCards.BuildItemCard. Stack trace follows.");
    ScriptTrace();

    return kItemCard;
}

function int GetItemCharges(EItemType eItem, optional bool bForce1_for_NonGrenades = false, optional bool bForItemCardDisplay = false)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetItemCharges was called. This needs to be replaced with LWCEWeaponTemplate.GetItemCharges. Stack trace follows.");
    ScriptTrace();

    return 0;
}

function string GetItemTypeName(EItemType iItem)
{
    `LWCE_LOG_CLS("GetItemTypeName is deprecated in LWCE. Use LWCE_TItem.strName instead.");
    ScriptTrace();
    return "";
}

function bool HasAnyOfItemsEquipped(out array<name> arrItems, bool bDefaultIfEmpty)
{
    local name ItemName;

    if (arrItems.Length == 0)
    {
        return bDefaultIfEmpty;
    }

    foreach arrItems(ItemName)
    {
        if (HasItemEquipped(ItemName))
        {
            return true;
        }
    }

    return false;
}

function bool HasItemEquipped(name ItemName)
{
    return class'LWCEInventoryUtils'.static.HasItemOfName(LWCE_XGStrategySoldier(m_kSoldier).m_kCEChar.kInventory, ItemName);
}

function bool IsSlotValid(EInventorySlot eSlot)
{
    if (IsInCovertOperativeMode())
    {
        switch (eSlot)
        {
            case eInvSlot_Armor:
            case eInvSlot_Large:
                return false;
        }
    }

    if (eSlot == eInvSlot_Pistol)
    {
        if (m_kSoldier.IsATank() || m_kSoldier.IsAugmented() || m_kSoldier.HasPerk(`LW_PERK_ID(FireRocket)))
        {
            return false;
        }
    }

    return true;
}

function bool OnAcceptPromotion()
{
    local int iRow, iColumn;
    local LWCE_TPerkTreeChoice kPerkChoice;
    local LWCE_XGStrategySoldier kSoldier;

    iRow = GetAbilityTreeBranch() - 1;
    iColumn = GetAbilityTreeColumnAsPerkIndex();
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    if (!`LWCE_PERKS_STRAT.TryGetPerkChoiceInTree(kPerkChoice, kSoldier, iRow, iColumn, m_iCurrentView == eSoldierView_PsiPromotion))
    {
        `LWCE_LOG_CLS("Couldn't find the selected perk for this promotion! Not applying promotion.");
        return false;
    }

    if (m_iCurrentView == eSoldierView_PsiPromotion)
    {
        LWCE_XGFacility_PsiLabs(PSILABS()).LWCE_AddSoldier(kSoldier, kPerkChoice);

        if (m_bReturnToDebriefUI)
        {
            PRES().GetPsiLabsUI().GetMgr().UpdateView();
            OnLeavePromotion();
        }
        else
        {
            SetActiveSoldier(kSoldier);
        }

        return true;
    }
    else
    {
        // Perk 46 is used by Long War to select a random subclass for a new soldier
        if (kPerkChoice.iPerkId == 46)
        {
            // Signals for the soldier's class to be set randomly
            kSoldier.LWCE_SetSoldierClass(0);
            UpdateDoll();
        }
        else
        {
            kSoldier.GivePerk(kPerkChoice.iPerkId);

            if (kPerkChoice.iNewClassId != -1)
            {
                kSoldier.LWCE_SetSoldierClass(kPerkChoice.iNewClassId);
                UpdateDoll();
            }
        }

        kSoldier.LWCE_LevelUpStats(kPerkChoice, GetAbilityTreeBranch());
        Sound().PlaySFX(SNDLIB().SFX_UI_ChoosePromotion);
    }

    UpdateView();
    return true;
}

function bool OnEquip(int iInventory, int iLocker)
{
    local LWCE_XGFacility_Lockers kLockers;
    local bool bEquipped, bEquippedArmor;

    kLockers = LWCE_XGFacility_Lockers(LOCKERS());

    if (m_kCELocker.arrOptions[iLocker].iState != eUIState_Normal)
    {
        PlayBadSound();
        return false;
    }

    if (m_kCEGear.arrOptions[iInventory].iOptionType == 0)
    {
        bEquipped = kLockers.LWCE_EquipArmor(m_kSoldier, m_kCELocker.arrOptions[iLocker].ItemName);
        bEquippedArmor = bEquipped;
        Sound().PlaySFX(SNDLIB().SFX_UI_EquipArmor);

        if ((!BARRACKS().m_bVolunteerUrged && HQ().HasFacility(/* Gollop Chamber */ eFacility_DeusEx)) && BARRACKS().HasPotentialVolunteer())
        {
            BARRACKS().m_bVolunteerUrged = true;
            m_bUrgeGollop = true;
        }
    }
    else if (m_kCEGear.arrOptions[iInventory].iOptionType == 1)
    {
        bEquipped = kLockers.LWCE_EquipPistol(m_kSoldier, m_kCELocker.arrOptions[iLocker].ItemName);
        Sound().PlaySFX(SNDLIB().SFX_UI_EquipWeapon);
    }
    else if (m_kCEGear.arrOptions[iInventory].iOptionType == 2)
    {
        bEquipped = kLockers.LWCE_EquipLargeItem(m_kSoldier, m_kCELocker.arrOptions[iLocker].ItemName, m_kCEGear.arrOptions[iInventory].iSlot);
        Sound().PlaySFX(SNDLIB().SFX_UI_EquipWeapon);
    }
    else if (m_kCEGear.arrOptions[iInventory].iOptionType == 3)
    {
        bEquipped = kLockers.LWCE_EquipSmallItem(m_kSoldier, m_kCELocker.arrOptions[iLocker].ItemName, m_kCEGear.arrOptions[iInventory].iSlot);
        Sound().PlaySFX(SNDLIB().SFX_UI_EquipWeapon);
    }

    if (bEquipped)
    {
        m_kSoldier.OnLoadoutChange();
        UpdateDoll();

        if (bEquippedArmor)
        {
            if (!m_kSoldier.IsASuperSoldier())
            {
                // TODO: pull this from item template
                LOCKERS().DoNarrativeMomentsForEquipingArmors(m_kSoldier.m_kChar.kInventory.iArmor);
            }
        }
    }

    return bEquipped;
}

/**
 * Callback for when gear is clicked in the loadout screen, either currently-equipped gear or gear in the locker.
 */
function OnGearAccept()
{
    local int I;
    local LWCEEquipmentTemplate kEquipment;

    if (!m_kCELocker.bIsSelected && m_kCELocker.arrOptions.Length >= 0)
    {
        m_kCELocker.bIsSelected = true;
        PlayGoodSound();
    }
    else if (OnEquip(m_kCEGear.iHighlight, m_kCELocker.iHighlight))
    {
        m_kCELocker.bIsSelected = false;
        m_kCEGear.bDataDirty = true;

        // Check if the most recent equipment change has invalidated any other equipment,
        // and if so, remove it
        for (I = 0; I < m_kCEGear.arrOptions.Length; I++)
        {
            kEquipment = LWCEEquipmentTemplate(`LWCE_ITEM(m_kCEGear.arrOptions[I].ItemName));

            if (kEquipment == none)
            {
                continue;
            }

            if (!HasAnyOfItemsEquipped(kEquipment.arrCompatibleEquipment, true)
              || HasAnyOfItemsEquipped(kEquipment.arrIncompatibleEquipment, false)
              || HasAnyOfItemsEquipped(kEquipment.arrMutuallyExclusiveEquipment, false))
            {
                OnUnequipGear(I);
            }
        }

        UpdateView();
        PRES().m_kSoldierSummary.UpdatePanels();

        if (PRES().m_kSoldierLoadout != none)
        {
            PRES().m_kSoldierLoadout.UpdatePanels();
        }
    }
}

function bool OnNextSoldier(optional bool includeSHIV = false, optional bool SkipSpecial = false, optional bool includeMEC = true)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local XGStrategySoldier NextSoldier;
    local int iClassId, iNextSoldierIndex;

    if (BARRACKS().m_arrSoldiers.Length <= 1 || m_bPreventSoldierCycling)
    {
        return false;
    }

    iNextSoldierIndex = CycleSoldierIndex(1, m_iCurrentView == eSoldierView_PsiPromotion, includeSHIV, SkipSpecial, includeMEC);
    NextSoldier = BARRACKS().m_arrSoldiers[iNextSoldierIndex];

    if (HANGAR().m_kSkyranger.m_arrSoldiers.Find(m_kSoldier) == INDEX_NONE)
    {
        `CONTENTMGR.RequestContentCacheFlush();
    }

    if (m_kSoldier.PerkLockedOut(1, 0, false) || m_iCurrentView != eSoldierView_Promotion || m_kSoldier.IsATank() || m_kSoldier.IsAugmented())
    {
        SetActiveSoldier(NextSoldier);
    }
    else if (IsOptionEnabled(`LW_SECOND_WAVE_ID(CommandersChoice)))
    {
        kCESoldier = LWCE_XGStrategySoldier(m_kSoldier);

        iClassId = GetNextValidClassId(1, kCESoldier.m_kCEChar.iBaseClassId);
        kCESoldier.m_kCESoldier.iSoldierClassId = iClassId;
        kCESoldier.m_kCEChar.iBaseClassId = iClassId;
        kCESoldier.m_kCEChar.iClassId = iClassId;

        STORAGE().AutoEquip(m_kSoldier);
        UpdateDoll();
    }
    else
    {
        SetActiveSoldier(NextSoldier);
    }

    m_kCEGear.iHighlight = 0;
    UpdateView();
    PlayScrollSound();
    return true;
}

function bool OnPrevSoldier(optional bool includeSHIV = false, optional bool SkipSpecial = false, optional bool includeMEC = true)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local XGStrategySoldier PrevSoldier;
    local int iClassId, iPrevSoldierIndex;

    if (BARRACKS().m_arrSoldiers.Length <= 1 || m_bPreventSoldierCycling)
    {
        return false;
    }

    iPrevSoldierIndex = CycleSoldierIndex(-1, m_iCurrentView == eSoldierView_PsiPromotion, includeSHIV, SkipSpecial, includeMEC);
    PrevSoldier = BARRACKS().m_arrSoldiers[iPrevSoldierIndex];

    if (HANGAR().m_kSkyranger.m_arrSoldiers.Find(m_kSoldier) == INDEX_NONE)
    {
        `CONTENTMGR.RequestContentCacheFlush();
    }

    if (m_kSoldier.PerkLockedOut(1, 0, false) || m_iCurrentView != 1 || m_kSoldier.IsATank() || m_kSoldier.IsAugmented())
    {
        SetActiveSoldier(PrevSoldier);
    }
    else if (IsOptionEnabled(`LW_SECOND_WAVE_ID(CommandersChoice)))
    {
        kCESoldier = LWCE_XGStrategySoldier(m_kSoldier);

        iClassId = GetNextValidClassId(1, kCESoldier.m_kCEChar.iBaseClassId);
        kCESoldier.m_kCESoldier.iSoldierClassId = iClassId;
        kCESoldier.m_kCEChar.iBaseClassId = iClassId;
        kCESoldier.m_kCEChar.iClassId = iClassId;

        STORAGE().AutoEquip(m_kSoldier);
        UpdateDoll();
    }
    else
    {
        SetActiveSoldier(PrevSoldier);
    }

    m_kCEGear.iHighlight = 0;
    UpdateView();
    PlayScrollSound();
    return true;
}

function OnPromotionRight()
{
    local int iOption, iNumColumns;

    iOption = Clamp(GetAbilityTreeOption() - 1, 0, 2);
    iNumColumns = `LWCE_PERKS_STRAT.GetNumColumnsInTreeRow(LWCE_XGStrategySoldier(m_kSoldier), GetAbilityTreeBranch() - 1, m_iCurrentView == eSoldierView_PsiPromotion);

    if (iNumColumns == 1)
    {
        iOption = 1;
    }
    else if (iNumColumns == 2)
    {
        iOption = 0;
    }

    SetAbilityTreeOption(iOption);
    PlayScrollSound();
}

function OnPromotionLeft()
{
    local int iOption, iNumColumns;

    iOption = Clamp(GetAbilityTreeOption() + 1, 0, 2);
    iNumColumns = `LWCE_PERKS_STRAT.GetNumColumnsInTreeRow(LWCE_XGStrategySoldier(m_kSoldier), GetAbilityTreeBranch() - 1, m_iCurrentView == eSoldierView_PsiPromotion);

    if (iNumColumns == 1)
    {
        iOption = 1;
    }
    else if (iNumColumns == 2)
    {
        iOption = 2;
    }

    SetAbilityTreeOption(iOption);
    PlayScrollSound();
}

function OnPromotionUp()
{
    super.OnPromotionUp();
    ClampAbilityTreeSelection();
}

function OnPromotionDown()
{
    local bool bIsPsiPromotion;
    local int iNewBranch, iNumPerkRows;

    bIsPsiPromotion = m_iCurrentView == eSoldierView_PsiPromotion;
    iNumPerkRows = `LWCE_PERKS_STRAT.GetNumRowsInTree(LWCE_XGStrategySoldier(m_kSoldier), bIsPsiPromotion);
    iNewBranch = Min(GetAbilityTreeBranch() + 1, iNumPerkRows);

    SetAbilityTreeBranch(iNewBranch);
    PlayScrollSound();
    ClampAbilityTreeSelection();
}

function bool OnUnequipGear(optional int iGear = -1)
{
    local LWCE_TInventoryOption kOption;
    local LWCE_XGFacility_Lockers kLockers;

    kLockers = LWCE_XGFacility_Lockers(LOCKERS());

    if (iGear == -1)
    {
        iGear = m_kCEGear.iHighlight;
    }

    if (!m_kCELocker.bIsSelected)
    {
        kOption = m_kCEGear.arrOptions[iGear];

        if (kOption.ItemName != '')
        {
            switch (kOption.iOptionType)
            {
                case 3:
                    kLockers.UnequipSmallItem(m_kSoldier, kOption.iSlot);
                    break;
                case 2:
                    kLockers.UnequipLargeItem(m_kSoldier, kOption.iSlot);
                    break;
            }

            m_kSoldier.OnLoadoutChange();

            UpdateGear();
            UpdateLocker();
            UpdateView();

            PRES().m_kSoldierSummary.UpdatePanels();
            PlayGoodSound();

            return true;
        }
        else
        {
            PlayBadSound();
        }
    }
    else
    {
        PlayBadSound();
    }

    return false;
}

function bool PreviousPerksToAssign()
{
    local int iRow, iColumn;
    local int iNumColumns;
    local bool bHasPerkFromRow, bIsPsiPromotion;
    local LWCE_XComPerkManager kPerkMgr;
    local LWCE_XGStrategySoldier kSoldier;

    bIsPsiPromotion = m_iCurrentView == eSoldierView_PsiPromotion;
    kPerkMgr = `LWCE_PERKS_STRAT;
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    if (GetAbilityTreeBranch() <= 0)
    {
        return false;
    }

    for (iRow = 1; iRow < GetAbilityTreeBranch(); iRow++)
    {
        bHasPerkFromRow = false;
        iNumColumns = kPerkMgr.GetNumColumnsInTreeRow(kSoldier, iRow - 1, bIsPsiPromotion);

        for (iColumn = 0; iColumn < iNumColumns; iColumn++)
        {
            if (kSoldier.HasPerk(kSoldier.LWCE_GetPerkInClassTree(iRow - 1, GetAbilityTreeColumnAsPerkIndex(iRow - 1, iColumn), bIsPsiPromotion)))
            {
                bHasPerkFromRow = true;
                break;
            }
        }

        if (!bHasPerkFromRow)
        {
            return true;
        }
    }

    return false;
}

function bool ShouldAutoAssignPerk(out int iColumnToAssign)
{
    local bool bIsPsiPromotion;
    local int iRow;
    local LWCE_XComPerkManager kPerkMgr;
    local LWCE_XGStrategySoldier kSoldier;

    bIsPsiPromotion = m_iCurrentView == eSoldierView_PsiPromotion;
    kPerkMgr = `LWCE_PERKS_STRAT;
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);
    iRow = GetAbilityTreeBranch() - 1;

    if (kPerkMgr.GetNumColumnsInTreeRow(kSoldier, iRow, bIsPsiPromotion) == 1 && CanPromote())
    {
        iColumnToAssign = 1;
        return true;
    }

    iColumnToAssign = -1;
    return false;
}

function UpdateAbilities()
{
    local int Index;
    local TTableMenu kMenu;
    local TTableMenuOption kOption;
    local LWCE_XGStrategySoldier kSoldier;

    kSoldier = LWCE_XGStrategySoldier(m_KSoldier);

    kMenu.arrCategories.AddItem(21);

    for (Index = 0; Index < kSoldier.m_kCEChar.arrPerks.Length; Index++)
    {
        kOption.arrStates[0] = kSoldier.m_kCEChar.arrPerks[Index].Id;
        kOption.iState = eUIState_Normal;
        kMenu.arrOptions.AddItem(kOption);
    }

    kMenu.kHeader.arrStrings = GetHeaderStrings(kMenu.arrCategories);
    kMenu.kHeader.arrStates = GetHeaderStates(kMenu.arrCategories);
    kMenu.bTakesNoInput = true;
    m_kAbilities.tblAbilities = kMenu;
}

function UpdateDoll()
{
    local LWCE_XGStrategySoldier kSoldier;

    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    if (kSoldier != none)
    {
        m_kDoll.iFlag = kSoldier.GetCountry();
        m_kDoll.imgFlag.strPath = class'UIScreen'.static.GetFlagPath(m_kDoll.iFlag);

        if (kSoldier.IsATank())
        {
            m_kDoll.imgSoldier.strPath = `LWCE_ITEM(kSoldier.m_kCEChar.kInventory.nmArmor).ImagePath;
        }
        else
        {
            m_kDoll.imgSoldier.iImage = eImage_Soldier;
        }
    }
}

function UpdateGear()
{
    local LWCE_TInventory kInv;
    local int iItem, iOption, iIndex;

    kInv = LWCE_XGStrategySoldier(m_kSoldier).LWCE_GetInventory();
    m_kCEGear.arrOptions.Remove(0, m_kCEGear.arrOptions.Length);

    if (IsSlotValid(eInvSlot_Armor))
    {
        m_kCEGear.arrOptions[0] = LWCE_BuildInventoryOption(kInv.nmArmor, eInvSlot_Armor, 0 == m_kCEGear.iHighlight);
    }

    if (IsSlotValid(eInvSlot_Large))
    {
        for (iItem = 0; iItem < kInv.arrLargeItems.Length; iItem++)
        {
            iOption = m_kCEGear.arrOptions.Length;
            m_kCEGear.arrOptions.Add(1);
            m_kCEGear.arrOptions[iOption] = LWCE_BuildInventoryOption(kInv.arrLargeItems[iItem], eInvSlot_Large, iOption == m_kCEGear.iHighlight);
            m_kCEGear.arrOptions[iOption].iSlot = iItem;
        }
    }

    if (IsSlotValid(eInvSlot_Pistol))
    {
        m_kCEGear.arrOptions.Add(1);
        iIndex = m_kCEGear.arrOptions.Length - 1;
        m_kCEGear.arrOptions[iIndex] = LWCE_BuildInventoryOption(kInv.nmPistol, eInvSlot_Pistol, iIndex == m_kCEGear.iHighlight);
    }

    if (IsSlotValid(eInvSlot_Small))
    {
        for (iItem = 0; iItem < kInv.arrSmallItems.Length; iItem++)
        {
            iOption = m_kCEGear.arrOptions.Length;
            m_kCEGear.arrOptions.Add(1);
            m_kCEGear.arrOptions[iOption] = LWCE_BuildInventoryOption(kInv.arrSmallItems[iItem], eInvSlot_Small, iOption == m_kCEGear.iHighlight);
            m_kCEGear.arrOptions[iOption].iSlot = iItem;
        }
    }
}

function UpdateLocker()
{
    local LWCE_XGFacility_Lockers kLockers;
    local array<LWCE_TLockerItem> arrLockerItems;
    local int I;

    kLockers = LWCE_XGFacility_Lockers(LOCKERS());

    m_kCELocker.txtTitle.StrValue = m_strLabelLocker;
    m_kCELocker.arrOptions.Remove(0, m_kCELocker.arrOptions.Length);

    if (!IsSlotValid(EInventorySlot(m_kCEGear.arrOptions[m_kCEGear.iHighlight].iOptionType)))
    {
        return;
    }

    arrLockerItems = kLockers.LWCE_GetLockerItems(m_kCEGear.arrOptions[m_kCEGear.iHighlight].iOptionType, m_kCEGear.arrOptions[m_kCEGear.iHighlight].iSlot, m_kSoldier);

    for (I = 0; I < arrLockerItems.Length; I++)
    {
        m_kCELocker.arrOptions[I] = LWCE_BuildLockerOption(arrLockerItems[I], m_kCEGear.arrOptions[m_kCEGear.iHighlight].iOptionType);
        m_kCELocker.arrOptions[I].bHighlight = I == m_kCELocker.iHighlight;
    }

    if (m_kCELocker.arrOptions.Length == 0)
    {
        m_kCELocker.txtMsg.StrValue = m_strLabelNoneAvailable;
        m_kCELocker.txtMsg.iState = eUIState_Bad;
    }
    else
    {
        m_kCELocker.txtMsg.StrValue = "";
    }
}

function UpdateView()
{
    local LWCE_XGStrategySoldier kSoldier;

    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    UpdateHeader();
    UpdateButtonHelp();

    switch (m_iCurrentView)
    {
        case eSoldierView_MainMenu:
            UpdateDoll();
            UpdateMainMenu();
            UpdateAbilities();
            break;
        case eSoldierView_Promotion:
        case eSoldierView_PsiPromotion:
        case eSoldierView_MECPromotion:
            UpdateDoll();
            UpdateAbilities();
            break;
        case eSoldierView_Gear:
            UpdateDoll();
            UpdateAbilities();
            UpdateGear();
            UpdateLocker();
            break;
        case eSoldierView_GeneMods:
            UpdateDoll();
            UpdateAbilities();
            break;
        default:
            UpdateDoll();
            break;
    }

    super(XGScreenMgr).UpdateView();

    if (m_iCurrentView == eSoldierView_Gear)
    {
        if (LOCKERS().m_bNarrArcWarning)
        {
            Narrative(`XComNarrativeMoment("ArcWarning"));
            LOCKERS().m_bNarrArcWarning = false;
        }
        else if (m_bUrgeGollop)
        {
            m_bUrgeGollop = false;
            Narrative(`XComNarrativeMoment("UrgeGollopEntry"));
        }
    }
    else if (m_iCurrentView == eSoldierView_Promotion)
    {
        if (kSoldier.LWCE_GetClass() == eSC_Sniper)
        {
            Narrative(`XComNarrativeMoment("FirstSniper"));
        }
        else if (kSoldier.LWCE_GetClass() == eSC_Assault)
        {
            Narrative(`XComNarrativeMoment("FirstAssault"));
        }
        else if (kSoldier.LWCE_GetClass() == eSC_HeavyWeapons)
        {
            Narrative(`XComNarrativeMoment("FirstHeavy"));
        }
        else if (kSoldier.LWCE_GetClass() == eSC_Support)
        {
            Narrative(`XComNarrativeMoment("FirstSupport"));
        }
    }
}

/// <summary>
/// Returns the current column in the order [0, 1, 2], as opposed to the way the base game does it, [2, 1, 0] (and sometimes 3).
/// </summary>
function int GetAbilityTreeColumnAsPerkIndex(optional int iRow = -1, optional int iColumn = -1)
{
    local int iNumColumns;

    if (iRow == -1)
    {
        iRow = GetAbilityTreeBranch() - 1;
    }

    if (iColumn == -1)
    {
        iColumn = GetAbilityTreeOption();
    }

    iNumColumns = `LWCE_PERKS_STRAT.GetNumColumnsInTreeRow(LWCE_XGStrategySoldier(m_kSoldier), iRow, m_iCurrentView == eSoldierView_PsiPromotion);

    if (iNumColumns == 1)
    {
        return 0;
    }

    if (iNumColumns == 2)
    {
        if (iColumn == 2 || iColumn == 3)
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }

    // Column numbers from UI range from 1 to 3, but backwards (i.e. index 3 is the leftmost, not rightmost).
    // Flip them around and subtract 1 to get the array index.
    return iNumColumns - iColumn - 1;
}

function string GetStatChangesString(LWCE_TCharacterStats kStats)
{
    local int Index;
    local array<string> arrStatValues;
    local array<string> arrStatStrings;
    local string strOutput;

    if (kStats.iAim > 0)
    {
        arrStatValues.AddItem("+" $ kStats.iAim);
        arrStatStrings.AddItem(m_strStatBonusesAim);
    }

    if (kStats.iHP > 0)
    {
        arrStatValues.AddItem("+" $ kStats.iHP);
        arrStatStrings.AddItem(m_strStatBonusesHP);
    }

    if (kStats.iMobility > 0)
    {
        arrStatValues.AddItem("+" $ kStats.iMobility);
        arrStatStrings.AddItem(m_strStatBonusesMobility);
    }

    if (kStats.iWill > 0)
    {
        arrStatValues.AddItem("+" $ kStats.iWill);
        arrStatStrings.AddItem(m_strStatBonusesWill);
    }

    // Damage Reduction is the only non-int stat so it has to be handled specially
    if (arrStatValues.Length == 0 && kStats.fDamageReduction == 0.0)
    {
        return "";
    }

    strOutput = m_strStatBonusesPrefix;

    if (kStats.fDamageReduction != 0.0)
    {
        strOutput $= m_strStatBonusesDamageReduction $ kStats.fDamageReduction; // TODO rounding issues

        if (arrStatValues.Length > 0)
        {
            strOutput $= m_strStatBonusesSeparator;
        }
    }

    for (Index = 0; Index < arrStatValues.Length; Index++)
    {
        // TODO: this assumes stat numbers should always be appended, but it's hard to localize an unknown number of values
        strOutput $= arrStatValues[Index] $ arrStatStrings[Index];

        if (Index != arrStatValues.Length - 1)
        {
            strOutput $= m_strStatBonusesSeparator;
        }
    }

    return strOutput;
}

function TItemCard SOLDIERUIGetItemCard()
{
    local TItemCard kItemCard;

    `LWCE_LOG_DEPRECATED_CLS(SOLDIERUIGetItemCard);

    return kItemCard;
}

function LWCE_TItemCard LWCE_SOLDIERUIGetItemCard()
{
    local LWCE_TItemCard kItemCard;

    if (m_kCELocker.bIsSelected)
    {
        kItemCard = class'LWCE_XGItemCards'.static.BuildItemCard(m_kCELocker.arrOptions[m_kCELocker.iHighlight].ItemName, LWCE_XGStrategySoldier(m_kSoldier));
    }
    else
    {
        kItemCard = class'LWCE_XGItemCards'.static.BuildItemCard(m_kCEGear.arrOptions[m_kCEGear.iHighlight].ItemName, LWCE_XGStrategySoldier(m_kSoldier));
    }

    return kItemCard;
}

function UpdateHeader()
{
    local name nmOriginalArmor, nmOriginalWeapon;
    local int aModifiers[ECharacterStat];
    local array<name> arrBackPackItems;
    local LWCE_XGFacility_Lockers kLockers;
    local LWCE_XGTacticalGameCore kGameCore;
    local LWCE_XGStrategySoldier kSoldier;

    kLockers = LWCE_XGFacility_Lockers(LOCKERS());
    kGameCore = `LWCE_GAMECORE;
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    m_kHeader.txtName.StrValue = kSoldier.GetName(eNameType_First) @ kSoldier.GetName(eNameType_Last);
    m_kHeader.txtName.iState = eUIState_Normal;

    m_kHeader.txtNickname.StrValue = kSoldier.GetName(eNameType_Nick);
    m_kHeader.txtNickname.iState = eUIState_Nickname;

    m_kHeader.txtStatus.strLabel = m_strLabelStatus;
    m_kHeader.txtStatus.StrValue = kSoldier.GetStatusString();
    m_kHeader.txtStatus.iState = kSoldier.GetStatusUIState();

    m_kHeader.txtOffense.strLabel = m_strLabelOffense;
    m_kHeader.txtOffense.StrValue = string(kSoldier.GetMaxStat(eStat_Offense));
    m_kHeader.txtOffense.iState = eUIState_Normal;
    m_kHeader.txtOffense.bNumber = true;

    m_kHeader.txtDefense.strLabel = m_strLabelDefense;
    m_kHeader.txtDefense.StrValue = string(kSoldier.GetMaxStat(eStat_Defense));
    m_kHeader.txtDefense.iState = eUIState_Normal;
    m_kHeader.txtDefense.bNumber = true;

    m_kHeader.txtHP.strLabel = m_strLabelHPSPACED;
    m_kHeader.txtHP.StrValue = string(kSoldier.GetMaxStat(eStat_HP));

    if (kSoldier.IsInjured())
    {
        m_kHeader.txtHP.StrValue $= "/" $ kSoldier.GetMaxStat(eStat_HP);
        m_kHeader.txtHP.iState = eUIState_Bad;
    }

    m_kHeader.txtHP.bNumber = true;

    m_kHeader.txtSpeed.strLabel = m_strLabelMobility;
    m_kHeader.txtSpeed.StrValue = string(kSoldier.GetMaxStat(eStat_Mobility));
    m_kHeader.txtSpeed.iState = eUIState_Normal;
    m_kHeader.txtSpeed.bNumber = true;

    m_kHeader.txtWill.strLabel = m_strLabelWill;
    m_kHeader.txtWill.StrValue = string(kSoldier.GetMaxStat(eStat_Will));

    if (IsInCovertOperativeMode())
    {
        nmOriginalArmor = kSoldier.m_kCEChar.kInventory.nmArmor;
        nmOriginalWeapon = kSoldier.m_kCEChar.kInventory.arrLargeItems[0];

        kSoldier.m_kCEChar.kInventory.nmArmor = 'Item_LeatherJacket';
        kLockers.LWCE_EquipLargeItem(kSoldier, 'Item_AssaultRifle', 0);

        arrBackpackItems = class'LWCEInventoryUtils'.static.GetAllBackpackItems(kSoldier.m_kCEChar.kInventory);
        kGameCore.LWCE_GetInventoryStatModifiers(aModifiers, kSoldier.m_kCEChar, 'Item_AssaultRifle', arrBackPackItems);

        kSoldier.m_kCEChar.kInventory.nmArmor = nmOriginalArmor;
        kLockers.LWCE_EquipLargeItem(kSoldier, nmOriginalWeapon, 0);
    }
    else
    {
        arrBackpackItems = class'LWCEInventoryUtils'.static.GetAllBackpackItems(kSoldier.m_kCEChar.kInventory);
        kGameCore.LWCE_GetInventoryStatModifiers(aModifiers, kSoldier.m_kCEChar, kGameCore.LWCE_GetEquipWeapon(kSoldier.m_kCEChar.kInventory), arrBackPackItems);
    }

    m_kHeader.txtHPMod.StrValue = string(aModifiers[eStat_HP]);
    m_kHeader.txtOffenseMod.StrValue = string(aModifiers[eStat_Offense]);
    m_kHeader.txtDefenseMod.StrValue = string(aModifiers[eStat_Defense]);
    m_kHeader.txtSpeedMod.StrValue = string(aModifiers[eStat_Mobility]);
    m_kHeader.txtWillMod.StrValue = string(aModifiers[eStat_Will]);
    m_kHeader.txtCritShot.StrValue = string(aModifiers[eStat_FlightFuel]);
    m_kHeader.txtStrength.StrValue = (string((aModifiers[eStat_DamageReduction] % 100) / 10) $ ".") $ string((aModifiers[eStat_DamageReduction] % 100) % 10); // Damage Reduction
}

protected function int GetNextValidClassId(int iDirection, int iClassId)
{
    local int Index, iCurrentIndex;
    local LWCE_XGFacility_Barracks kBarracks;

    iDirection = iDirection > 0 ? 1 : -1; // normalize direction value
    kBarracks = LWCE_XGFacility_Barracks(BARRACKS());

    iCurrentIndex = kBarracks.arrSoldierClasses.Find('iSoldierClassId', iClassId);

    if (iCurrentIndex == INDEX_NONE)
    {
        `LWCE_LOG_CLS("ERROR: could not locate class definition for soldier class ID " $ iClassId);
        return -1;
    }

    // Start just after the current class; keep going (using modular arithmetic to stay in bounds) until we get back where we started
    for (Index = iCurrentIndex + iDirection; Index != iCurrentIndex; Index = (Index + iDirection) % kBarracks.arrSoldierClasses.Length)
    {
        if (!kBarracks.arrSoldierClasses[Index].bIsBaseClass || kBarracks.arrSoldierClasses[Index].bIsPsionic)
        {
            continue;
        }

        return kBarracks.arrSoldierClasses[Index].iSoldierClassId;
    }

    `LWCE_LOG_CLS("WARNING: could not find any valid next class ID for soldier class ID " $ iClassId);
    return iClassId;
}