class XComLinearColorPalette extends Object
    native(Core);

struct native XComLinearColorPaletteEntry
{
    var() LinearColor Primary;
    var() LinearColor Secondary;
};

var() array<XComLinearColorPaletteEntry> Entries;
var() int BaseOptions;
