class XGDateTime extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub 
struct CheckpointRecord
{
    var float m_fTime;
    var int m_iDay;
    var int m_iMonth;
    var int m_iYear;
};
var float m_fTime;
var int m_iDay;
var int m_iMonth;
var int m_iYear;
var const localized string m_sAM;
var const localized string m_sPM;
var const localized string m_strMonth0;
var const localized string m_strMonth1;
var const localized string m_strMonth2;
var const localized string m_strMonth3;
var const localized string m_strMonth4;
var const localized string m_strMonth5;
var const localized string m_strMonth6;
var const localized string m_strMonth7;
var const localized string m_strMonth8;
var const localized string m_strMonth9;
var const localized string m_strMonth10;
var const localized string m_strMonth11;
var const localized string m_strMonthDayYear;
var const localized string m_strYearSuffix;
var const localized string m_strMonthSuffix;
var const localized string m_strDaySuffix;

function bool IsFirstDay(){}
function SetTime(int iHour, int iMinute, int iSecond, int iMonth, int iDay, int iYear){}
function CopyDateTime(XGDateTime kDate){}
function GetLocalizedTime(Vector2D v2Loc, out XGDateTime kDate){}
final function int GetXMTHourDiff(){}
function ETimeOfDay GetTimeOfDay(){}
function string GetTimeString(){}
function string GetMonthString(optional int iMonth, optional bool bCapitalize){}
function string GetMonthStringCapitalized(string Month){}
function string GetDateString(){}
function AddTime(float fSeconds){}
function RemoveTime(float fSeconds){}
function AddDays(int iNumDays){}
protected function AddDay(){}
function AddMonth(){}
protected function AddYear(){}
function int GetHour(){}
function int GetMinute(){}
function int GetSecond(){}
function int GetYear(){}
function int GetMonth(){}
function int GetDay(){}
function float GetTimeInSeconds(){}
function int GetTotalDays(){}
function int DaysInMonth(int iMonth, int iYear){}
function int DifferenceInYears(XGDateTime kSubtractThisOne){}
function int DifferenceInMonths(XGDateTime kSubtractThisOne){}
function int DifferenceInDays(XGDateTime kSubtractThisOne){}
function int DifferenceInHours(XGDateTime kSubtractThisOne){}
function int DifferenceInMinutes(XGDateTime kSubtractThisOne){}
function int DifferenceInSeconds(XGDateTime kSubtractThisOne){}
function bool LessThan(XGDateTime kDate){}
function bool DateEquals(XGDateTime kDate){}


DefaultProperties
{
}
