class Highlander_XComHQPresentationLayer extends XComHQPresentationLayer;

simulated function Init()
{
    `HL_LOG_CLS("Init");
    super.Init();
}

// Sometimes it's very difficult to tell how a UI class is being instantiated. Overriding this function with some logging helps a lot.
// Comment it back in and change the target script class for easier debugging.
/*
function XGScreenMgr GetMgr(class<Actor> kMgrClass, optional IScreenMgrInterface kInterface = none, optional int iView = -1, optional bool bIgnoreIfDoesNotExist = false)
{
    `HL_LOG_CLS("Request for screen manager class: " $ string(kMgrClass));

    if (string(kMgrClass) == "XGDebriefUI")
    {
        ScriptTrace();
    }

    return super.GetMgr(kMgrClass, kInterface, iView, bIgnoreIfDoesNotExist);
}
*/

simulated function UIChooseTech(optional int iView = 1)
{
    m_kChooseTech = Spawn(class'Highlander_UIChooseTech', self);
    m_kChooseTech.Init(XComPlayerController(Owner), Get3DMovie(), iView);
    PushState('State_ChooseTech');
}

reliable client simulated function UIItemUnlock(TItemUnlock kUnlock)
{
    local TDialogueBoxData kData;

    kData.strTitle = kUnlock.strTitle;
    kData.strText = kUnlock.strName $ "<br><br>" $ kUnlock.strDescription $ "<br><br>" $ kUnlock.strHelp;
    kData.strCancel = "";
    kData.sndIn = kUnlock.sndFanfare;
    kData.eType = eDialog_NormalWithImage;

    if (kUnlock.eItemUnlocked != eItem_NONE)
    {
        kData.strImagePath = class'UIUtilities'.static.GetItemImagePath(kUnlock.eItemUnlocked);
    }
    else if (kUnlock.bFoundryProject)
    {
        kData.strImagePath = `HL_FTECH(kUnlock.iUnlocked).ImagePath;
    }
    else if (kUnlock.eUnlockImage != 0)
    {
        kData.strImagePath = class'UIUtilities'.static.GetStrategyImagePath(kUnlock.eUnlockImage);
    }

    UIRaiseDialog(kData);
}

reliable client simulated function UIManufactureFoundry(int iTech, optional int iProjectIndex = -1)
{
    m_kManufacturing = Spawn(class'Highlander_UIManufacturing', self);
    m_kManufacturing.InitFoundry(XComPlayerController(Owner), Get3DMovie(), iTech, iProjectIndex);
    PushState('State_Manufacture');
    CAMLookAtNamedLocation(class'UIManufacturing'.default.m_strCameraTag, 1.0);
}

reliable client simulated function UIMissionControl()
{
    // Highlander: removed a call to ScriptTrace() that served no purpose
    PushState('State_MC');
}

simulated state State_Archives
{
    simulated function Activate()
    {
        m_kScienceLabs = Spawn(class'Highlander_UIScienceLabs', self);
        m_kScienceLabs.Init(XComPlayerController(Owner), Get3DMovie());
        Get3DMovie().ShowDisplay(class'UIScienceLabs'.default.DisplayTag);
        CAMLookAtNamedLocation(class'UIScienceLabs'.default.m_strCameraTag, 1.0);
    }
}

simulated state State_BaseBuild
{
    simulated function Activate()
    {
        GetCamera().StartRoomViewNamed('Expansion', 1.0);
        m_kBuildFacilities = Spawn(class'Highlander_UIBuildFacilities', self);
        m_kBuildFacilities.Init(XComPlayerController(Owner), GetHUD());
        GetStrategyHUD().m_kBuildQueue.Hide();
    }
}

simulated state State_BaseBuildChooseFacility
{
    simulated function Activate()
    {
        m_kChooseFacility = Spawn(class'Highlander_UIChooseFacility', self);
        m_kChooseFacility.Init(XComPlayerController(Owner), GetHUD());
    }
}

simulated state State_Debrief
{
    simulated function Activate()
    {
        m_kDebriefUI = Spawn(class'Highlander_UIDebrief', self);
        XComHeadquartersController(Owner).SetInputState('None');
    }
}

simulated state State_Foundry
{
    simulated function Activate()
    {
        m_kFoundryUI = Spawn(class'Highlander_UIFoundry', self);
        m_kFoundryUI.Init(XComPlayerController(Owner), Get3DMovie(), 0);
        Get3DMovie().ShowDisplay(class'UIFoundry'.default.DisplayTag);
        CAMLookAtNamedLocation(class'UIFoundry'.default.m_strCameraTag, 1.0);
    }
}

simulated state State_HangarHiring
{
    simulated function Activate()
    {
        // Highlander: replace UIHiring_Hangar class for a bug fix (see issue #1)
        m_kHangarHiring = Spawn(class'Highlander_UIHiring_Hangar', self);
        m_kHangarHiring.Init(XComPlayerController(Owner), GetHUD(), 4);
        GetHUD().LoadScreen(m_kHangarHiring);
    }
}

simulated state State_LabsMenu
{
    simulated function Activate()
    {
        m_kSubMenu = Spawn(class'Highlander_UIStrategyHUD_FSM_Science', m_kStrategyHUD);
        m_kSubMenu.Init(XComPlayerController(Owner), m_kHUD, m_kStrategyHUD, m_iFacilityView);
        m_kStrategyHUD.m_kMenu.SetSelectedFacility(`HQGAME.GetGameCore().GetHQ().LABS());
    }
}

simulated state State_MC
{
    simulated function Activate()
    {
        m_kUIMissionControl = Spawn(class'Highlander_UIMissionControl', self);
        m_kUIMissionControl.Init(XComPlayerController(Owner), GetHUD());
    }
}

simulated state State_StrategyHUD
{
    simulated function Activate()
    {
        m_kStrategyHUD = Spawn(class'Highlander_UIStrategyHUD', self);
        m_kStrategyHUD.Init(XComPlayerController(Owner), GetHUD());
        GetHUD().LoadScreen(m_kStrategyHUD);
        Sound().PlayAmbience(2);
        Sound().PlayMusic(`HQGAME.GetGameCore().GetActMusic());
        XComHeadquartersController(Owner).SetInputState('HQ_FreeMovement');
    }
}
