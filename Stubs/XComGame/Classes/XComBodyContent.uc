class XComBodyContent extends Actor
    native(Unit)
    notplaceable
    hidecategories(Navigation,Movement,Display,Attachment,Actor,Collision,Physics,Debug,Object,Advanced)
	dependson(XComContentManager);
//complete stub

var() SkeletalMesh SkeletalMesh;
var deprecated EGender Gender;
var() EColorPalette ShirtPalette;
var() EColorPalette PantsPalette;
var() array<MaterialInterface> Materials;
var deprecated Texture2D ColorPalette;