class LWCE_XGBuildUI extends XGBuildUI
    dependson(LWCE_XGBase, LWCE_XGFacility_Engineering);

struct LWCE_TFacilityTable
{
    var TTableMenu mnuOptions;
    var array<TObjectSummary> arrSummaries;
    var array<name> arrFacilities;
};

struct LWCE_TUIBaseTile
{
    var LWCE_TTerrainTile kTile;
    var TText txtLabel;
    var TText txtCounter;
    var TImage imgTile;
    var bool bDisabled;
};

struct LWCE_TUIFacilityTile
{
    var LWCE_TFacilityTile kTile;
    var TText txtLabel;
    var TText txtCounter;
    var TImage imgTile;
    var bool bDoubleSize;
    var bool bAdjacencyBonusLeft;
    var bool bAdjacencyBonusTop;
};

var int m_iBaseId; // ID of the base which this UI is looking at
var array<LWCE_TUIFacilityTile> m_arrCEFacilityTiles;
var LWCE_TFacilityTable m_kCETable;
var array<LWCE_TUIBaseTile> m_arrCETiles;

var private LWCE_XGHeadquarters m_kHQ; // just to save casting constantly

function Init(int iView)
{
    m_kHQ = LWCE_XGHeadquarters(HQ());
    m_iBaseId = m_kHQ.m_arrBases[0].m_iId; // TODO: add hooks for mods to let us pick other bases somehow

    super.Init(iView);
}

function TUIBaseTile BuildBaseTile(int iTileIndex)
{
    local TUIBaseTile kTile;

    `LWCE_LOG_DEPRECATED_CLS(BuildBaseTile);

    return kTile;
}

function LWCE_TUIBaseTile LWCE_BuildBaseTile(int iTileIndex)
{
    local LWCE_XGBase kBase;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_TUIBaseTile kUITile;
    local LWCE_TFacilityProject kFacilityProject;
    local LWCE_TConstructionProject kConstructionProject;
    local XGParamTag kTag;
    local int Index;

    kBase = GetTargetBase();
    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());

    kUITile.kTile = kBase.m_arrCETiles[iTileIndex];
    Index = kBase.m_arrTerrainTypeConfig.Find('nmTerrainType', kUITile.kTile.nmType);

    if (Index != INDEX_NONE)
    {
        kUITile.imgTile.strLabel = kBase.m_arrTerrainTypeConfig[Index].ImageName;
    }

    if (kUITile.kTile.nmType == 'RockSteam' || kUITile.kTile.nmType == 'ExcavatedSteam')
    {
        if (iTileIndex != m_iLastTileIndex)
        {
            kUITile.txtLabel.StrValue = m_strLabelSteam;
        }
    }

    kTag = new class'XGParamTag';

    if (kUITile.kTile.bConstruction)
    {
        kUITile.imgTile.strLabel = "Construction";
        kFacilityProject = kEngineering.LWCE_GetFacilityProject(kBase.m_iId, kUITile.kTile.X, kUITile.kTile.Y);
        kTag.IntValue0 = kEngineering.LWCE_GetFacilityCounter(kFacilityProject);
        kUITile.txtLabel.StrValue = `LWCE_FACILITY(kFacilityProject.FacilityName).strName;
        kUITile.txtCounter.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strLabelDays, kTag);
    }
    else if (kUITile.kTile.bExcavation)
    {
        kUITile.imgTile.strLabel = "BeingExcavated";
        kConstructionProject = kEngineering.LWCE_GetConstructionProject(kBase.m_iId, kUITile.kTile.X, kUITile.kTile.Y);
        kTag.IntValue0 = kEngineering.LWCE_GetConstructionCounter(kConstructionProject);
        kUITile.txtLabel.StrValue = m_strLabelExcavating;
        kUITile.txtCounter.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strLabelDays, kTag);
    }

    if (kUITile.kTile.eState != eTileState_Accessible)
    {
        kUITile.bDisabled = true;
    }

    return kUITile;
}

