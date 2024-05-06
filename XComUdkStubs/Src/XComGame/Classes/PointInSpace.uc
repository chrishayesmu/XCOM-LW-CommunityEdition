class PointInSpace extends Actor
    placeable
    hidecategories(Navigation);

var() export editinline SpriteComponent VisualizeSprite;
var() export editinline ArrowComponent VisualizeArrow;
var transient Vector Forward;
var transient Vector Right;
var transient Vector Up;

defaultproperties
{
    begin object name=Sprite class=SpriteComponent
        HiddenGame=true
    end object

    VisualizeSprite=Sprite
    Components.Add(Sprite)

    bStatic=false
    bNoDelete=false
}