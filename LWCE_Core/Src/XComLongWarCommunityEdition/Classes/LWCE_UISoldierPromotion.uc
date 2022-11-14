class LWCE_UISoldierPromotion extends UISoldierPromotion;

// Important notes for promotion UI:
//     * The tree "branch" (as in m_kLocalMgr.GetAbilityTreeBranch()) refers to the row, and numbers 1 (top) through 7 (bottom)
//     * The tree "option" (as in m_kLocalMgr.GetAbilityTreeOption()) refers to the column, and numbers 2 through 0 (the leftmost option is 2, rightmost 0)

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager, bool _psiPromote, bool _mecPromote)
{
    local XGSoldierUI kMgr;
    local int iView;

    BaseInit(_controllerRef, _manager);
    m_bPsiPromotion = _psiPromote;
    m_bMECPromotion = _mecPromote;

    if (_mecPromote)
    {
        iView = 3;
    }
    else if (_psiPromote)
    {
        iView = 2;
    }
    else
    {
        iView = 1;
    }

    m_kSoldier = kSoldier;

    if (!XComHQPresentationLayer(controllerRef.m_Pres).IsMgrRegistered(class'LWCE_XGSoldierUI'))
    {
        kMgr = Spawn(class'LWCE_XGSoldierUI', XComHQPresentationLayer(controllerRef.m_Pres));
        kMgr.m_kInterface = self;
        kMgr.m_kSoldier = kSoldier;
        XComHQPresentationLayer(controllerRef.m_Pres).AddPreformedMgr(kMgr);

        kMgr.Init(iView);
        m_kLocalMgr = kMgr;
    }

    m_kSoldierHeader = Spawn(class'LWCE_UIStrategyComponent_SoldierInfo', self);
    m_kSoldierHeader.Init(_controllerRef, _manager, self, m_kSoldier);

    m_kSoldierStats = Spawn(class'UIStrategyComponent_SoldierStats', self);
    m_kSoldierStats.Init(GetMgr(), _controllerRef, _manager, self);

    m_kMecSoldierStats = Spawn(class'LWCE_UISoldierPromotion_MecBonusAbility', self);
    m_kMecSoldierStats.Init(_controllerRef, _manager, self, m_kSoldier);

    foreach AllActors(class'SkeletalMeshActor', m_kCameraRig)
    {
        if (m_kCameraRig.Tag == 'UICameraRig_SoldierPromote')
        {
            m_kCameraRigDefaultLocation = m_kCameraRig.Location;
            break;
        }
    }

    manager.LoadScreen(self);
}

simulated function XGSoldierUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGSoldierUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGSoldierUI', self, iStaringView));
    }

    return m_kLocalMgr;
}

