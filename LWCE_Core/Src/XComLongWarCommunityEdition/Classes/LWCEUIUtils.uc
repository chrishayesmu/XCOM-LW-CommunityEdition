// This class contains utilities related to manipulating Flash movies and UI elements. It is not
// a parallel to the base game's UIUtilities class, which is more related to string lookups and
// forming HTML strings.
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
/// Sets the object's additive color transform, where each color ranges from -255 to 255.
/// The final value for each channel is computed as (origValue * multiplier) + offset, clamped to
/// the range [0, 255].
/// </summary>
static function SetObjectColorAdd(GFxObject gfxObj, int Red, int Green, int Blue, optional int Alpha = -1)
{
    local ASColorTransform kTransform;

    kTransform = gfxObj.GetColorTransform();
    kTransform.Add.R = Red;
    kTransform.Add.G = Green;
    kTransform.Add.B = Blue;

    if (Alpha >= 0)
    {
        kTransform.Add.A = Alpha;
    }

    gfxObj.SetColorTransform(kTransform);
}

/// <summary>
/// Sets the object's multiplicative color transform. The multiplier for each channel can be any value.
/// The final value for each channel is computed as (origValue * multiplier) + offset, clamped to
/// the range [0, 255].
/// </summary>
static function SetObjectColorMultiply(GFxObject gfxObj, float Red, float Green, float Blue, optional float Alpha = -1.0)
{
    local ASColorTransform kTransform;

    kTransform = gfxObj.GetColorTransform();
    kTransform.Multiply.R = Red;
    kTransform.Multiply.G = Green;
    kTransform.Multiply.B = Blue;

    if (Alpha >= 0)
    {
        kTransform.Multiply.A = Alpha;
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