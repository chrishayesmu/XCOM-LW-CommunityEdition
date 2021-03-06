class LWCE_XComTacticalCheatManager extends XComTacticalCheatManager;

var bool bDisplayMovementGrid;

`include(generators.uci)

`LWCE_GENERATOR_XCOMCHEATMANAGER

exec function DebugShotAgainstTarget(optional int iAbilityId = eAbility_ShotStandard)
{
    local int Index;
    local float fClosestDist, fCurrentDist;
    local LWCE_Console kConsole;
    local TShotInfo kInfo;
    local TShotResult kResult;
    local LWCE_XGUnit kShooter, kTarget;
    local array<XGUnit> arrTargets;
    local XComUnitPawn kClosestPawn, kPawn;
    local XGAbility_Targeted kAbility;

    kConsole = GetConsole();
    kShooter = LWCE_XGUnit(Outer.GetActiveUnit());

    foreach Outer.AllActors(class'XComUnitPawn', kPawn)
    {
        if (kPawn == kShooter.m_kPawn)
        {
            continue;
        }

        if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(XGUnit(kPawn.GetGameUnit())))
        {
            continue;
        }

        fCurrentDist = VSize(kPawn.Location - kShooter.Location);

        if (kClosestPawn == none || fCurrentDist < fClosestDist)
        {
            kClosestPawn = kPawn;
            fClosestDist = fCurrentDist;
        }
    }

    kTarget = LWCE_XGUnit(kClosestPawn.GetGameUnit());

    kConsole.OutputTextLine("Shooter: " $ kShooter.SafeGetCharacterFullName() $ "; target: " $ kTarget.SafeGetCharacterFullName());

    // Set up a fake ability to use
    arrTargets.Length = 1;
    arrTargets[0] = kTarget;

    kAbility = XGAbility_Targeted(`LWCE_ABILITYTREE.SpawnAbility(iAbilityId, kShooter, arrTargets, kShooter.m_kInventory.GetActiveWeapon()));

    class'LWCE_XGAbility_Extensions'.static.GetShotSummary(kAbility, kResult, kInfo);

    kConsole.OutputTextLine("AIM: " $ kInfo.arrHitBonusStrings.Length $ " bonuses, " $ kInfo.arrHitPenaltyStrings.Length $ " penalties");

    for (Index = 0; Index < kInfo.arrHitBonusStrings.Length; Index++)
    {
        kConsole.OutputTextLine("  Bonus #" $ Index $ ": " $ kInfo.arrHitBonusValues[Index] $ " from " $ kInfo.arrHitBonusStrings[Index]);
    }

    for (Index = 0; Index < kInfo.arrHitPenaltyStrings.Length; Index++)
    {
        kConsole.OutputTextLine("  Penalty #" $ Index $ ": " $ kInfo.arrHitPenaltyValues[Index] $ " from " $ kInfo.arrHitPenaltyStrings[Index]);
    }

    kConsole.OutputTextLine("CRIT CHANCE: " $ kInfo.arrCritBonusStrings.Length $ " bonuses, " $ kInfo.arrCritPenaltyStrings.Length $ " penalties");

    for (Index = 0; Index < kInfo.arrCritBonusStrings.Length; Index++)
    {
        kConsole.OutputTextLine("  Bonus #" $ Index $ ": " $ kInfo.arrCritBonusValues[Index] $ " from " $ kInfo.arrCritBonusStrings[Index]);
    }

    for (Index = 0; Index < kInfo.arrCritPenaltyStrings.Length; Index++)
    {
        kConsole.OutputTextLine("  Penalty #" $ Index $ ": " $ kInfo.arrCritPenaltyValues[Index] $ " from " $ kInfo.arrCritPenaltyStrings[Index]);
    }
}

exec function DropMan(optional bool bAddToHumanTeam = false)
{
    local XGCharacter kChar;
    local XComSpawnPoint kSpawnPt;
    local XGUnit kUnit;

    kSpawnPt = Outer.Spawn(class'XComSpawnPoint',,, GetCursorLoc(), rot(0, 0, 0));

    if (bAddToHumanTeam)
    {
        kChar = Outer.Spawn(class'XGCharacter_Civilian');
        kUnit = XGBattle_SP(`BATTLE).GetHumanPlayer().SpawnUnit(class'XGUnit', XGBattle_SP(`BATTLE).GetHumanPlayer().m_kPlayerController, kSpawnPt.Location, kSpawnPt.Rotation, kChar, XGBattle_SP(`BATTLE).GetHumanPlayer().m_kSquad,, kSpawnPt);
        class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kUnit);
    }
    else
    {
        XGAIPlayer_Animal(XGBattle_SP(`BATTLE).GetAnimalPlayer()).SpawnCivilian(kSpawnPt);
    }
}

exec function GiveBonus(string strName)
{
    local int iBonus;
    local LWCE_XGUnit kUnit;

    kUnit = LWCE_XGUnit(Outer.GetActiveUnit());

    if (kUnit == none)
    {
        return;
    }

    iBonus = FindPerkByName(strName);

    if (iBonus > 0)
    {
        kUnit.AddBonus(iBonus);
    }
}

exec function GivePenalty(string strName)
{
    local int iPenalty;
    local LWCE_XGUnit kUnit;

    kUnit = LWCE_XGUnit(Outer.GetActiveUnit());

    if (kUnit == none)
    {
        return;
    }

    iPenalty = FindPerkByName(strName);

    if (iPenalty > 0)
    {
        kUnit.AddPenalty(iPenalty);
    }
}

exec function PrintCoverInfo()
{
    local LWCE_Console kConsole;
    local LWCE_XGUnit kUnit;
    local XComCoverPoint CoverPoint;

    kUnit = LWCE_XGUnit(Outer.GetActiveUnit());
    kConsole = GetConsole();

    if (!kUnit.CanUseCover())
    {
        kConsole.OutputTextLine("Active unit can't use cover.");
        return;
    }

    kConsole.OutputTextLine("Printing cover info for " $ kUnit $ "...\n");

    CoverPoint = kUnit.GetCoverPoint();

    if ( (CoverPoint.Flags & class'XComWorldData'.const.COVER_North) != 0 )
    {
        if ( (CoverPoint.Flags & class'XComWorldData'.const.COVER_NLow) != 0 )
        {
            kConsole.OutputTextLine("  Unit has LOW COVER to the NORTH");
        }
        else
        {
            kConsole.OutputTextLine("  Unit has HIGH COVER to the NORTH");
        }
    }

    if ( (CoverPoint.Flags & class'XComWorldData'.const.COVER_South) != 0 )
    {
        if ( (CoverPoint.Flags & class'XComWorldData'.const.COVER_SLow) != 0 )
        {
            kConsole.OutputTextLine("  Unit has LOW COVER to the SOUTH");
        }
        else
        {
            kConsole.OutputTextLine("  Unit has HIGH COVER to the SOUTH");
        }
    }

    if ( (CoverPoint.Flags & class'XComWorldData'.const.COVER_East) != 0 )
    {
        if ( (CoverPoint.Flags & class'XComWorldData'.const.COVER_ELow) != 0 )
        {
            kConsole.OutputTextLine("  Unit has LOW COVER to the EAST");
        }
        else
        {
            kConsole.OutputTextLine("  Unit has HIGH COVER to the EAST");
        }
    }

    if ( (CoverPoint.Flags & class'XComWorldData'.const.COVER_West) != 0 )
    {
        if ( (CoverPoint.Flags & class'XComWorldData'.const.COVER_WLow) != 0 )
        {
            kConsole.OutputTextLine("  Unit has LOW COVER to the WEST");
        }
        else
        {
            kConsole.OutputTextLine("  Unit has HIGH COVER to the WEST");
        }
    }
}

exec function ReloadAmmo()
{
    local XGUnit kSoldier;

    kSoldier = Outer.m_kActiveUnit;
    class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kSoldier);
}

reliable server function ServerGivePerk(string strName)
{
    local int iPerkId, Index;
    local TInventory kInventory;
    local TLoadout Loadout;
    local XGTacticalGameCore kGameCore;
    local LWCE_XComPerkManager kPerksMgr;
    local LWCE_XGUnit kUnit;

    if (strName == "")
    {
        return;
    }

    kUnit = LWCE_XGUnit(Outer.GetActiveUnit());
    kPerksMgr = LWCE_XComPerkManager(PERKS());

    if (kUnit == none)
    {
        return;
    }

    kGameCore = `GAMECORE;
    iPerkId = class'LWCE_XComCheatManager_Extensions'.static.FindPerkByString(strName, kPerksMgr);

    if (iPerkId <= 0)
    {
        GetConsole().OutputTextLine("Could not find perk " $ strName);
        return;
    }

    if (kUnit.HasPerk(iPerkId))
    {
        return;
    }

    GetConsole().OutputTextLine("Giving perk " $ iPerkId);

    if (iPerkId == 113) // Ammo Conservation
    {
        kUnit.GetCharacter().m_kChar.aUpgrades[123] = kUnit.GetCharacter().m_kChar.aUpgrades[123] | 2;
        return;
    }

    kPerksMgr.GivePerk(kUnit, iPerkId);
    kUnit.UpdateUnitBuffs();
    kUnit.m_bBuildAbilityDataDirty = true;
    kUnit.BuildAbilities(true);
    XComPresentationLayer(Outer.m_Pres).GetTacticalHUD().m_kPerks.UpdatePerks();

    if (kUnit.GetCharacter().HasAnyGeneMod())
    {
        kUnit.GetPawn().XComUpdateAnimSetList();
    }

    // If giving a psi perk, make sure the unit has a psi amp or their animations/abilities won't work right
    if (kPerksMgr.LWCE_GetPerk(iPerkId).bIsPsionic)
    {
        kUnit.GetPawn().CHEAT_InitPawnPerkContent(kUnit.GetCharacter().m_kChar);
        kInventory = kUnit.GetCharacter().m_kChar.kInventory;

        if (kGameCore.TInventoryCustomItemsFind(kInventory, `LW_ITEM_ID(PsiAmp)) == INDEX_NONE)
        {
            kGameCore.TInventoryCustomItemsAddItem(kInventory, `LW_ITEM_ID(PsiAmp));
        }

        for (Index = 0; Index < kInventory.iNumCustomItems; Index++)
        {
            if (kInventory.arrCustomItems[Index] == `LW_ITEM_ID(PsiAmp))
            {
                Loadout.Items[14] = `LW_ITEM_ID(PsiAmp);
            }
        }

        class'LWCE_XGLoadoutMgr'.static.ApplyLoadout(kUnit, Loadout, false);
    }

    // TODO: this used to be able to remove perks; need a new console command for that
}

exec function ShowAlienStats()
{
    local LWCE_Console kConsole;
    local XGBattle_SP kBattle;

    kConsole = GetConsole();

    if (kConsole == none)
    {
        return;
    }

    kBattle = XGBattle_SP(`BATTLE);

    if (kBattle == none)
    {
        kConsole.OutputTextLine("This command is only valid in single-player battles.");
        return;
    }

    kConsole.OutputTextLine("Alien Research (Total): " $ kBattle.STAT_GetStat(1));
    kConsole.OutputTextLine("Alien Research (Bonus Only): " $ kBattle.STAT_GetStat(2));
    kConsole.OutputTextLine("Alien Resources: " $ kBattle.STAT_GetStat(19));
    kConsole.OutputTextLine("XCOM Threat Level: " $ kBattle.STAT_GetStat(21));
}

exec function ToggleDebugMenu()
{
    if (DebugMenu == none)
    {
        DebugMenu = Outer.Spawn(class'LWCE_UIDebugMenu');
    }

    if (DebugMenu.m_bEnabled == false)
    {
        if (Outer.m_Pres.GetHUD().m_bDebugHardHide)
        {
            UIToggleHardHide();
        }

        DebugMenu.Init(Outer, Outer.m_Pres.GetHUD());
        Outer.PlayerInput.PushState('DebugMenuEnabled');
    }
    else
    {
        DebugMenu.Lower();
        DebugMenu = none;
        Outer.PlayerInput.PopState();
    }
}

exec function ToggleDisplayOfMovementGrid()
{
    bDisplayMovementGrid = !bDisplayMovementGrid;
}

exec function ToggleTacticalHUD()
{
    local UITacticalHUD kTacHud;

    kTacHud = `LWCE_TACPRES.m_kTacticalHud;

    if (kTacHud == none)
    {
        `LWCE_LOG_CLS("ToggleTacticalHUD: no HUD found");
        return;
    }

    if (kTacHud.IsVisible())
    {
        kTacHud.Hide();
    }
    else
    {
        kTacHud.Show();
    }
}

function Do_AddUnitAtCursor(int iLoadout, optional Vector vOffset)
{
    local XComSpawnPoint kSpawnPt;
    local XGCharacter_Soldier kChar;
    local XGUnit kSoldier;
    local LoadoutTemplate Loadout;

    kSpawnPt = Outer.Spawn(class'XComSpawnPoint',,, (GetCursorLoc()) + vOffset, rot(0, 0, 0));
    kChar = XComTacticalGRI(Outer.WorldInfo.GRI).m_CharacterGen.CreateBaseSoldier();
    kChar.m_kChar = `GAMECORE.GetTCharacter(2);

    if (class'XGLoadoutMgr'.static.GetLoadoutTemplate(ELoadoutTypes(iLoadout), Loadout))
    {
        kChar.m_kChar.kInventory = Loadout.Inventory;
    }
    else
    {
        class'XGLoadoutMgr'.static.GetLoadoutTemplate(eLoadout_Rifleman, Loadout);
        kChar.m_kChar.kInventory = Loadout.Inventory;
    }

    kChar.m_eType = EPawnType(class'XGBattleDesc'.static.MapSoldierToPawn(kChar.m_kChar.kInventory.iArmor, kChar.m_kSoldier.kAppearance.iGender, false));

    if (kChar.m_kChar.kInventory.iArmor == 193 || kChar.m_kChar.kInventory.iArmor == 194 || kChar.m_kChar.kInventory.iArmor == 195)
    {
        kChar.m_kChar.eClass = eSC_Mec;
    }

    kSoldier = XGBattle_SP(`BATTLE).GetHumanPlayer().SpawnUnit(class'XGUnit', XGBattle_SP(`BATTLE).GetHumanPlayer().m_kPlayerController, kSpawnPt.Location, kSpawnPt.Rotation, kChar, XGBattle_SP(`BATTLE).GetHumanPlayer().m_kSquad,, kSpawnPt);
    XComHumanPawn(kSoldier.GetPawn()).SetAppearance(kChar.m_kSoldier.kAppearance);
    class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kSoldier);
    kSoldier.UpdateItemCharges();
}

function int FindPerkByName(string strName)
{
    local int Index;
    local string strPerkName;
    local LWCE_XComPerkManager kPerksMgr;

    kPerksMgr = LWCE_XComPerkManager(PERKS());

    for (Index = 0; Index < kPerksMgr.m_arrCEPerks.Length; Index++)
    {
        strPerkName = kPerksMgr.GetPerkName(kPerksMgr.m_arrCEPerks[Index].iPerkId);
        strPerkName = Repl(strPerkName, " ", "");
        strPerkName = Repl(strPerkName, ":", "");
        strPerkName = Repl(strPerkName, "-", "");

        if (strPerkName ~= strName)
        {
            return kPerksMgr.m_arrCEPerks[Index].iPerkId;
        }
    }

    return -1;
}