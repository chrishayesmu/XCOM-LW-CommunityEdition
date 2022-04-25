class XComLocalizer extends Object
    native(Core);

/*
* This documentation is taken from the XCOM 2 function of the same name/class.
*
* Tokenize the string. Given "Sometext <With:Tag/> MoreText", the resulting
* tokens would be "Sometext", "<With:Tag/>", and "MoreText". Any escape chacaters
* are removed.
*/
// Export UXComLocalizer::execEscapeAndTokenize(FFrame&, void* const)
native static final function EscapeAndTokenize(out array<string> OutTokens, string InString);

// Export UXComLocalizer::execExtractTag(FFrame&, void* const)
native static final function bool ExtractTag(string InString, out string TagName, out string OptName);

// Export UXComLocalizer::execExpandStringByTag(FFrame&, void* const)
native static function string ExpandStringByTag(string StringToExpand, XGLocalizeTag Tag);

// Export UXComLocalizer::execExpandString(FFrame&, void* const)
native static function string ExpandString(string StringToExpand, optional XGLocalizeContext context);