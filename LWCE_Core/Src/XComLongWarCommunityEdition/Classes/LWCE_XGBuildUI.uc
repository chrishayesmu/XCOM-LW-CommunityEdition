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

var int m_iBaseId; // ID of the base which this UI is looking at. Do not change directly; use SetTargetBaseId.
var array<LWCE_TUIFacilityTile> m_arrCEFacilityTiles;
var LWCE_TFacilityTable m_kCETable;
var array<LWCE_TUIBaseTile> m_arrCETiles;

var private LWCE_XGHeadquarters m_kHQ; // just to save casting constantly
var private LWCE_XGBase m_kBase; // which base we're looking at

// Coordinate bounds: build cursor isn't allowed outside of these bounds,
// which are based on the target base's size compared to what the UI's designed for
var private int m_iMinX;
var private int m_iMaxX;
var private int m_iMinY;
var private int m_iMaxY;

function Init(int iView)
{
    m_kHQ = LWCE_XGHeadquarters(HQ());
    m_iBaseId = m_kHQ.m_arrBases[0].m_iId;
    m_kBase = GetTargetBase();

    UpdateCoordinateBounds();

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
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_TUIBaseTile kUITile;
    local LWCE_TFacilityProject kFacilityProject;
    local LWCE_TConstructionProject kConstructionProject;
    local XGParamTag kTag;
    local int Index;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());

    kUITile.kTile = m_kBase.m_arrCETiles[iTileIndex];
    Index = m_kBase.m_arrTerrainTypeConfig.Find('nmTerrainType', kUITile.kTile.nmType);

    if (Index != INDEX_NONE)
    {
        kUITile.imgTile.strLabel = m_kBase.m_arrTerrainTypeConfig[Index].ImageName;
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
        kFacilityProject = kEngineering.LWCE_GetFacilityProject(m_kBase.m_iId, kUITile.kTile.X, kUITile.kTile.Y);
        kTag.IntValue0 = kEngineering.LWCE_GetFacilityCounter(kFacilityProject);
        kUITile.txtLabel.StrValue = `LWCE_FACILITY(kFacilityProject.FacilityName).strName;
        kUITile.txtCounter.StrValue = class'XComLocalizer'.static.ExpandStringByTag(m_strLabelDays, kTag);
    }
    else if (kUITile.kTile.bExcavation)
    {
        kUITile.imgTile.strLabel = "BeingExcavated";
        kConstructionProject = kEngineering.LWCE_GetConstructionProject(m_kBase.m_iId, kUITile.kTile.X, kUITile.kTile.Y);
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

        if (kFacility.nmRequiredTerrainType != '' && kFacility.nmRequiredTerrainType != GetTargetBase().LWCE_GetTileAt(TileXFromUI(m_kCursor.X), TileYFromUI(m_kCursor.Y)).nmType)
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
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_TUIFacilityTile kUITile;
    local LWCEFacilityTemplate kFacility;
    local LWCE_TConstructionProject kConstructionProject;
    local XGParamTag kTag;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kFacility = `LWCE_FACILITY(m_kBase.m_arrCEFacilities[iTileIndex].FacilityName);

    kUITile.kTile = m_kBase.m_arrCEFacilities[iTileIndex];
    kUITile.txtLabel.StrValue = kFacility.strName;
    kUITile.bDoubleSize = false; // TODO: rewrite the size system to be more flexible
    kUITile.imgTile.strLabel = kFacility.ImageLabel;
    kUITile.bAdjacencyBonusLeft = m_kBase.LWCE_GetAdjacency(kUITile.kTile.X, kUITile.kTile.Y, kUITile.kTile.X - 1, kUITile.kTile.Y) != '';
    kUITile.bAdjacencyBonusTop = m_kBase.LWCE_GetAdjacency(kUITile.kTile.X, kUITile.kTile.Y, kUITile.kTile.X, kUITile.kTile.Y - 1) != '';

    if (kUITile.kTile.bIsBeingRemoved)
    {
        kTag = new class'XGParamTag';
        kConstructionProject = kEngineering.LWCE_GetConstructionProject(m_kBase.m_iId, kUITile.kTile.X, kUITile.kTile.Y);
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
    kSummary.bCanAfford = LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_GetFacilityCostSummary(kSummary.kCost, kFacility.GetFacilityName(), TileXFromUI(m_kCursor.X), TileYFromUI(m_kCursor.Y), false);

    return kSummary;
}

simulated function ConfirmCancelConstructionDialogueCallback(EUIAction eAction)
{
    local int TileX, TileY;

    TileX = TileXFromUI(m_kCursor.X);
    TileY = TileYFromUI(m_kCursor.Y);

    if (eAction == eUIAction_Accept)
    {
        m_kBase.m_arrCETiles[m_kBase.TileIndex(TileX, TileY)].bConstruction = false;
        m_kBase.m_arrCETiles[m_kBase.TileIndex(TileX, TileY)].bExcavation = false;

        if (m_kBase.LWCE_GetFacilityAt(TileX, TileY) != '')
        {
            m_kBase.m_arrCEFacilities[m_kBase.TileIndex(TileX, TileY)].bIsBeingRemoved = false;
        }

        LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_CancelConstructionProject(m_kBase.m_iId, TileX, TileY);
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

function LWCE_XGBase GetTargetBase()
{
    return m_kHQ.GetBaseById(m_iBaseId);
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
    local int TileX, TileY;

    TileX = TileXFromUI(m_kCursor.X);
    TileY = TileYFromUI(m_kCursor.Y);

    if (m_kCursor.iCursorState == eBCS_CantDo)
    {
        PlayBadSound();
    }
    else if (m_kCursor.iCursorState == eBCS_BuildFacility)
    {
        GoToView(eBuildView_Menu);
        PRES().CAMLookAtHQTile(TileX, TileY, 1.0);
    }
    else if (m_kCursor.iCursorState == eBCS_BuildAccessLift)
    {
        LWCE_XComHQPresentationLayer(PRES()).LWCE_UIManufactureFacility('Facility_AccessLift', m_kBase.m_iId, TileX, TileY);
    }
    else if (m_kCursor.iCursorState == eBCS_Cancel)
    {
        ConfirmCancelConstructionDialogue();
    }
    else if (m_kCursor.iCursorState == eBCS_Excavate)
    {
        m_kBase.m_arrCETiles[m_kBase.TileIndex(TileX, TileY)].bExcavation = true;
        LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_AddConstructionProject(eBCS_Excavate, m_kBase.m_iId, TileX, TileY);
        UpdateView();
        Sound().PlaySFX(SNDLIB().SFX_UI_ExcavationStarted);
    }
    else if (m_kCursor.iCursorState == eBCS_RemoveFacility)
    {
        LWCE_ConfirmRemovalDialogue(TileX, TileY);
    }
}

function OnCursorDown()
{
    if (m_kCursor.Y == m_iMaxY)
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

function OnCursorLeft()
{
    if (m_kCursor.X == m_iMinX)
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
    if (m_kCursor.X == m_iMaxX)
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
    if (m_kCursor.Y == m_iMinY)
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

function OnChooseFacility(int iOption)
{
    local int TileX, TileY;

    TileX = TileXFromUI(m_kCursor.X);
    TileY = TileYFromUI(m_kCursor.Y);

    if (m_kCETable.mnuOptions.arrOptions[iOption].iState == eUIState_Disabled)
    {
        PlayBadSound();
        return;
    }
    else
    {
        LWCE_XComHQPresentationLayer(PRES()).LWCE_UIManufactureFacility(m_kCETable.arrFacilities[iOption], m_iBaseId, TileX, TileY);
    }
}

function SetTargetBaseId(int iBaseId)
{
    m_iBaseId = iBaseId;
    m_kBase = GetTargetBase();

    m_arrCETiles.Length = 0;
    m_arrCEFacilityTiles.Length = 0;

    UpdateCoordinateBounds();
    UpdateView();
}

function UpdateCursor()
{
    local LWCE_TTerrainTile kTile;
    local LWCE_TProjectCost kCost;
    local TText txtCost, txtHelp;
    local TButtonText txtLabel;
    local name FacilityName;
    local int TileX, TileY;

    // Clamp cursor position to ensure it's in-bounds when switching between bases
    m_kCursor.X = Clamp(m_kCursor.X, m_iMinX, m_iMaxX);
    m_kCursor.Y = Clamp(m_kCursor.Y, m_iMinY, m_iMaxY);

    TileX = TileXFromUI(m_kCursor.X);
    TileY = TileYFromUI(m_kCursor.Y);

    m_kCursor.iSize = 1;
    m_kCursor.iCursorState = eBCS_CantDo;
    kTile = m_kBase.LWCE_GetTileAt(TileX, TileY);

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
                FacilityName = m_kBase.LWCE_GetFacilityAt(TileX, TileY);
                // TODO implement variable facility sizes later
                // m_kCursor.iSize = `LWCE_FACILITY(FacilityName).iSize;

                if (m_kBase.m_arrCEFacilities[m_kBase.TileIndex(TileX, TileY)].bIsBeingRemoved)
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
                case 'Excavated':
                case 'ExcavatedSteam':
                    if (m_kBase.IsAccessLocation(TileX, TileY))
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
                        RemoveTerrainTileLabelAtIndex(m_kBase.TileIndex(TileX, TileY));
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
                        RemoveTerrainTileLabelAtIndex(m_kBase.TileIndex(TileX, TileY));
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
        kCost = LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_GetConstructionProjectCost(m_kCursor.iCursorState, m_kBase.m_iId, TileX, TileY);

        if (kCost.kCost.iCash != 0)
        {
            txtCost.StrValue = LWCE_GetCostString(kCost);
        }

        if (!m_kBase.LWCE_CanAfford(m_kCursor.iCursorState, kCost, txtHelp))
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
    m_kHeader.txtPower = GetPowerResourceText();

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

    for (iTile = 0; iTile < m_kBase.m_arrCETiles.Length; iTile++)
    {
        if (m_kBase.m_arrCETiles[iTile].Y == 0)
        {
            continue;
        }

        if (!m_kBase.m_arrCETiles[iTile].bHasFacility)
        {
            m_arrCETiles[iTerrain++] = LWCE_BuildBaseTile(iTile);
        }
    }

    m_arrCEFacilityTiles.Length = 0;

    for (iTile = 0; iTile < m_kBase.m_arrCEFacilities.Length; iTile++)
    {
        if (m_kBase.m_arrCETiles[iTile].Y == 0)
        {
            continue;
        }

        if (m_kBase.m_arrCEFacilities[iTile].FacilityName != '')
        {
            m_arrCEFacilityTiles[iFacility++] = LWCE_BuildFacilityTile(iTile);
        }
    }
}

protected function TLabeledText GetPowerResourceText()
{
    local TLabeledText kResource;

    kResource.StrValue = m_kBase.GetPowerUsed() $ "/" $ m_kBase.GetPowerCapacity();
    kResource.strLabel = GetResourceLabel(eResource_Power);
    kResource.iState = m_kBase.GetPowerAvailable() > 0 ? eUIState_Warning : eUIState_Bad;
    kResource.bNumber = true;
    return kResource;
}

function int SortFacilities(TFacility kFacility1, TFacility kFacility2)
{
    `LWCE_LOG_DEPRECATED_CLS(SortFacilities);

    return 0;
}

protected function int LWCE_SortFacilities(LWCEFacilityTemplate kFacility1, LWCEFacilityTemplate kFacility2)
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

    nmTargetTileType = GetTargetBase().LWCE_GetTileAt(TileXFromUI(m_kCursor.X), TileYFromUI(m_kCursor.Y)).nmType;

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
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCEFacilityTemplate kFacility;
    local TDialogueBoxData kDialogData;
    local name FacilityName;
    local int iPower, iSatCap;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    FacilityName = m_kBase.LWCE_GetFacilityAt(X, Y);
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
            iPower += m_kBase.LWCE_GetSurroundingAdjacencies(X, Y, 'Power') * class'XGTacticalGameCore'.default.POWER_ADJACENCY_BONUS;
        }

        if (m_kBase.GetPowerAvailable() < iPower)
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
    local int TileX, TileY;

    TileX = TileXFromUI(m_kCursor.X);
    TileY = TileYFromUI(m_kCursor.Y);

    if (eAction == eUIAction_Accept)
    {
        if (!m_bCantRemove)
        {
            m_kBase.m_arrCEFacilities[m_kBase.TileIndex(TileX, TileY)].bIsBeingRemoved = true;
            LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_AddConstructionProject(eBCS_RemoveFacility, m_kBase.m_iId, TileX, TileY);
            Sound().PlaySFX(SNDLIB().SFX_UI_FacilityRemoved);
        }
    }

    UpdateView();
}

protected function int TileXFromUI(int X)
{
    return X - (NUM_TERRAIN_WIDE - m_kBase.m_iNumTilesWide) / 2;
}

protected function int TileYFromUI(int Y)
{
    return Y - (NUM_TERRAIN_HIGH - m_kBase.m_iNumTilesHigh) / 2;
}

protected function UpdateCoordinateBounds()
{
    local float fOffsetX, fOffsetY;

    fOffsetX = (NUM_TERRAIN_WIDE - m_kBase.m_iNumTilesWide) / 2.0f;
    m_iMinX = FCeil(fOffsetX);
    m_iMaxX = NUM_TERRAIN_WIDE - FFloor(fOffsetX) - 1;

    fOffsetY = (NUM_TERRAIN_HIGH - m_kBase.m_iNumTilesHigh) / 2.0f;
    m_iMinY = FFloor(fOffsetY) + 1;
    m_iMaxY = NUM_TERRAIN_HIGH - FCeil(fOffsetY) - 1;

    `LWCE_LOG_CLS("Coordinate bounds: [" $ m_iMinX $ ", " $ m_iMinY $ "] to [" $ m_iMaxX $ ", " $ m_iMaxY $ "]");
}