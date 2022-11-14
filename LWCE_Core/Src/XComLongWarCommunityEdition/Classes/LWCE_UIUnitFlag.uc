class LWCE_UIUnitFlag extends UIUnitFlag;

var protected GFxObject m_gfxVisibilityPreviewIcon;

simulated function OnInit()
{
    super(UI_FxsPanel).OnInit();

    m_kCharacter = m_kUnit.GetCharacter();
    SetAim(m_kUnit.GetOffense());
    SetWeapon();
    RealizeHitPoints();

    if (m_kCharacter.m_kChar.iType == eChar_Soldier)
    {
        SetNames(m_kCharacter.GetLastName(), m_kCharacter.GetNickname());
        SetRank(XGCharacter_Soldier(m_kCharacter).m_kSoldier.iRank);
    }
    else if (m_kCharacter.m_kChar.iType == eChar_Civilian)
    {
        SetNames(m_kCharacter.GetLastName(), m_kCharacter.GetNickname());
    }
    else
    {
        SetNames(m_kUnit.SafeGetCharacterName(), "");
        SetRank(-1);
    }

    RealizeMoves();
    RealizeCover();
    RealizeEKG();
    RealizeCriticallyWounded();
    RealizeStunned();

    if (controllerRef != none && m_kUnit == XComTacticalController(controllerRef).GetActiveUnit())
    {
        SetSelected(true);
    }
    else
    {
        RealizeAlphaSelection();
    }

    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_aCurrentStats',           self, RealizeAim, eStat_Offense);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_arrBonuses',              self, RealizeBuffs);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_iBaseCoverValue',         self, RealizeCover);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_arrFlankingUnits',        self, RealizeCover);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_bIsFlying',               self, RealizeCover);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_bInAscent',               self, RealizeCover);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_aAbilitiesAffecting',     self, RealizeCover);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_bFlankDataWatchVariable', self, RealizeCover);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_iCriticalWoundCounter',   self, RealizeCriticallyWounded);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_bStabilized',             self, RealizeCriticallyWounded);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_arrPenalties',            self, RealizeDebuffs);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_iPanicCounter',           self, RealizeEKG);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_aCurrentStats',           self, RealizeHitPoints, eStat_HP);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_aInventoryStats',         self, RealizeHitPoints, eStat_HP);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_aCurrentStats',           self, RealizeHitPoints, eStat_ShieldHP);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_aCurrentStats',           self, RealizeModifiers, eStat_Offense);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_aCurrentStats',           self, RealizeModifiers, eStat_Defense);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_iFireActionsPerformed',   self, RealizeMoves);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_iMoves',                  self, RealizeMoves);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_iMovesActionsPerformed',  self, RealizeMoves);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_iUseAbilities',           self, RealizeMoves);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_bStunned',                self, RealizeStunned);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_aCurrentStats',           self, SetWeapon, eStat_Reaction);

    // Changes in LWCE
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_arrCEBonuses',   self, RealizeBuffs);
    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_arrCEPenalties', self, RealizeDebuffs);
}

simulated function Update(XGUnit kNewActiveUnit)
{
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(m_kUnit))
    {
        return;
    }

    super.Update(kNewActiveUnit);
}

simulated function ToggleVisibilityPreviewIcon(bool bVisible, bool bFlanking)
{
    local array<ASValue> arrParams;
    local GFxObject gfxUnitFlag;

    if (!IsVisible())
    {
        return;
    }

    // Icon is created as-needed because not all of the resources are loaded when the flag inits
    if (m_gfxVisibilityPreviewIcon == none)
    {
        // Set up a new movie clip with our desired image in it
        gfxUnitFlag = `PRES.GetHUD().GetVariableObject(GetASPath());

        if (gfxUnitFlag == none)
        {
            return;
        }

        m_gfxVisibilityPreviewIcon = gfxUnitFlag.CreateEmptyMovieClip("gfxVisIcon");

        arrParams.Add(1);
        arrParams[0].Type = AS_String;
        arrParams[0].s = "img:///gfxMessageMgr.Attack_red";
        m_gfxVisibilityPreviewIcon.Invoke("loadMovie", arrParams);

        m_gfxVisibilityPreviewIcon.SetPosition(-2.0, -45.5);
    }

    switch (m_kUnit.GetTeam())
    {
        case eTeam_XCom:
            if (bFlanking)
            {
                class'LWCEUIUtils'.static.SetObjectColorMultiply(m_gfxVisibilityPreviewIcon, 0, 0, 0);
                class'LWCEUIUtils'.static.SetObjectColorAddFromStruct(m_gfxVisibilityPreviewIcon, class'LWCEUIUtils'.default.FlankColor);
            }
            else
            {
                class'LWCEUIUtils'.static.SetObjectColorMultiply(m_gfxVisibilityPreviewIcon, 0, 0, 0);
                class'LWCEUIUtils'.static.SetObjectColorAddFromStruct(m_gfxVisibilityPreviewIcon, class'LWCEUIUtils'.default.XComLightColor);
            }

            // Unit flags for inactive XCOM soldiers are set to 30% alpha; we need to counter that by
            // setting our own icon to absurdly high alpha that cancels out
            m_gfxVisibilityPreviewIcon.SetFloat("_alpha", 333);
            break;
        case eTeam_Neutral:
            // TODO needs testing to make sure this is visible enough
            // Set neutral colors to grayscale
            class'LWCEUIUtils'.static.SetObjectColorMultiply(m_gfxVisibilityPreviewIcon, 0, 0, 0);
            class'LWCEUIUtils'.static.SetObjectColorAdd(m_gfxVisibilityPreviewIcon, 180, 180, 180); // grayscale reduction
            break;
        case eTeam_Alien:
            if (bFlanking)
            {
                class'LWCEUIUtils'.static.SetObjectColorMultiply(m_gfxVisibilityPreviewIcon, 0, 0, 0);
                class'LWCEUIUtils'.static.SetObjectColorAddFromStruct(m_gfxVisibilityPreviewIcon, class'LWCEUIUtils'.default.FlankColor);
            }
            else
            {
                class'LWCEUIUtils'.static.SetObjectColorMultiply(m_gfxVisibilityPreviewIcon, 230.0 / 255.0, 0, 0); // lighten the red channel a little
                class'LWCEUIUtils'.static.SetObjectColorAdd(m_gfxVisibilityPreviewIcon, 0, 0, 0);
            }

            break;
    }

    m_gfxVisibilityPreviewIcon.SetVisible(bVisible);
}

protected function string GetASPath()
{
    return "_level0.theInterfaceMgr.gfxUnitFlag.theUnitFlagManager.flag-" $ string(m_kUnit.Name);
}