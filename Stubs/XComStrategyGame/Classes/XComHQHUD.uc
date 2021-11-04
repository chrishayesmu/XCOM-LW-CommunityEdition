class XComHQHUD extends XComHUD
	config(Game);
//complete stub

const Y_OFFSET = 20;

struct ChooseFacilityMIC
{
    var EFacilityType Facility;
    var string FacilityMICName;
    var MaterialInstanceConstant FacilityMIC;
};

var array<ChooseFacilityMIC> ChooseFacilityMICs;
var MaterialInstanceConstant FacilityMIC;
var float FacilityTextureScale;
var float FacilityTextureNormSizeX;
var float FacilityTextureNormSizeY;
var Material FacilityBackgroundMaterial;
var float FacilityBackgroundTextureNormSizeX;
var float FacilityBackgroundTextureNormSizeY;

event PostBeginPlay(){}
function DrawHUD(){}
function ShowFacilityTexture(EFacilityType Facility){}
function HideFacilityTexture(){}
