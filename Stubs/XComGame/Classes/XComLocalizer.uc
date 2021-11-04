class XComLocalizer extends Object
    native(Core);
//complete stub

// Export UXComLocalizer::execEscapeAndTokenize(FFrame&, void* const)
private native static final function EscapeAndTokenize(out array<string> OutTokens, string InString);

// Export UXComLocalizer::execExtractTag(FFrame&, void* const)
private native static final function bool ExtractTag(string InString, out string TagName, out string OptName);

// Export UXComLocalizer::execExpandStringByTag(FFrame&, void* const)
native static function string ExpandStringByTag(string StringToExpand, XGLocalizeTag Tag);

// Export UXComLocalizer::execExpandString(FFrame&, void* const)
native static function string ExpandString(string StringToExpand, optional XGLocalizeContext context);