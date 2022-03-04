class LWCE_XComHQPresentationLayer extends XComHQPresentationLayer;

`include(generators.uci)

`LWCE_GENERATOR_XCOMPRESENTATIONLAYERBASE

simulated function Init()
{
    `LWCE_LOG_CLS("Init");
    super.Init();
}

function XGScreenMgr GetMgr(class<Actor> kMgrClass, optional IScreenMgrInterface kInterface = none, optional int iView = -1, optional bool bIgnoreIfDoesNotExist = false)
{
    ReplaceClassWithLWCEEquivalent(kMgrClass);

    //`LWCE_LOG_CLS("Getting class " $ kMgrClass);

    return super.GetMgr(kMgrClass, kInterface, iView, bIgnoreIfDoesNotExist);
}

function Mod_Notify(TMCNotice kNotice)
{
    if (m_kUIMissionControl != none)
    {
        LWCE_XGMissionControlUI(m_kUIMissionControl.GetMgr()).Mod_AddNotice(kNotice);
    }
}

function bool RemoveMgr(class<Actor> kMgrClass)
{
    ReplaceClassWithLWCEEquivalent(kMgrClass);

    return super.RemoveMgr(kMgrClass);
}

function ReplaceClassWithLWCEEquivalent(out class<Actor> kClass)
{
    local class<Actor> kCEClass;

    if (Instr(string(kClass.Name), "LWCE") != INDEX_NONE)
    {
        return;
    }

    kCEClass = class<Actor>(DynamicLoadObject("XComLongWarCommunityEdition.LWCE_" $ string(kClass.Name), class'Class', true));

    if (kCEClass != none)
    {
        kClass = kCEClass;
    }
}

simulated function UIChooseTech(optional int iView = 1)
{
    m_kChooseTech = Spawn(class'LWCE_UIChooseTech', self);
    m_kChooseTech.Init(XComPlayerController(Owner), Get3DMovie(), iView);
    PushState('State_ChooseTech');
}

reliable client simulated function UICustomize(XGStrategySoldier kSoldier)
{
    if (m_kSoldierCustomize == none)
    {
        m_kSoldierCustomize = Spawn(class'LWCE_UISoldierCustomize', self);
        m_kSoldierCustomize.Init(kSoldier, XComPlayerController(Owner), Get3DMovie());
        PushState('State_Customize');
    }
}

reliable client simulated function UIFundingCouncilRequest(IFCRequestInterface kDataInterface)
{
    m_kFundingCouncilRequest = Spawn(class'LWCE_UIFundingCouncilRequest', self);
    m_kFundingCouncilRequest.Init(XComPlayerController(Owner), GetHUD(), kDataInterface);
    PushState('State_FundingCouncilRequest');
}

reliable client simulated function UIFundingCouncilRequestComplete(IFCRequestInterface kDataInterface)
{
    m_kFundingCouncilRequest = Spawn(class'LWCE_UIFundingCouncilRequest', self);
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
        kData.strImagePath = `LWCE_FTECH(kUnlock.iUnlocked).ImagePath;
    }
    else if (kUnlock.eUnlockImage != 0)
    {
        kData.strImagePath = class'UIUtilities'.static.GetStrategyImagePath(kUnlock.eUnlockImage);
    }

    UIRaiseDialog(kData);
}

reliable client simulated function UIManufactureFacility(EFacilityType eFacility, int X, int Y)
{
    m_kManufacturing = Spawn(class'LWCE_UIManufacturing', self);
    m_kManufacturing.InitFacility(XComPlayerController(Owner), Get3DMovie(), eFacility, X, Y);
    PushState('State_Manufacture');
    CAMLookAtNamedLocation(class'UIManufacturing'.default.m_strCameraTag, 0.0);
}

reliable client simulated function UIManufactureFoundry(int iTech, optional int iProjectIndex = -1)
{
    m_kManufacturing = Spawn(class'LWCE_UIManufacturing', self);
    m_kManufacturing.InitFoundry(XComPlayerController(Owner), Get3DMovie(), iTech, iProjectIndex);
    PushState('State_Manufacture');
    CAMLookAtNamedLocation(class'UIManufacturing'.default.m_strCameraTag, 1.0);
}

reliable client simulated function UIManufactureItem(EItemType eItem, optional int iQueueIndex = -1)
{
    `LWCE_LOG_DEPRECATED_CLS(UIManufactureItem);
}

