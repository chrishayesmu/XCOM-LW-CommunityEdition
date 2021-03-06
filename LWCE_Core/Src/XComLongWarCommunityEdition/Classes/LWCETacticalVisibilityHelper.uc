/***************************************************************************************************
 * This class uses invisible units to help provide line-of-sight and flanking previews in-game.
 * It is based on the Line-of-Sight Indicators mod (https://www.nexusmods.com/xcom/mods/666), and
 * uses a modified version of its source code (https://github.com/tracktwo/sightlines).
 *
 * Per the BSD 2-Clause license which Sightlines is licensed under, the text of the license is
 * included here.
 *
 *        Copyright (c) 2015,
 *        All rights reserved.
 *
 *        Redistribution and use in source and binary forms, with or without
 *        modification, are permitted provided that the following conditions are met:
 *
 *        * Redistributions of source code must retain the above copyright notice, this
 *          list of conditions and the following disclaimer.
 *
 *        * Redistributions in binary form must reproduce the above copyright notice,
 *          this list of conditions and the following disclaimer in the documentation
 *          and/or other materials provided with the distribution.
 *
 *        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *        AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *        IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *        DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 *        FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *        DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 *        SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *        CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 *        OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *        OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 ***************************************************************************************************/

class LWCETacticalVisibilityHelper extends Actor
    config(LWCEQualityOfLife);

enum EVisDiscColor
{
    eVDC_None,
    eVDC_Green,
    eVDC_Gold,
    eVDC_Orange,
    eVDC_Red,
    eVDC_White
};

// Pawn types for the two invisible units we use. We need one unit that can use cover, for when the
// selected unit is a soldier, and one that can't, for SHIVs/MECs. The original Sightlines mod used
// a Chryssalid, but that causes the Chryssalid slobber VFX to be visible when moving the cursor
// around, so we use a Zombie instead.
//
// TODO: if anyone ever writes a mod that puts alien pawns on the neutral team, the vis helper is
// going to ruin everything they're doing
const COVER_USING_HELPER_PAWN_TYPE     = 30; // ePawnType_Sectoid
const NON_COVER_USING_HELPER_PAWN_TYPE = 44; // ePawnType_Zombie

const HELPER_UNIT_TEAM = 1; // eTeam_Neutral
const PROCESS_POSITION_DELAY_SECONDS = 0.075f; // How many seconds to wait between when the cursor moves and when
                                               // XGUnit.ProcessNewPosition is called, for performance

var config bool bShowFlanks;
var config bool bShowForEnemyUnits;
var config bool bShowForFriendlyUnits;
var config bool bShowForNeutralUnits;
var config bool bShowInUnitFlag;

var config bool bShowInUnitDisc;
var config EVisDiscColor eDiscColorForEnemyUnits;
var config EVisDiscColor eDiscColorForFlankedEnemyUnits;
var config EVisDiscColor eDiscColorForFriendlyUnits;
var config EVisDiscColor eDiscColorForFlankedFriendlyUnits;
var config EVisDiscColor eDiscColorForNeutralUnits;

var protected XGUnit m_kNonCoverUsingHelper;
var protected XGUnit m_kCoverUsingHelper;

var protected Vector m_vLastValidCursor;
var protected Vector m_vLastValidDestination;
var protected bool m_bInitialized;
var protected float m_fTimeUntilProcessPosition;

static function LWCETacticalVisibilityHelper GetInstance()
{
    local LWCETacticalVisibilityHelper kHelper;

    foreach `WORLDINFO.AllActors(class'LWCETacticalVisibilityHelper', kHelper)
    {
        return kHelper;
    }

    return none;
}

static function bool IsVisHelper(XGUnit kUnit)
{
    if (kUnit.GetTeam() != HELPER_UNIT_TEAM)
    {
        return false;
    }

    if (kUnit.GetCharacter().m_eType == NON_COVER_USING_HELPER_PAWN_TYPE || kUnit.GetCharacter().m_eType == COVER_USING_HELPER_PAWN_TYPE)
    {
        return true;
    }

    return false;
}

static function CreateAndInitialize()
{
    local LWCETacticalVisibilityHelper kVisHelper;

    kVisHelper = GetInstance();

    if (kVisHelper != none)
    {
        kVisHelper.Init();
        return;
    }

    kVisHelper = `WORLDINFO.Spawn(class'LWCETacticalVisibilityHelper');
    kVisHelper.Init();
}

