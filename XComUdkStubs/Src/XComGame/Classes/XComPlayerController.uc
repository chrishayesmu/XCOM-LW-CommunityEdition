class XComPlayerController extends XComPlayerControllerNativeBase
    native(Core)
    config(Game)
    hidecategories(Navigation);

var XComPresentationLayerBase m_Pres;
var class<XComPresentationLayerBase> m_kPresentationLayerClass;
var private XComWeatherControl m_kWeatherControl;
var transient float LastCheckpointSaveTime;
var bool bProfileSettingsUpdated;
var bool bIsAcceptingInvite;
var bool bVoluntarilyDisconnectingFromGame;
var privatewrite bool bBlockingInputAfterMovie;
var transient bool m_bPauseFromLossOfFocus;
var transient bool m_bPauseFromGame;
var protected transient float m_fAltTabTime;