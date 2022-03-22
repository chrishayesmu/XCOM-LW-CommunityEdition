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

static function GfxObject DuplicateMovieClip(string strClipToDuplicatePath, string strNewClipName, optional UIFxsMovie manager = GetHUD())
{
	local ASValue myValue;
	local array<ASValue> myArray;
	local string strParent;
	local int iCount;

	iCount = InStr(strClipToDuplicatePath, ".", /* bSearchFromRight */ true);
	strParent = Left(strClipToDuplicatePath, iCount);

	myValue.Type = AS_String;
	myValue.s = strNewClipName;
	myArray.AddItem(myValue);

	myValue.Type = AS_Number;
	myValue.n = float(manager.ActionScriptInt(strParent $ ".getNextHighestDepth"));
	myArray.AddItem(myValue);

	manager.GetVariableObject(strClipToDuplicatePath).Invoke("duplicateMovieClip", myArray);

	return manager.GetVariableObject(strParent $ "." $ strNewClipName);
}

/// <summary>
/// Sets the object's color transform multiplication, where each color ranges from 0 to 255.
/// </summary>
static function SetObjectColorMultiply(GFxObject gfxObj, int Red, int Green, int Blue, optional int Alpha = -1)
{
    local ASColorTransform kTransform;

    kTransform.Multiply.R = Red / 255.0;
    kTransform.Multiply.G = Green / 255.0;
    kTransform.Multiply.B = Blue / 255.0;

    if (Alpha >= 0)
    {
        kTransform.Multiply.A = Alpha / 255.0;
    }

    gfxObj.SetColorTransform(kTransform);
}

/// <summary>
/// Sets the object's scale, where 1.0 is the default value for each axis.
/// </summary>
static function SetObjectScale(GFxObject gfxObj, float X, float Y, float Z)
{
    local ASDisplayInfo kDisplayInfo;

    kDisplayInfo = gfxObj.GetDisplayInfo();

    kDisplayInfo.XScale = X * 100.0;
    kDisplayInfo.YScale = Y * 100.0;
    kDisplayInfo.ZScale = Z * 100.0;

    gfxObj.SetDisplayInfo(kDisplayInfo);
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