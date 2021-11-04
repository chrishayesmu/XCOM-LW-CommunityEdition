class UI_FxsMessageBox extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation)
	dependsOn(UIMessageMgr);
//complete stub

var protected string m_strTitle;
var protected UIMessageMgr.EUIPulse m_ePulse;
var protected UIMessageMgrBase.EUIIcon m_eIcon;
var protected float m_fTime;

simulated function Init(coerce name _s_name, XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function SetDisplay(){}
simulated function AnimateOut(){}
simulated function name GetName(){}
simulated function SetTitle(string _sMessage){}
simulated function string GetTitle(){}
simulated function SetPulse(EUIPulse _ePulse){}
simulated function EUIPulse GetPulse(){}
simulated function SetTime(float _fTime){}
simulated function float GetTime(){}
simulated function SetIcon(EUIIcon _eIcon){}
simulated function EUIIcon GetIcon(){}