function TTableMenuOption BuildFacilityOption(TFacility kFacility, array<int> arrCategories)
{
    local TTableMenuOption kOption;

    `LWCE_LOG_DEPRECATED_CLS(BuildFacilityOption);

    return kOption;
}

function TTableMenuOption LWCE_BuildFacilityOption(LWCEFacilityTemplate kFacility, array<int> arrCategories)
{
    local TTableMenuOption kOption;
    local int iCategory, iPower, iState;
    local string strCategory;

    for (iCategory = 0; iCategory < arrCategories.Length; iCategory++)
    {
        iState = 0;
        strCategory = "";

        switch (arrCategories[iCategory])
        {
            case 2:
                strCategory = kFacility.strName;

                if (kFacility.IsBuildPriority())
                {
                    strCategory @= "-" @ m_strPriority;
                    iState = eUIState_Good;
                }

                break;
            case 6:
                strCategory = string(kFacility.kCost.iCash);

                if (kFacility.kCost.iCash > GetResource(eResource_Money))
                {
                    iState = eUIState_Bad;
                    kOption.iState = eUIState_Disabled;
                    kOption.strHelp = m_strErrNeedFunds;
                }

                break;
            case 9:
                strCategory = string(kFacility.GetBuildTimeInHours(/* bRush */ false));
                break;
            case 12:
                iPower = kFacility.GetPower();

                if (iPower < 0)
                {
                    strCategory = "+";
                }

                strCategory $= iPower;

                if (iPower > 0 && iPower > GetResource(eResource_Power))
                {
                    iState = eUIState_Bad;
                    kOption.iState = eUIState_Disabled;
                    kOption.strHelp = m_strErrNeedPower;
                }

                break;
        }

        if (kFacility.nmRequiredTerrainType != '' && kFacility.nmRequiredTerrainType != LWCE_XGBase(Base()).LWCE_GetTileAt(m_kCursor.X, m_kCursor.Y).nmType)
        {
            kOption.iState = eUIState_Disabled;
            kOption.strHelp = m_strErrNeedSteam; // TODO update this error message
        }

        kOption.arrStrings.AddItem(strCategory);
        kOption.arrStates.AddItem(iState);
    }

    return kOption;
}

function TUIFacilityTile BuildFacilityTile(int iTileIndex)
{
    local TUIFacilityTile kTile;

    `LWCE_LOG_DEPRECATED_CLS(BuildFacilityTile);

    return kTile;
}

function LWCE_TUIFacilityTile LWCE_BuildFacilityTile(int iTileIndex)
{
    local LWCE_XGBase kBase;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_TUIFacilityTile kUITile;
    local LWCEFacilityTemplate kFacility;
    local LWCE_TConstructionProject kConstructionProject;
    local XGParamTag kTag;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kBase = GetTargetBase();
    kFacility = `LWCE_FACILITY(kBase.m_arrCEFacilities[iTileIndex].FacilityName);

    kUITile.kTile = kBase.m_arrCEFacilities[iTileIndex];
    kUITile.txtLabel.StrValue = kFacility.strName;
    kUITile.bDoubleSize = false; // TODO: rewrite the size system to be more flexible
    kUITile.imgTile.strLabel = kFacility.ImageLabel;
    kUITile.bAdjacencyBonusLeft = kBase.LWCE_GetAdjacency(kUITile.kTile.X, kUITile.kTile.Y, kUITile.kTile.X - 1, kUITile.kTile.Y) != '';
    kUITile.bAdjacencyBonusTop = kBase.LWCE_GetAdjacency(kUITile.kTile.X, kUITile.kTile.Y, kUITile.kTile.X, kUITile.kTile.Y - 1) != '';

    if (kUITile.kTile.bIsBeingRemoved)
    {
        kTag = new class'XGParamTag';
        kConstructionProject = kEngineering.LWCE_GetConstructionProject(kBase.m_iId, kUITile.kTile.X, kUITile.kTile.Y);
        kTag.IntValue0 = kEngineering.LWCE_GetConstructionCounter(kConstructionProject);
        kUITile.txtLabel.StrValue @= m_strLabelRemoving;
        kUITile.txtCounter.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strLabelDays, kTag);
    }

    return kUITile;
}

function TObjectSummary BuildSummary(TFacility kFacility)
{
    local TObjectSummary kSummary;

    `LWCE_LOG_DEPRECATED_CLS(BuildSummary);

    return kSummary;
}

