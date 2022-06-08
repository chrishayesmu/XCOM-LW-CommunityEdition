class XComContentManager extends Object;

enum EUIMode
{
    eUIMode_Common,
    eUIMode_Shell,
    eUIMode_Tactical,
    eUIMode_Strategy,
    eUIMode_MAX
};

enum EContentCategory
{
    eContent_Unit,
    eContent_Weapon,
    eContent_ArmorKit,
    eContent_UI,
    eContent_Head,
    eContent_Body,
    eContent_Hair,
    eContent_Voice,
    eContent_Palette,
    eContent_Perk,
    eContent_MAX
};

enum EColorPalette
{
    ePalette_HairColor<DisplayName=Hair Color>,
    ePalette_ShirtColor<DisplayName=Shirt Color>,
    ePalette_PantsColor<DisplayName=Pants Color>,
    ePalette_FormalClothesColor<DisplayName=Formal Clothes Color>,
    ePalette_CaucasianSkin<DisplayName=Caucasian Skin>,
    ePalette_AfricanSkin<DisplayName=African Skin>,
    ePalette_HispanicSkin<DisplayName=Hispanic Skin>,
    ePalette_AsianSkin<DisplayName=Asian Skin>,
    ePalette_EyeColor<DisplayName=Eye Color>,
    ePalette_ArmorTint<DisplayName=Armor Tints>,
    ePalette_MAX
};