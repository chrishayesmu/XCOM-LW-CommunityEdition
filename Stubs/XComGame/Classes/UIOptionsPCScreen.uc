class UIOptionsPCScreen extends UI_FxsScreen
    native(UI)
    notplaceable
    hidecategories(Navigation);
//complete stub

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
var bool m_bVideoOptionsChanged;
var bool m_bVideoOptionsChanged_VSync;
var bool m_bVideoOptionsChanged_Mode;
var bool m_bAnyValueChanged;
var bool m_GEngineValueChanged;
var bool m_SystemSettingsChanged;
var bool m_GammaSettingsChanged;
var bool m_bPendingExit;
var bool m_bSavingInProgress;
var bool m_bOldVSync;
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
var array<UIWidgetHelper> m_arrWidgetHelpers;
var int m_iCurrentTab;
var int m_OldViewportStyle;
var int m_OldResolutionWidth;
var int m_OldResolutionHeight;
var int m_KeepResolutionCountdown;
var XComOnlineProfileSettings m_kProfileSettings;
var SoundCue m_SoldierVoice;
var array<int> m_kGameResolutionWidths;
var array<int> m_kGameResolutionHeights;
var const localized string m_strInterfaceLabel_Touch;
var int m_iCurrentInputOption;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
function WatchForChanges(){}
simulated function SavePreviousProfileSettingsToBuffer(){}
simulated function RestorePreviousProfileSettings(){}
simulated function RefreshHelp(){}
simulated function AS_SetHelp(int Index, string Text, string buttonIcon){}
simulated event ModifyHearSoundComponent(AudioComponent AC){}
simulated function bool OnUnrealCommand(int Cmd, int Actionmask){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
// Export UUIOptionsPCScreen::execSetSupportedResolutions(FFrame&, void* const)
native simulated function SetSupportedResolutions(UIWidget_Combobox kCombobox, bool BorderlessWindow, bool WindowedMode);

// Export UUIOptionsPCScreen::execGetCurrentVSync(FFrame&, void* const)
native simulated function bool GetCurrentVSync();

// Export UUIOptionsPCScreen::execGetCurrentMouseLock(FFrame&, void* const)
native simulated function bool GetCurrentMouseLock();

// Export UUIOptionsPCScreen::execGetCurrentFRSmoothingToggle(FFrame&, void* const)
native simulated function bool GetCurrentFRSmoothingToggle();

// Export UUIOptionsPCScreen::execGetIsBorderlessWindow(FFrame&, void* const)
native simulated function bool GetIsBorderlessWindow();

// Export UUIOptionsPCScreen::execGetCurrentTextureFilteringSetting(FFrame&, void* const)
native simulated function EUI_PCOptions_GraphicsSettings GetCurrentTextureFilteringSetting();

// Export UUIOptionsPCScreen::execGetCurrentShadowSetting(FFrame&, void* const)
native simulated function EUI_PCOptions_GraphicsSettings GetCurrentShadowSetting();

// Export UUIOptionsPCScreen::execGetCurrentFOWSetting(FFrame&, void* const)
native simulated function EUI_PCOptions_GraphicsSettings GetCurrentFOWSetting();

// Export UUIOptionsPCScreen::execGetCurrentPostProcessQualitySetting(FFrame&, void* const)
native simulated function EUI_PCOptions_GraphicsSettings GetCurrentPostProcessQualitySetting();

// Export UUIOptionsPCScreen::execGetCurrentAntiAliasingSetting(FFrame&, void* const)
native simulated function EUI_PCOptions_GraphicsSettings GetCurrentAntiAliasingSetting();

// Export UUIOptionsPCScreen::execGetCurrentEffectsSettings(FFrame&, void* const)
native simulated function EUI_PCOptions_GraphicsSettings GetCurrentEffectsSettings();

// Export UUIOptionsPCScreen::execGetCurrentTextureDetailSetting(FFrame&, void* const)
native simulated function EUI_PCOptions_GraphicsSettings GetCurrentTextureDetailSetting();

// Export UUIOptionsPCScreen::execSetTextureFilteringSysSetting(FFrame&, void* const)
native simulated function SetTextureFilteringSysSetting(EUI_PCOptions_GraphicsSettings InSetting);

// Export UUIOptionsPCScreen::execSetShadowSysSetting(FFrame&, void* const)
native simulated function SetShadowSysSetting(EUI_PCOptions_GraphicsSettings InSetting);

// Export UUIOptionsPCScreen::execSetFOWSysSetting(FFrame&, void* const)
native simulated function SetFOWSysSetting(EUI_PCOptions_GraphicsSettings InSetting);

// Export UUIOptionsPCScreen::execSetPostProcessQualitySysSetting(FFrame&, void* const)
native simulated function SetPostProcessQualitySysSetting(EUI_PCOptions_GraphicsSettings InSetting);

// Export UUIOptionsPCScreen::execSetAntiAliasingSysSetting(FFrame&, void* const)
native simulated function SetAntiAliasingSysSetting(EUI_PCOptions_GraphicsSettings InSetting);

// Export UUIOptionsPCScreen::execSetEffectsSetting(FFrame&, void* const)
native simulated function SetEffectsSetting(EUI_PCOptions_GraphicsSettings InSetting);

// Export UUIOptionsPCScreen::execSetTextureDetailSysSetting(FFrame&, void* const)
native simulated function SetTextureDetailSysSetting(EUI_PCOptions_GraphicsSettings InSetting);
simulated function MakeDefaultGraphicsSpinner(UIWidget_Spinner kSpinner){}
simulated function MakeNoMediumGraphicsSpinner(UIWidget_Spinner kSpinner){}
simulated function bool IsSpinnerEqualToSetting(EUI_PCOptions_GraphicsSettings MainSetting, EUI_PCOptions_Graphics GraphicsSpinner){}
simulated function bool IsNoMediumSpinnerEqualToSetting(EUI_PCOptions_GraphicsSettings MainSetting, EUI_PCOptions_Graphics GraphicsSpinner){}
simulated function bool IsNoMediumSpinnerEqual(EUI_PCOptions_GraphicsSettings MainSpinnerValue, EUI_PCOptions_GraphicsSettings NoMediumSpinnerValue){}
simulated function SetPresetState(){}
simulated function ApplyPresetState(){}
simulated function RefreshData(){}
// Export UUIOptionsPCScreen::execUpdateViewportNative(FFrame&, void* const)
native function UpdateViewportNative(int ScreenWidth, int ScreenHeight, bool Fullscreen, int BorderlessWindow);
simulated function KeepResolutionCallback(EUIAction eAction){}
simulated function KeepResolutionCountdown(){}
function UpdateViewport(){}
function UpdateMode_OnIncrease(){}
function UpdateMode_OnDecrease(){}
native function UpdateMouseLockNative(bool bNewMouseLock);
function UpdateMouseLock(){}
function UpdateResolution(){}
native function float GetGammaPercentageNative();
function float GetGammaPercentage(){}
native function UpdateGammaNative(float UpdateGamma);
function UpdateGamma(){}
native function UpdateVSyncNative(bool bUseVSync);
function UpdateVSync(){}
native function UpdateFRSmoothingNative(bool bUseFRSmoothing);

function UpdateFRSmoothing(){}
function UpdateViewportCheck(){}
function bool DidVideoOptionsChange(){}
function UpdateGraphicsWidgetCommon(){}
function SetGraphicsSettingsFromSpinners(){}
function UpdatePreset_OnIncrease(){}
function UpdatePreset_OnDecrease(){}
function UpdateTextureFiltering_OnChanged(){}
function UpdateShadow_OnChanged(){}
function UpdateEffects_OnChanged(){}
function UpdateFOW_OnChanged(){}
function UpdateAntiAliasing_OnChanged(){}
function UpdatePostProcessing_OnChanged(){};
function UpdateAmbientOcclusion_OnChanged(){}
function UpdateTextureDetail_OnChanged(){}
function UpdateMasterVolume(){}
function UpdateSpeakerPreset(){}
function UpdateVoiceVolume(){}
function UpdateSoundEffectsVolume(){}
function UpdateMusicVolume(){}
function UpdateEnableSoldierSpeech(){}
function UpdateForeignLanguages(){}
function UpdateGlamCam(){}
function UpdateThirdPersonCam(){}
function UpdateAutosave(){}
function UpdateShowEnemyHealth(){}
function OpenKeyBindingsScreen(){}
function UpdateZoomLevel(){}
function UpdateHealthBars(){}
function UpdateSubtitles(){}
function UpdateEdgeScroll(){}
function UpdateInputDevice_OnIncrease(){}
function UpdateInputDevice_OnDecrease(){}
function ResetMouseDevice(){}
function SetInputDevice(int iInputDevice){}
function RefreshInputDevice(){}
function OnInputDeviceChange(){}
function string GetInputDeviceLabel(){}
function ResetToDefaults(){}
function ConfirmUserWantsToResetToDefault(EUIAction eAction){}
simulated function ResetProfileSettings(){}
simulated function StoreInitVideoSettings(){}
simulated function ResetInitVideoSettings(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
// Export UUIOptionsPCScreen::execSaveGEngineConfig(FFrame&, void* const)
native simulated function SaveGEngineConfig();

// Export UUIOptionsPCScreen::execSaveSystemSettings(FFrame&, void* const)
native simulated function SaveSystemSettings();

// Export UUIOptionsPCScreen::execSaveGamma(FFrame&, void* const)
native simulated function SaveGamma();

simulated function IgnoreChangesAndExit(){}
simulated function ConfirmUserWantsToIgnoreChanges(EUIAction eAction){}
simulated function SaveAndExit(){}
simulated function SaveComplete(bool bWasSuccessful){}
simulated function ExitScreen(){}
simulated function SaveProfileFailedDialog(){}
simulated function OnUDPadUp(){}
simulated function OnUDPadDown(){}
simulated function SetSelectedTab(int iSelect){}
simulated function AS_SetTitle(string Title){}
simulated function AS_SetTabTitle(int Index, string Title){}
simulated function AS_SetLangaugeHint(string hint){}
simulated function AS_SelectTab(int Index){}
simulated function AS_SetGammaDirections(string Text){}
simulated function AS_SetTabHelp(string str0, string str1){}
simulated function AS_PrepClosing(){}
event Destroyed(){}
