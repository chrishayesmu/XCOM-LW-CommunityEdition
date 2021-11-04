class XComEarthRadar extends Actor;

//complete stub

var() export editinline StaticMeshComponent RadarMesh;
var() LinearColor DefaultRadarColor;

simulated event PreBeginPlay(){}
static function XComEarthRadar PlaceRadar(XComEarth EARTH, Vector2D EarthCoords, optional float RadarScale, optional float RadarSpeed, optional LinearColor RadarColor){}
static function UpdateRadar(XComEarthRadar Radar, optional float RadarScale, optional float RadarSpeed, optional LinearColor RadarColor){}
