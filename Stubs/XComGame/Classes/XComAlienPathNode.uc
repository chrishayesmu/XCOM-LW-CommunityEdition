class XComAlienPathNode extends Actor
    native(AI)
    placeable
    hidecategories(Navigation);
//complete stub

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