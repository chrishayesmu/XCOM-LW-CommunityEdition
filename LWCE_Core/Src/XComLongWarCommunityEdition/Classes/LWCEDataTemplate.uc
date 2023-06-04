/// <summary>
/// Base class for all data templates. See LWCEDataTemplateManager for an overview of the templating system.
/// </summary>
class LWCEDataTemplate extends Object
    abstract
    PerObjectConfig;

var protectedwrite name DataName;

/// <summary>
/// A common delegate type for adjusting the cost of research, Foundry projects, facilities, etc. Not used
/// in LWCEDataTemplate itself, but common among its subclasses.
/// </summary>
delegate AdjustCostDelegate(LWCEDataTemplate kTemplate, out LWCE_TCost kCost);

/// <summary>
/// Sets the name of this template, which is how the game will refer to it. Should only be set
/// immediately after template creation, and then never changed. This name may be used when serializing
/// game saves, so changing the name of existing templates should be done sparingly, if at all.
/// </summary>
function SetTemplateName(name NewName)
{
	DataName = NewName;
}

/// <summary>
/// Checks that this template is valid. Exactly what that means will depend on the subclass, but invalid
/// templates will not be cached by template managers, nor used in gameplay.
/// </summary>
/// <param name="strError">A string to populate with the validation error, if any.</param>
/// <returns>True if the template is valid, false otherwise.</returns>
function bool ValidateTemplate(out string strError)
{
	return true;
}

protected function array<name> CopyNameArray(const array<name> InArray)
{
    local int Index;
    local array<name> OutArray;

    for (Index = 0; Index < InArray.Length; Index++)
    {
        OutArray.AddItem(InArray[Index]);
    }

    return OutArray;
}

/// <summary>
/// Creates a clone of the template in a safe way. Using this for cloning is strongly recommended; making a
/// clone in an incorrect way can cause ALL templates of the same name to become invalidated.
/// </summary>
protected function LWCEDataTemplate InstantiateClone()
{
    local LWCEDataTemplate kClone;

    // Deliberately do not set the clone's object name. Creating a PerObjectConfig object appears to trigger all
    // objects with the same name to load from their config, which can invalidate the templates which are cached.
    kClone = new (none) self.Class;
    kClone.DataName = self.DataName;

    return kClone;
}

/// <summary>
/// Goes through the prereqs object and checks that any templates it references actually exist. If not, validation
/// is failed and an error with the template name is added. This should only be called after all template managers
/// have been created by the game engine.
/// </summary>
/// <returns>True if prereqs contain only valid references, false otherwise.</returns>
protected function bool ValidatePrereqs(const out LWCE_TPrereqs kPrereqs, out string strError)
{
    local name ReqTemplateName;
    local array<string> arrErrors;
    local LWCEFoundryProjectTemplateManager kFoundryMgr;
    local LWCETechTemplateManager kTechMgr;

    strError = "";

    if (kPrereqs.arrFoundryReqs.Length > 0)
    {
        kFoundryMgr = `LWCE_FOUNDRY_TEMPLATE_MGR;

        foreach kPrereqs.arrFoundryReqs(ReqTemplateName)
        {
            if (!kFoundryMgr.HasTemplateByName(ReqTemplateName))
            {
                arrErrors.AddItem("Foundry: " $ ReqTemplateName);
            }
        }
    }

    if (kPrereqs.arrTechReqs.Length > 0)
    {
        kTechMgr = `LWCE_TECH_TEMPLATE_MGR;

        foreach kPrereqs.arrTechReqs(ReqTemplateName)
        {
            if (!kTechMgr.HasTemplateByName(ReqTemplateName))
            {
                arrErrors.AddItem("Tech: " $ ReqTemplateName);
            }
        }
    }

    if (arrErrors.Length > 0)
    {
        JoinArray(arrErrors, strError, ", ");
        strError = "Invalid prereq IDs: " $ strError;

        return false;
    }

    return true;
}