reliable client simulated function LWCE_UIManufactureItem(int iItemId, optional int iQueueIndex = -1)
{
    local LWCE_UIManufacturing kManufacturing;

    kManufacturing = Spawn(class'LWCE_UIManufacturing', self);
    m_kManufacturing = kManufacturing;

    kManufacturing.LWCE_InitItem(XComPlayerController(Owner), Get3DMovie(), iItemId, iQueueIndex);
    PushState('State_Manufacture');
    CAMLookAtNamedLocation(class'UIManufacturing'.default.m_strCameraTag, 1.0);
}

reliable client simulated function UIHangarShipSummary(XGShip_Interceptor kShip)
{
    m_kShipSummary = Spawn(class'LWCE_UIShipSummary', self);
    m_kShipSummary.Init(XComPlayerController(Owner), GetHUD(), kShip);
    PushState('State_HangarShipSummary');
}

reliable client simulated function UIHangarShipLoadout(XGShip_Interceptor kShip)
{
    m_kShipLoadout = Spawn(class'LWCE_UIShipLoadout', self);
    m_kShipLoadout.Init(XComPlayerController(Owner), GetHUD(), kShip);
    PushState('State_HangarShipLoadout');
}

simulated function UIItemCard(TItemCard tCardData)
{
    `LWCE_LOG_DEPRECATED_CLS(UIItemCard);
}

simulated function LWCE_UIItemCard(LWCE_TItemCard tCardData)
{
    m_kItemCard = Spawn(class'LWCE_UIItemCards', self);
    LWCE_UIItemCards(m_kItemCard).LWCE_Init(XComPlayerController(Owner), GetHUD(), tCardData);
    PushState('State_ItemCard');
}

reliable client simulated function UIMissionControl()
{
    // LWCE: removed a call to ScriptTrace() that served no purpose
    PushState('State_MC');
}

reliable client simulated function UISoldier(XGStrategySoldier kSoldier, optional int iView = 0, optional bool bReturnToDebriefUI = false, optional bool bPreventSoldierCycling = false, optional bool bCovertOperativeMode = false)
{
    m_kSoldierSummary = Spawn(class'LWCE_UISoldierSummary', self);
    m_kSoldierSummary.Init(kSoldier, XComPlayerController(Owner), Get3DMovie(), iView, bCovertOperativeMode);
    m_kSoldierSummary.GetMgr().m_bReturnToDebriefUI = bReturnToDebriefUI;
    m_kSoldierSummary.GetMgr().m_bPreventSoldierCycling = bPreventSoldierCycling;

    PushState('State_Soldier');
}

reliable client simulated function UISoldierPromotionMEC(XGStrategySoldier kSoldier)
{
    m_kSoldierPromote = Spawn(class'LWCE_UISoldierPromotion', self);
    m_kSoldierPromote.Init(kSoldier, XComPlayerController(Owner), Get3DMovie(), /* _psiPromote */ false, /* _mecPromote */ true);
    PushState('State_SoldierPromotion');
}

reliable client simulated function UISoldierPromotion(XGStrategySoldier kSoldier, bool psiPromote)
{
    m_kSoldierPromote = Spawn(class'LWCE_UISoldierPromotion', self);
    m_kSoldierPromote.Init(kSoldier, XComPlayerController(Owner), Get3DMovie(), psiPromote, false);
    PushState('State_SoldierPromotion');
}

reliable client simulated function UISoldierGeneMods(XGStrategySoldier kSoldier, bool bViewGenesOnly, optional int iSelectedRow = -1, optional int iSelectedCol = -1)
{
    m_kSoldierGeneMods = Spawn(class'LWCE_UISoldierGeneMods', self);
    m_kSoldierGeneModsHUD = Spawn(class'UISoldierGeneModsHUD', self);
    m_kSoldierGeneMods.Init(kSoldier, XComPlayerController(Owner), Get3DMovie(), bViewGenesOnly, iSelectedRow, iSelectedCol);
    m_kSoldierGeneModsHUD.Init(XComPlayerController(Owner), GetHUD());
    PushState('State_SoldierGeneMods');
}

reliable client simulated function UISoldierLoadout(XGStrategySoldier kSoldier)
{
    m_kSoldierLoadout = Spawn(class'LWCE_UISoldierLoadout', self);
    m_kSoldierLoadout.Init(kSoldier, XComPlayerController(Owner), Get3DMovie());
    PushState('State_SoldierLoadout');
}

simulated state State_Archives
{
    simulated function Activate()
    {
        m_kScienceLabs = Spawn(class'LWCE_UIScienceLabs', self);
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
        m_kBuildFacilities = Spawn(class'LWCE_UIBuildFacilities', self);
        m_kBuildFacilities.Init(XComPlayerController(Owner), GetHUD());
        GetStrategyHUD().m_kBuildQueue.Hide();
    }
}

simulated state State_BaseBuildChooseFacility
{
    simulated function Activate()
    {
        m_kChooseFacility = Spawn(class'LWCE_UIChooseFacility', self);
        m_kChooseFacility.Init(XComPlayerController(Owner), GetHUD());
    }
}

simulated state State_BuildItem
{
    simulated function Activate()
    {
        m_kBuildItem = Spawn(class'LWCE_UIBuildItem', self);
        m_kBuildItem.Init(XComPlayerController(Owner), Get3DMovie(), 1);
        Get3DMovie().ShowDisplay(class'UIBuildItem'.default.DisplayTag);
        CAMLookAtNamedLocation(class'UIBuildItem'.default.m_strCameraTag, 1.0);
    }
}

simulated state State_Debrief
{
    simulated function Activate()
    {
        m_kDebriefUI = Spawn(class'LWCE_UIDebrief', self);
        XComHeadquartersController(Owner).SetInputState('None');
    }
}

simulated state State_EngineeringMenu
{
    simulated function Activate()
    {
        m_kSubMenu = Spawn(class'LWCE_UIStrategyHUD_FSM_Engineering', m_kStrategyHUD);
        m_kSubMenu.Init(XComPlayerController(Owner), m_kHUD, m_kStrategyHUD, m_iFacilityView);
        m_kStrategyHUD.m_kMenu.SetSelectedFacility(`HQGAME.GetGameCore().GetHQ().ENGINEERING());
    }
}

