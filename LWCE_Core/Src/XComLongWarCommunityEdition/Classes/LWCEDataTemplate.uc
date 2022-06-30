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
/// <param ref="strError">A string to populate with the validation error, if any.</param>
/// <returns>True if the template is valid, false otherwise.</returns>
function bool ValidateTemplate(out string strError)
{
	return true;
}