class LWCE_XComTacticalCheatManager extends XComTacticalCheatManager;

var bool bDisplayMovementGrid;

`include(generators.uci)

`LWCE_GENERATOR_XCOMCHEATMANAGER

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

exec function ReloadAmmo()
{
    local XGUnit kSoldier;

    kSoldier = Outer.m_kActiveUnit;
    class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kSoldier);
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