simulated state State_Foundry
{
    simulated function Activate()
    {
        m_kFoundryUI = Spawn(class'LWCE_UIFoundry', self);
        m_kFoundryUI.Init(XComPlayerController(Owner), Get3DMovie(), 0);
        Get3DMovie().ShowDisplay(class'UIFoundry'.default.DisplayTag);
        CAMLookAtNamedLocation(class'UIFoundry'.default.m_strCameraTag, 1.0);
    }
}

simulated state State_HangarHiring
{
    simulated function Activate()
    {
        // LWCE: replace UIHiring_Hangar class for a bug fix (see issue #1)
        m_kHangarHiring = Spawn(class'LWCE_UIHiring_Hangar', self);
        m_kHangarHiring.Init(XComPlayerController(Owner), GetHUD(), 4);
        GetHUD().LoadScreen(m_kHangarHiring);
    }
}

simulated state State_LabsMenu
{
    simulated function Activate()
    {
        m_kSubMenu = Spawn(class'LWCE_UIStrategyHUD_FSM_Science', m_kStrategyHUD);
        m_kSubMenu.Init(XComPlayerController(Owner), m_kHUD, m_kStrategyHUD, m_iFacilityView);
        m_kStrategyHUD.m_kMenu.SetSelectedFacility(`HQGAME.GetGameCore().GetHQ().LABS());
    }
}

simulated state State_MC
{
    simulated function Activate()
    {
        m_kUIMissionControl = Spawn(class'LWCE_UIMissionControl', self);
        m_kUIMissionControl.Init(XComPlayerController(Owner), GetHUD());
    }
}

simulated state State_PauseMenu
{
    simulated function Activate()
    {
        local bool bAllowSaving;

        bAllowSaving = AllowSaving();
        ToggleUIWhenPaused(false);
        m_kPauseMenu = Spawn(class'LWCE_UIPauseMenu', self);
        m_kPauseMenu.Init(XComPlayerController(Owner), GetHUD(), m_bIsIronman, bAllowSaving);
    }
}

simulated state State_StrategyHUD
{
    simulated function Activate()
    {
        m_kStrategyHUD = Spawn(class'LWCE_UIStrategyHUD', self);
        m_kStrategyHUD.Init(XComPlayerController(Owner), GetHUD());
        GetHUD().LoadScreen(m_kStrategyHUD);
        Sound().PlayAmbience(2);
        Sound().PlayMusic(`HQGAME.GetGameCore().GetActMusic());
        XComHeadquartersController(Owner).SetInputState('HQ_FreeMovement');
    }
}