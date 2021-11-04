class XComHeadContent extends Actor
    native(Unit)
    notplaceable
    hidecategories(Navigation,Movement,Display,Attachment,Actor,Collision,Physics,Debug,Object,Advanced)
	dependson(XComContentManager);
//complete stub

var() SkeletalMesh SkeletalMesh;
var() EColorPalette SkinPalette;
var() EColorPalette EyePalette;