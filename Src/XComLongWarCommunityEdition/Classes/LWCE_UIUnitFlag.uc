class LWCE_UIUnitFlag extends UIUnitFlag;

var protected GFxObject m_gfxVisibilityPreviewIcon;

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
        m_gfxVisibilityPreviewIcon = gfxUnitFlag.CreateEmptyMovieClip("gfxVisIcon");

        arrParams.Add(1);
        arrParams[0].Type = AS_String;
        arrParams[0].s = "img:///gfxMessageMgr.Attack_red";
        m_gfxVisibilityPreviewIcon.Invoke("loadMovie", arrParams);

        m_gfxVisibilityPreviewIcon.SetPosition(-2.0, -45.5);

        class'LWCEUIUtils'.static.SetObjectColorMultiply(m_gfxVisibilityPreviewIcon, 230, 0, 0);
    }

    m_gfxVisibilityPreviewIcon.SetVisible(bVisible);
}

protected function string GetASPath()
{
    return "_level0.theInterfaceMgr.gfxUnitFlag.theUnitFlagManager.flag-" $ string(m_kUnit.Name);
}