function Init()
{
    if (m_bInitialized)
    {
        return;
    }

    if (`BATTLE == none || `LWCE_UNITFLAGMGR == none || AnimalPlayer() == none || AnimalPlayer().m_kSquad == none)
    {
        SetTimer(0.1, /* inbLoop */ false, 'Init');
        return;
    }

    InitializeHelpers();
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(Cursor(), 'Location', self, OnCursorMoved);
    m_bInitialized = true;
}

simulated event Tick(float fDeltaT)
{
    if (!m_bInitialized)
    {
        return;
    }

    // For flanking indicators, we need to call ProcessNewPosition to make the helper unit properly
    // handle when it's in cover. This is only needed for the helper that can actually use cover, and
    // it's an expensive call, so we only call it for one unit, and only after moves. We wait a brief
    // time before making the call so that if the player is quickly moving the mouse around, we aren't
    // stacking up expensive calls and tanking the frame rate.
    if (m_fTimeUntilProcessPosition > 0.0f && CanSafelyUpdateVisibility())
    {
        m_fTimeUntilProcessPosition -= fDeltaT;

        if (m_fTimeUntilProcessPosition <= 0.0f)
        {
            m_kCoverUsingHelper.ProcessNewPosition(false);
            ClearVisHelperTileClaims();
        }
    }

    UpdateVisibilityMarkers();
}

function MoveHelpersOutOfTheWay()
{
    local Vector vLocation;

    if (!m_bInitialized)
    {
        return;
    }

    if (m_kNonCoverUsingHelper != none)
    {
        vLocation = class'XComWorldData'.static.GetWorldData().FindClosestValidLocation(m_kNonCoverUsingHelper.Location, /* bAllowFlying */ false, /* bPrioritizeZLevel */ false);
        MoveHelperUnit(m_kNonCoverUsingHelper, vLocation);
    }

    if (m_kCoverUsingHelper != none)
    {
        vLocation = class'XComWorldData'.static.GetWorldData().FindClosestValidLocation(m_kCoverUsingHelper.Location, /* bAllowFlying */ false, /* bPrioritizeZLevel */ false);
        MoveHelperUnit(m_kCoverUsingHelper, vLocation);
    }

    ClearVisHelperTileClaims();
}

function UpdateVisibilityMarkers()
{
    local Vector vDestination;
    local XGUnit kActiveUnit;

    if (!m_bInitialized)
    {
        return;
    }

    kActiveUnit = TacticalController().m_kActiveUnit;

    // At certain times, we don't want to show LOS indicators; automatically hide them in those cases
    if (ShouldHideVisibilityMarkers(kActiveUnit))
    {
        HideAllVisibilityMarkers();
        return;
    }

    vDestination = kActiveUnit.GetPathingPawn().GetPathDestinationLimitedByCost();

    // The zero vector indicates the cursor is in an unpathable position
    if (VSizeSq(vDestination) == 0.0)
    {
        HideAllVisibilityMarkers();
        return;
    }

    if (class'Helpers'.static.AreVectorsDifferent(Cursor().Location, m_vLastValidCursor, 0.1f) || class'Helpers'.static.AreVectorsDifferent(vDestination, m_vLastValidDestination, 0.1f))
    {
        OnCursorMoved();
    }

    // We can't tell if the visibility data has actually changed; it's just ready at some point after we move the helper units.
    // Unfortunately we just have to update the UI pretty often.
    if (kActiveUnit.CanUseCover())
    {
        SetVisibilityMarkers(kActiveUnit, m_kCoverUsingHelper);
    }
    else
    {
        SetVisibilityMarkers(kActiveUnit, m_kNonCoverUsingHelper);
    }
}

