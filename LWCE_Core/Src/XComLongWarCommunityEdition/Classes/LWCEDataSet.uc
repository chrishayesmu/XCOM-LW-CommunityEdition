/// <summary>
/// DataSets, based on the X2DataSet class from XCOM 2, are a code-based method of creating and modifying
/// data templates. They can be used in combination with configuration-driven templates, or the two systems
/// can be used completely independently.
///
/// Unlike in XCOM 2, the OnPostTemplatesCreated hook is contained in LWCEDataSet rather than the mod base class.
///
/// Also unlike XCOM 2, new DataSets cannot be picked up automatically at runtime. You must append any subclasses
/// of LWCEDataSet to the config array LWCE_XComEngine.arrDataSets. See DefaultLWCEEngine.ini for examples.
///
/// Note that DataSet classes are not instantiated by the game engine; only their static functions are used.
/// </summary>
class LWCEDataSet extends Object
    abstract;

/// <summary>
/// Implement this function in subclasses in order to create templates from code. You can freely mix and
/// match template types; they will automatically be sent to their respective template managers.
/// </summary>
static function array<LWCEDataTemplate> CreateTemplates()
{
    local array<LWCEDataTemplate> arrTemplates;

    arrTemplates.Length = 0;

    return arrTemplates;
}

/// <summary>
/// Implement this function in subclasses to be called after all templates have been created. This can be
/// used to modify templates post-creation. This function should be considered the one and only opportunity
/// to modify templates after they are created - doing so at any other time may break the game!
///
/// Templates have not yet been validated when this function is called.
/// </summary>
static function OnPostTemplatesCreated() {}