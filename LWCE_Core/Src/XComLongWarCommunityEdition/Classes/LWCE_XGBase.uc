class LWCE_XGBase extends XGBase
    config(LWCEFacilities);

struct LWCE_TFacilityTile
{
    var int X;
    var int Y;
    var name FacilityName;
    var bool bIsBeingRemoved;
};

struct LWCE_TTerrainTile
{
    var int X;
    var int Y;
    var name nmType;  // As per XGGameData.ETerrainTypes, but made into a name type for flexibility with mods. Unlike the parent type,
                      // this field is not used to mark whether a tile has a facility; use bHasFacility for that instead. That way, nmType
                      // always reflects the underlying terrain, not what is built on it, making facility destruction simpler. (Note: the 'Open'
                      // terrain type was functionally identical to 'Excavated' and is not used in LWCE.)
    var int iParentX; // For multi-tile facilities, all tiles other than the main one should have iParentX and iParentY set.
    var int iParentY;
    var ETileState eState;
    var bool bConstruction;
    var bool bExcavation;
    var bool bHasFacility;

    structdefaultproperties
    {
        iParentX=-1
        iParentY=-1
    }
};

struct LWCE_TTerrainTypeConfig
{
    var name nmTerrainType;
    var string MapName;
    var string ImageName;
};

struct CheckpointRecord_LWCE_XGBase extends XGBase.CheckpointRecord
{
    var array<LWCE_TFacilityTile> m_arrCEFacilities;
    var array<LWCE_TTerrainTile> m_arrCETiles;

    var Vector2D m_vBaseCoords;
    var int m_iNumTilesHigh;
    var int m_iNumTilesWide;
    var int m_iContinent;
    var int m_iCountry;
    var int m_iId;
    var bool m_bIsPrimaryBase;
};

var config array<LWCE_TTerrainTypeConfig> m_arrTerrainTypeConfig;

var config array<int> BaselinePowerForPrimaryBase;
var config array<int> BaselinePowerForNonPrimaryBases;

var array<LWCE_TFacilityTile> m_arrCEFacilities;
var array<LWCE_TTerrainTile> m_arrCETiles;

var Vector2D m_vBaseCoords;
var int m_iNumTilesHigh;
var int m_iNumTilesWide;
var int m_iContinent;
var int m_iCountry;
var int m_iId;
var bool m_bIsPrimaryBase;

function Init()
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

/// <summary>
/// Initializes this base to have the given width and height, in tiles. While this is dynamic unlike the vanilla game,
/// it is not changeable after the base is created.
///
/// TODO: the base needs to know where in the world it is (country + coordinates)
/// </summary>
function LWCE_Init(bool IsPrimaryBase, int Id, int Width, int Height, Vector2D Coords)
{
    m_bIsPrimaryBase = IsPrimaryBase;
    m_iId = Id;
    m_iNumTilesWide = Width;
    m_iNumTilesHigh = Height;
    m_vBaseCoords = Coords;

    GenerateTiles();
}

function BeginAlienContainment(EItemType kCaptive)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(BeginAlienContainment);
}

