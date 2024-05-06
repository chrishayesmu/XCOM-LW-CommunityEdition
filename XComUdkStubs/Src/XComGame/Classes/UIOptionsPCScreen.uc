class UIOptionsPCScreen extends UI_FxsScreen
    native(UI)
    notplaceable
    hidecategories(Navigation);

const GAMMA_HIGH = 2.7;
const GAMMA_LOW = 1.7;
const GAMMA_XBOX_PERCENT = 30;
const GAMMA_DEFAULT_PERCENT = 50;

enum EUI_PCOptions_GraphicsSettings
{
    eGraphicsSetting_Low,
    eGraphicsSetting_Medium,
    eGraphicsSetting_High,
    eGraphicsSetting_Custom,
    eGraphicsSetting_Disabled,
    eGraphicsSetting_MAX
};

enum EFXSFXAAType
{
    FXSAA_Off,
    FXSAA_FXAA0,
    FXSAA_FXAA1,
    FXSAA_FXAA2,
    FXSAA_FXAA3,
    FXSAA_FXAA4,
    FXSAA_FXAA5,
    FXSAA_MAX
};

enum EUI_PCOptions_Tabs
{
    ePCTab_Video,
    ePCTab_Graphics,
    ePCTab_Audio,
    ePCTab_Gameplay,
    ePCTab_Interface,
    ePCTab_MAX
};

enum EUI_PCOptions_Video
{
    ePCTabVideo_Mode,
    ePCTabVideo_MouseLock,
    ePCTabVideo_Resolution,
    ePCTabVideo_Gamma,
    ePCTabVideo_VSync,
    ePCTabVideo_FRSmoothing,
    ePCTabVideo_MAX
};

enum EUI_PCOptions_Graphics
{
    ePCTabGraphics_Preset,
    ePCTabGraphics_Shadow,
    ePCTabGraphics_TextureFiltering,
    ePCTabGraphics_FOW,
    ePCTabGraphics_AntiAliasing,
    ePCTabGraphics_TextureDetail,
    ePCTabGraphics_Effects,
    ePCTabGraphics_AmbientOcclusion,
    ePCTabGraphics_MAX
};

enum EUI_PCOptions_Audio
{
    ePCTabAudio_MasterVolume,
    ePCTabAudio_VoiceVolume,
    ePCTabAudio_SoundEffectsVolume,
    ePCTabAudio_MusicVolume,
    ePCTabAudio_SpeakerPreset,
    ePCTabAudio_EnableSoldierSpeech,
    ePCTabAudio_ForeignLanguages,
    ePCTabAudio_MAX
};

enum EUI_PCOptions_Gameplay
{
    ePCTabGameplay_GlamCam,
    ePCTabGameplay_ThirdPersonCam,
    ePCTabGameplay_AutosaveMaster,
    ePCTabGameplay_ShowEnemyHealth,
    ePCTabGameplay_MAX
};

enum EUI_PCOptions_Interface
{
    ePCTabInterface_InputDevice,
    ePCTabInterface_KeyBindings,
    ePCTabInterface_ZoomLevels,
    ePCTabInterface_HealthBars,
    ePCTabInterface_Subtitles,
    ePCTabInterface_EdgeScroll,
    ePCTabInterface_MAX
};

enum EUI_PCOptions_InputOptions
{
    ePCTabInterface_InputOption_Mouse,
    ePCTabInterface_InputOption_Touch,
    ePCTabInterface_InputOption_Gamepad,
    ePCTabInterface_InputOption_MAX
};

struct native TUIOptionsInitVideoSettings
{
    var bool bMouseLock;
    var int iGamma;
    var bool bVSync;
    var bool bFRSmoothing;

    structdefaultproperties
    {
        bMouseLock=false
        iGamma=0
        bVSync=false
        bFRSmoothing=false
    }
};

