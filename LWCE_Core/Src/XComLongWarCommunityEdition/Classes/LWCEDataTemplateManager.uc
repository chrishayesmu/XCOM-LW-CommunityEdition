/// <summary>
/// Base class for implementing a data templating system, similar to the one used in XCOM 2. Much of this code, as well
/// as function signatures and general design, are inspired by XCOM 2's system.
///
/// Each template manager class is responsible for a single class of template, stored in ManagedTemplateClass, and its
/// subclasses. There should not be multiple template managers attempting to handle the same part of the class hierarchy,
/// as each template is allowed to assume it will only be loaded once.
///
/// Template managers are initialized by the game engine, at which point they load in all relevant templates from config
/// files. Templates can also be added through code, if template manager implementations choose to allow this.
/// </summary>
class LWCEDataTemplateManager extends Object
    config(LWCEEngine)
    abstract;

struct TemplateCacheEntry
{
    var name TemplateName;
    var LWCEDataTemplate kTemplate;
};

// Names of classes which should be managed by this class. Since we don't have access to the dynamic class enumeration
// capabilities which XCOM 2 uses, we have to drive our template through configuration instead. Classes listed here will
// be loaded, and checked to ensure they are subclasses of ManagedTemplateClass.
var config array<string> arrManagedTemplateClasses;

// What type of templates are handled by this manager. Classes configured in arrManagedTemplateClasses must be subclasses of this
// (or must be ManagedTemplateClass itself). Any dynamically-created templates (from LWCEDataSet.CreateTemplates) which are subclasses
// of ManagedTemplateClass will also be added to this manager, even if their class is not present in arrManagedTemplateClasses.
var class<LWCEDataTemplate> ManagedTemplateClass;

// Cache of all templates which are loaded by this manager. DO NOT EXPOSE OUTSIDE THIS CLASS AND ITS SUBCLASSES.
// Any invalid modification of this cache will break a lot of things.
var protected array<TemplateCacheEntry> m_arrTemplates;

