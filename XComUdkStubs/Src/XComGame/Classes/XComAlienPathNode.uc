class XComAlienPathNode extends Actor
    native(AI)
    placeable
    hidecategories(Navigation);

enum EPathNodeType
{
    PATH_NODE_TYPE_DEFAULT,
    PATH_NODE_TYPE_DOOR_OPEN_LOCATION,
    PATH_NODE_TYPE_MAX
};

var() bool ValidStartLocation;
var bool m_bTerminal;
var() XComAlienPathNode.EPathNodeType Type;
var() XComInteractiveLevelActor InteractActor;
var() int WaitTurns;
var editoronly export editinline ArrowComponent m_kArrow;
var editoronly export editinline SpriteComponent m_kSprite;
var editoronly export editinline SpriteComponent m_kSpriteStart;

defaultproperties
{
    bStatic=true
    bNoDelete=true
    bCollideWhenPlacing=true

    begin object name=CollisionCylinder class=CylinderComponent
        CollisionHeight=50.0
        CollisionRadius=50.0
    end object

    Components.Add(CollisionCylinder)
    CollisionComponent=CollisionCylinder
}