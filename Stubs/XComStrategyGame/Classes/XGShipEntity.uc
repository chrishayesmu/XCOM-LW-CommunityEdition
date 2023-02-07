class XGShipEntity extends XGEntity
    notplaceable
    hidecategories(Navigation);

enum EShipAnimation
{
    eShipAnim_Flying,
    eShipAnim_Landing,
    eShipAnim_Hunting,
    eShipAnim_MAX
};

function Vector2D GetCoords(){}
function Vector GetHeading(){}
function XGShip GetShip(){}
function EShipType GetShipModel(){}
function EShipAnimation GetAnim(){}