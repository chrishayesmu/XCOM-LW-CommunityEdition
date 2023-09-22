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
    local int iCountry;

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
        // I have no idea what this loop is for, or why you would be missing countries mid-game, or why
        // if you were missing countries, you would add them all in one continent. Maybe this is a weird
        // carry-over from a beta version of LW that had less countries or something.
        if (World().m_arrCountries.Length < 36)
        {
            for (iCountry = World().m_arrCountries.Length; iCountry < 36; iCountry++)
            {
                BuildCountry(iCountry, eContinent_Europe, true);
            }
        }

        SatCoverage = eSat_Hyperwave;

        foreach World().m_arrCountries(kCountry)
        {
            if (kCountry.HasSatelliteCoverage())
            {
                `HQGAME.GetEarth().SetCountrySatellite(ECountry(kCountry.GetID()), SatCoverage);
            }
        }
    }
}

function BuildCity()
{
    local int iCity;
    local XGCity kCity;

    m_arrCities.Add(255);

    for (iCity = 0; iCity < class'XGFacility_Engineering'.default.m_arrAlloyProjects.Length; iCity++)
    {
        kCity = Spawn(class'LWCE_XGCity');
        kCity.m_iID = class'XGFacility_Engineering'.default.m_arrAlloyProjects[iCity].iType;
        kCity.m_strName = class'XGLocalizedData'.default.CityTypeNames[kCity.m_iID];
        kCity.m_iCountry = class'XGFacility_Engineering'.default.m_arrAlloyProjects[iCity].iCountry;
        kCity.m_v2Coords = class'XGFacility_Engineering'.default.m_arrAlloyProjects[iCity].v2Loc;

        m_arrCities[kCity.m_iID] = kCity;

        Country(kCity.m_iCountry).m_arrCities.AddItem(kCity.m_iID);
    }
}

function BuildCouncilCountry(int iCountry, int iContinent, bool bDeveloped)
{
    local TCountry kCountry;

    kCountry.iEnum = iCountry;
    kCountry.strName = class'XGLocalizedData'.default.CountryNames[iCountry];
    kCountry.strNameWithArticle = class'XGLocalizedData'.default.CountryNamesWithArticle[iCountry];
    kCountry.strNameWithArticleLower = class'XGLocalizedData'.default.CountryNamesWithArticleLower[iCountry];
    kCountry.strNamePossessive = class'XGLocalizedData'.default.CountryPossessive[iCountry];
    kCountry.strNameAdjective = class'XGLocalizedData'.default.CountryAdjective[iCountry];
    kCountry.iContinent = iContinent;
    kCountry.bDeveloped = bDeveloped;
    kCountry.bCouncilMember = true;

    m_arrCountries[iCountry] = Spawn(class'LWCE_XGCountry');
    m_arrCountries[iCountry].InitNewGame(kCountry);

    Continent(iContinent).m_arrCountries.AddItem(iCountry);
}

function BuildCountry(int iCountry, int iContinent, bool bDeveloped)
{
    local TCountry kCountry;

    kCountry.iEnum = iCountry;
    kCountry.strName = class'XGLocalizedData'.default.CountryNames[iCountry];
    kCountry.strNamePossessive = class'XGLocalizedData'.default.CountryPossessive[iCountry];
    kCountry.strNameAdjective = class'XGLocalizedData'.default.CountryAdjective[iCountry];
    kCountry.iContinent = iContinent;
    kCountry.bDeveloped = bDeveloped;
    kCountry.bCouncilMember = false;

    m_arrCountries[iCountry] = Spawn(class'LWCE_XGCountry');
    m_arrCountries[iCountry].InitNewGame(kCountry);

    Continent(iContinent).m_arrCountries.AddItem(iCountry);
}

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

    `LWCE_LOG_DEPRECATED_CLS(GetContinents);

    return arrContinents;
}

function array<name> LWCE_GetContinents()
{
    local array<name> arrContinents;
    local int Index;

    for (Index = 0; Index < m_arrContinents.Length; Index++)
    {
        arrContinents.AddItem(LWCE_XGContinent(m_arrContinents[Index]).m_nmContinent);
    }
    
    return arrContinents;
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