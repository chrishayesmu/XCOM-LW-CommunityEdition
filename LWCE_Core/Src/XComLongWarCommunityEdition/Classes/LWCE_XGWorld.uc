class LWCE_XGWorld extends XGWorld
    dependson(LWCETypes);

struct CheckpointRecord_LWCE_XGWorld extends XGWorld.CheckpointRecord
{
    var array<LWCE_TSatNode> m_arrCESatNodes;
};

var array<LWCE_TSatNode> m_arrCESatNodes;

function Init(bool bNewGame)
{
    local XGCountry kCountry;
    local ESatelliteCoverage SatCoverage;

    if (HQ().IsHyperwaveActive())
    {
        SatCoverage = eSat_Hyperwave;
    }
    else
    {
        SatCoverage = eSat_Regular;
    }

    foreach m_arrCountries(kCountry)
    {
        if (kCountry.LeftXCom() && kCountry.m_kEntity == none)
        {
            kCountry.SetEntity(Spawn(class'LWCE_XGEntity'), kCountry.GetStormEntity());
        }
    }

    if (bNewGame)
    {
        InitNewGame();
    }
    else
    {
        // Not sure how needed this all is; why would it default to hyperwave?
        SatCoverage = eSat_Hyperwave;

        foreach m_arrCountries(kCountry)
        {
            if (kCountry.HasSatelliteCoverage())
            {
                `LWCE_LOG_NOT_IMPLEMENTED(LWCE_XGWorld.Init -> SetCountrySatellite);
                // `HQGAME.GetEarth().SetCountrySatellite(ECountry(kCountry.GetID()), SatCoverage);
            }
        }
    }
}

function InitNewGame()
{
    CreateContinents();
    CreateCountries();
    CreateCities();
    CreateSatNodes();
}

function BuildCity()
{
    `LWCE_LOG_DEPRECATED_BY(BuildCity, CreateCities);
}

function BuildCouncilCountry(int iCountry, int iContinent, bool bDeveloped)
{
    `LWCE_LOG_DEPRECATED_BY(BuildCouncilCountry, LWCE_BuildCountry);
}

function BuildCountry(int iCountry, int iContinent, bool bDeveloped)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildCountry);
}

function LWCE_BuildCountry(name nmCountry, name nmContinent)
{
    local LWCE_XGCountry kCountry;

    kCountry = Spawn(class'LWCE_XGCountry');
    kCountry.LWCE_InitNewGame(nmCountry, nmContinent);

    m_arrCountries.AddItem(kCountry);
}

function BuildSatNode(ECountry ECountry, Vector2D v2Coords)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildSatNode);
}

function LWCE_BuildSatNode(name nmCountry, Vector2D v2Coords)
{
    local LWCE_TSatNode kNode;

    kNode.nmCountry = nmCountry;
    kNode.v2Coords = v2Coords;

    m_arrCESatNodes.AddItem(kNode);
}

/// <summary>
/// Creates all of the cities to start the game.
/// </summary>
function CreateCities()
{
    local array<LWCE_XGCountry> arrCountries;
    local LWCECityTemplateManager kCityTemplateMgr;
    local LWCECityTemplate kCityTemplate;
    local LWCE_XGCountry kCountry;
    local LWCE_XGCity kCity;
    local name nmCity;

    kCityTemplateMgr = `LWCE_CITY_TEMPLATE_MGR;

    arrCountries = GetCouncilCountries(/* bRequireCurrentMember */ false);

    foreach arrCountries(kCountry)
    {
        foreach kCountry.m_kTemplate.arrCities(nmCity)
        {
            kCityTemplate = kCityTemplateMgr.FindCityTemplate(nmCity);

            kCity = Spawn(class'LWCE_XGCity');
            kCity.m_nmCity = nmCity;
            kCity.m_strName = kCityTemplate.strName;
            kCity.m_nmCountry = kCountry.m_nmCountry;
            kCity.m_v2Coords = kCityTemplate.v2Location;

            m_arrCities.AddItem(kCity);

            kCountry.m_arrCECities.AddItem(nmCity);
        }
    }
}

/// <summary>
/// Creates all of the continents to start the game.
/// </summary>
function CreateContinents()
{
    local array<LWCEContinentTemplate> arrContinents;
    local LWCE_XGContinent kContinent;
    local int iContinent;

    arrContinents = `LWCE_CONTINENT_TEMPLATE_MGR.GetAllContinentTemplates();

    for (iContinent = 0; iContinent < arrContinents.Length; iContinent++)
    {
        kContinent = Spawn(class'LWCE_XGContinent');
        kContinent.m_nmContinent = arrContinents[iContinent].GetContinentName();
        kContinent.InitNewGame();

        m_arrContinents.AddItem(kContinent);
    }
}

/// <summary>
/// Creates all of the countries to start the game.
/// </summary>
function CreateCountries()
{
    local int iCountry;
    local XGContinent kContinent;
    local LWCE_XGContinent kCEContinent;

    foreach m_arrContinents(kContinent)
    {
        kCEContinent = LWCE_XGContinent(kContinent);

        for (iCountry = 0; iCountry < kCEContinent.m_kTemplate.arrCountries.Length; iCountry++)
        {
            LWCE_BuildCountry(kCEContinent.m_kTemplate.arrCountries[iCountry], kCEContinent.m_nmContinent);
        }
    }
}

