class XGCountryTag extends XGLocalizeTag
    native;
//complete stub

var XGCountry kCountry;
var XGCity kCity;

native function bool Expand(string InString, out string OutString);

event string GetCountryName(){}

event string GetCountryNameWithArticle(){}
event string GetCountryNameWithArticleLowerCase(){}
event string GetCountryNamePossessive(){}
event string GetCountryNameAdjective(){}
event string GetCountryCityName(){}
