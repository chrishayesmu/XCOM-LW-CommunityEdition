class LWCE_XGContinentUI extends XGContinentUI;

struct LWCE_TStartingOption
{
    var name Country;
    var name Continent;
    var name ContinentBonus;
    var name StartingBonus;
    var string ContinentFriendlyName;
    var string ContinentBonusFriendlyName;
    var string ContinentBonusFriendlyDescription;
    var string CountryFriendlyName;
    var string StartingBonusFriendlyName;
    var string StartingBonusFriendlyDescription;
    var int CountryStartingCash;
    var Vector2D CountryCoords;
};

var array<LWCE_TStartingOption> m_arrStartingOptions;

var private LWCEBonusTemplateManager m_kBonusTemplateMgr;
var private LWCEContinentTemplateManager m_kContinentTemplateMgr;
var private LWCECountryTemplateManager m_kCountryTemplateMgr;

var const localized string m_strContinentBonusNameRandom;
var const localized string m_strContinentBonusDescRandom;

function Init(int iView)
{
    m_kBonusTemplateMgr = `LWCE_BONUS_TEMPLATE_MGR;
    m_kContinentTemplateMgr = `LWCE_CONTINENT_TEMPLATE_MGR;
    m_kCountryTemplateMgr = `LWCE_COUNTRY_TEMPLATE_MGR;

    super.Init(iView);
}

function bool OnChooseCont(int iOption)
{
    local LWCE_XGHeadquarters kHQ;
    local LWCE_TStartingOption kOption;

    kHQ = LWCE_XGHeadquarters(HQ());
    kOption = m_arrStartingOptions[iOption];

    kHQ.SetStartingData(kOption.Continent, kOption.Country, kOption.StartingBonus);

    if (!ISCONTROLLED())
    {
        GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0.0, 1.0), 0.20);
        PRES().UILoadAnimation(true);
        PRES().SetTimer(0.210, false, 'StartNewGame', Game());
        PRES().PopState();
    }
    else
    {
        PRES().m_kContinentSelect.Hide();
    }

    return true;
}

function UpdateMainMenu()
{
    local array<LWCEContinentTemplate> arrContinents;
    local LWCEBonusTemplate kContinentBonusTemplate, kStartingBonusTemplate;
    local LWCECountryTemplate kCountryTemplate;
    local LWCE_TStartingOption kStartingOption;
    local int iBonus, iContinent, iCountry;
    local name nmContinentBonus;

    arrContinents = m_kContinentTemplateMgr.GetAllContinentTemplates();
    
    for (iContinent = 0; iContinent < arrContinents.Length; iContinent++)
    {
        // If continents have multiple bonuses assigned, one will randomly be picked after starting
        // the campaign. If only one bonus, go ahead and display it to the player now.
        if (arrContinents[iContinent].arrContinentBonuses.Length == 1)
        {
            nmContinentBonus = arrContinents[iContinent].arrContinentBonuses[0];
            kContinentBonusTemplate = m_kBonusTemplateMgr.FindBonusTemplate(nmContinentBonus);
        }
        else
        {
            nmContinentBonus = '';
            kContinentBonusTemplate = none;
        }

        for (iCountry = 0; iCountry < arrContinents[iContinent].arrCountries.Length; iCountry++)
        {
            kCountryTemplate = m_kCountryTemplateMgr.FindCountryTemplate(arrContinents[iContinent].arrCountries[iCountry]);

            if (kCountryTemplate == none)
            {
                `LWCE_LOG_ERROR("Couldn't find a country template with the name " $ arrContinents[iContinent].arrCountries[iCountry]);
                continue;
            }

            if (!kCountryTemplate.bIsCouncilMember)
            {
                continue;
            }

            for (iBonus = 0; iBonus < kCountryTemplate.arrStartingBonuses.Length; iBonus++)
            {
                kStartingBonusTemplate = m_kBonusTemplateMgr.FindBonusTemplate(kCountryTemplate.arrStartingBonuses[iBonus]);

                if (kStartingBonusTemplate == none)
                {
                    `LWCE_LOG_ERROR("Couldn't find a bonus template with the name " $ kCountryTemplate.arrStartingBonuses[iBonus]);
                    continue;
                }

                // Data (so we can pass it to HQ when starting the game)
                kStartingOption.Continent = arrContinents[iContinent].GetContinentName();
                kStartingOption.ContinentBonus = nmContinentBonus;
                kStartingOption.Country = kCountryTemplate.GetCountryName();
                kStartingOption.StartingBonus = kStartingBonusTemplate.GetBonusName();

                // Localization content
                kStartingOption.ContinentFriendlyName = arrContinents[iContinent].strName;
                kStartingOption.ContinentBonusFriendlyName = nmContinentBonus != '' ? kContinentBonusTemplate.strName : m_strContinentBonusNameRandom;
                kStartingOption.ContinentBonusFriendlyDescription = nmContinentBonus != '' ? kContinentBonusTemplate.strDescription : m_strContinentBonusDescRandom;
                kStartingOption.CountryFriendlyName = kCountryTemplate.strName;
                kStartingOption.CountryStartingCash = kCountryTemplate.iStartingCash;
                kStartingOption.StartingBonusFriendlyName = kStartingBonusTemplate.strName;
                kStartingOption.StartingBonusFriendlyDescription = kStartingBonusTemplate.strDescription;

                // Used to rotate the geoscape when selecting a country
                kStartingOption.CountryCoords = kCountryTemplate.GetCoords();

                m_arrStartingOptions.AddItem(kStartingOption);
            }
        }
    }

    m_arrStartingOptions.Sort(SortStartingOptions);
    `LWCE_LOG("There are " $ m_arrStartingOptions.Length $ " starting options");
}

function int SortStartingOptions(LWCE_TStartingOption Option1, LWCE_TStartingOption Option2)
{
    // Sort first by country name
    if (Option1.CountryFriendlyName < Option2.CountryFriendlyName)
    {
        return 0;
    }
    else if (Option1.CountryFriendlyName > Option2.CountryFriendlyName)
    {
        return -1;
    }

    // Then sort by bonus name
    if (Option1.StartingBonusFriendlyName < Option2.StartingBonusFriendlyName)
    {
        return 0;
    }
    else if (Option1.StartingBonusFriendlyName > Option2.StartingBonusFriendlyName)
    {
        return -1;
    }

    return 0;
}