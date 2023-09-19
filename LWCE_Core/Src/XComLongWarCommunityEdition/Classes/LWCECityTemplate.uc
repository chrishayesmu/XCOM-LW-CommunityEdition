class LWCECityTemplate extends LWCEDataTemplate
    config(LWCEWorld);

var config Vector2D vLocation;   // Where on the Geoscape this city is located.

var const localized string strName;

function name GetCityName()
{
    return DataName;
}