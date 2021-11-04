class UIInterfaceMgr extends UIFxsMovie
    config(UI);

var UIMessageMgr MessageMgr;
var UIAnchoredMessageMgr AnchoredMessageMgr;
var UINarrativeCommLink CommLink;
var UIDialogueBox DialogBox;
var bool bShownNormally;
var int ForceShowCount;

simulated function OnInit(){}
simulated function Show(optional bool bShowAllScreens=true){}
simulated function Hide(optional bool bHideAllScreens=true){}
simulated function PushForceShowUI(){}
simulated function PopForceShowUI(){}
simulated function HideUIForCinematics(){}
simulated function ShowUIForCinematics(){}