function XGPlayer AnimalPlayer()
{
    return XGBattle_SP(`BATTLE).GetAnimalPlayer();
}

function XCom3DCursor Cursor()
{
    return TacticalController().GetCursor();
}

function XComTacticalController TacticalController()
{
    local XComTacticalController kTacticalController;

    foreach WorldInfo.AllControllers(class'XComTacticalController', kTacticalController)
    {
        break;
    }

    return kTacticalController;
}

protected function InitializeHelpers()
{
    local XGUnit kUnit;

    // Start by looking for helpers in the level already; if we're loading a save they'll be there
    foreach AllActors(class'XGUnit', kUnit)
    {
        if (kUnit.GetTeam() != HELPER_UNIT_TEAM)
        {
            continue;
        }

        if (kUnit.GetCharacter().m_eType == NON_COVER_USING_HELPER_PAWN_TYPE)
        {
            m_kNonCoverUsingHelper = kUnit;
        }
        else if (kUnit.GetCharacter().m_eType == COVER_USING_HELPER_PAWN_TYPE)
        {
            m_kCoverUsingHelper = kUnit;
        }
    }

    if (m_kNonCoverUsingHelper == none)
    {
        `LWCE_LOG_CLS("Spawning non-cover-using helper unit with pawn type " $ NON_COVER_USING_HELPER_PAWN_TYPE);
        m_kNonCoverUsingHelper = SpawnHelperUnit(NON_COVER_USING_HELPER_PAWN_TYPE);
    }

    if (m_kCoverUsingHelper == none)
    {
        `LWCE_LOG_CLS("Spawning cover-using helper unit with pawn type " $ COVER_USING_HELPER_PAWN_TYPE);
        m_kCoverUsingHelper = SpawnHelperUnit(COVER_USING_HELPER_PAWN_TYPE);
    }

    `LWCE_LOG_CLS("Configuring non-cover-using helper unit " $ m_kNonCoverUsingHelper);
    ConfigureHelperUnit(m_kNonCoverUsingHelper);

    `LWCE_LOG_CLS("Configuring cover-using helper unit " $ m_kCoverUsingHelper);
    ConfigureHelperUnit(m_kCoverUsingHelper);

    // This is needed because after loading the helper from a save,
    // ProcessNewPosition() is called, which makes it stick to cover in the
    // location where it was saved. Calling ProcessNewPosition(false) again
    // resets this. Otherwise flanking indicators break.
    m_kNonCoverUsingHelper.ProcessNewPosition(false);
    m_kCoverUsingHelper.ProcessNewPosition(false);

    // Need to do this to make sure any tile occupied at the time the game was saved is now cleared.
    // This has to come after ProcessNewPosition, for reasons unknown.
    class'XComWorldData'.static.GetWorldData().SetTileBlockedByUnitFlag(m_kNonCoverUsingHelper);
    class'XComWorldData'.static.GetWorldData().SetTileBlockedByUnitFlag(m_kCoverUsingHelper);

    ClearVisHelperTileClaims(/* bForce */ true);
}

/// <summary>
/// Checks if the game is in a state where updating visibility data (such as by moving the helper unit, or
/// updating their cover states) is going to break something.
/// </summary>
protected function bool CanSafelyUpdateVisibility()
{
    local XGAction kAction;
    local XGAction_Targeting kTargetingAction;
    local XGUnit kActiveUnit;

    if (!m_bInitialized)
    {
        return false;
    }

    kActiveUnit = TacticalController().m_kActiveUnit;

    if (kActiveUnit == none)
    {
        return false;
    }

    kAction = kActiveUnit.GetAction();

    if (kAction == none)
    {
        return false;
    }

    kTargetingAction = XGAction_Targeting(kActiveUnit.GetAction());

    if (kTargetingAction != none && kTargetingAction.m_kShot != none && kTargetingAction.m_kShot.IsA('XGAbility_Grapple'))
    {
        return true;
    }

    // XGAction_Path is used when choosing the unit's destination; it's the only action other than targeting a grapple
    // that we can safely update visibility during. IsPerformingAction does not count it, hence the separate check.
    if (kAction.IsA('XGAction_Path'))
    {
        return true;
    }

    return false;
}

/// <summary>
/// Marks tiles occupied by vis helpers as unoccupied, unless there is an actual unit occupying the same tile.
/// </summary>
/// <param name="bForce">If true, tile claims will be modified even if it's not currently safe to do so.</param>
protected function ClearVisHelperTileClaims(optional bool bForce = false)
{
    local bool bClearCoverHelper, bClearNonCoverHelper;
    local int iCoverHelperX, iCoverHelperY, iCoverHelperZ;
    local int iNonCoverHelperX, iNonCoverHelperY, iNonCoverHelperZ;
    local int iUnitX, iUnitY, iUnitZ;
    local XComWorldData kWorldData;
    local XGUnit kUnit;

    if (!bForce && !CanSafelyUpdateVisibility())
    {
        return;
    }

    bClearCoverHelper = true;
    bClearNonCoverHelper = true;
    kWorldData = class'XComWorldData'.static.GetWorldData();

    kWorldData.GetTileCoordinatesFromPosition(m_kCoverUsingHelper.Location, iCoverHelperX, iCoverHelperY, iCoverHelperZ);
    kWorldData.GetTileCoordinatesFromPosition(m_kNonCoverUsingHelper.Location, iNonCoverHelperX, iNonCoverHelperY, iNonCoverHelperZ);

    foreach AllActors(class'XGUnit', kUnit)
    {
        if (IsVisHelper(kUnit))
        {
            continue;
        }

        kWorldData.GetTileCoordinatesFromPosition(kUnit.Location, iUnitX, iUnitY, iUnitZ);

        // Our vis helpers don't always quite match unit positions on the Z axis, so add a small tolerance in that dimension
        if (iUnitX == iCoverHelperX && iUnitY == iCoverHelperY && Abs(iUnitZ - iCoverHelperZ) <= 2)
        {
            bClearCoverHelper = false;
        }

        if (iUnitX == iNonCoverHelperX && iUnitY == iNonCoverHelperY && Abs(iUnitZ - iNonCoverHelperZ) <= 2)
        {
            bClearNonCoverHelper = false;
        }
    }

    if (bClearCoverHelper)
    {
        kWorldData.ClearTileBlockedByUnitFlag(m_kCoverUsingHelper);
        m_kCoverUsingHelper.UnClaimCover();
    }

    if (bClearNonCoverHelper)
    {
        kWorldData.ClearTileBlockedByUnitFlag(m_kNonCoverUsingHelper);
        m_kNonCoverUsingHelper.UnClaimCover();
    }
}

protected function ConfigureHelperUnit(XGUnit kUnit)
{
    // Make our helpers as non-interactive as possible, so they don't interfere with gameplay
    kUnit.m_kPawn.SetCollision(/* bNewColActors */ false, /* bNewBlockActors */ false, /* bNewIgnoreEncroachers */ true);
    kUnit.m_kPawn.bCollideWorld = false;
    kUnit.m_kPawn.SetPhysics(PHYS_None);

    kUnit.SetVisible(false);
    kUnit.SetHidden(true);
    kUnit.SetHiding(true);
    kUnit.SetVisibleToTeams(eTeam_None);
    kUnit.m_bForceHidden = true;

    kUnit.m_kPawn.SetHidden(true);
    kUnit.m_kPawn.HideMainPawnMesh();
    kUnit.m_kPawn.Weapon.Mesh.SetHidden(true);
}

protected function HideAllVisibilityMarkers()
{
    local XGUnit kUnit, kActiveUnit;

    if (!m_bInitialized)
    {
        return;
    }

    kActiveUnit = TacticalController().m_kActiveUnit;

    foreach AllActors(class'XGUnit', kUnit)
    {
        MarkUnit(kUnit, false, /* bFlanked */ false, kActiveUnit == kUnit);
    }
}

protected function MarkUnit(XGUnit kUnit, bool bVisible, bool bFlanked, bool bIsActiveUnit)
{
    local MaterialInterface kMaterial;
    local LWCE_UIUnitFlag kFlag;

    if (!m_bInitialized)
    {
        return;
    }

    if (bShowInUnitFlag)
    {
        kFlag = `LWCE_UNITFLAGMGR.GetFlagForUnit(kUnit);

        if (kFlag != none)
        {
            kFlag.ToggleVisibilityPreviewIcon(bIsActiveUnit ? false : bVisible, bFlanked);
        }
    }

    if (bShowInUnitDisc)
    {
        if (bIsActiveUnit)
        {
            // For the active unit, we need to restore their disc to its normal state, and let the
            // normal processes manage its color
            kUnit.m_kDiscMesh.SetHidden(false);
        }
        else
        {
            kMaterial = GetMaterialForUnitDisc(kUnit, bFlanked);
            bVisible = bVisible && kMaterial != none;

            kUnit.m_kDiscMesh.SetHidden(!bVisible);

            if (bVisible)
            {
                kUnit.m_kDiscMesh.SetMaterial(0, kMaterial);
            }
        }
    }
}

