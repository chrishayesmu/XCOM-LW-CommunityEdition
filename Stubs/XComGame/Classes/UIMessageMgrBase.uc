class UIMessageMgrBase extends UI_FxsScreen
    abstract
    native(UI)
    notplaceable
    hidecategories(Navigation);

enum EUIIcon
{
    eIcon_None,
    eIcon_XcomTurn,
    eIcon_AlienTurn,
    eIcon_QuestionMark,
    eIcon_ExclamationMark,
    eIcon_GenericCircle,
    eIcon_Globe,
    eIcon_MAX
};

function ShouldDisplayAndBroadcastMessage(out int ibDisplayMessage, out int ibBroadcastMessage, ETeam eBroadcastToTeams, string warnMessage){}