function TObjectSummary LWCE_BuildSummary(LWCEFacilityTemplate kFacility)
{
    local TObjectSummary kSummary;

    kSummary.imgObject.strPath = kFacility.ImagePath;
    kSummary.txtSummary.StrValue = kFacility.strBriefSummary;
    kSummary.txtRequirementsLabel.StrValue = m_strLabelRequiredBuild;
    kSummary.bCanAfford = LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_GetFacilityCostSummary(kSummary.kCost, kFacility.GetFacilityName(), m_kCursor.X, m_kCursor.Y, false);

    return kSummary;
}

simulated function ConfirmCancelConstructionDialogueCallback(EUIAction eAction)
{
    local LWCE_XGBase kBase;

    if (eAction == eUIAction_Accept)
    {
        kBase = GetTargetBase();

        kBase.m_arrCETiles[kBase.TileIndex(m_kCursor.X, m_kCursor.Y)].bConstruction = false;
        kBase.m_arrCETiles[kBase.TileIndex(m_kCursor.X, m_kCursor.Y)].bExcavation = false;

        if (kBase.LWCE_GetFacilityAt(m_kCursor.X, m_kCursor.Y) != '')
        {
            kBase.m_arrCEFacilities[kBase.TileIndex(m_kCursor.X, m_kCursor.Y)].bIsBeingRemoved = false;
        }

        LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_CancelConstructionProject(kBase.m_iId, m_kCursor.X, m_kCursor.Y);
        Sound().PlaySFX(SNDLIB().SFX_UI_FacilityRemoved);
    }

    UpdateView();
}

