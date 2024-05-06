class UINavigationHelp extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

const HELP_OPTION_IDENTIFIER = "buttonHelp";

enum EButtonIconPC
{
    eButtonIconPC_Prev_Soldier,
    eButtonIconPC_Next_Soldier,
    eButtonIconPC_Hologlobe,
    eButtonIconPC_Details,
    eButtonIconPC_Back,
    eButtonIconPC_Pause,
    eButtonIconPC_MAX
};

var int LEFT_HELP_CONTAINER_PADDING;
var int RIGHT_HELP_CONTAINER_PADDING;
var int CENTER_HELP_CONTAINER_PADDING;
var const localized string m_strBackButtonLabel;
var private delegate<onHelpBarInitializedDelegate> m_notifyHelpBarLoadedDelegate;
var private array< delegate<onButtonClickedDelegate> > m_arrButtonClickDelegates;

delegate onHelpBarInitializedDelegate()
{
}

delegate onButtonClickedDelegate()
{
}

defaultproperties
{
    LEFT_HELP_CONTAINER_PADDING=20
    RIGHT_HELP_CONTAINER_PADDING=20
    CENTER_HELP_CONTAINER_PADDING=60
    s_name="helpBarMC"
}