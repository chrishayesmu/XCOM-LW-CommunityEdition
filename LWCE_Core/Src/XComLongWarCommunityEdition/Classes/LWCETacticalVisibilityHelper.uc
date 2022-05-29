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
var config EVisDiscColor eDiscColorForFlankedNeutralUnits;

var protected bool m_bInitialized;
var XGUnit m_kNonCoverUsingHelper;
var XGUnit m_kCoverUsingHelper;

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
    //m_kNonCoverUsingHelper.UnClaimCover();
    //m_kCoverUsingHelper.UnClaimCover();

    //m_kNonCoverUsingHelper.ProcessNewPosition(false);
    //m_kCoverUsingHelper.ProcessNewPosition(false);

    class'XComWorldData'.static.GetWorldData().SetTileBlockedByUnitFlag(m_kNonCoverUsingHelper);
    class'XComWorldData'.static.GetWorldData().ClearTileBlockedByUnitFlag(m_kNonCoverUsingHelper);
    class'XComWorldData'.static.GetWorldData().SetTileBlockedByUnitFlag(m_kCoverUsingHelper);
    class'XComWorldData'.static.GetWorldData().ClearTileBlockedByUnitFlag(m_kCoverUsingHelper);
}

protected function ConfigureHelperUnit(XGUnit kUnit)
{
    // Make our helpers as non-interactive as possible, so they don't interfere with gameplay
    kUnit.m_kPawn.SetCollision(/* bNewColActors */ false, /* bNewBlockActors */ false, /* bNewIgnoreEncroachers */ true);
    kUnit.m_kPawn.bCollideWorld = false;
    kUnit.m_kPawn.SetPhysics(PHYS_None);

    kUnit.UnClaimCover();
    kUnit.SetVisible(false);
    kUnit.SetHidden(true);
    kUnit.SetHiding(true);
    kUnit.SetVisibleToTeams(eTeam_None);

    //kUnit.m_kPawn.SetHidden(true);
    //kUnit.m_kPawn.HideMainPawnMesh();
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
        MarkUnit(kUnit, false, /* bFlanked */, kActiveUnit == kUnit);
    }
}

protected function MarkUnit(XGUnit kUnit, bool bVisible, optional bool bFlanked, optional bool bIsActiveUnit)
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
    vLoc.X = 48.0f + 96.0f * FFloor(vLoc.X / 96.0f);
    vLoc.Y = 48.0f + 96.0f * FFloor(vLoc.Y / 96.0f);

    kUnit.SetLocation(vLoc);
    kUnit.GetPawn().SetLocation(vLoc);

    // Make sure the tile isn't registered as blocked so it doesn't affect nearby units
    class'XComWorldData'.static.GetWorldData().ClearTileBlockedByUnitFlag(kUnit);

    // Need to reset the unit after each move, or else some parts of it become visible again
    ConfigureHelperUnit(kUnit);
}

protected function OnCursorMoved()
{
    local XGUnit kActiveUnit;
    local Vector vDestination;

    if (!m_bInitialized)
    {
        return;
    }

    kActiveUnit = TacticalController().m_kActiveUnit;

    // Save recomputing visibility data if it's not XCOM's turn
    if (kActiveUnit == none || kActiveUnit.GetTeam() != eTeam_XCom)
    {
        return;
    }

    vDestination = kActiveUnit.GetPathingPawn().GetPathDestinationLimitedByCost();

    if (VSizeSq(vDestination) == 0.0)
    {
        // Zero vector: don't move the helpers, cursor is not on a valid tile
        return;
    }

    // We just move the helper units, without updating any visibility markers. It
    // will take a few frames for visibility info to fully update.
    MoveHelperUnit(m_kNonCoverUsingHelper, vDestination);
    MoveHelperUnit(m_kCoverUsingHelper, vDestination);
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
            eDiscColor = bFlanked ? eDiscColorForFlankedNeutralUnits : eDiscColorForNeutralUnits;
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
                bVisible = bShowForEnemyUnits && arrEnemies.Find(kUnit) != INDEX_NONE && kActiveUnit.GetSquad().SquadCanSeeEnemy(kUnit);
                break;
            case eTeam_Neutral:
                // TODO: needs extra testing, not sure if neutrals will count as enemies to an XCOM unit
                bVisible = bShowForNeutralUnits && arrFriends.Find(kUnit) != INDEX_NONE && kActiveUnit.GetSquad().SquadCanSeeEnemy(kUnit);
                break;
            case eTeam_XCom:
                bVisible = bShowForFriendlyUnits && arrFriends.Find(kUnit) != INDEX_NONE;
                break;
        }

        bFlanked = false;

        if (bVisible)
        {
            // For some reason, after loading a save, IsFlankedBy stops working for our helper units.
            // Flank indicators are disabled entirely until we can figure that out.
            bFlanked = !kUnit.IsFlying() && kUnit.CanUseCover() && (!kUnit.IsInCover() || kUnit.IsFlankedBy(kHelper) || kUnit.IsFlankedByLoc(kHelper.Location));
        }

        MarkUnit(kUnit, bVisible, bFlanked, kUnit == kActiveUnit);
    }
}

protected function bool ShouldHideVisibilityMarkers(XGUnit kActiveUnit)
{
    local XGAction_Targeting kAction;

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

    if (kActiveUnit.IsPerformingAction())
    {
        kAction = XGAction_Targeting(kActiveUnit.GetAction());

        if (kAction != none)
        {
            if (kAction.m_kShot != none && kAction.m_kShot.IsA('XGAbility_Grapple'))
            {
                return false;
            }
        }

        return true;
    }

    return false;
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