simulated function InitializeTree()
{
    local Vector kCameraOffset;
    local XGParamTag kTag;
    local string strTitle;
    local LWCE_XGStrategySoldier kSoldier;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    if (m_bPsiPromotion)
    {
        strTitle = m_strPsiAbilitiesTitle;
    }
    else
    {
        kTag.StrValue0 = Caps(kSoldier.GetClassName());
        strTitle = class'XComLocalizer'.static.ExpandString(m_strNormalAbilitiesTitle);
    }

    AS_InitializeTree(strTitle, kSoldier.GetClassIcon(), m_bPsiPromotion);

    if (kSoldier.IsAugmented())
    {
        // Move camera to accommodate MECs who aren't in the base augments, due to their model's size
        if (kSoldier.m_kCEChar.kInventory.nmArmor != 'Item_BaseAugments')
        {
            kCameraOffset += (TransformVectorByRotation(m_kCameraRig.Rotation, vect(0.0, 0.0, 1.0)) * m_kCameraRigMecVerticalOffset);
        }
    }

    m_kCameraRig.SetLocation(m_kCameraRigDefaultLocation - kCameraOffset);
    `HQPRES.CAMLookAtNamedLocation(m_strCameraTag, 1.0);
}

simulated function UpdateAbilityData()
{
    local int iRow, iColumn, iColumn_AS, iPerkId, iNumColumns, iNumActualRows, iSoldierRank;
    local bool bIsRowPromotable, bIsFirstPromotableRow;
    local EColumnHighlightState eHighlightState;
    local LWCE_XGSoldierUI kMgr;
    local LWCE_XComPerkManager kPerkMgr;
    local LWCE_XGStrategySoldier kSoldier;

    kMgr = LWCE_XGSoldierUI(GetMgr());
    kPerkMgr = `LWCE_PERKS_STRAT;
    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    if (m_bPsiPromotion)
    {
        iSoldierRank = kSoldier.GetPsiRank();

        if (kSoldier.IsReadyToPsiLevelUp())
        {
            ++iSoldierRank;
        }
    }
    else
    {
        iSoldierRank = kSoldier.GetRank();
    }

    iNumActualRows = kPerkMgr.GetNumRowsInTree(kSoldier, m_bPsiPromotion);
    bIsFirstPromotableRow = true;

    for (iRow = 0; iRow < 7; iRow++)
    {
        // Only populate the row (except for the rank name) if there are perks in the current tree
        if (iRow < iNumActualRows)
        {
            iNumColumns = kPerkMgr.GetNumColumnsInTreeRow(kSoldier, iRow, m_bPsiPromotion);

            // Don't show row if it's for a future rank and Hidden Trees is enabled
            if (iRow >= iSoldierRank && m_kSoldier.IsOptionEnabled(`LW_SECOND_WAVE_ID(HiddenTrees)))
            {
                iColumn = iNumColumns;
                bIsFirstPromotableRow = false;
            }
            else
            {
                bIsRowPromotable = iRow < iSoldierRank;

                for (iColumn = 0; iColumn < iNumColumns; iColumn++)
                {
                    // TODO maybe find a way to do this where the same perk can be in multiple places on the tree
                    iPerkId = kSoldier.LWCE_GetPerkInClassTree(iRow, iColumn, m_bPsiPromotion);

                    if (kSoldier.HasPerk(iPerkId))
                    {
                        bIsRowPromotable = false;
                    }
                }

                for (iColumn = 0; iColumn < iNumColumns; iColumn++)
                {
                    iPerkId = kSoldier.LWCE_GetPerkInClassTree(iRow, iColumn, m_bPsiPromotion);

                    if (iNumColumns == 1)
                    {
                        // If there's only one perk in the row, put it in the middle position
                        iColumn_AS = 1;
                    }
                    else
                    {
                        // The AS columns number (2, 1, 0) instead of (0, 1, 2)
                        iColumn_AS = iNumColumns - iColumn - 1;

                        if (iColumn_AS == 1 && iNumColumns == 2)
                        {
                            iColumn_AS = 2;
                        }
                    }

                    if (iPerkId > 0)
                    {
                        if (bIsFirstPromotableRow)
                        {
                            if (bIsRowPromotable)
                            {
                                AS_SetAbilityIcon(iRow, iColumn_AS, kPerkMgr.GetPerkImage(iPerkId), kSoldier.PerkLockedOut(iPerkId, iRow, m_bPsiPromotion));
                            }
                            else
                            {
                                AS_SetAbilityIcon(iRow, iColumn_AS, kPerkMgr.GetPerkImage(iPerkId), kSoldier.HasPerk(iPerkId));
                            }
                        }
                        else
                        {
                            AS_SetAbilityIcon(iRow, iColumn_AS, kPerkMgr.GetPerkImage(iPerkId), false);
                        }
                    }
                }

                if (bIsRowPromotable)
                {
                    if (bIsFirstPromotableRow)
                    {
                        eHighlightState = eCHS_On;
                        bIsFirstPromotableRow = false;
                        kMgr.SetAbilityTreeBranch(iRow + 1);
                    }
                    else
                    {
                        eHighlightState = eCHS_Off;
                    }
                }
                else
                {
                    eHighlightState = eCHS_Off;
                }
            }
        }
        else
        {
            eHighlightState = eCHS_Locked;
        }

        if (kSoldier.HasAnyMedal() && iRow >= 2)
        {
            AS_SetColumnData(iRow, Caps(kSoldier.GetName(eNameType_Rank)) @ string(iRow), eHighlightState);
        }
        else
        {
            AS_SetColumnData(iRow, Caps(`GAMECORE.GetRankString(iRow + 1,, m_bPsiPromotion)), eHighlightState);
        }
    }

    // Sometimes choosing a perk changes the size of the tree (e.g. when picking a new class), so clamp to avoid that
    kMgr.ClampAbilityTreeSelection();
    RealizeSelected();
}
