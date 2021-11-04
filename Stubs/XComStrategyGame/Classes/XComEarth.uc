class XComEarth extends Actor
	dependsOn(XComHQCountryBorderToggles);
//complete stub

var() export editinline StaticMeshComponent EarthMesh;
var() float Radius;
var() const editconst export editinline LightEnvironmentComponent LightEnvironment;
var XComHQCountryBorderToggles CBT;
var() XComUniverseCenter m_kUniverseCenter;
var array<XComEarthRadar> m_aRadars;
var array<int> m_CountryToIndex;

function UpdateUniverseRotation(XGDateTime kDateTime){}
function PlaceActorOnEarth(Actor inActor, Vector2D inCoords, optional int inYaw, optional int inPitch, optional float fElevation){}
function SetParticleGameSpeed(float TimeScale){}
simulated event Init(){}
function Vector2D ConvertEarthCoords(Vector2D vEarthSpace){}
function Vector2D UnconvertEarthCoords(Vector2D vEarthSpace){}
function Vector FromEarthCoords(Vector2D vEarthSpace, optional float AdditionalRadius){}
function Rotator FromEarthCoordsRot(Vector2D vEarthSpace, optional float AdditionalRadius){}
function Vector2D ToEarthCoords(Vector vWorldSpace){}
function bool IsWater(Vector2D v2EarthCoords){}
function SetCountrySatellite(ECountry eCntry, ESatelliteCoverage SatCoverage){}
function HighlightCountry(ECountry eCntry, Color clrHighlight, optional float fTime){}
function PulseCountry(ECountry eCntry, Color clr1, Color clr2, float fTime){}
function ClearCountryHighlight(ECountry eCntry){}
function GetSurfaceOrientation(Vector2D EarthCoords, Rotator LocalRotation, optional float AdditionalRadius, optional out Vector out_Location, optional out Rotator out_Rotation){}
function bool InWater(Vector PositionOnEarthsSurface){}
