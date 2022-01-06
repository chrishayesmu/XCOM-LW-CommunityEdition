class Highlander_XComHQPresentationLayer extends XComHQPresentationLayer;

var Highlander_UIModSettings m_kModSettings;

simulated function Init()
{
    `HL_LOG_CLS("Init");
    super.Init();
}

function XGScreenMgr GetMgr(class<Actor> kMgrClass, optional IScreenMgrInterface kInterface = none, optional int iView = -1, optional bool bIgnoreIfDoesNotExist = false)
{
    ReplaceClassWithHighlanderEquivalent(kMgrClass);

    //`HL_LOG_CLS("Getting class " $ kMgrClass);

    return super.GetMgr(kMgrClass, kInterface, iView, bIgnoreIfDoesNotExist);
}

function Mod_Notify(TMCNotice kNotice)
{
    if (m_kUIMissionControl != none)
    {
        Highlander_XGMissionControlUI(m_kUIMissionControl.GetMgr()).Mod_AddNotice(kNotice);
    }
}

function bool RemoveMgr(class<Actor> kMgrClass)
{
    ReplaceClassWithHighlanderEquivalent(kMgrClass);

    return super.RemoveMgr(kMgrClass);
}

function ReplaceClassWithHighlanderEquivalent(out class<Actor> kClass)
{
    local class<Actor> kHLClass;

    if (Instr(string(kClass.Name), "Highlander") != INDEX_NONE)
    {
        return;
    }

    kHLClass = class<Actor>(DynamicLoadObject("XComHighlander.Highlander_" $ string(kClass.Name), class'Class'));

    if (kHLClass != none)
    {
        kClass = kHLClass;
    }
}

simulated function UIChooseTech(optional int iView = 1)
{
    m_kChooseTech = Spawn(class'Highlander_UIChooseTech', self);
    m_kChooseTech.Init(XComPlayerController(Owner), Get3DMovie(), iView);
    PushState('State_ChooseTech');
}

reliable client simulated function UICustomize(XGStrategySoldier kSoldier)
{
    if (m_kSoldierCustomize == none)
    {
        m_kSoldierCustomize = Spawn(class'Highlander_UISoldierCustomize', self);
        m_kSoldierCustomize.Init(kSoldier, XComPlayerController(Owner), Get3DMovie());
        PushState('State_Customize');
    }
}

reliable client simulated function UIFundingCouncilRequest(IFCRequestInterface kDataInterface)
{
    m_kFundingCouncilRequest = Spawn(class'Highlander_UIFundingCouncilRequest', self);
    m_kFundingCouncilRequest.Init(XComPlayerController(Owner), GetHUD(), kDataInterface);
    PushState('State_FundingCouncilRequest');
}