function bool CanAfford(int iProjectType, TProjectCost kCost, out TText txtHelp)
{
    `LWCE_LOG_DEPRECATED_CLS(CanAfford);

    return false;
}

function bool LWCE_CanAfford(int iProjectType, LWCE_TProjectCost kCost, out TText txtHelp)
{
    local bool bFreeBuild;

    bFreeBuild = false;

    if (XComCheatManager(GetALocalPlayerController().CheatManager) != none)
    {
        bFreeBuild = XComCheatManager(GetALocalPlayerController().CheatManager).m_bStrategyAllFacilitiesFree;
    }

    if (!bFreeBuild && ! LWCE_XGHeadquarters(HQ()).CanAffordCost(kCost.kCost))
    {
        txtHelp.StrValue = m_strLabelInsufficientFunds;
        txtHelp.iState = eUIState_Bad;
        return false;
    }

    return true;
}

function CaptureAlienMapStreamFinished(name LevelPackageName)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(CaptureAlienMapStreamFinished);
}

function DoAlienInterrogation(EItemType kCaptive)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(DoAlienInterrogation);
}

function GenerateTiles()
{
    local LWCEDataContainer kEventData;
    local int X, Y;
    local array<int> arrDeepRockTiles;
    local int iNumSteamVents, iTile, I;
    local int iAccessX;

    iNumSteamVents = class'XGTacticalGameCore'.default.NUM_STARTING_STEAM_VENTS;

    // EVENT: BeforeGenerateBaseTiles
    //
    // SUMMARY: Emitted when a base is about to generate its tiles. Can be used to manipulate the
    //          generation variables.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: int - Out parameter. How many steam vents to generate.
    //
    // SOURCE: LWCE_XGBase

    kEventData = class'LWCEDataContainer'.static.New('BeforeGenerateBaseTiles');
    kEventData.AddInt(iNumSteamVents);

    `LWCE_EVENT_MGR.TriggerEvent('BeforeGenerateBaseTiles', kEventData, self);

    iAccessX = GetAccessX(); // after event, in case base size is changed
    iNumSteamVents = kEventData.Data[0].I;

    if (HQ().HasBonus(/* Ring of Fire */ 13) > 0)
    {
        iNumSteamVents += HQ().HasBonus(13);
    }

    `LWCE_LOG_CLS("GenerateTiles: base is " $ m_iNumTilesHigh $ " tiles high and " $ m_iNumTilesWide $ " tiles wide");

    m_arrCETiles.Add(m_iNumTilesHigh * m_iNumTilesWide);
    m_arrCEFacilities.Add(m_iNumTilesHigh * m_iNumTilesWide);

    for (Y = 0; Y < m_iNumTilesHigh; Y++)
    {
        for (X = 0; X < m_iNumTilesWide; X++)
        {
            if (Y == 0)
            {
                m_arrCETiles[TileIndex(X, Y)].nmType = 'Excavated';
            }
            else if (Y == 1)
            {
                m_arrCETiles[TileIndex(X, Y)].nmType = 'Excavated';

                if (X > (m_iNumTilesWide / 2) && Roll(75))
                {
                    m_arrCETiles[TileIndex(X, Y)].nmType = 'Rock';
                }
            }
            else if (IsAccessLocation(X, Y))
            {
                m_arrCETiles[TileIndex(X, Y)].nmType = 'Excavated';
            }
            else if (Roll(20))
            {
                m_arrCETiles[TileIndex(X, Y)].nmType = 'Excavated';
            }
            else
            {
                m_arrCETiles[TileIndex(X, Y)].nmType = 'Rock';
                arrDeepRockTiles.AddItem(TileIndex(X, Y));
            }

            m_arrCETiles[TileIndex(X, Y)].X = X;
            m_arrCETiles[TileIndex(X, Y)].Y = Y;
        }
    }

    for (I = 0; I < iNumSteamVents && arrDeepRockTiles.Length > 0; I++)
    {
        iTile = Rand(arrDeepRockTiles.Length);
        m_arrCETiles[arrDeepRockTiles[iTile]].nmType = 'RockSteam';
        arrDeepRockTiles.Remove(iTile, 1);
    }

    LWCE_SetFacility('Facility_Hangar', 0, 0);
    LWCE_SetFacility('Facility_Barracks', 2, 0);
    LWCE_SetFacility('Facility_MissionControl', 4, 0);
    LWCE_SetFacility('Facility_Research', 6, 0);
    LWCE_SetFacility('Facility_AccessLift', iAccessX, 1);
    m_arrCETiles[TileIndex(iAccessX, 1)].eState = eTileState_Accessible;
    LWCE_SetFacility('Facility_SatelliteUplink', 2, 1);

    if (HQ().HasBonus(/* Skunkworks */ 17) > 0)
    {
        LWCE_SetFacility('Facility_Foundry', 4, 1);
        LWCE_XGStrategy(Game()).m_arrCEFacilityUnlocks.AddItem('Facility_Foundry');
    }

    if (HQ().HasBonus(/* Advanced Preparations */ 20) > 0)
    {
        LWCE_SetFacility('Facility_Laboratory', 4, 1);
        LWCE_SetFacility('Facility_Workshop', 5, 1);
        LWCE_XGStrategy(Game()).m_arrCEFacilityUnlocks.AddItem('Facility_Laboratory');
        LWCE_XGStrategy(Game()).m_arrCEFacilityUnlocks.AddItem('Facility_Workshop');
    }

    if (HQ().HasBonus(/* Research Focus */ 33) > 0)
    {
        LWCE_SetFacility('Facility_Laboratory', 4, 1);
        LWCE_SetFacility('Facility_Laboratory', 5, 1);
        LWCE_XGStrategy(Game()).m_arrCEFacilityUnlocks.AddItem('Facility_Laboratory');
    }

    if (HQ().HasBonus(/* Assembly Line */ 34) > 0)
    {
        LWCE_SetFacility('Facility_Laboratory', 4, 1);
        LWCE_SetFacility('Facility_Laboratory', 5, 1);
        LWCE_XGStrategy(Game()).m_arrCEFacilityUnlocks.AddItem('Facility_Laboratory');
    }

    if (HQ().HasBonus(/* Roscosmos */ 29) > 0)
    {
        LWCE_SetFacility('Facility_SatelliteUplink', 1, 1);
    }

    if (HQ().HasBonus(/* Wei Renmin Fuwu */ 30) > 0)
    {
        LWCE_SetFacility('Facility_RepairBay', 4, 1);
        LWCE_SetFacility('Facility_Workshop', 5, 1);
        LWCE_XGStrategy(Game()).m_arrCEFacilityUnlocks.AddItem('Facility_RepairBay');
        LWCE_XGStrategy(Game()).m_arrCEFacilityUnlocks.AddItem('Facility_Workshop');
    }

    // EVENT: AfterGenerateBaseTiles
    //
    // SUMMARY: Emitted after a base has generated its tiles. Can be used to modify the base layout,
    //          add/remove facilities, etc.
    //
    // DATA: LWCE_XGBase
    //
    // SOURCE: LWCE_XGBase

    `LWCE_EVENT_MGR.TriggerEvent('AfterGenerateBaseTiles', self, self);

    UpdateTiles();
}

