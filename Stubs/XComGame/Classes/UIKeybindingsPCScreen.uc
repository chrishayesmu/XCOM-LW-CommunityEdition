class UIKeybindingsPCScreen extends UI_FxsScreen
    native(UI)
    notplaceable
    hidecategories(Navigation);

struct native UIKeyBind
{
    var init string UserLabel;
    var KeyBind PrimaryBind;
    var KeyBind SecondaryBind;
    var bool BlockUnbindingPrimaryKey;
};