function string GetCostString(TProjectCost kCost)
{
    `LWCE_LOG_DEPRECATED_CLS(GetCostString);

    return "";
}

function string LWCE_GetCostString(LWCE_TProjectCost kCost)
{
    local string strReturn;

    strReturn = m_strLabelCost;

    if (kCost.kCost.iCash > 0)
    {
        strReturn @= ConvertCashToString(kCost.kCost.iCash);
    }

    return strReturn;
}

function int GetTilesHigh()
{
    return GetTargetBase().m_iNumTilesHigh;
}

function int GetTilesWide()
{
    return GetTargetBase().m_iNumTilesWide;
}

function OnChooseTile()
{
    local LWCE_XGBase kBase;

    kBase = GetTargetBase();

    if (m_kCursor.iCursorState == eBCS_CantDo)
    {
        PlayBadSound();
    }
    else if (m_kCursor.iCursorState == eBCS_BuildFacility)
    {
        GoToView(eBuildView_Menu);
        PRES().CAMLookAtHQTile(m_kCursor.X, m_kCursor.Y, 1.0);
    }
    else if (m_kCursor.iCursorState == eBCS_BuildAccessLift)
    {
        LWCE_XComHQPresentationLayer(PRES()).LWCE_UIManufactureFacility('Facility_AccessLift', kBase.m_iId, m_kCursor.X, m_kCursor.Y);
    }
    else if (m_kCursor.iCursorState == eBCS_Cancel)
    {
        ConfirmCancelConstructionDialogue();
    }
    else if (m_kCursor.iCursorState == eBCS_Excavate)
    {
        kBase.m_arrCETiles[Base().TileIndex(m_kCursor.X, m_kCursor.Y)].bExcavation = true;
        LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_AddConstructionProject(eBCS_Excavate, kBase.m_iId, m_kCursor.X, m_kCursor.Y);
        UpdateView();
        Sound().PlaySFX(SNDLIB().SFX_UI_ExcavationStarted);
    }
    else if (m_kCursor.iCursorState == eBCS_RemoveFacility)
    {
        LWCE_ConfirmRemovalDialogue(m_kCursor.X, m_kCursor.Y);
    }
}

function OnCursorLeft()
{
    if (m_kCursor.X == 0)
    {
        PlayBadSound();
        return;
    }

    m_kCursor.X -= 1;

    // TODO support facility sizes
    /*
    if (Base().GetTileAt(m_kCursor.X - 1, m_kCursor.Y).bSecondTile)
    {
        m_kCursor.X -= 2;
    }
    else
    {
        m_kCursor.X -= 1;
    }
    */

    PlayScrollSound();
    UpdateView();
}

function OnCursorRight()
{
    if (m_kCursor.X == LWCE_XGBase(Base()).m_iNumTilesWide - 1)
    {
        PlayBadSound();
        return;
    }

    m_kCursor.X += m_kCursor.iSize;
    PlayScrollSound();
    UpdateView();
}

function OnCursorUp()
{
    if (m_kCursor.Y == 1)
    {
        PlayBadSound();
        return;
    }

    m_kCursor.Y -= 1;

    // TODO support facility sizes
    /*
    if (Base().GetTileAt(m_kCursor.X, m_kCursor.Y).bSecondTile)
    {
        m_kCursor.X -= 1;
    }
     */

    PlayScrollSound();
    UpdateView();
}

function OnCursorDown()
{
    if (m_kCursor.Y == LWCE_XGBase(Base()).m_iNumTilesHigh - 1)
    {
        PlayBadSound();
        return;
    }

    m_kCursor.Y += 1;

    // TODO support facility sizes
    /*
    if (Base().GetTileAt(m_kCursor.X, m_kCursor.Y).bSecondTile)
    {
        m_kCursor.X -= 1;
    }
    */

    PlayScrollSound();
    UpdateView();
}

function OnChooseFacility(int iOption)
{
    if (m_kCETable.mnuOptions.arrOptions[iOption].iState == eUIState_Disabled)
    {
        PlayBadSound();
        return;
    }
    else
    {
        LWCE_XComHQPresentationLayer(PRES()).LWCE_UIManufactureFacility(m_kCETable.arrFacilities[iOption], m_iBaseId, m_kCursor.X, m_kCursor.Y);
    }
}

function UpdateCursor()
{
    local LWCE_XGBase kBase;
    local LWCE_TTerrainTile kTile;
    local LWCE_TProjectCost kCost;
    local TText txtCost, txtHelp;
    local TButtonText txtLabel;
    local name FacilityName;

    m_kCursor.iSize = 1;
    m_kCursor.iCursorState = eBCS_CantDo;
    kBase = GetTargetBase();
    kTile = kBase.LWCE_GetTileAt(m_kCursor.X, m_kCursor.Y);

    if ( kTile.eState == eTileState_Accessible && (kTile.bConstruction || kTile.bExcavation) )
    {
        m_kCursor.iCursorState = eBCS_Cancel;
        txtLabel.StrValue = m_strLabelCancel;
        txtLabel.iButton = 1;
    }
    else if (kTile.eState == eTileState_Accessible)
    {
        if (kTile.bHasFacility)
        {
                FacilityName = kBase.LWCE_GetFacilityAt(m_kCursor.X, m_kCursor.Y);
                // TODO implement variable facility sizes later
                // m_kCursor.iSize = `LWCE_FACILITY(FacilityName).iSize;

                if (kBase.m_arrCEFacilities[kBase.TileIndex(m_kCursor.X, m_kCursor.Y)].bIsBeingRemoved)
                {
                    m_kCursor.iCursorState = eBCS_Cancel;
                    txtLabel.StrValue = m_strLabelCancel;
                    txtLabel.iButton = 1;
                }
                else if (`LWCE_FACILITY(FacilityName).bCanDestroy)
                {
                    m_kCursor.iCursorState = eBCS_RemoveFacility;
                    txtLabel.StrValue = m_strLabelRemove;
                    txtLabel.iButton = 1;
                }

                m_iLastTileIndex = -1;
        }
        else
        {
            switch (kTile.nmType)
            {
                case 'Open':
                case 'Excavated':
                case 'ExcavatedSteam':
                    if (kBase.IsAccessLocation(m_kCursor.X, m_kCursor.Y))
                    {
                        m_kCursor.iCursorState = eBCS_BuildAccessLift;
                        txtLabel.StrValue = m_strLabelBuildLift;
                        txtLabel.iButton = 1;
                    }
                    else
                    {
                        m_kCursor.iCursorState = eBCS_BuildFacility;
                        txtLabel.StrValue = m_strLabelBuildFacility;
                        txtLabel.iButton = 1;
                    }

                    if (kTile.nmType == 'ExcavatedSteam')
                    {
                        RemoveTerrainTileLabelAtIndex(kBase.TileIndex(m_kCursor.X, m_kCursor.Y));
                    }
                    else
                    {
                        m_iLastTileIndex = -1;
                    }

                    break;
                case 'Rock':
                case 'RockSteam':
                    m_kCursor.iCursorState = eBCS_Excavate;
                    txtLabel.StrValue = m_strLabelExcavate;
                    txtLabel.iButton = 1;

                    if (kTile.nmType == 'RockSteam')
                    {
                        RemoveTerrainTileLabelAtIndex(kBase.TileIndex(m_kCursor.X, m_kCursor.Y));
                    }
                    else
                    {
                        m_iLastTileIndex = -1;
                    }
                    break;
                default:
                    break;
            }
        }

    }
    else if (kTile.eState == eTileState_NoAccess)
    {
        txtHelp.StrValue = m_strErrNeedLift;
        txtHelp.iState = eUIState_Bad;
        m_iLastTileIndex = -1;
    }
    else if (kTile.eState == eTileState_NoExcavation)
    {
        txtHelp.StrValue = m_strErrNeedExcavating;
        txtHelp.iState = eUIState_Bad;
        m_iLastTileIndex = -1;
    }

    if (m_kCursor.iCursorState != eBCS_CantDo && m_kCursor.iCursorState != eBCS_BuildFacility && m_kCursor.iCursorState != eBCS_BuildAccessLift)
    {
        kCost = LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_GetConstructionProjectCost(m_kCursor.iCursorState, kBase.m_iId, m_kCursor.X, m_kCursor.Y);

        if (kCost.kCost.iCash != 0)
        {
            txtCost.StrValue = LWCE_GetCostString(kCost);
        }

        if (!kBase.LWCE_CanAfford(m_kCursor.iCursorState, kCost, txtHelp))
        {
            m_kCursor.iCursorState = eBCS_CantDo;
        }
    }

    if (m_kCursor.iCursorState == eBCS_CantDo)
    {
        m_kCursor.iUIState = eUIState_Bad;
        txtCost.iState = eUIState_Bad;
    }
    else
    {
        m_kCursor.iUIState = eUIState_Good;
    }

    m_kCursor.txtLabel = txtLabel;
    m_kCursor.txtCost = txtCost;
    m_kCursor.txtHelp = txtHelp;
}

function UpdateFacilityTable()
{
    local int iFacility;
    local array<LWCEFacilityTemplate> arrFacilities;
    local TTableMenu kMenu;
    local TTableMenuOption kOption;
    local TObjectSummary kSummary;
    local bool bFacilitiesFree;

    bFacilitiesFree = false;

    if (XComCheatManager(GetALocalPlayerController().CheatManager) != none)
    {
        bFacilitiesFree = XComCheatManager(GetALocalPlayerController().CheatManager).m_bStrategyAllFacilitiesFree;
    }

    m_kCETable.arrSummaries.Remove(0, m_kCETable.arrSummaries.Length);
    kMenu.arrCategories.AddItem(2);
    arrFacilities = LWCE_XGItemTree(ITEMTREE()).LWCE_GetBuildFacilities();
    arrFacilities.Sort(LWCE_SortFacilities);

    `LWCE_LOG_CLS("UpdateFacilityTable: " $ arrFacilities.Length $ " facilities to build");

    for (iFacility = 0; iFacility < arrFacilities.Length; iFacility++)
    {
        kOption = LWCE_BuildFacilityOption(arrFacilities[iFacility], kMenu.arrCategories);
        kSummary = LWCE_BuildSummary(arrFacilities[iFacility]);

        if (!kSummary.bCanAfford && !bFacilitiesFree)
        {
            kOption.strHelp = kSummary.kCost.strHelp;
            kOption.iState = eUIState_Disabled;
        }

        kMenu.arrOptions.AddItem(kOption);
        m_kCETable.arrSummaries.AddItem(kSummary);
        m_kCETable.arrFacilities[iFacility] = arrFacilities[iFacility].GetFacilityName();
    }

    kMenu.kHeader.arrStrings = GetHeaderStrings(kMenu.arrCategories);
    kMenu.kHeader.arrStates = GetHeaderStates(kMenu.arrCategories);
    m_kCETable.mnuOptions = kMenu;
}

function UpdateHeader()
{
    m_kHeader.txtCash = GetResourceText(eResource_Money);
    m_kHeader.txtPower = GetResourceText(eResource_Power);

    if (LWCE_XGStorage(STORAGE()).LWCE_EverHadItem('Item_Elerium'))
    {
        m_kHeader.txtElerium = GetResourceText(eResource_Elerium);
    }

    if (LWCE_XGStorage(STORAGE()).LWCE_EverHadItem('Item_Elerium'))
    {
        m_kHeader.txtAlloys = GetResourceText(eResource_Alloys);
    }
}

function UpdateTiles()
{
    local int iTile, iTerrain, iFacility;
    local LWCE_XGBase kBase;

    kBase = GetTargetBase();

    for (iTile = 0; iTile < kBase.m_arrCETiles.Length; iTile++)
    {
        if (kBase.m_arrCETiles[iTile].Y == 0)
        {
            continue;
        }

        if (!kBase.m_arrCETiles[iTile].bHasFacility)
        {
            m_arrCETiles[iTerrain++] = LWCE_BuildBaseTile(iTile);
        }
    }

    m_arrCEFacilityTiles.Length = 0;

    for (iTile = 0; iTile < kBase.m_arrCEFacilities.Length; iTile++)
    {
        if (kBase.m_arrCETiles[iTile].Y == 0)
        {
            continue;
        }

        if (kBase.m_arrCEFacilities[iTile].FacilityName != '')
        {
            m_arrCEFacilityTiles[iFacility++] = LWCE_BuildFacilityTile(iTile);
        }
    }
}

function int SortFacilities(TFacility kFacility1, TFacility kFacility2)
{
    `LWCE_LOG_DEPRECATED_CLS(SortFacilities);

    return 0;
}

function int LWCE_SortFacilities(LWCEFacilityTemplate kFacility1, LWCEFacilityTemplate kFacility2)
{
    local bool bIsPriority1, bIsPriority2;
    local name nmTargetTileType;

    bIsPriority1 = kFacility1.IsBuildPriority();
    bIsPriority2 = kFacility2.IsBuildPriority();

    if (bIsPriority1 && !bIsPriority2)
    {
        return 0;
    }

    if (!bIsPriority1 && bIsPriority2)
    {
        return -1;
    }

    nmTargetTileType = LWCE_XGBase(BASE()).LWCE_GetTileAt(m_kCursor.X, m_kCursor.Y).nmType;

    // If the target tile is capable of hosting special facilities (e.g. steam for Thermo Generators), those facilities should
    // be hoisted to the top of the list
    if (kFacility1.nmRequiredTerrainType == nmTargetTileType && kFacility2.nmRequiredTerrainType != nmTargetTileType)
    {
        return 0;
    }

    if (kFacility1.nmRequiredTerrainType != nmTargetTileType && kFacility2.nmRequiredTerrainType == nmTargetTileType)
    {
        return -1;
    }

    if (kFacility1.strName <= kFacility2.strName)
    {
        return 0;
    }

    return -1;
}

protected function LWCE_ConfirmRemovalDialogue(int X, int Y)
{
    local LWCE_XGBase kBase;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCEFacilityTemplate kFacility;
    local TDialogueBoxData kDialogData;
    local name FacilityName;
    local int iPower, iSatCap;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kBase = GetTargetBase();
    FacilityName = kBase.LWCE_GetFacilityAt(X, Y);
    kFacility = `LWCE_FACILITY(FacilityName);

    kDialogData.eType = eDialog_Normal;
    kDialogData.strTitle = m_strRemoveTitle;
    kDialogData.strText = m_strRemoveBody;
    kDialogData.strAccept = m_strRemoveOK;
    kDialogData.strCancel = m_strRemoveCancel;
    kDialogData.fnCallback = ConfirmRemovalDialogueCallback;

    m_bCantRemove = false;

    PlaySmallOpenSound();

    iPower = kFacility.GetPower();

    // Don't allow removing the facility if it's providing power we need for other facilities
    // TODO let the template dictate when a facility can be removed
    if (iPower < 0)
    {
        if (kFacility.arrAdjacencies.Find('Power') != INDEX_NONE)
        {
            iPower += kBase.LWCE_GetSurroundingAdjacencies(X, Y, 'Power') * class'XGTacticalGameCore'.default.POWER_ADJACENCY_BONUS;
        }

        if (kBase.GetPowerAvailable() < iPower)
        {
            kDialogData.strText = m_strPowerCantRemoveBody;
            m_bCantRemove = true;
        }
    }

/*
    if (FacilityName == 'Facility_AlienContainment')
    {
        if (`LWCE_LABS.LWCE_IsInterrogationTech(`LWCE_LABS.LWCE_GetCurrentTech().GetTechName()))
        {
            kDialogData.strText = m_strCaptiveCantRemoveBody;
            m_bCantRemove = true;
        }
        else
        {
            kDialogData.strText = m_strCaptiveRemoveBody;
        }
    }
    else if (FacilityName == eFacility_Workshop)
    {
        if (ITEMTREE().GetEngineersRequiredForNextUplink(eFacility_SmallRadar, true) > ENGINEERING().GetNumEngineersAvailable())
        {
            kDialogData.strText = m_strWorkshopCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (FacilityName == eFacility_SmallRadar || FacilityName == eFacility_LargeRadar)
    {
        if (FacilityName == eFacility_SmallRadar)
        {
            iSatCap = class'XGTacticalGameCore'.default.UPLINK_CAPACITY;
        }
        else if (FacilityName == eFacility_LargeRadar)
        {
            iSatCap = class'XGTacticalGameCore'.default.NEXUS_CAPACITY;
        }

        iSatCap += (Base().GetSurroundingAdjacencies(X, Y, eAdj_Satellites) * class'XGTacticalGameCore'.default.UPLINK_ADJACENCY_BONUS);

        if ( (HQ().GetSatelliteLimit() - HQ().m_arrSatellites.Length) < iSatCap )
        {
            kDialogData.strText = m_strUplinkCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (FacilityName == eFacility_Foundry)
    {
        if (ENGINEERING().m_arrFoundryProjects.Length > 0)
        {
            kDialogData.strText = m_strFoundryCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (FacilityName == eFacility_PsiLabs)
    {
        if (`LWCE_PSILABS.m_arrCETraining.Length > 0)
        {
            kDialogData.strText = m_strPsiLabsCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (FacilityName == eFacility_GeneticsLab)
    {
        if (GENELABS().m_arrPatients.Length > 0)
        {
            kDialogData.strText = m_strGeneLabsCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (FacilityName == eFacility_CyberneticsLab)
    {
        if (CYBERNETICSLAB().m_arrPatients.Length > 0)
        {
            kDialogData.strText = m_strCyberneticsLabsCantRemoveBody;
            m_bCantRemove = true;
        }
        else if (CYBERNETICSLAB().m_arrRepairingMecs.Length > 0)
        {
            kDialogData.strText = m_strCyberneticsLabsCantRemoveMecs;
            m_bCantRemove = true;
        }
    }
 */

    if (m_bCantRemove)
    {
        kDialogData.eType = eDialog_Warning;
        kDialogData.strTitle = m_strCantRemoveTitle;
        kDialogData.strCancel = "";
        kDialogData.strAccept = m_strOK;
    }

    PRES().UIRaiseDialog(kDialogData);
    GetUIScreen().Show();
}

simulated function ConfirmRemovalDialogueCallback(EUIAction eAction)
{
    local LWCE_XGBase kBase;

    kBase = GetTargetBase();

    if (eAction == eUIAction_Accept)
    {
        if (!m_bCantRemove)
        {
            kBase.m_arrCEFacilities[kBase.TileIndex(m_kCursor.X, m_kCursor.Y)].bIsBeingRemoved = true;
            LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_AddConstructionProject(eBCS_RemoveFacility, kBase.m_iId, m_kCursor.X, m_kCursor.Y);
            Sound().PlaySFX(SNDLIB().SFX_UI_FacilityRemoved);
        }
    }

    UpdateView();
}

protected function LWCE_XGBase GetTargetBase()
{
    return m_kHQ.GetBaseById(m_iBaseId);
}