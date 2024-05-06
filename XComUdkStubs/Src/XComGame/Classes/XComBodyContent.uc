class XComBodyContent extends Actor
    dependson(XGTacticalGameCoreNativeBase, XComContentManager)
    notplaceable
    hidecategories(Navigation, Movement, Display, Attachment, Actor, Collision, Physics, Debug, Object, Advanced);

var() SkeletalMesh SkeletalMesh;
var deprecated EGender Gender <Tooltip = "Do not use. Included for compatibility purposes only.">;
var() EColorPalette ShirtPalette;
var() EColorPalette PantsPalette;
var() array<MaterialInterface> Materials;
var deprecated Texture2D ColorPalette <Tooltip = "Do not use. Included for compatibility purposes only.">;

defaultproperties
{
    ShirtPalette=ePalette_ShirtColor
    PantsPalette=ePalette_PantsColor
}