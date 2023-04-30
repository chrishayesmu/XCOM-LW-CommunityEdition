/// <summary>
/// A generic data container class, similar to (and based on) the XComLWTuple class from XCOM 2's Community Highlander.
///
/// The purpose of this class is to encapsulate
/// </summary>
class LWCEDataContainer extends Object;

/// <summary>
/// Describes what type of data is being used. Each type has a corresponding field in the LWCEDataValue struct.
/// </summary>
enum LWCEDataType
{
    eDT_Bool,
    eDT_Int,
    eDT_Float,
    eDT_String,
    eDT_Name,
    eDT_Object,
    eDT_Vector,
    eDT_Rotator,
    eDT_Tile,
    eDT_ArrayObjects,
    eDT_ArrayInts,
    eDT_ArrayFloats,
    eDT_ArrayStrings,
    eDT_ArrayNames,
    eDT_ArrayVectors,
    eDT_ArrayRotators,
    eDT_ArrayTiles
};

/// <summary>
/// Represents a single value, which could be any of the types in LWCEDataType. Consumers can check the Type field to know
/// which data field to access, though generally this won't be necessary; most users will know what to expect based on the
/// reason they're receiving the data in the first place. (For example, if receiving data via an event handler, the event's trigger
/// should always pass the same data types in the same order, so you can just follow that contract.)
/// </summary>
struct LWCEDataValue
{
    var bool B;
    var int I;
    var float F;
    var String S;
    var name Nm;
    var Object Obj;
    var Vector Vec;
    var Rotator Rot;
    var TTile Tile;
    var array<Object> arrObjs;
    var array<int> arrInts;
    var array<float> arrFloats;
    var array<string> arrStrings;
    var array<name> arrNames;
    var array<Vector> arrVecs;
    var array<Rotator> arrRots;
    var array<TTile> arrTiles;

    var LWCEDataType Type;
};

// An arbitrary identifier for this data container. It is recommended to set this in order to help consumers with debugging,
// and allow the consumer to group related logic and branch on the data container's Id.
var name Id;

// The data within the container.
var array<LWCEDataValue> Data;

// #region Static helpers
//
// These functions define an easy way to create data containers for common scenarios. Using them isn't required, but can make
// your code more concise.

static function LWCEDataContainer New(name NewId)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;

    return Container;
}

static function LWCEDataContainer NewBool(name NewId, bool Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddBool(Value);

    return Container;
}

static function LWCEDataContainer NewFloat(name NewId, float Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddFloat(Value);

    return Container;
}

static function LWCEDataContainer NewInt(name NewId, int Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddInt(Value);

    return Container;
}

static function LWCEDataContainer NewName(name NewId, name Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddName(Value);

    return Container;
}

static function LWCEDataContainer NewObject(name NewId, Object Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddObject(Value);

    return Container;
}

static function LWCEDataContainer NewRotator(name NewId, Rotator Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddRotator(Value);

    return Container;
}

static function LWCEDataContainer NewString(name NewId, string Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddString(Value);

    return Container;
}

static function LWCEDataContainer NewTile(name NewId, TTile Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddTile(Value);

    return Container;
}

static function LWCEDataContainer NewVector(name NewId, vector Value)
{
    local LWCEDataContainer Container;

    Container = new class'LWCEDataContainer';
    Container.Id = NewId;
    Container.AddVector(Value);

    return Container;
}

// #endregion

// #region Instance helpers
//
// These functions provide a simple way to add more data to the container. Like the static helpers, using them is not mandatory.

function AddBool(bool Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_Bool;
    DataValue.B = Value;

    Data.AddItem(DataValue);
}

function AddFloat(float Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_Float;
    DataValue.F = Value;

    Data.AddItem(DataValue);
}

function AddInt(int Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_Int;
    DataValue.I = Value;

    Data.AddItem(DataValue);
}

function AddName(name Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_Name;
    DataValue.Nm = Value;

    Data.AddItem(DataValue);
}

function AddObject(Object Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_Object;
    DataValue.Obj = Value;

    Data.AddItem(DataValue);
}

function AddRotator(Rotator Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_Rotator;
    DataValue.Rot = Value;

    Data.AddItem(DataValue);
}

function AddString(string Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_String;
    DataValue.S = Value;

    Data.AddItem(DataValue);
}

function AddTile(TTile Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_Tile;
    DataValue.Tile = Value;

    Data.AddItem(DataValue);
}

function AddVector(Vector Value)
{
    local LWCEDataValue DataValue;

    DataValue.Type = eDT_Vector;
    DataValue.Vec = Value;

    Data.AddItem(DataValue);
}

// #endregion