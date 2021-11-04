class XGItem extends Actor
	abstract
	native(Core)
	dependson(XGGameData);
//complete stub

struct CheckpointRecord
{
    var bool m_bDamaged;
};

var EItemType m_eType;
var string m_strUIImage;
var bool m_bDamaged;

static simulated function EItemType ItemType(){}
native static simulated function bool IsSharedAlienWeapon();
native static simulated function EItemType GameplayType();
static simulated function string ItemUIImage(){}
simulated function bool IsInitialReplicationComplete(){}
