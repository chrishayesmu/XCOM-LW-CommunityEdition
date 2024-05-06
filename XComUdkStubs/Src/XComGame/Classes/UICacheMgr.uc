class UICacheMgr extends Object
    native(UI);

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

var private array<UICacheItem> uicache;
var bool forceUpdates;