function int GetAccessX()
{
    return m_iNumTilesWide / 2;
}

function int GetAdjacencies(EAdjacencyType eAdj)
{
    `LWCE_LOG_DEPRECATED_CLS(GetAdjacencies);

    return -100;
}

function int LWCE_GetAdjacencies(name nmAdjType)
{
    local int X, Y, Index, iTotal;
    local array<LWCE_NameIntKVP> arrAdjs;

    // Skip the first row, which is invisible and contains the hangar, mission control, etc
    for (Y = 1; Y < m_iNumTilesHigh; Y++)
    {
        for (X = 0; X < m_iNumTilesWide; X++)
        {
            `LWCE_UTILS.ModifyKeyValuePair(arrAdjs, LWCE_GetAdjacency(X + 1, Y,     X, Y), 1);
            `LWCE_UTILS.ModifyKeyValuePair(arrAdjs, LWCE_GetAdjacency(X,     Y + 1, X, Y), 1);
        }
    }

    if (nmAdjType == 'All')
    {
        for (Index = 0; Index < arrAdjs.Length; Index++)
        {
            iTotal += arrAdjs[Index].Value;
        }
    }
    else
    {
        iTotal = 0;
        `LWCE_UTILS.TryFindValue(arrAdjs, nmAdjType, iTotal);
    }

    return iTotal;
}

function EAdjacencyType GetAdjacency(int X1, int Y1, int X2, int Y2)
{
    `LWCE_LOG_DEPRECATED_CLS(GetAdjacency);

    return eAdj_None;
}

// TODO: in LWCE facilities can have multiple adjacencies; this function should be able
// to return multiple accordingly
function name LWCE_GetAdjacency(int X1, int Y1, int X2, int Y2)
{
    local int Index;
    local name nmFacility1, nmFacility2;
    local LWCEFacilityTemplate kFacility1, kFacility2;

    if (!IsValidTile(X1, Y1) || !IsValidTile(X2, Y2))
    {
        return '';
    }

    nmFacility1 = m_arrCEFacilities[TileIndex(X1, Y1)].FacilityName;
    nmFacility2 = m_arrCEFacilities[TileIndex(X2, Y2)].FacilityName;

    if (nmFacility1 == '' || nmFacility2 == '')
    {
        return '';
    }

    kFacility1 = `LWCE_FACILITY(nmFacility1);
    kFacility2 = `LWCE_FACILITY(nmFacility2);

    for (Index = 0; Index < kFacility1.arrAdjacencies.Length; Index++)
    {
        if (kFacility2.arrAdjacencies.Find(kFacility1.arrAdjacencies[Index]) != INDEX_NONE)
        {
            return kFacility1.arrAdjacencies[Index];
        }
    }

    return '';
}

function int GetFacilityAt(int X, int Y)
{
    `LWCE_LOG_DEPRECATED_CLS(GetFacilityAt);
    return -1;
}

