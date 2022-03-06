class LWCEUIUtils extends Object;

static function bool TryGetPanelReference(UI_FxsPanel kPanel, out GFxObject gfxRef)
{
    gfxRef = kPanel.manager.GetVariableObject(string(kPanel.GetMCPath()));

    return gfxRef != none;
}

static function LWCEUIButton CreateButton(GFxObject gfxParent, string strButtonName)
{
    return LWCEUIButton(BindMovie(gfxParent, "XComButton", strButtonName, class'LWCEUIButton'));
}

static function LWCEUICheckbox CreateCheckbox(GFxObject gfxParent, string strCheckboxName)
{
    local LWCEUICheckbox kCheckbox;

    kCheckbox = LWCEUICheckbox(BindMovie(gfxParent, "XComCheckbox", strCheckboxName, class'LWCEUICheckbox'));
    AS_AddMouseListener(kCheckbox);
    AS_BindMouse(kCheckbox);

    return kCheckbox;
}

static function LWCEUICombobox CreateCombobox(GFxObject gfxParent, string strComboboxName)
{
    local LWCEUICombobox kCombobox;

    kCombobox = LWCEUICombobox(BindMovie(gfxParent, "XComCombobox", strComboboxName, class'LWCEUICombobox'));
    //AS_AddMouseListener(kCombobox);
    //AS_BindMouse(kCombobox);

    return kCombobox;
}

static function LWCEUISlider CreateSlider(GFxObject gfxParent, string strSliderName)
{
    return LWCEUISlider(BindMovie(gfxParent, "XComSlider", strSliderName, class'LWCEUISlider'));
}

static function GfxObject BindMovie(GFxObject kOwner, coerce string strFlashClass, coerce string strClipName, optional class<GfxObject> kClass = none, optional UIFxsMovie kManager = GetHUD())
{
    local GFxObject gfxResult;
	local array<ASValue> myArray;

	gfxResult = AS_BindMovie(kOwner, strFlashClass, strClipName, kManager);

	myArray.Add(1); // silence compiler warning
	gfxResult.Invoke("onLoad", myArray);

	if (kClass != none)
	{
		gfxResult = kOwner.GetObject(strClipName, kClass);
	}

	return gfxResult;
}

protected static function AS_AddMouseListener(GfxObject kListener)
{
	GetHUD().ActionScriptVoid(GetHUD().GetMCPath() $ "._global.Mouse.addListener");
}

protected static function AS_BindMouse(GfxObject kBindToObject)
{
	GetHUD().ActionScriptVoid(GetHUD().GetMCPath() $ "._global.Bind.mouse");
}

protected static function GfxObject AS_BindMovie(GFxObject kOwner, coerce string strTemplateFlashClass, coerce string strNewClipID, optional UIFxsMovie kManager = GetHUD())
{
	return kManager.ActionScriptObject(kManager.GetMCPath() $ "._global.Bind.movie");
}

protected static function UIInterfaceMgr GetHUD()
{
    return XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController()).m_Pres.GetHUD();
}