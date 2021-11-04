class XGCharacterGenerator extends Actor
    config(NameList)
    notplaceable
    hidecategories(Navigation)
	DependsOn(XGTacticalGameCoreNativeBase);
//complete stub

var const localized array<localized string> m_arrMHeavyNicknames;
var const localized array<localized string> m_arrMAssaultNicknames;
var const localized array<localized string> m_arrMSniperNicknames;
var const localized array<localized string> m_arrMSupportNicknames;
var const localized array<localized string> m_arrMMECNicknames;
var const localized array<localized string> m_arrFHeavyNicknames;
var const localized array<localized string> m_arrFAssaultNicknames;
var const localized array<localized string> m_arrFSniperNicknames;
var const localized array<localized string> m_arrFSupportNicknames;
var const localized array<localized string> m_arrFMECNicknames;
var config array<config string> m_arrAmMFirstNames;
var config array<config string> m_arrAmFFirstNames;
var config array<config string> m_arrAmLastNames;
var config array<config string> m_arrAbMFirstNames;
var config array<config string> m_arrAbFFirstNames;
var config array<config string> m_arrAbLastNames;
var config array<config string> m_arrIsMFirstNames;
var config array<config string> m_arrIsFFirstNames;
var config array<config string> m_arrIsLastNames;
var config array<config string> m_arrRsMFirstNames;
var config array<config string> m_arrRsFFirstNames;
var config array<config string> m_arrRsMLastNames;
var config array<config string> m_arrRsFLastnames;
var config array<config string> m_arrEnMFirstNames;
var config array<config string> m_arrEnFFirstNames;
var config array<config string> m_arrEnLastNames;
var config array<config string> m_arrFrMFirstNames;
var config array<config string> m_arrFrFFirstNames;
var config array<config string> m_arrFrLastNames;
var config array<config string> m_arrAfMFirstNames;
var config array<config string> m_arrAfFFirstNames;
var config array<config string> m_arrAfLastNames;
var config array<config string> m_arrJpMFirstNames;
var config array<config string> m_arrJpFFirstNames;
var config array<config string> m_arrJpLastNames;
var config array<config string> m_arrChMFirstNames;
var config array<config string> m_arrChFFirstNames;
var config array<config string> m_arrChLastNames;
var config array<config string> m_arrInMFirstNames;
var config array<config string> m_arrInFFirstNames;
var config array<config string> m_arrInLastNames;
var config array<config string> m_arrGmMFirstNames;
var config array<config string> m_arrGmFFirstNames;
var config array<config string> m_arrGmLastNames;
var config array<config string> m_arrItMFirstNames;
var config array<config string> m_arrItFFirstNames;
var config array<config string> m_arrItLastNames;
var config array<config string> m_arrMxMFirstNames;
var config array<config string> m_arrMxFFirstNames;
var config array<config string> m_arrMxLastNames;
var config array<config string> m_arrAuMFirstNames;
var config array<config string> m_arrAuFFirstNames;
var config array<config string> m_arrAuLastNames;
var config array<config string> m_arrEsMFirstNames;
var config array<config string> m_arrEsFFirstNames;
var config array<config string> m_arrEsLastNames;
var config array<config string> m_arrGrMFirstNames;
var config array<config string> m_arrGrFFirstNames;
var config array<config string> m_arrGrLastNames;
var config array<config string> m_arrNwMFirstNames;
var config array<config string> m_arrNwFFirstNames;
var config array<config string> m_arrNwLastNames;
var config array<config string> m_arrIrMFirstNames;
var config array<config string> m_arrIrFFirstNames;
var config array<config string> m_arrIrLastNames;
var config array<config string> m_arrSkMFirstNames;
var config array<config string> m_arrSkFFirstNames;
var config array<config string> m_arrSkLastNames;
var config array<config string> m_arrDuMFirstNames;
var config array<config string> m_arrDuFFirstNames;
var config array<config string> m_arrDuLastNames;
var config array<config string> m_arrScMFirstNames;
var config array<config string> m_arrScFFirstNames;
var config array<config string> m_arrScLastNames;
var config array<config string> m_arrBgMFirstNames;
var config array<config string> m_arrBgFFirstNames;
var config array<config string> m_arrBgLastNames;
var config array<config string> m_arrPlMFirstNames;
var config array<config string> m_arrPlMLastnames;
var config array<config string> m_arrPlFFirstNames;
var config array<config string> m_arrPlFLastNames;
var int m_aLastMaleVoice[ECharacterLanguage];
var int m_aLastFemaleVoice[ECharacterLanguage];
var int m_iHairType;

function GenerateName(int iGender, int iCountry, out string strFirst, out string strLast, optional int iRace){}
function GenerateNickname(int iGen, ESoldierClass eClass, out string strNickName){}
function int PickOriginCountry(optional int iContinent){}
function XGCharacter_Soldier CreateBaseSoldier(optional ELoadoutTypes eLoadout, optional EGender eForceGender, optional ESoldierClass eClass){}
function TSoldier CreateTSoldier(optional EGender eForceGender, optional int iCountry, optional int iRace, optional ESoldierClass eClass){}
static function ECharacterLanguage GetLanguageByString(optional string strLanguage){}
function ECharacterLanguage GetLanguageByCountry(ECountry Country){}
function int GetNextMaleVoice(ECharacterLanguage eLang, bool IsMec){}
function int GetNextFemaleVoice(ECharacterLanguage eLang, bool IsMec){}
function int ChooseHairColor(const out TAppearance kAppearance, int iNumBaseOptions){}
function int ChooseFacialHair(const out TAppearance kAppearance, int iOrigin, int iNumBaseOptions){}
function int GetRandomRaceByCountry(int iCountry){}