function name LWCE_GetFacilityAt(int X, int Y)
{
    return m_arrCEFacilities[TileIndex(X, Y)].FacilityName;
}

function Vector GetFacilityLocation(int iFacility)
{
    `LWCE_LOG_DEPRECATED_CLS(GetFacilityLocation);
    return vect(-100.0, -100.0, -100.0);
}

function Vector LWCE_GetFacilityLocation(name nmFacility)
{
    local int Index;
    local Vector locVec;

    for (Index = 0; Index < m_arrCEFacilities.Length; Index++)
    {
        if (m_arrCEFacilities[Index].FacilityName == nmFacility)
        {
            locVec.X = float(m_arrCEFacilities[Index].X);
            locVec.Y = float(m_arrCEFacilities[Index].Y);
            return locVec;
        }
    }

    return vect(0.0, 0.0, 0.0);
}

function Vector GetFacility3DLocation(int iFacility)
{
    `LWCE_LOG_DEPRECATED_CLS(GetFacility3DLocation);
    return vect(-100.0, -100.0, -100.0);
}

function Vector LWCE_GetFacility3DLocation(name nmFacility)
{
    local int Index;

    for (Index = 0; Index < m_arrCEFacilities.Length; Index++)
    {
        if (m_arrCEFacilities[Index].FacilityName == nmFacility)
        {
            return GetRoomLocation(m_arrCEFacilities[Index].Y, m_arrCEFacilities[Index].X);
        }
    }

    return vect(0.0, 0.0, 0.0);
}

function array<THQAnim> GetHQAnims()
{
    local array<THQAnim> arrAnims;

    arrAnims.Length = 0;

    // Non-primary bases probably shouldn't have Bradford strolling around
    return m_bIsPrimaryBase ? super.GetHQAnims() : arrAnims;
}

function string GetMapName(ETerrainTypes eTerrainType, EFacilityType eFacType)
{
    `LWCE_LOG_DEPRECATED_CLS(GetMapName);

    return "";
}

function string LWCE_GetMapName(name nmTerrainType, name nmFacility)
{
    local int Index;

    if (nmFacility != '')
    {
        return `LWCE_FACILITY(nmFacility).MapName;
    }

    for (Index = 0; Index < m_arrTerrainTypeConfig.Length; Index++)
    {
        if (m_arrTerrainTypeConfig[Index].nmTerrainType == nmTerrainType)
        {
            return m_arrTerrainTypeConfig[Index].MapName;
        }
    }

    return "";
}

function int GetPowerAvailable()
{
    return GetPowerCapacity() - GetPowerUsed();
}

function int GetPowerCapacity()
{
    local LWCEFacilityTemplateManager kTemplateMgr;
    local int iPower, iTotalPower, Index;

    kTemplateMgr = `LWCE_FACILITY_TEMPLATE_MGR;

    if (m_bIsPrimaryBase)
    {
        iTotalPower += BaselinePowerForPrimaryBase[Game().GetDifficulty()];
    }
    else
    {
        iTotalPower += BaselinePowerForNonPrimaryBases[Game().GetDifficulty()];
    }

    for (Index = 0; Index < m_arrCEFacilities.Length; Index++)
    {
        if (m_arrCEFacilities[Index].FacilityName == '')
        {
            continue;
        }

        iPower = kTemplateMgr.FindFacilityTemplate(m_arrCEFacilities[Index].FacilityName).GetPower();

        // Negative value means power is being generated
        if (iPower < 0)
        {
            iTotalPower += -iPower;
        }
    }

    // TODO: adjacencies are being double counted
    iTotalPower += LWCE_GetAdjacencies('Power') * class'XGTacticalGameCore'.default.POWER_ADJACENCY_BONUS;

    return iTotalPower;
}

function int GetPowerUsed()
{
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCEFacilityTemplateManager kTemplateMgr;
    local int iPower, iTotalPower, Index;

    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kTemplateMgr = `LWCE_FACILITY_TEMPLATE_MGR;

    for (Index = 0; Index < m_arrCEFacilities.Length; Index++)
    {
        if (m_arrCEFacilities[Index].FacilityName == '')
        {
            continue;
        }

        iPower = kTemplateMgr.FindFacilityTemplate(m_arrCEFacilities[Index].FacilityName).GetPower();

        if (iPower > 0)
        {
            iTotalPower += iPower;
        }
    }

    // Check any facilities being built in this base
    for (Index = 0; Index < kEngineering.m_arrCEFacilityProjects.Length; Index++)
    {
        if (kEngineering.m_arrCEFacilityProjects[Index].iBaseId != m_iId)
        {
            continue;
        }

        iPower = kTemplateMgr.FindFacilityTemplate(kEngineering.m_arrCEFacilityProjects[Index].FacilityName).GetPower();

        if (iPower > 0)
        {
            iTotalPower += iPower;
        }
    }

    return iTotalPower;
}

