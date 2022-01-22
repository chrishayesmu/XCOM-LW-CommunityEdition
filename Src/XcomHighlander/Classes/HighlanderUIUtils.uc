class HighlanderUIUtils extends Object;

static function bool TryGetPanelReference(UI_FxsPanel kPanel, out GFxObject gfxRef)
{
    gfxRef = kPanel.manager.GetVariableObject(string(kPanel.GetMCPath()));

    return gfxRef != none;
}

static function HighlanderUIButton CreateButton(GFxObject gfxParent, string strButtonName)
{
    return HighlanderUIButton(BindMovie(gfxParent, "XComButton", strButtonName, class'HighlanderUIButton'));
}

static function HighlanderUICheckbox CreateCheckbox(GFxObject gfxParent, string strCheckboxName)
{
    local HighlanderUICheckbox kCheckbox;

    kCheckbox = HighlanderUICheckbox(BindMovie(gfxParent, "XComCheckbox", strCheckboxName, class'HighlanderUICheckbox'));
    AS_AddMouseListener(kCheckbox);
    AS_BindMouse(kCheckbox);

    return kCheckbox;
}

static function HighlanderUICombobox CreateCombobox(GFxObject gfxParent, string strComboboxName)
{
    local HighlanderUICombobox kCombobox;

    kCombobox = HighlanderUICombobox(BindMovie(gfxParent, "XComCombobox", strComboboxName, class'HighlanderUICombobox'));
    AS_AddMouseListener(kCombobox);
    AS_BindMouse(kCombobox);

    return kCombobox;
}

static function HighlanderUISlider CreateSlider(GFxObject gfxParent, string strSliderName)
{
    return HighlanderUISlider(BindMovie(gfxParent, "XComSlider", strSliderName, class'HighlanderUISlider'));
}

static function GfxObject BindMovie(GFxObject kOwner, coerce string strFlashClass, coerce string strClipName, optional class<GfxObject> kClass = none, optional UIFxsMovie kManager = none)
{
    local GFxObject gfxResult;
	local array<ASValue> myArray;

	myArray.Length = 0; // silence compiler warning

	gfxResult = AS_BindMovie(kOwner, strFlashClass, strClipName, kManager);
	gfxResult.Invoke("onLoad", myArray);

	if (kClass != none)
	{
		gfxResult = kOwner.GetObject(strClipName, kClass);
	}

	return gfxResult;
}

protected static function AS_AddMouseListener(GfxObject kListener)
{
	`PRES.GetHUD().ActionScriptVoid(`PRES.GetHUD().GetMCPath() $ "._global.Mouse.addListener");
}

protected static function AS_BindMouse(GfxObject kBindToObject)
{
	`PRES.GetHUD().ActionScriptVoid(`PRES.GetHUD().GetMCPath() $ "._global.Bind.mouse");
}

protected static function GfxObject AS_BindMovie(GFxObject kOwner, coerce string strTemplateFlashClass, coerce string strNewClipID, optional UIFxsMovie kManager = none)
{
    if (kManager == none)
    {
        kManager = `PRES.GetHUD();
    }

	return kManager.ActionScriptObject(kManager.GetMCPath() $ "._global.Bind.movie");
}