/// <summary>
/// Creates all of the satellite nodes to start the game.
/// </summary>
function CreateSatNodes()
{
    local array<LWCE_XGCountry> arrCountries;
    local LWCE_XGCountry kCountry;

    arrCountries = LWCE_GetCountries();

    foreach arrCountries(kCountry)
    {
        LWCE_BuildSatNode(kCountry.m_nmCountry, kCountry.m_kTemplate.v2SatNodeLoc);
    }
}

function XGContinent GetContinent(int iContinent)
{
    `LWCE_LOG_DEPRECATED_CLS(GetContinent);

    return none;
}

function LWCE_XGContinent LWCE_GetContinent(name nmContinent)
{
    local int Index;

    for (Index = 0; Index < m_arrContinents.Length; Index++)
    {
        if (LWCE_XGContinent(m_arrContinents[Index]).m_nmContinent == nmContinent)
        {
            return LWCE_XGContinent(m_arrContinents[Index]);
        }
    }

    return none;
}

function array<int> GetContinents()
{
    local array<int> arrContinents;
    arrContinents.Length = 0;

    `LWCE_LOG_DEPRECATED_BY(GetContinents, LWCE_GetContinentNames);

    return arrContinents;
}

function array<LWCE_XGContinent> LWCE_GetContinents()
{
    local array<LWCE_XGContinent> arrContinents;
    local int Index;

    for (Index = 0; Index < m_arrContinents.Length; Index++)
    {
        arrContinents.AddItem(LWCE_XGContinent(m_arrContinents[Index]));
    }

    return arrContinents;
}

function array<name> LWCE_GetContinentNames()
{
    local array<name> arrContinents;
    local int Index;

    for (Index = 0; Index < m_arrContinents.Length; Index++)
    {
        arrContinents.AddItem(LWCE_XGContinent(m_arrContinents[Index]).m_nmContinent);
    }

    return arrContinents;
}

function LWCE_XGContinent GetContinentContainingCountry(name nmCountry)
{
    local XGContinent kContinent;

    foreach m_arrContinents(kContinent)
    {
        if (LWCE_XGContinent(kContinent).ContainsCountry(nmCountry))
        {
            return LWCE_XGContinent(kContinent);
        }
    }

    return none;
}

/// <summary>
/// Gets all of the countries which are part of the XCOM funding council. If `bRequireCurrentMember` is `true`,
/// then only countries which are currently in the council (i.e. have not defected) are returned.
/// </summary>
function array<LWCE_XGCountry> GetCouncilCountries(bool bRequireCurrentMember)
{
    local array<LWCE_XGCountry> arrCouncilCountries;
    local XGCountry kCountry;

    foreach m_arrCountries(kCountry)
    {
        if (kCountry.IsCouncilMember() && (!bRequireCurrentMember || !kCountry.LeftXCom()))
        {
            arrCouncilCountries.AddItem(LWCE_XGCountry(kCountry));
        }
    }

    return arrCouncilCountries;
}

function XGCountry GetCountry(int iCountryID)
{
    `LWCE_LOG_DEPRECATED_CLS(GetCountry);
    return none;
}

function LWCE_XGCountry LWCE_GetCountry(name nmCountry)
{
    local int Index;

    for (Index = 0; Index < m_arrCountries.Length; Index++)
    {
        if (LWCE_XGCountry(m_arrCountries[Index]).m_nmCountry == nmCountry)
        {
            return LWCE_XGCountry(m_arrCountries[Index]);
        }
    }

    return none;
}

function array<LWCE_XGCountry> LWCE_GetCountries()
{
    local array<LWCE_XGCountry> arrCountries;
    local int Index;

    for (Index = 0; Index < m_arrCountries.Length; Index++)
    {
        arrCountries.AddItem(LWCE_XGCountry(m_arrCountries[Index]));
    }

    return arrCountries;
}

function EContinent GetRandomContinent()
{
    `LWCE_LOG_DEPRECATED_CLS(GetRandomContinent);

    return EContinent(-100);
}

function name LWCE_GetRandomContinent()
{
    local int Index;

    Index = Rand(m_arrContinents.Length);
    return LWCE_XGContinent(m_arrContinents[Index]).m_nmContinent;
}

function TSatNode GetSatelliteNode(int iCountry)
{
    local TSatNode kNode;

    `LWCE_LOG_DEPRECATED_CLS(GetSatelliteNode);

    return kNode;
}

function LWCE_TSatNode LWCE_GetSatelliteNode(name nmCountry)
{
    local LWCE_TSatNode kNode;

    foreach m_arrCESatNodes(kNode)
    {
        if (kNode.nmCountry == nmCountry)
        {
            return kNode;
        }
    }

    return kNode;
}

function OnLoadGame()
{
    // TODO: add OnLoadGame to all of our facilities and use them to make sure post-load behavior is consistent with installed mods.
    // Ex: storage should check that all infinite items are added to storage for enumeration, in case a mod has been installed/updated
    // that makes an item infinite that wasn't infinite the last time the game was loaded.
}

function string RecordStartedGame()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordStartedGame);

    return "";
}