protected function MoveHelperUnit(XGUnit kUnit, out Vector vLoc)
{
    kUnit.GetPawn().SetLocation(vLoc);

    // Need to reset the unit after each move, or else some parts of it become visible again
    ConfigureHelperUnit(kUnit);
}

function OnCursorMoved()
{
    local Vector vDestination;

    if (!m_bInitialized)
    {
        return;
    }

    // Save recomputing visibility data if not needed
    if (!CanSafelyUpdateVisibility())
    {
        return;
    }

    vDestination = TacticalController().m_kActiveUnit.GetPathingPawn().GetPathDestinationLimitedByCost();

    if (VSizeSq(vDestination) == 0.0)
    {
        // Zero vector: don't move the helpers, cursor is not on a valid tile
        return;
    }

    if (!class'Helpers'.static.AreVectorsDifferent(Cursor().Location, m_vLastValidCursor, 0.1f) || !class'Helpers'.static.AreVectorsDifferent(vDestination, m_vLastValidDestination, 0.1f))
    {
        return;
    }

    m_vLastValidCursor = Cursor().Location;
    m_vLastValidDestination = vDestination;

    // We just move the helper units, without updating any visibility markers. It
    // will take a few frames for visibility info to fully update.
    MoveHelperUnit(m_kNonCoverUsingHelper, vDestination);
    MoveHelperUnit(m_kCoverUsingHelper, vDestination);

    ClearVisHelperTileClaims();

    // Queue up for position processing later
    m_fTimeUntilProcessPosition = PROCESS_POSITION_DELAY_SECONDS;
}

