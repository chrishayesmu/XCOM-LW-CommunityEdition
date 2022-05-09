class LWCE_UIUnitFlag extends UIUnitFlag;

var protected GFxObject m_gfxVisibilityPreviewIcon;

simulated function OnInit()
{
    super.OnInit();

    WorldInfo.MyWatchVariableMgr.RegisterWatchVariable(m_kUnit, 'm_arrCEBonuses', self, RealizeBuffs);
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

simulated function ToggleVisibilityPreviewIcon(bool bVisible)
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
            // Wipe out the original colors and replace with XCOM's
            class'LWCEUIUtils'.static.SetObjectColorMultiply(m_gfxVisibilityPreviewIcon, 0, 0, 0);
            class'LWCEUIUtils'.static.SetObjectColorAdd(m_gfxVisibilityPreviewIcon, 103, 232, 237);

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
            class'LWCEUIUtils'.static.SetObjectColorMultiply(m_gfxVisibilityPreviewIcon, 230.0 / 255.0, 0, 0); // lighten the red channel a little
            break;
    }

    m_gfxVisibilityPreviewIcon.SetVisible(bVisible);
}

protected function string GetASPath()
{
    return "_level0.theInterfaceMgr.gfxUnitFlag.theUnitFlagManager.flag-" $ string(m_kUnit.Name);
}