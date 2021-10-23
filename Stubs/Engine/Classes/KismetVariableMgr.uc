class KismetVariableMgr extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var native transient Map_Mirror VariableMap;
var native transient Map_Mirror ClassMap;

// Export UKismetVariableMgr::execRebuildVariableMap(FFrame&, void* const)
native function RebuildVariableMap();

// Export UKismetVariableMgr::execGetVariable(FFrame&, void* const)
native function SequenceVariable GetVariable(name VariableName);

// Export UKismetVariableMgr::execRebuildClassMap(FFrame&, void* const)
native function RebuildClassMap();

// Export UKismetVariableMgr::execGetObjectByClass(FFrame&, void* const)
native function array<SequenceObject> GetObjectByClass(Class SequenceClass);
