class UICacheMgr extends Object
    native(UI);
//complete stub

struct native UICacheItem
{
    var int I;
    var float F;
    var bool B;
    var string S;
    var bool T;
    var string Type;
    var string Id;
};

var array<UICacheItem> uicache;
var bool forceUpdates;

function bool Clear(){}
function bool Del(string VarName){}
protected function int GetIndex(string VarName){}
function bool IsValid(string VarName){}
function PrintCache(){};
function bAdd(string VarName, bool Value, optional bool bCheckForDups=true){}
function bool bFind(string VarName){}
function bool bUpdate(string VarName, bool NewValue){}
function fAdd(string VarName, float Value, optional bool bCheckForDups=true){}
function float fFind(string VarName){}
function bool fUpdate(string VarName, float NewValue){}
function iAdd(string VarName, int Value, optional bool bCheckForDups=true){}
function int iFind(string VarName){}
function bool iUpdate(string VarName, int NewValue){}
function sAdd(string VarName, string Value, optional bool bCheckForDups=true){}
function string sFind(string VarName){}
function bool sUpdate(string VarName, string NewValue){}
protected function AddTracker(string VarName){}
function bool GetTracker(string VarName){}
function ResetTracker(string VarName){}
function Track(string VarName, bool NewValue){}
function DEBUG_RunSelfTest(){}