reliable client simulated function UIFundingCouncilRequestComplete(IFCRequestInterface kDataInterface)
{
    m_kFundingCouncilRequest = Spawn(class'Highlander_UIFundingCouncilRequest', self);
    m_kFundingCouncilRequest.Init(XComPlayerController(Owner), GetHUD(), kDataInterface, 3);
    PushState('State_FundingCouncilRequest');
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

reliable client simulated function UIManufactureFacility(EFacilityType eFacility, int X, int Y)
{
    m_kManufacturing = Spawn(class'Highlander_UIManufacturing', self);
    m_kManufacturing.InitFacility(XComPlayerController(Owner), Get3DMovie(), eFacility, X, Y);
    PushState('State_Manufacture');
    CAMLookAtNamedLocation(class'UIManufacturing'.default.m_strCameraTag, 0.0);
}

reliable client simulated function UIManufactureFoundry(int iTech, optional int iProjectIndex = -1)
{
    m_kManufacturing = Spawn(class'Highlander_UIManufacturing', self);
    m_kManufacturing.InitFoundry(XComPlayerController(Owner), Get3DMovie(), iTech, iProjectIndex);
    PushState('State_Manufacture');
    CAMLookAtNamedLocation(class'UIManufacturing'.default.m_strCameraTag, 1.0);
}

reliable client simulated function UIManufactureItem(EItemType eItem, optional int iQueueIndex = -1)
{
    `HL_LOG_DEPRECATED_CLS(UIManufactureItem);
}

reliable client simulated function HL_UIManufactureItem(int iItemId, optional int iQueueIndex = -1)
{
    local Highlander_UIManufacturing kManufacturing;

    kManufacturing = Spawn(class'Highlander_UIManufacturing', self);
    m_kManufacturing = kManufacturing;

    kManufacturing.HL_InitItem(XComPlayerController(Owner), Get3DMovie(), iItemId, iQueueIndex);
    PushState('State_Manufacture');
    CAMLookAtNamedLocation(class'UIManufacturing'.default.m_strCameraTag, 1.0);
}

reliable client simulated function UIHangarShipSummary(XGShip_Interceptor kShip)
{
    m_kShipSummary = Spawn(class'Highlander_UIShipSummary', self);
    m_kShipSummary.Init(XComPlayerController(Owner), GetHUD(), kShip);
    PushState('State_HangarShipSummary');
}

reliable client simulated function UIHangarShipLoadout(XGShip_Interceptor kShip)
{
    m_kShipLoadout = Spawn(class'Highlander_UIShipLoadout', self);
    m_kShipLoadout.Init(XComPlayerController(Owner), GetHUD(), kShip);
    PushState('State_HangarShipLoadout');
}

simulated function UIItemCard(TItemCard tCardData)
{
    `HL_LOG_DEPRECATED_CLS(UIItemCard);
}

simulated function HL_UIItemCard(HL_TItemCard tCardData)
{
    m_kItemCard = Spawn(class'Highlander_UIItemCards', self);
    Highlander_UIItemCards(m_kItemCard).HL_Init(XComPlayerController(Owner), GetHUD(), tCardData);
    PushState('State_ItemCard');
}

reliable client simulated function UIMissionControl()
{
    // Highlander: removed a call to ScriptTrace() that served no purpose
    PushState('State_MC');
}

reliable client simulated function HL_UIModSettings()
{
    if (m_kModSettings == none)
    {
        PushState('State_ModSettings');
    }
}

reliable client simulated function UISoldier(XGStrategySoldier kSoldier, optional int iView = 0, optional bool bReturnToDebriefUI = false, optional bool bPreventSoldierCycling = false, optional bool bCovertOperativeMode = false)
{
    m_kSoldierSummary = Spawn(class'Highlander_UISoldierSummary', self);
    m_kSoldierSummary.Init(kSoldier, XComPlayerController(Owner), Get3DMovie(), iView, bCovertOperativeMode);
    m_kSoldierSummary.GetMgr().m_bReturnToDebriefUI = bReturnToDebriefUI;
    m_kSoldierSummary.GetMgr().m_bPreventSoldierCycling = bPreventSoldierCycling;

    PushState('State_Soldier');
}

reliable client simulated function UISoldierPromotionMEC(XGStrategySoldier kSoldier)
{
    m_kSoldierPromote = Spawn(class'Highlander_UISoldierPromotion', self);
    m_kSoldierPromote.Init(kSoldier, XComPlayerController(Owner), Get3DMovie(), /* _psiPromote */ false, /* _mecPromote */ true);
    PushState('State_SoldierPromotion');
}

reliable client simulated function UISoldierPromotion(XGStrategySoldier kSoldier, bool psiPromote)
{
    m_kSoldierPromote = Spawn(class'Highlander_UISoldierPromotion', self);
    m_kSoldierPromote.Init(kSoldier, XComPlayerController(Owner), Get3DMovie(), psiPromote, false);
    PushState('State_SoldierPromotion');
}

reliable client simulated function UISoldierGeneMods(XGStrategySoldier kSoldier, bool bViewGenesOnly, optional int iSelectedRow = -1, optional int iSelectedCol = -1)
{
    m_kSoldierGeneMods = Spawn(class'Highlander_UISoldierGeneMods', self);
    m_kSoldierGeneModsHUD = Spawn(class'UISoldierGeneModsHUD', self);
    m_kSoldierGeneMods.Init(kSoldier, XComPlayerController(Owner), Get3DMovie(), bViewGenesOnly, iSelectedRow, iSelectedCol);
    m_kSoldierGeneModsHUD.Init(XComPlayerController(Owner), GetHUD());
    PushState('State_SoldierGeneMods');
}

reliable client simulated function UISoldierLoadout(XGStrategySoldier kSoldier)
{
    m_kSoldierLoadout = Spawn(class'Highlander_UISoldierLoadout', self);
    m_kSoldierLoadout.Init(kSoldier, XComPlayerController(Owner), Get3DMovie());
    PushState('State_SoldierLoadout');
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

simulated state State_BuildItem
{
    simulated function Activate()
    {
        m_kBuildItem = Spawn(class'Highlander_UIBuildItem', self);
        m_kBuildItem.Init(XComPlayerController(Owner), Get3DMovie(), 1);
        Get3DMovie().ShowDisplay(class'UIBuildItem'.default.DisplayTag);
        CAMLookAtNamedLocation(class'UIBuildItem'.default.m_strCameraTag, 1.0);
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

simulated state State_EngineeringMenu
{
    simulated function Activate()
    {
        m_kSubMenu = Spawn(class'Highlander_UIStrategyHUD_FSM_Engineering', m_kStrategyHUD);
        m_kSubMenu.Init(XComPlayerController(Owner), m_kHUD, m_kStrategyHUD, m_iFacilityView);
        m_kStrategyHUD.m_kMenu.SetSelectedFacility(`HQGAME.GetGameCore().GetHQ().ENGINEERING());
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

simulated state State_ModSettings extends BaseScreenState
{
    simulated function Activate()
    {
        m_kModSettings = Spawn(class'Highlander_UIModSettings', self);
        m_kModSettings.Init(XComPlayerController(Owner), GetHUD());
        m_kModSettings.Show();
    }

    simulated function Deactivate()
    {
        GetHUD().RemoveScreen(m_kModSettings);
        m_kModSettings = none;
    }

    simulated function OnReceiveFocus()
    {
        m_kModSettings.OnReceiveFocus();
    }

    simulated function OnLoseFocus()
    {
        m_kModSettings.OnLoseFocus();
    }

    stop;
}

simulated state State_PauseMenu
{
    simulated function Activate()
    {
        local bool bAllowSaving;

        bAllowSaving = AllowSaving();
        ToggleUIWhenPaused(false);
        m_kPauseMenu = Spawn(class'Highlander_UIPauseMenu', self);
        m_kPauseMenu.Init(XComPlayerController(Owner), GetHUD(), m_bIsIronman, bAllowSaving);
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

// ----------------------------------------------------------------------------------
// NOTE: states past this point are from XComPresentationLayerBase, and need to be modified here,
// in Highlander_XComShellPresentationLayer, and in Highlander_XComPresentationLayer together!
// ----------------------------------------------------------------------------------

simulated state State_PCKeybindings
{
    simulated function Activate()
    {
        m_kPCKeybindings = Spawn(class'Highlander_UIKeybindingsPCScreen', self);
        m_kPCKeybindings.Init(XComPlayerController(Owner), GetHUD());
    }
}