protected function MaterialInterface GetMaterialForUnitDisc(XGUnit kUnit, bool bFlanked)
{
    local EVisDiscColor eDiscColor;

    switch (kUnit.GetTeam())
    {
        case eTeam_Alien:
            eDiscColor = bFlanked ? eDiscColorForFlankedEnemyUnits : eDiscColorForEnemyUnits;
            break;
        case eTeam_Neutral:
            eDiscColor = eDiscColorForNeutralUnits;
            break;
        case eTeam_XCom:
            eDiscColor = bFlanked ? eDiscColorForFlankedFriendlyUnits : eDiscColorForFriendlyUnits;
            break;
    }

    switch (eDiscColor)
    {
        case eVDC_None:
            return none;
        case eVDC_Green:
            return kUnit.UnitCursor_UnitSelect_Green;
        case eVDC_Gold:
            return kUnit.UnitCursor_UnitSelect_Gold;
        case eVDC_Orange:
            return kUnit.UnitCursor_UnitSelect_Orange;
        case eVDC_Red:
            return kUnit.UnitCursor_UnitSelect_RED;
        case eVDC_White:
            // For some reason the "purple" unit select is actually white
            return kUnit.UnitCursor_UnitSelect_Purple;
    }

    `LWCE_LOG_CLS("WARNING: Unit " $ kUnit $ " couldn't be mapped to a disc color. Using a default value.");
    return kUnit.UnitCursor_UnitSelect_RED;
}

protected function SetVisibilityMarkers(XGUnit kActiveUnit, XGUnit kHelper)
{
    local bool bFlanked, bVisible;
    local array<XGUnit> arrEnemies, arrFriends;
    local XGUnit kUnit;

    arrEnemies = kHelper.GetVisibleEnemies();
    arrFriends = kHelper.GetVisibleFriends();

    foreach AllActors(class'XGUnit', kUnit)
    {
        switch (kUnit.GetTeam())
        {
            case eTeam_Alien:
                bVisible = bShowForEnemyUnits && kUnit.IsAliveAndWell() && arrEnemies.Find(kUnit) != INDEX_NONE && kActiveUnit.GetSquad().SquadCanSeeEnemy(kUnit);
                break;
            case eTeam_Neutral:
                // TODO: needs extra testing, not sure if neutrals will count as enemies to an XCOM unit
                bVisible = bShowForNeutralUnits && kUnit.IsAliveAndWell() && arrFriends.Find(kUnit) != INDEX_NONE && kActiveUnit.GetSquad().SquadCanSeeEnemy(kUnit);
                break;
            case eTeam_XCom:
                // IsAlive instead of IsAliveAndWell for bleeding out/stabilized units
                bVisible = bShowForFriendlyUnits && kUnit.IsAlive() && arrFriends.Find(kUnit) != INDEX_NONE;
                break;
        }

        bFlanked = false;

        if (bVisible && bShowFlanks && kUnit.GetTeam() != eTeam_Neutral)
        {
            // Condition from UISightlineHUD_SightlineContainer
            bFlanked = kUnit.CanUseCover() && !kUnit.IsFlying()
                 && ( !kUnit.IsInCover() || kUnit.IsFlankedByLoc(kHelper.m_kPawn.Location) || kUnit.IsFlankedBy(kHelper) );
        }

        MarkUnit(kUnit, bVisible, bFlanked, kUnit == kActiveUnit);
    }
}

protected function bool ShouldHideVisibilityMarkers(XGUnit kActiveUnit)
{
    if (!m_bInitialized)
    {
        return true;
    }

    if (kActiveUnit == none)
    {
        return true;
    }

    if (kActiveUnit.GetTeam() != eTeam_XCom)
    {
        return true;
    }

    // Hide vis markers any time it's not safe to update them; this makes sense for most abiliites
    // (e.g. no need for vis markers when targeting a grenade) and also prevents showing stale data
    return !CanSafelyUpdateVisibility();
}

protected function XGUnit SpawnHelperUnit(EPawnType eType)
{
    local XGPlayer kPlayer;
    local XComSpawnPoint_Alien kSpawnPoint;
    local XGUnit kUnit;

    kPlayer = AnimalPlayer();
    kSpawnPoint = Spawn(class'XComSpawnPoint_Alien', /* SpawnOwner */, /* SpawnTag */, /* SpawnLocation */, /* SpawnRotation */, /* ActorTemplate */, /* bNoCollisionFail */ true);

    kUnit = kPlayer.SpawnAlien(eType, kSpawnPoint, /* bSnapToCover */, /* bSnapToGround */, /* bAddFlag */ false);

    return kUnit;
}