var TUIOptionsInitVideoSettings m_kInitVideoSettings;
var const localized string m_strTitle;
var const localized string m_strCreditsLink;
var const localized string m_strExitAndSaveSettings;
var const localized string m_strResetAllSettings;
var const localized string m_strIgnoreChangesDialogue;
var const localized string m_strIgnoreChangesConfirm;
var const localized string m_strIgnoreChangesCancel;
var const localized string m_strWantToResetToDefaults;
var const localized string m_strSoldiersLanguageHint;
var const localized string m_strTabVideo;
var const localized string m_strTabGraphics;
var const localized string m_strTabAudio;
var const localized string m_strTabGameplay;
var const localized string m_strTabInterface;
var const localized string m_strVideoLabel_Mode;
var const localized string m_strVideoLabel_Fullscreen;
var const localized string m_strVideoLabel_Windowed;
var const localized string m_strVideoLabel_BorderlessWindow;
var const localized string m_strVideolabel_MouseLock;
var const localized string m_strVideoLabel_Resolution;
var const localized string m_strVideoLabel_Gamma;
var const localized string m_strVideoLabel_GammaDirections;
var const localized string m_strVideoLabel_VSyncToggle;
var const localized string m_strVideoLabel_FRSmoothingToggle;
var const localized string m_strVideoKeepSettings_Title;
var const localized string m_strVideoKeepSettings_Body;
var const localized string m_strVideoKeepSettings_Confirm;
var const localized string m_strGraphicsLabel_Preset;
var const localized string m_strGraphicsLabel_Shadow;
var const localized string m_strGraphicsLabel_TextureFiltering;
var const localized string m_strGraphicsLabel_AntiAliasing;
var const localized string m_strGraphicsLabel_PostProcessing;
var const localized string m_strGraphicsLabel_FOW;
var const localized string m_strGraphicsLabel_Effects;
var const localized string m_strGraphicsLabel_AmbientOcclusion;
var const localized string m_strGraphicsLabel_TextureDetail;
var const localized string m_strGraphicsSetting_Low;
var const localized string m_strGraphicsSetting_Medium;
var const localized string m_strGraphicsSetting_High;
var const localized string m_strGraphicsSetting_Disabled;
var const localized string m_strGraphicsSetting_Custom;
var bool bInputReceived;
var bool m_bAllowCredits;
var private bool m_bVideoOptionsChanged;
var private bool m_bVideoOptionsChanged_VSync;
var private bool m_bVideoOptionsChanged_Mode;
var private bool m_bAnyValueChanged;
var private bool m_GEngineValueChanged;
var private bool m_SystemSettingsChanged;
var private bool m_GammaSettingsChanged;
var private bool m_bPendingExit;
var private bool m_bSavingInProgress;
var private bool m_bOldVSync;
var string m_strHelp_MouseNav_Accept;
var string m_strHelp_MouseNav_Cancel;
var array<string> m_DefaultGraphicsSettingLabels;
var array<int> m_DefaultGraphicsSettingValues;
var const localized string m_strAudioLabel_MasterVolume;
var const localized string m_strAudioLabel_SpeakerPreset;
var const localized string m_strAudioLabel_VoiceVolume;
var const localized string m_strAudioLabel_SoundEffectVolume;
var const localized string m_strAudioLabel_MusicVolume;
var const localized string m_strAudioLabel_EnableSoldierSpeech;
var const localized string m_strAudioLabel_ForeignLanguages;
var const localized string m_strGameplayLabel_GlamCam;
var const localized string m_strGameplayLabel_ThirdPersonCamera;
var const localized string m_strGameplayLabel_StrategyAutosaveFrequency;
var const localized string m_strGameplayLabel_TacticalAutosaveFrequency;
var const localized string m_strGameplayLabel_AutosaveToggle;
var const localized string m_strGameplayLabel_AutosaveOnReturnFromTactical;
var const localized string m_strGameplayLabel_ShowEnemyHealth;
var const localized string m_strInterfaceLabel_DefaultCameraZoom;
var const localized string m_strInterfaceLabel_ShowHealthBars;
var const localized string m_strInterfaceLabel_ShowSubtitles;
var const localized string m_strInterfaceLabel_EdgescrollSpeed;
var const localized string m_strInterfaceLabel_InputDevice;
var const localized string m_strInterfaceLabel_Controller;
var const localized string m_strInterfaceLabel_Mouse;
var const localized string m_strInterfaceLabel_KeyBindings;
var const localized string m_strSavingOptionsFailed;
var const localized string m_strSavingOptionsFailed360;
var private array<UIWidgetHelper> m_arrWidgetHelpers;
var private int m_iCurrentTab;
var private int m_OldViewportStyle;
var private int m_OldResolutionWidth;
var private int m_OldResolutionHeight;
var private int m_KeepResolutionCountdown;
var XComOnlineProfileSettings m_kProfileSettings;
var SoundCue m_SoldierVoice;
var array<int> m_kGameResolutionWidths;
var array<int> m_kGameResolutionHeights;
var const localized string m_strInterfaceLabel_Touch;
var private int m_iCurrentInputOption;

defaultproperties
{
    m_iCurrentTab=2
    s_package="/ package/gfxOptionsPCScreen/OptionsPCScreen"
    s_screenId="gfxOptionsPCScreen"
    e_InputState=eInputState_Consume
    s_name="theScreen"
}