function int GetSurroundingAdjacencies(int X, int Y, EAdjacencyType eAdjType)
{
    `LWCE_LOG_DEPRECATED_CLS(GetSurroundingAdjacencies);

    return -1;
}

function int LWCE_GetSurroundingAdjacencies(int X, int Y, name AdjType)
{
    local int iAdjacencies;

    if (!IsValidTile(X, Y))
    {
        return 0;
    }

    if (LWCE_GetAdjacency(X - 1, Y, X, Y) == AdjType)
    {
        iAdjacencies += 1;
    }

    if (LWCE_GetAdjacency(X + 1, Y, X, Y) == AdjType)
    {
        iAdjacencies += 1;
    }

    if (LWCE_GetAdjacency(X, Y - 1, X, Y) == AdjType)
    {
        iAdjacencies += 1;
    }

    if (LWCE_GetAdjacency(X, Y + 1, X, Y) == AdjType)
    {
        iAdjacencies += 1;
    }

    return iAdjacencies;
}

function TTerrainTile GetTileAt(int X, int Y)
{
    local TTerrainTile Tile;

    `LWCE_LOG_DEPRECATED_CLS(GetTileAt);

    return Tile;
}

function LWCE_TTerrainTile LWCE_GetTileAt(int X, int Y)
{
    return m_arrCETiles[TileIndex(X, Y)];
}

function HandleFacilitySpecificFuncitionality(EFacilityType eFacType, LevelStreaming LvlStreaming)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(HandleFacilitySpecificFuncitionality);
}

function bool HasAccess(int X, int Y)
{
    if (Y == 0)
    {
        return true;
    }

    if (IsAccessLocation(X, Y))
    {
        return LWCE_GetFacilityAt(X, Y - 1) == 'Facility_AccessLift';
    }
    else
    {
        return LWCE_GetFacilityAt(GetAccessX(), Y) == 'Facility_AccessLift';
    }
}

function bool HasExcavation(int X, int Y)
{
    local int iTileX;
    local name nmType;

    if (X > GetAccessX())
    {
        for (iTileX = GetAccessX() + 1; iTileX < X; iTileX++)
        {
            nmType = m_arrCETiles[TileIndex(iTileX, Y)].nmType;

            if (nmType != 'Excavated' && nmType != 'ExcavatedSteam')
            {
                return false;
            }
        }
    }
    else if (X < GetAccessX())
    {
        for (iTileX = GetAccessX() - 1; iTileX > X; iTileX--)
        {
            nmType = m_arrCETiles[TileIndex(iTileX, Y)].nmType;

            if (nmType != 'Excavated' && nmType != 'ExcavatedSteam')
            {
                return false;
            }
        }
    }
    else
    {
        return Y == 0 || LWCE_GetFacilityAt(X, Y - 1) == 'Facility_AccessLift';
    }

    return true;
}

function InterrogateContainedAlien(EItemType kCaptive)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(InterrogateContainedAlien);
}

function bool IsFacilityAt(int X, int Y)
{
    return m_arrCETiles[TileIndex(X, Y)].bHasFacility;
}

function bool IsPrimaryTile(int X, int Y)
{
    return IsFacilityAt(X, Y) && m_arrCETiles[TileIndex(X, Y)].iParentX == -1 && m_arrCETiles[TileIndex(X, Y)].iParentY == -1;
}

