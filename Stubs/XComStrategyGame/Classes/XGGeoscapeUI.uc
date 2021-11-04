class XGGeoscapeUI extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

var const localized string m_strNewMissionType;
var const localized string m_strMissionCrash;
var const localized string m_strTerrorSite;
var const localized string m_strAlienBase;
var array<XGEntity> m_arrTestStaticEntities;

function Clear();
function DrawUFO(XGEntity kEntity, int iType, int iValue, Vector2D v2Loc){}
function DrawSkyranger(XGEntity kEntity, int iType, int iValue, Vector2D v2Loc){}
function DrawInterceptor(XGEntity kEntity, int iType, int iValue, Vector2D v2Loc){}
function DrawMission(XGEntity kEntity, int iType, Vector2D v2Loc){}
function DrawTemple(XGEntity kEntity, Vector2D v2Loc){}
function DrawBase(XGEntity kEntity, Vector2D v2Loc){}
function DrawSatellite(XGEntity kEntity, Vector2D v2Loc){}
function DrawCountry(XGEntity kEntity, Vector2D v2Loc){}
function EndFrame(float fDeltaT){}
function CreateTestEntities(){}
function DrawTestEntities(){}
