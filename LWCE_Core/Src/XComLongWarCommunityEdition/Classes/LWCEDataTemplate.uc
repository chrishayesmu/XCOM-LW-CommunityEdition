/// <summary>
/// Base class for all data templates. See LWCEDataTemplateManager for an overview of the templating system.
/// </summary>
class LWCEDataTemplate extends Object
    abstract
    PerObjectConfig;

var protectedwrite name DataName;

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

/// <summary>
/// Called right before a template is destroyed and removed from its template manager. Generally the only reason
/// this would happen is if it's being replaced by another template with the same name. Subclasses may override
/// this function if they need to perform some cleanup.
/// </summary>
function BeforeDestroy()
{
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