function bool IsValidTile(int X, int Y)
{
    return X >= 0 && Y >= 0 && X < m_iNumTilesWide && Y < m_iNumTilesHigh;
}

function bool IsEngineeringFacility(EFacilityType eFacility)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(IsEngineeringFacility);

    return false;
}

function bool IsPowerFacility(EFacilityType eFacility)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(IsPowerFacility);

    return false;
}

function bool IsSatelliteFacility(EFacilityType eFacility)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(IsSatelliteFacility);

    return false;
}

function bool IsScienceFacility(EFacilityType eFacility)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(IsScienceFacility);

    return false;
}

function LookAtFacility(int iFacilityType, optional float fInterpTime = 2.0f)
{
    `LWCE_LOG_DEPRECATED_CLS(LookAtFacility);
}

function LWCE_LookAtFacility(name nmFacilityType, optional float fInterpTime = 2.0f)
{
    local int X, Y;

    for (Y = 0; Y < m_iNumTilesHigh; Y++)
    {
        for (X = 0; X < m_iNumTilesWide; X++)
        {
            if (LWCE_GetFacilityAt(X, Y) == nmFacilityType)
            {
                PRES().CAMLookAtHQTile(X, Y, fInterpTime);
                return;
            }
        }
    }
}

function OnAlienContainmentStreamed(name LevelPackageName)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(OnAlienContainmentStreamed);
}

function OnFaciltyStreamed_AlienContainment(name LevelStreamed)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(OnFaciltyStreamed_AlienContainment);
}

function OnFaciltyStreamed_OTS(name LevelStreamed)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(OnFaciltyStreamed_OTS);
}

function OnInterrogationCinematicComplete()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(OnInterrogationCinematicComplete);
}

function PerformAction(int iCursorState, int X, int Y, optional int iFacility, optional int iTimer)
{
    `LWCE_LOG_DEPRECATED_CLS(PerformAction);
}

function LWCE_PerformAction(EBuildCursorState eCursorState, int X, int Y, optional name nmFacility)
{
    local int TargetTileIndex, iNumAdjacencies;

    TargetTileIndex = TileIndex(X, Y);

    if (eCursorState == eBCS_BeginConstruction)
    {
        m_arrCETiles[TargetTileIndex].bConstruction = true;
    }
    else if (eCursorState == eBCS_Excavate)
    {
        if (m_arrCETiles[TargetTileIndex].nmType == 'RockSteam')
        {
            m_arrCETiles[TargetTileIndex].nmType = 'ExcavatedSteam';
        }
        else
        {
            m_arrCETiles[TargetTileIndex].nmType = 'Excavated';
        }

        m_arrCETiles[TargetTileIndex].bExcavation = false;
    }
    else if (eCursorState == eBCS_RemoveFacility)
    {
        if (m_arrCEFacilities[TargetTileIndex].FacilityName == 'Facility_AlienContainment')
        {
            // TODO rewrite captive stuff
            if (m_currAlienCaptive != 0)
            {
                class'XComMapManager'.static.RemoveStreamingMapByName(class'XComMapManager'.static.GetAlienContainmentMatineeFromType(m_currAlienCaptive));
            }

            class'XComMapManager'.static.RemoveStreamingMapByName(ALIENCONTAINMENT_ANIMMAP);
        }

        LWCE_XGHeadquarters(HQ()).LWCE_RemoveFacility(m_arrCEFacilities[TargetTileIndex].FacilityName);

        m_arrCETiles[TargetTileIndex].bHasFacility = false;
        m_arrCEFacilities[TargetTileIndex].bIsBeingRemoved = false;
        m_arrCEFacilities[TargetTileIndex].FacilityName = '';

        Sound().PlaySFX(SNDLIB().SFX_Facility_DisassembleItem);
    }
    else if (eCursorState == eBCS_BuildFacility)
    {
        m_arrCETiles[TargetTileIndex].bConstruction = false;
        LWCE_SetFacility(nmFacility, X, Y);
        Sound().PlaySFX(SNDLIB().SFX_Facility_ConstructItem);
    }

    if (STAT_GetStat(eRecap_MaxPower) < HQ().GetPowerCapacity())
    {
        STAT_SetStat(eRecap_MaxPower, HQ().GetPowerCapacity());
    }

    iNumAdjacencies = LWCE_GetAdjacencies('All');
    if (STAT_GetStat(eRecap_MaxAdjacencies) < iNumAdjacencies)
    {
        STAT_SetStat(eRecap_MaxAdjacencies, iNumAdjacencies);
    }

    RemoveRoom(Y, X);
    LWCE_StreamInRoom(Y, X, m_arrCETiles[TargetTileIndex].nmType, LWCE_GetFacilityAt(X, Y));
    UpdateTiles();
}