/// <summary>
/// Initializes all relevant templates and caches them. Should only be called by LWCE code.
/// </summary>
function InitTemplates()
{
    local int ClassIndex, SectionIndex;
    local string strTemplateName;
    local array<string> arrParts, arrSectionNames;
    local class<LWCEDataTemplate> kTemplateClass;
    local LWCEDataTemplate kTemplate;
    local TemplateCacheEntry kCacheEntry;

    if (arrManagedTemplateClasses.Length == 0)
    {
        `LWCE_LOG_CLS("ERROR: ManagedTemplateClasses is not populated! Impossible to initialize templates.");
        return;
    }

    // Iterate all of the template classes we're configured for, validate them, then load their data from config files
    for (ClassIndex = 0; ClassIndex < arrManagedTemplateClasses.Length; ClassIndex++)
    {
        kTemplateClass = class<LWCEDataTemplate>(DynamicLoadObject(arrManagedTemplateClasses[ClassIndex], class'Class'));

        if (kTemplateClass == none)
        {
            `LWCE_LOG_CLS("ERROR: failed to load requested class by name: " $ arrManagedTemplateClasses[ClassIndex]);
            continue;
        }

        if (!ClassIsChildOf(kTemplateClass, ManagedTemplateClass))
        {
            `LWCE_LOG_CLS("ERROR: configured template class " $ arrManagedTemplateClasses[ClassIndex] $ " is not a subclass of " $ ManagedTemplateClass $ " and will be ignored");
            continue;
        }

        GetPerObjectConfigSections(kTemplateClass, arrSectionNames, /* ObjectOuter */ , /* MaxResults */ 4096);

        for (SectionIndex = 0; SectionIndex < arrSectionNames.Length; SectionIndex++)
        {
            arrParts = SplitString(arrSectionNames[SectionIndex], " ", /* bCullEmpty */ true);

            if (arrParts.Length != 2)
            {
                `LWCE_LOG_CLS("WARNING: config section with header '" $ arrSectionNames[SectionIndex] $ "' is in an invalid format and will be ignored");
                continue;
            }

            strTemplateName = arrParts[0];

            // Create template without validation for now; validate them after all template managers are loaded
            kTemplate = InstantiateTemplate(kTemplateClass, strTemplateName);

            kCacheEntry.kTemplate = kTemplate;
            kCacheEntry.TemplateName = kTemplate.DataName;

            m_arrTemplates.AddItem(kCacheEntry);
        }
    }

    // TODO: add hook for code-based addition of templates

    `LWCE_LOG_CLS("Cached " $ m_arrTemplates.Length $ " template(s) across " $ arrManagedTemplateClasses.Length $ " type(s)");
}

/// <summary>
/// Adds a new template to the cache. Child classes should expose a type-appropriate
/// version of this function, which delegates to this. This function is public for use by other
/// classes in LWCE's data template framework, but mods should always prefer using the appropriately
/// typed subclass methods.
/// </summary>
function bool AddDataTemplate(LWCEDataTemplate kTemplate, bool ReplaceDuplicate = false)
{
    local int Index;
    local TemplateCacheEntry kCacheEntry;

    if (!ClassIsChildOf(kTemplate.Class, ManagedTemplateClass))
    {
        return false;
    }

    Index = m_arrTemplates.Find('TemplateName', kTemplate.Name);

    if (Index != INDEX_NONE && !ReplaceDuplicate)
    {
        return false;
    }

    if (Index != INDEX_NONE)
    {
        m_arrTemplates[Index].kTemplate = kTemplate;
        return true;
    }

    kCacheEntry.kTemplate = kTemplate;
    kCacheEntry.TemplateName = kTemplate.DataName;

    m_arrTemplates.AddItem(kCacheEntry);

    return true;
}

/// <summary>
/// Retrieves the names of all of the templates which are cached in this template manager.
/// </summary>
function array<name> GetTemplateNames()
{
    local array<name> arrNames;
    local int Index;

    arrNames.Length = m_arrTemplates.Length;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        arrNames[Index] = m_arrTemplates[Index].TemplateName;
    }

    return arrNames;
}

function bool HasTemplateByName(name TemplateName)
{
    return m_arrTemplates.Find('TemplateName', TemplateName) != INDEX_NONE;
}

/// <summary>
/// After templates have been loaded, this function will validate them individually and remove any which
/// are invalid. This should not be called until after all template managers are inited, so that cross-references
/// between templates can be validated as well.
/// </summary>
/// <returns>True if all templates were valid; false if any were invalid and had to be removed.</returns>
function bool ValidateAndFilterTemplates()
{
    local bool bAllValid;
    local int Index;
    local string strError;

    bAllValid = true;

    for (Index = 0; Index < m_arrTemplates.Length; Index++)
    {
        if (!m_arrTemplates[Index].kTemplate.ValidateTemplate(strError))
        {
            `LWCE_LOG_CLS("Template " $ m_arrTemplates[Index].TemplateName $ " failed validation: " $ strError);
            bAllValid = false;

            m_arrTemplates.Remove(Index, 1);
            Index--;
        }
    }

    return bAllValid;
}

/// <summary>
/// Retrieves a cached template by name. Child classes should expose a type-appropriate
/// version of this function, which delegates to this.
/// </summary>
protected function LWCEDataTemplate FindDataTemplate(name DataName)
{
    local int Index;

    if (DataName == '')
    {
        return none;
    }

    Index = m_arrTemplates.Find('TemplateName', DataName);

    if (Index == INDEX_NONE)
    {
        return none;
    }

    return m_arrTemplates[Index].kTemplate;
}

protected function LWCEDataTemplate InstantiateTemplate(class<LWCEDataTemplate> TemplateClass, string strTemplateName)
{
    local LWCEDataTemplate kTemplate;

    // The template object needs to have its name set, with no owner, to pull in the matching config automatically
    kTemplate = new (none, strTemplateName) TemplateClass;
    kTemplate.SetTemplateName(name(strTemplateName));

    return kTemplate;
}