function SetFacility(int iFacility, int X, int Y)
{
    `LWCE_LOG_DEPRECATED_CLS(SetFacility);
}

function LWCE_SetFacility(name nmFacility, int X, int Y)
{
    local int TargetTileIndex;

    TargetTileIndex = TileIndex(X, Y);

    // TODO: use a better method that can accommodate multiple sizes
    // if (Facility(iFacility).iSize == 2)
    // {
    //     m_arrCETiles[TileIndex(X + 1, Y)].iType = eTerrain_Facility;
    //     m_arrCETiles[TileIndex(X + 1, Y)].bSecondTile = true;
    // }

    m_arrCETiles[TargetTileIndex].bHasFacility = true;

    m_arrCEFacilities[TargetTileIndex].FacilityName = nmFacility;
    m_arrCEFacilities[TargetTileIndex].X = X;
    m_arrCEFacilities[TargetTileIndex].Y = Y;

    LWCE_XGHeadquarters(HQ()).LWCE_AddFacility(nmFacility);
}

function StreamInBaseRooms(optional bool bImmediate = true)
{
    local int X, Y;

    for (Y = 0; Y < m_iNumTilesHigh; Y++)
    {
        for (X = 0; X < m_iNumTilesWide; X++)
        {
            LWCE_StreamInRoom(Y, X, m_arrCETiles[TileIndex(X, Y)].nmType, LWCE_GetFacilityAt(X, Y), bImmediate);
        }
    }
}

function StreamInRoom(int iRow, int iCol, ETerrainTypes eTerrainType, EFacilityType eFacType, optional bool bImmediate = false)
{
    `LWCE_LOG_DEPRECATED_CLS(StreamInRoom);
}

function LWCE_StreamInRoom(int iRow, int iCol, name nmTerrainType, name nmFacility, optional bool bImmediate = false)
{
    local Vector vLoc;
    local string MapName;
    local LevelStreaming LvlStreaming;

    if (iRow == 0)
    {
        return;
    }

    vLoc = GetRoomLocation(iRow, iCol);

    if (IsAccessLocation(iCol, iRow) && nmFacility == '')
    {
        MapName = LWCE_GetMapName('ExcavatedAccessLift', '');
    }
    else
    {
        MapName = LWCE_GetMapName(nmTerrainType, nmFacility);
    }

    LvlStreaming = class'XComMapManager'.static.AddStreamingMap(MapName, vLoc,, bImmediate);

    // TODO: emit an event to trigger facility on-loaded delegates, as per HandleFacilitySpecificFuncitionality in base class
}

function int TileIndex(int X, int Y)
{
    return X + Y * m_iNumTilesWide;
}

function UnstreamRooms()
{
    local int X, Y;

    for (Y = 0; Y < m_iNumTilesHigh; Y++)
    {
        for (X = 0; X < m_iNumTilesWide; X++)
        {
            RemoveRoom(Y, X);
        }
    }
}

function UpdateTiles()
{
    local int X, Y;

    for (Y = 0; Y < m_iNumTilesHigh; Y++)
    {
        for (X = 0; X < m_iNumTilesWide; X++)
        {
            if (m_arrCETiles[TileIndex(X, Y)].eState == eTileState_Accessible)
            {
                // no change
            }
            else if (!HasAccess(X, Y))
            {
                m_arrCETiles[TileIndex(X, Y)].eState = eTileState_NoAccess;
            }
            else if (!HasExcavation(X, Y))
            {
                m_arrCETiles[TileIndex(X, Y)].eState = eTileState_NoExcavation;
            }
            else
            {
                m_arrCETiles[TileIndex(X, Y)].eState = eTileState_Accessible;
            }

            // This might be a good spot for a mod hook in the future
        }
    }

    XComHeadquartersController(`HQGAME.PlayerController).ClientFlushLevelStreaming();
}